"""영어 학습 추천을 위한 Gemini API 사용 모듈"""

import os
import json
import logging
import google.generativeai as genai


# Logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Prompt
GRAMMAR_SYSTEM_PROMPT = """
당신은 사용자의 영어 학습 기록을 참조하여, 추가 영어 학습을 위한 영어 문장을 생성합니다.
기본적으로 한국식 영어 문법 구조 학습에 적절한 1, 2, 3, 4, 5형식 문장 중 랜덤으로 5개 문장을 생성합니다.
만약 학습 기록이 3개 이하일 경우 Cold Start 를 위해 간단한 1, 2 형식 문장 중 랜덤으로 5개 문장을 생성합니다.

생성 결과는 python 의 string 의 list 형식으로 처리할 수 있는 형식으로 반환합니다.
예를 들어서 "[\"This is first sentence.\", \"This is second sentence.\", \"This is third sentence.\", \"This is fourth sentence.\", \"This is fifth sentence.\"]"

```input
{input_texts}
```
"""

def get_recommended_sentences(event):
    """추천 문장을 가져옵니다."""
    # Get the API key from environment variables
    api_key = os.environ.get('GOOGLE_API_KEY')
    if not api_key:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'API key not found'})
        }

    # Extract history from request body
    body = json.loads(event.get('body', '{}'))
    histories = body.get('history')

    query_params = event.get('queryStringParameters', {})
    model = query_params.get('model', 'gemini-pro')
    max_output_tokens = int(query_params.get('max_output_tokens', 8192))
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
    system_prompt = GRAMMAR_SYSTEM_PROMPT.format(input_texts=histories)

    max_retry = 3
    sentences = None
    for _ in range(max_retry):
        response = gen.generate_content(system_prompt)
        try:
            # Return the analysis result
            sentences = json.loads(response.text)
            break
        except json.JSONDecodeError as e:
            logger.error("응답 파싱 실패: %s", str(e))
            continue

    if sentences is None:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to parse the response'})
        }

    return {
        'statusCode': 200,
        'body': json.dumps({'sentences': sentences}, ensure_ascii=False)
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
        result = get_recommended_sentences(event)
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
