from __future__ import annotations
from pydantic import BaseModel, Field
from typing import Union, List
import logging
import os, json
import yaml
import functions_framework
import google.generativeai as genai
from pydantic import BaseModel, Field
from typing import Literal, Union

# Constants
GCP_PROJECT_ID = ''

# Logger
logger = logging.getLogger(__name__)

# Prompt
GRAMMAR_SYSTEM_PROMPT = """\
당신은 사용자로부터 전달받은 영어 문장을 분석하여 올바른 영어 작문을 수행하였는지 평가하는 작업을 수행하게 됩니다.
영어 작문 평가는 영어 문장의 문법적 오류, 철자 오류, 문장 구조 오류, 번역 상 매끄럽지 않은 부분 등을 찾아내어 사용자에게 피드백을 제공하는 작업입니다.

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


# class PartialAnalysisResult(BaseModel):
#     id: str = Field(..., title="단어", description="문장의 각 단어를 키로 사용합니다.")
#     class_name: str = Field(..., title="문법적 역할", description="문법적인 역할을 나타내는 클래스입니다. 주어, 목적어, 동사, 부사, 관사, 대명사, 전치사, 접속사, 감탄사 등이 있습니다.")
#     comment: Union[str, None] = Field(None, title="문법적 오류 설명", description="만약 문법적인 오류가 발견되었다면 이에 대한 설명을 제공합니다. 그렇지 않다면 이 필드는 없어도 됩니다.")

#     def to_dict(self) -> dict:
#         return {
#             "id": self.id,
#             "class_name": self.class_name,
#             "comment": self.comment
#         }

class PartialAnalysisResult(BaseModel):
    word: str = Field(..., title="단어", description="문장의 각 단어를 키로 사용합니다.")
    syntax: str = Field(..., title="문법적 역할", description="문법적인 역할을 나타내는 클래스입니다. 주어, 목적어, 동사, 부사, 관사, 대명사, 전치사, 접속사, 감탄사 등이 있습니다.")
    comment: Union[str, None] = Field(None, title="문법적 오류 설명", description="만약 문법적인 오류가 발견되었다면 이에 대한 설명을 제공합니다. 그렇지 않다면 이 필드는 없어도 됩니다.")

    def to_dict(self) -> dict:
        return {
            "word": self.word,
            "syntax": self.syntax,
            "comment": self.comment
        }

class AnalysisResult(BaseModel):
    # is_normal_sentence: bool = Field(..., title="정상적인 문장 여부", description="사용자가 작성한 문장이 정상적인 문장인지 여부를 나타냅니다.")
    # is_harmful_sentence: bool = Field(..., title="유해한 문장 여부", description="사용자가 작성한 문장이 유해한 문장인지 여부를 나타냅니다.")
    # is_invalid_structure: bool = Field(..., title="잘못된 문장 구조 여부", description="문장 구조가 잘못되었는지 여부를 나타냅니다.")
    kr: str = Field(..., title="한글 번역 결과", description="한글 번역 결과입니다.")
    en: str = Field(..., title="영어 문장", description="입력된 영어 문장입니다. 문법적 오류를 개선한 문장을 제공합니다.")
    result: List[PartialAnalysisResult] = Field(..., title="문법적 분석 결과", description="문장의 각 단어에 대한 문법적 역할을 분석한 결과입니다.")

    def to_dict(self) -> dict:
        return {
            # "is_normal_sentence": self.is_normal_sentence,
            # "is_harmful_sentence": self.is_harmful_sentence,
            # "is_invalid_structure": self.is_invalid_structure,
            "kr": self.kr,
            "en": self.en,
            "result": [r.to_dict() for r in self.result]
        }


def get_analysis_result(request, headers):
    # Get the API key from environment variables
    api_key = os.getenv('API_KEY', 'AIzaSyBw6HkIZSKepeD1rWlQcJxHuUqla9UmC9k')
    if not api_key:
        return {'error': 'API key not found'}, 500, headers

    # Extract prompt from request
    request_json = request.get_json(silent=True) # POST data
    request_args = request.args # query params

    # Get inputs
    prompt = request_json.get('prompt')
    model = request_args.get('model', 'gemini-pro')
    max_output_tokens = request_args.get('max_output_tokens', 8192)

    if prompt is None:
        return {'error': 'Input data is empty'}, 500, headers

    if model not in ['gemini-pro']:
        return {'error': f"Invalid model type: {model}"}, 500, headers

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
            data = yaml.load(raw_text, Loader=yaml.FullLoader)
            valid_text = AnalysisResult(**data)
            break
        except Exception as e:
            logger.error(f"Failed to parse the response: {e}")
            continue
    
    if valid_text is None:
        return {'error': 'Failed to parse the response'}, 500, headers

    valid_text = valid_text.to_dict()
    valid_text = json.dumps(valid_text, indent=4, ensure_ascii=False)
    return valid_text, 200, headers


def get_analysis_template(request, headers):
    return {}, 200, headers


@functions_framework.http
def main(request):
    """ Main API
    """
    # Set CORS headers for the preflight request
    if request.method == "OPTIONS":
        # Allows GET requests from any origin with the Content-Type
        # header and caches preflight response for an 3600s
        headers = {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Max-Age": "3600",
        }

        return ("", 204, headers)

    # Set CORS headers for the main request
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Max-Age": "3600",
    }

    if request.method == "POST":
        return get_analysis_result(request, headers)
    elif request.method == "GET":
        return get_analysis_template(request, headers)
    else:
        return {"error": "Method not allowed"}, 405, headers