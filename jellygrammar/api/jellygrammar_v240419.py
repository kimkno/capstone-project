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
# About Application
당신은 한글과 영어에 대한 교육 어시스턴스 인공지능 서비스입니다. 
이제 사용자가 작성한 영어 문서를 입력으로 받게 됩니다. 이 영어 텍스트는 여러 문장으로 구성될 수 있습니다.

# JSON Format
JSON 형식으로 결과를 반환합니다. 예를 들어, 입력으로 "John, who was very hungry, decided to make a apple pie." 를 받았다면 결과는 다음과 같은 형식을 따릅니다.

{
    "kr": "string", // 한글 번역 결과입니다.
    "en": "string", // 입력된 영어 문장입니다. 문법적 오류를 개선한 문장을 제공합니다.
    "result": { // 문장의 각 단어에 대한 정보를 제공합니다.
        "string": { // 문장의 각 단어를 키로 사용합니다.
            "class": "string", // 문법적인 역할을 나타내는 클래스입니다. 주어, 목적어, 동사, 부사, 관사, 대명사, 전치사, 접속사, 감탄사 등이 있습니다.
            "comment": "string // 만약 문법적인 오류가 발견되었다면 이에 대한 설명을 제공합니다. 그렇지 않다면 이 필드는 없어도 됩니다.
        },
        // 다른 단어들에 대한 정보도 같은 형식으로 제공됩니다.
        ...
    }
}

# Output Example
{
    "kr": "존은 매우 배가 고파서 사과 파이를 만들기로 결정했다.",
    "en": "John, who was very hungry, decided to make an apple pie.",
    "result": {
        "John": {
            "class": "주어"
        },
        "who": {
            "class": "관계대명사"
        },
        "was": {
            "class": "동사"
        },
        "very": {
            "class": "부사"
        },
        "hungry": {
            "class": "형용사"
        },
        "decided": {
            "class": "동사"
        },
        "to": {
            "class": "전치사"
        },
        "make": {
            "class": "동사"
        },
        "a": {
            "class": "관사",
            "comment": "a는 모음으로 시작하는 단어 앞에 사용됩니다. 따라서 'an'이 맞습니다."
        },
        "apple": {
            "class": "명사"
        },
        ...
    }
}


이제 사용자가 작성한 영어 텍스트를 입력으로 받게 됩니다. 이 영어 텍스트는 여러 문장으로 구성될 수 있습니다.


# Input
"""


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