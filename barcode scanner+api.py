import cv2
from pyzbar.pyzbar import decode
import requests

def get_product_info(barcode):
    api_key = "799afab4fbf24d66b4cf"  # API 키를 여기에 넣기
    api_url = f"https://www.foodsafetykorea.go.kr/apiMain.do{barcode}?apiKey={api_key}"
    response = requests.get(api_url)
    

    if response.status_code == 200:
        product_data = response.json()
        return product_data
    else:
        return None

def scan_barcode_and_get_info():
    cap = cv2.VideoCapture(0)  # 0번 카메라를 사용하여 웹캠을 엽니다.

    while True:
        ret, frame = cap.read()  # 웹캠에서 프레임을 읽어옵니다.
        if not ret:
            continue

        # 프레임에서 바코드를 찾습니다.
        barcodes = decode(frame)

        # 발견된 바코드를 출력합니다.
        if barcodes:
            for barcode in barcodes:
                barcode_data = barcode.data.decode("utf-8")
                print("바코드:", barcode_data)

                # 바코드를 사용하여 제품 정보 가져오기
                product_info = get_product_info(barcode_data)
                if product_info:
                    # 제품 정보 출력
                    print("제품명:", product_info.get('name', '정보 없음'))
                    print("가격:", product_info.get('salePrice', '정보 없음'))
                    print("카테고리:", product_info.get('categoryPath', '정보 없음'))
                else:
                    print("제품 정보를 찾을 수 없습니다.")

        # 프레임을 화면에 표시합니다.
        cv2.imshow('Barcode Scanner', frame)

        # 'q' 키를 누르면 종료합니다.
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

scan_barcode_and_get_info()
