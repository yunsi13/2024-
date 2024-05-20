import pandas as pd
df = pd.read_csv("C:/Users/diddi/A_python/data.csv", encoding='cp949')

# 결과 출력
print(df[df['바코드'] == 8801043014830])
barcode = 8801052993768

#print(f'바코드: {barcode}')