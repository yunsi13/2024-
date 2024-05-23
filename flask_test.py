from flask import Flask, jsonify
import pandas as pd
import openai

# CSV 파일 경로
file_path = "C:/Users/diddi/A_python/data.csv"

# 데이터 프레임으로 CSV 파일 읽기
df = pd.read_csv(file_path, encoding='cp949')  # 인코딩은 파일에 맞춰서 조정

# 찾고자하는 바코드 설정 : 이 바코드를 스캐너로 스캔해서 번호를 받아와야함.. 수정 해야 됨.. .. .. . ..  .
target_barcode = 8801043014830 

# 바코드를 기준으로 데이터 검색
filtered_df = df[df['바코드'] == target_barcode]

# 검색된 데이터가 있는지 확인
if not filtered_df.empty:
    # '제품 재질 1,2'의 값을 가져옴
    product_info = filtered_df['상품명'].iloc[0]
    material_info_1 = filtered_df['제품 재질 1'].iloc[0]
    material_info_2 = filtered_df['제품 재질 2'].iloc[0]
else:
    # 해당 바코드에 대한 데이터가 없는 경우
    print(f"No data found for barcode {target_barcode}")


# OpenAI API 키 설정
openai.api_key = 'your api key'

# ChatCompletion 인스턴스 생성 및 사용
response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[
        {"role": "system", "content": "너는 분리수거 방법을 알려주는 서비스야. 제품정보와 재질정보에 따른 분리수거 방법을 알려줘."},
        {"role": "system", "content": f"제품정보는 {product_info},재질정보는 {material_info_1},{material_info_2}이야."},  
    ]
)

# 응답 출력 : 사용자에게 출력할 내용
output = response['choices'][0]['message']['content']

#flask 
app = Flask(__name__)

# 안드로이드 스튜디오로 넘기는 변수
my_variable = output

@app.route('/get_variable')
def get_variable():
    return jsonify(value=my_variable)

if __name__ == '__main__':
    app.run(debug=True)