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

참고로 평가에 앞서 사용자가 작성한 문장이 정상적인 문장인지, 내용이 유해하거나 비정상적인 문장 구조를 가지고 있는지도 확인해야 합니다.

영어 작문 평가 결과는 yaml 형식으로 작성되어야 합니다. yaml 형식은 다음과 같은 형식을 따릅니다.

```yaml
is_normal_sentence: <Whether the sentence is normal or not>
is_harmful_sentence: <Whether the sentence is harmful or not>
is_invalid_structure: <Whether the sentence has invalid structure or not>
kr: "<Korean translation>"
en: "<Fixed English sentence>"
result:
  - id: "<Target word(s) to analyze>"
    class_name: "<Grammar class of the word>"
    comment: "<Comment if there is fix needed>"
```

예를 들면, 입력으로 "John, who was very hungry, decided to make a apple pie." 를 받았다면 결과는 다음과 같은 형식을 따릅니다.

```yaml
is_normal_sentence: true
is_harmful_sentence: false
is_invalid_structure: false
kr: "존은 매우 배가 고파서 사과 파이를 만들기로 결정했다."
en: "John, who was very hungry, decided to make an apple pie."
result:
  - id: "John"
    class_name: "주어"
    comment: null
  - id: "who"
    class_name: "관계대명사"
    comment: null
  - id: "was"
    class_name: "동사"
    comment: null
  - id: "very"
    class_name: "부사"
    comment: null
  - id: "hungry"
    class_name: "형용사"
    comment: null
  - id: "decided"
    class_name: "동사"
    comment: null
  - id: "to"
    class_name: "전치사"
    comment: null
  - id: "make"
    class_name: "동사"
    comment: null
  - id: "a"
    class_name: "관사"
    comment: "사과는 모음으로 시작하는 단어이므로 'a' 대신 'an'를 사용해야 합니다."
  - id: "apple"
    class_name: "명사"
    comment: null
  - id: "pie"
    class_name: "명사"
    comment: null
```

생성된 평가 결과는 yaml 형식으로 parsing 가능해야 합니다. 그 외의 답변은 허용되지 않습니다.
이제 사용자가 작성한 영어 텍스트를 입력으로 받게 됩니다. 이 영어 텍스트는 여러 문장으로 구성될 수 있습니다.
주어진 문장을 분석하여 yaml 형식으로 작성된 평가 결과를 반환하세요.


```input
{input_text}
```


"""

# class PartialAnalysisResult(BaseModel):
#     class_name: str = Field(..., title="문법적 역할", description="문법적인 역할을 나타내는 클래스입니다. 주어, 목적어, 동사, 부사, 관사, 대명사, 전치사, 접속사, 감탄사 등이 있습니다.")
#     comment: Union[str, None] = Field(None, title="문법적 오류 설명", description="만약 문법적인 오류가 발견되었다면 이에 대한 설명을 제공합니다. 그렇지 않다면 이 필드는 없어도 됩니다.")

class PartialAnalysisResult(BaseModel):
    id: str = Field(..., title="단어", description="문장의 각 단어를 키로 사용합니다.")
    class_name: str = Field(..., title="문법적 역할", description="문법적인 역할을 나타내는 클래스입니다. 주어, 목적어, 동사, 부사, 관사, 대명사, 전치사, 접속사, 감탄사 등이 있습니다.")
    comment: Union[str, None] = Field(None, title="문법적 오류 설명", description="만약 문법적인 오류가 발견되었다면 이에 대한 설명을 제공합니다. 그렇지 않다면 이 필드는 없어도 됩니다.")


class AnalysisResult(BaseModel):
    is_normal_sentence: bool = Field(..., title="정상적인 문장 여부", description="사용자가 작성한 문장이 정상적인 문장인지 여부를 나타냅니다.")
    is_harmful_sentence: bool = Field(..., title="유해한 문장 여부", description="사용자가 작성한 문장이 유해한 문장인지 여부를 나타냅니다.")
    is_invalid_structure: bool = Field(..., title="잘못된 문장 구조 여부", description="문장 구조가 잘못되었는지 여부를 나타냅니다.")
    kr: str = Field(..., title="한글 번역 결과", description="한글 번역 결과입니다.")
    en: str = Field(..., title="영어 문장", description="입력된 영어 문장입니다. 문법적 오류를 개선한 문장을 제공합니다.")
    result: List[PartialAnalysisResult] = Field(..., title="문법적 분석 결과", description="문장의 각 단어에 대한 문법적 역할을 분석한 결과입니다.")


# Get the API key from environment variables
api_key = os.getenv('API_KEY', 'AIzaSyBw6HkIZSKepeD1rWlQcJxHuUqla9UmC9k')
if not api_key:
    # return {'error': 'API key not found'}, 500, headers
    raise ValueError('API key not found')

# Extract prompt from request
# request_json = request.get_json(silent=True) # POST data
# request_args = request.args # query params

# Get inputs
# prompt = request_json.get('prompt')
# model = request_args.get('model', 'gemini-pro')
# max_output_tokens = request_args.get('max_output_tokens', 8192)
prompt = "John, who was very hungry, decided to make a apple pie."
model = "gemini-pro"
max_output_tokens = 8192

if prompt is None:
    # return {'error': 'Input data is empty'}, 500, headers
    raise ValueError('Input data is empty')

if model not in ['gemini-pro']:
    # return {'error': f"Invalid model type: {model}"}, 500, headers
    raise ValueError(f"Invalid model type: {model}")

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
        print(f"\n\n{raw_text}\n\n")
        data = yaml.load(raw_text, Loader=yaml.FullLoader)
        valid_text = AnalysisResult(**data)
        break
    except Exception as e:
        logger.error(f"Failed to parse the response: {e}")
        continue

if valid_text is None:
    # return {'error': 'Failed to parse the response'}, 500, headers
    raise ValueError('Failed to parse the response')

# return valid_text.dict(), 200, headers
print(valid_text.dict())