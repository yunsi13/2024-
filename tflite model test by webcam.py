import cv2
import numpy as np
import tensorflow as tf

# .tflite 모델 로드
model_path = "image_classification_model_MobileNet.tflite"
interpreter = tf.lite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

# 입력과 출력 텐서 정보 가져오기
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# 라벨 파일 정의
labels = ['Clothes', 'Electronics', 'Furniture', 'Glass', 'Metal', 'Paper', 'Plastic', 'Shoes', 'Styrofoam', 'Vinyl']

# 웹캠 설정
cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("웹캠을 열 수 없습니다.")
    exit()

while True:
    # 웹캠에서 프레임 읽기
    ret, frame = cap.read()
    if not ret:
        print("프레임을 읽을 수 없습니다.")
        break
    
    # 이미지를 모델 입력 크기로 조정 (224x224) 후 예측
    img = cv2.resize(frame, (224, 224))
    img = img / 255.0  # 스케일링
    img = img.astype(np.float32)  # 자료형을 FLOAT32로 변환
    img = np.expand_dims(img, axis=0)  # 배치 차원 추가

    # 모델로 예측 수행
    interpreter.set_tensor(input_details[0]['index'], img)
    interpreter.invoke()
    predictions = interpreter.get_tensor(output_details[0]['index'])
    
    class_index = np.argmax(predictions)
    class_label = labels[class_index]
    confidence = predictions[0][class_index]

    # 예측 결과 화면에 표시
    cv2.putText(frame, f"Prediction: {class_label} ({confidence:.2f})", (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)

    # 결과 출력
    cv2.imshow('Webcam Image Classification', frame)

    # 'q' 키를 누르면 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 리소스 해제
cap.release()
cv2.destroyAllWindows()
