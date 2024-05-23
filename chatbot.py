import openai

#open ai 키 입력
openai.api_key = 'your api key'

def chat_with_gpt(prompt):
  response = openai.ChatCompletion.create(
    model = "gpt-3.5-turbo",
    messages=[
      {"role": "user", "content": prompt}
    ]
  )
  return response.choices[0].message['content']

if __name__ == '__main__':
  user_input = input("Enter your message: ")
  response = chat_with_gpt(user_input)
  print("GPT Response:", response)
