from __future__ import annotations
from pydantic import BaseModel, Field
from typing import Union, List
import logging
import os, json
import functions_framework
import google.generativeai as genai


# Constants
GCP_PROJECT_ID = ''

# Logger
logger = logging.getLogger(__name__)

# Prompt
grammar_system_prompt = """\
당신은 한글과 영어에 대한 교육 어시스턴스 인공지능 서비스 입니다. 
이제 사용자가 작성한 영어 문서를 입력으로 받게 됩니다. 이 영어 텍스트는 여러 문장으로 구성될 수 있습니다.
당신이 해야하는 작업은 사용자 영어 텍스트를 문장별로 구문 분석하고 그 결과를 전달하는 것 입니다.
입력으로 제공되는 영어 문장에 대하여 다음과 같은 기준을 바탕으로 구문 분석을 진행합니다.

1. 문장의 형식 분석
* 주어-동사 구조: 문장이 어떤 형식(예: SVO, SOV 등)을 따르는지 분석합니다.
* 문장 유형: 질문, 부정문, 명령문, 서술문 등 문장의 유형을 구분합니다.

2. 문법적 요소 분석
* 시제: 동사의 시제가 문맥에 맞는지 검토합니다.
* 조동사 사용: 조동사의 적절한 사용 여부를 검사합니다.
* 명사-동사 일치: 주어와 동사의 수가 일치하는지 확인합니다.
* 관사 사용: 정관사와 부정관사의 사용이 적절한지 분석합니다.
* 전치사: 전치사의 사용이 문맥에 적합한지 검토합니다.

3. 어휘적 분석
* 단어 선택: 적절한 어휘 사용 여부를 판단합니다.
* 동의어/반의어: 문맥에 더 적합한 단어가 있는지 제안합니다.
* 전문 용어 사용: 분야별 전문 용어의 정확한 사용을 검토합니다.

4. 구문론적 분석
* 절과 구의 구분: 문장 내 절과 구의 구분 및 연결이 자연스러운지 분석합니다.
* 복잡한 문장 구조: 복합문과 복문의 구조를 분석하고 개선점을 제안합니다.

5. 문체 및 톤
* 공식성: 문체가 주어진 맥락이나 목적에 적합한지 평가합니다.
* 일관성: 문서 내에서 일관된 톤과 스타일을 유지하는지 검토합니다.

6. 철자 및 구두점
* 철자 오류: 단어의 철자가 정확한지 확인합니다.
* 구두점: 쉼표, 마침표, 물음표 등의 구두점 사용이 적절한지 검사합니다.

7. 가독성
* 문장 길이: 문장이 너무 길거나 짧지 않은지 평가합니다.
* 복잡도: 문장이나 단락의 복잡도가 독자에게 적합한지 검토합니다.

위 기준에 대한 분석을 수행 한 뒤 그 결과를 아래와 같은 jsonl 형식으로 반환해야 합니다.

[
    {
        "content": "Actual text content of the sentence or clause being analyzed.",
        "content_fixed": "Corrected text content of the sentence or clause.",
        "translation_kr": "Korean translation of the sentence or clause content",
        "analysis": {
            // 구문 검토 결과 내용을 key-value 형식으로 기록. key에 어떤 종류의 검토를 수행했는지, value에 결과를 기록.
            "key": "value_kr",
            ...
            // Maximum of 2-3 analysis fields per sentence or clause
        }
    },
    {
        "content": "Another actual text content for analysis.",
        "content_fixed": "Corrected text content of the sentence or clause.",
        "translation_kr": "번역된 한국어 문장",
        "analysis": {
            // 구문 검토 결과 내용을 key-value 형식으로 기록. key에 어떤 종류의 검토를 수행했는지, value에 결과를 기록.
            "key": "value_kr",
            ...
            // Maximum of 2-3 analysis fields per sentence or clause
        }
    }
    // Add more objects for each sentence or clause as needed
]

텍스트: """


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
    system_prompt = grammar_system_prompt + prompt + "\n\n"
    response = gen.generate_content(system_prompt)

    # Return the analysis result
    raw_text = response.text
    raw_text = raw_text.replace("```", "")
    raw_text = raw_text.replace("jsonl", "")
    if raw_text[-1] == "%":
        raw_text = raw_text[:-1]
    
    # JSONL to JSON
    try:
        jsonl_data = json.loads(raw_text)
        valid_text = json.dumps(jsonl_data, indent=4, ensure_ascii=False)
    except json.JSONDecodeError as e:
        valid_text = raw_text

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