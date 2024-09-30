# capstone-grammar-backend
## Installation
```bash
# Install poetry
pip install poetry

# Get the pypi package dependencies and install using pip
poetry export --without-hashes --format=requirements.txt > requirements.txt
pip install -r requirements.txt

# or using Poetry
poetry install
```

## Capstone Grammar
### v1.x
```bash
# v1.1 example
curl -X POST "https:/{}" \
-H "Content-Type: application/json" \
-d '{"model": "gemini-pro", "prompt": "He goes to the nearest store and look for the freshest apples they had."}'
```

```json
{
    "kr": "그는 가장 가까운 상점으로 가서 제일 신선한 사과를 찾았다.",
    "en": "He went to the nearest store and looked for the freshest apples they had.",
    "result": {
        "He": {
            "class": "주어"
        },
        "went": {
            "class": "동사"
        },
        "to": {
            "class": "전치사"
        },
        "the": {
            "class": "관사"
        },
        "nearest": {
            "class": "형용사"
        },
        "store": {
            "class": "명사"
        },
        "and": {
            "class": "접속사"
        },
        "looked": {
            "class": "동사"
        },
        "for": {
            "class": "전치사"
        },
        "freshest": {
            "class": "형용사",
            "comment": "most가 아닌 -est를 사용하는 것이 정확합니다."
        },
        "apples": {
            "class": "명사"
        },
        "they": {
            "class": "대명사"
        },
        "had": {
            "class": "동사"
        }
    }
}
```

### v240527
```bash
curl -X POST "{}" \
-H "Content-Type: application/json" \
-d '{"model": "gemini-pro", "prompt": "He goes to the nearest store and look for the freshest apples they had."}'
```

```json
{
    "is_normal_sentence": false,
    "is_harmful_sentence": false,
    "is_invalid_structure": true,
    "kr": "그는 가장 가까운 가게에 가서 가장 신선한 사과를 찾고 있었다.",
    "en": "He went to the nearest store and looked for the freshest apples they had.",
    "result": [
        {
            "id": "He",
            "class_name": "주어",
            "comment": null
        },
        {
            "id": "goes",
            "class_name": "동사",
            "comment": "과거형이어야 함"
        },
        {
            "id": "to",
            "class_name": "전치사",
            "comment": null
        },
        {
            "id": "the",
            "class_name": "관사",
            "comment": null
        },
        {
            "id": "nearest",
            "class_name": "형용사",
            "comment": null
        },
        {
            "id": "store",
            "class_name": "명사",
            "comment": null
        },
        {
            "id": "and",
            "class_name": "접속사",
            "comment": null
        },
        {
            "id": "look",
            "class_name": "동사",
            "comment": "과거형이어야 함"
        },
        {
            "id": "for",
            "class_name": "전치사",
            "comment": null
        },
        {
            "id": "the",
            "class_name": "관사",
            "comment": null
        },
        {
            "id": "freshest",
            "class_name": "형용사",
            "comment": null
        },
        {
            "id": "apples",
            "class_name": "명사",
            "comment": null
        },
        {
            "id": "they",
            "class_name": "주어",
            "comment": null
        },
        {
            "id": "had",
            "class_name": "동사",
            "comment": "과거완료형이어야 함"
        }
    ]
}
```