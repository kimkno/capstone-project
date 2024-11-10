"""구문 분석을 위한 Gemini API 사용 모듈"""

import json
import logging
import os
from typing import Union, List
import yaml
import google.generativeai as genai
from pydantic import BaseModel, Field


# Logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Prompt
GRAMMAR_SYSTEM_PROMPT = """
당신은 사용자로부터 전달받은 영어 문장을 분석하여 한국 수능식 영어 구문 분석을 수행하게 됩니다.
예를 들어서 This is a test sentence. 라는 문장에서 한국식 영어 구문 분석을 통해 This (주어) / is (동사) / a test sentence (보어)의 구조인 2형식 문장임을 알 수 있습니다.
구분 분석 과정에서 추가로 문법적 오류, 철자 오류, 문장 구조 오류, 번역 상 매끄럽지 않은 부분 등을 찾아내어 사용자에게 피드백을 제공하기도 합니다.

기본적인 전략은 작은 문장부터 시작하여 문장의 각 단어에 대한 문법적 역할을 분석하고, 문장 전체의 문법적 구조를 분석하는 것입니다.
이를 통해 문장의 문법적 오류를 찾아내고, 이를 수정하는 작업을 수행합니다.

영어 작문 평가 결과는 yaml 형식으로 작성되어야 합니다. yaml 형식은 다음과 같은 형식을 따릅니다.

```yaml
kr: "<Korean translation>"
en: "<Fixed English sentence>"
result:
  - word: "<Target word(s) to analyze>"
    syntax: "<Grammar class of the word>"
    comment: "<Comment if there is fix needed>"
```

예를 들면, 입력으로 "John, who was very hungry, decided to make a apple pie." 를 받았다면 결과는 다음과 같은 형식을 따릅니다.

```yaml
kr: "존은 매우 배가 고파서 사과 파이를 만들기로 결정했다."
en: "John, who was very hungry, decided to make an apple pie."
result:
  - word: "John"
    syntax: "주어"
    comment: null
  - word: "who"
    syntax: "관계대명사"
    comment: null
  - word: "was"
    syntax: "동사"
    comment: null
  - word: "very"
    syntax: "부사"
    comment: null
  - word: "hungry"
    syntax: "형용사"
    comment: null
  - word: "decided"
    syntax: "동사"
    comment: null
  - word: "to"
    syntax: "전치사"
    comment: null
  - word: "make"
    syntax: "동사"
    comment: null
  - word: "an"
    syntax: "관사"
    comment: "사과는 모음으로 시작하는 단어이므로 'a' 대신 'an'를 사용해야 합니다."
  - word: "apple"
    syntax: "명사"
    comment: null
  - word: "pie"
    syntax: "명사"
    comment: null
  - word: "."
```

생성된 평가 결과는 yaml 형식으로 parsing 가능해야 합니다. 그 외의 답변은 허용되지 않습니다.
이제 사용자가 작성한 영어 텍스트를 입력으로 받게 됩니다. 이 영어 텍스트는 여러 문장으로 구성될 수 있습니다.
주어진 문장을 분석하여 yaml 형식으로 작성된 평가 결과를 반환하세요.


```input
{input_text}
```
"""


class PartialAnalysisResult(BaseModel):
    """문장의 각 단어에 대한 부분적인 분석 결과를 나타내는 클래스입니다."""
    word: str = Field(..., title="단어", description="문장의 각 단어를 키로 사용합니다.")
    syntax: str = Field(
        ...,
        title="문법적 역할",
        description="문법적인 역할을 나타냅니다. 주어, 목적어, 동사 등이 있습니다."
    )
    comment: Union[str, None] = Field(
        None,
        title="문법적 오류 설명",
        description="문법적 오류가 발생하면 설명을 제공합니다."
    )

    def to_dict(self) -> dict:
        """객체를 딕셔너리로 변환합니다."""
        return {
            "word": self.word,
            "syntax": self.syntax,
            "comment": self.comment
        }


class AnalysisResult(BaseModel):
    """문장 분석 결과를 나타내는 클래스입니다."""
    kr: str = Field(..., title="한글 번역 결과", description="한글 번역 결과입니다.")
    result: List[PartialAnalysisResult] = Field(
        ...,
        title="문법적 분석 결과",
        description="문장의 각 단어에 대한 문법적 역할을 분석한 결과입니다."
    )

    def to_dict(self) -> dict:
        """객체를 딕셔너리로 변환합니다."""
        return {
            "kr": self.kr,
            "result": [r.to_dict() for r in self.result] if isinstance(self.result, list) else []
        }


def get_analysis_result(event):
    """이벤트에서 분석 결과를 가져옵니다."""
    # Get the API key from environment variables
    api_key = os.environ.get('GOOGLE_API_KEY')
    if not api_key:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'API key not found'})
        }

    # Extract prompt from request
    body = json.loads(event.get('body', '{}'))
    query_params = event.get('queryStringParameters', {})

    # Get inputs
    prompt = body.get('prompt')
    model = query_params.get('model', 'gemini-pro')
    max_output_tokens = int(query_params.get('max_output_tokens', 8192))

    if prompt is None:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Input data is empty'})
        }

    if model not in ['gemini-pro']:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': f"Invalid model type: {model}"})
        }

    # Init
    genai.configure(api_key=api_key)
    gen = genai.GenerativeModel(
        model,
        generation_config=genai.GenerationConfig(max_output_tokens=max_output_tokens)
    )

    # Generate
    system_prompt = GRAMMAR_SYSTEM_PROMPT.format(input_text=prompt)
    max_retry = 3
    valid_text = None
    for _ in range(max_retry):
        response = gen.generate_content(system_prompt)
        try:
            # Return the analysis result
            raw_text = response.text
            raw_text = raw_text.replace("```yaml", "")
            raw_text = raw_text.replace("```", "")
            data = yaml.safe_load(raw_text)
            valid_text = AnalysisResult(**data)
            break
        except (yaml.YAMLError, ValueError) as e:
            logger.error("응답 파싱 실패: %s", str(e))
            continue

    if valid_text is None:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to parse the response'})
        }

    valid_text = valid_text.to_dict()
    return {
        'statusCode': 200,
        'body': json.dumps(valid_text, ensure_ascii=False)
    }

def lambda_handler(event, _=None):
    """
    Lambda function handler
    """
    http_method = event.get('httpMethod')

    if http_method == "OPTIONS":
        return {
            'statusCode': 204,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Max-Age': '3600'
            }
        }

    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, GET',
        'Access-Control-Allow-Headers': 'Content-Type'
    }

    if http_method == "POST":
        result = get_analysis_result(event)
        result['headers'] = headers
        return result
    elif http_method == "GET":
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({})
        }
    else:
        return {
            'statusCode': 405,
            'headers': headers,
            'body': json.dumps({"error": "Method not allowed"})
        }
