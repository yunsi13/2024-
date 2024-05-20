import openai

# OpenAI API 키 설정
openai.api_key = 'add api key'

# ChatCompletion 인스턴스 생성 및 사용
response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[
        {"role": "system", "content": "너는 분리수거 방법을 알려주는 서비스야. 바코드 번호를 알려주면 제품정보와 분리수거 방법을 알려주면 돼."},
        {"role": "user", "content": "8801052993768"}
    ]
)

# 응답 출력
print(response['choices'][0]['message']['content'])
