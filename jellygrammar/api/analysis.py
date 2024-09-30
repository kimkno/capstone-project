import functions_framework
import os
import json
import httpx
import pathlib
import textwrap
import google.generativeai as genai


@functions_framework.http
def gemini(request):
    """Gemini 1.0 API proxy
    Args:
        request (flask.Request): The request object.
    Returns:
        Gemini API response.
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

    # Get the API key from environment variables
    api_key = os.getenv('API_KEY')
    if not api_key:
        return {'error': 'API key not found'}, 500, headers

    # Extract prompt from request
    request_json = request.get_json(silent=True) # POST data
    request_args = request.args # query params

    # Get inputs
    prompt = request_json.get('prompt')
    model = request_args.get('model', 'gemini-pro')

    if prompt is None:
        return {'error': 'Input data is empty'}, 500, headers

    if model not in ['gemini-pro']:
        return {'error': f"Invalid model type: {model}"}, 500, headers

    # Init
    genai.configure(api_key=api_key)
    gen = genai.GenerativeModel(model)

    # Generate
    response = gen.generate_content(prompt)
    
    prompt_feedback = dict()
    for feedback in response.prompt_feedback.safety_ratings:
        prompt_feedback[feedback.category.name] = feedback.probability.name

    return {'output': response.text, 'prompt_feedback': prompt_feedback}, 200, headers