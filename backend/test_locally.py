from lambda_function import lambda_handler

# 테스트 이벤트 생성
test_event = {
    'httpMethod': 'POST',
    'body': '{"prompt": "This is a test sentence."}',
    'queryStringParameters': {
        'model': 'gemini-pro',
        'max_output_tokens': '8192'
    }
}

# Lambda 핸들러 함수 호출
response = lambda_handler(test_event, None)

# 응답 출력
print("Status Code:", response['statusCode'])
print("Body:", response['body'])