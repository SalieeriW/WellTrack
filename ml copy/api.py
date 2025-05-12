import math
from flask import Flask, request, jsonify
from PIL import Image
import io
import cv2
import mediapipe as mp
import numpy as np
from typing import Optional
import tensorflow as tf
from flask import Flask

import tensorflow as tf

app = Flask(__name__)
app.prediction_model = None

try:
    app.prediction_model = tf.keras.models.load_model('efficientnet_model.h5')
    print("Model loaded successfully!")
    print(app.prediction_model.input_shape)
    app.prediction_model.summary()
except Exception as e:
    prediction_model = None
    print(f"Error loading model: {e}")

# Initialize MediaPipe (initialized once at startup)
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(max_num_hands=1, min_detection_confidence=0.8, min_tracking_confidence=0.8)
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(min_detection_confidence=0.8, min_tracking_confidence=0.8)

# Store calibration values here
calibration_values = {}
COMPARISON_THRESHOLD = {
    "ear": 0.04,  # Threshold for Eye Aspect Ratio
    "mar": 0.06,   # Threshold for Mouth Aspect Ratio
    "neck_straight": 10,  # Threshold for neck alignment in pixels
    "shoulder_angle": 8   # Threshold for shoulder alignment in degrees
}

LEFT_EYE = [33, 160, 158, 133, 153, 144]
RIGHT_EYE = [362, 385, 387, 263, 373, 380]
MOUTH = [91, 181, 61, 146, 84, 17, 314, 405]
FINGERS = [4, 8, 12, 16, 20]
LEFT_SHOULDER = 113
RIGHT_SHOULDER = 343

def euclidean_distance(point1, point2):
    return np.linalg.norm(np.array(point1) - np.array(point2))

def eye_aspect_ratio(eye_landmarks):
    A = euclidean_distance(eye_landmarks[1], eye_landmarks[5])
    B = euclidean_distance(eye_landmarks[2], eye_landmarks[4])
    C = euclidean_distance(eye_landmarks[0], eye_landmarks[3])
    return (A + B) / (2.0 * C) if C > 0 else 0

def mouth_aspect_ratio(mouth_landmarks):
    A = euclidean_distance(mouth_landmarks[1], mouth_landmarks[5])
    B = euclidean_distance(mouth_landmarks[2], mouth_landmarks[4])
    C = euclidean_distance(mouth_landmarks[0], mouth_landmarks[6])
    return (A + B) / (2.0 * C) if C > 0 else 0

def count_fingers(hand_landmarks):
    finger_states = []
    if hand_landmarks:
        for tip_index in FINGERS:
            tip = hand_landmarks.landmark[tip_index].y
            mcp = hand_landmarks.landmark[tip_index - 3].y
            finger_states.append(1 if tip < mcp else 0)
        # Thumb logic (simplified for one perspective)
        if hand_landmarks.landmark[4].x > hand_landmarks.landmark[5].x:
            finger_states[0] = 1
        else:
            finger_states[0] = 0
        return sum(finger_states)
    return None

def is_neck_straight(landmarks, width):
    if landmarks and len(landmarks) > 152:
        nose_tip = landmarks[4]
        chin = landmarks[152]
        nose_x = nose_tip.x * width
        chin_x = chin.x * width
        current_neck_diff = abs(nose_x - chin_x)
        return current_neck_diff
    return None

def are_shoulders_aligned(landmarks, width, height):
    if landmarks and len(landmarks) > max(LEFT_SHOULDER, RIGHT_SHOULDER):
        left_shoulder = landmarks[LEFT_SHOULDER]
        right_shoulder = landmarks[RIGHT_SHOULDER]
        left_shoulder_px = (int(left_shoulder.x * width), int(left_shoulder.y * height))
        right_shoulder_px = (int(right_shoulder.x * width), int(right_shoulder.y * height))

        delta_y = right_shoulder_px[1] - left_shoulder_px[1]
        delta_x = right_shoulder_px[0] - left_shoulder_px[0]
        angle_rad = math.atan2(delta_y, delta_x)
        angle_deg = math.degrees(angle_rad)

        return angle_deg
    return None

def process_image(image_bytes):
    try:
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        frame = np.array(image)
        height, width, _ = frame.shape
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        hand_results = hands.process(rgb_frame)
        face_results = face_mesh.process(cv2.cvtColor(rgb_frame, cv2.COLOR_BGR2RGB))

        features = {}

        if hand_results.multi_hand_landmarks:
            for hand_landmarks in hand_results.multi_hand_landmarks:
                features["finger_count"] = count_fingers(hand_landmarks)

        if face_results.multi_face_landmarks:
            for face_landmarks in face_results.multi_face_landmarks:
                landmarks = face_landmarks.landmark
                face_landmarks_pixels = [(lm.x, lm.y) for lm in landmarks]
                left_eye_points = [face_landmarks_pixels[i] for i in LEFT_EYE]
                right_eye_points = [face_landmarks_pixels[i] for i in RIGHT_EYE]
                mouth_points = [face_landmarks_pixels[i] for i in MOUTH]

                # Convert normalized to pixel coordinates for distance calculations
                left_eye_pixels = [(int(x * width), int(y * height)) for x, y in left_eye_points]
                right_eye_pixels = [(int(x * width), int(y * height)) for x, y in right_eye_points]
                mouth_pixels = [(int(x * width), int(y * height)) for x, y in mouth_points]

                features["ear"] = (eye_aspect_ratio(left_eye_pixels) + eye_aspect_ratio(right_eye_pixels)) / 2.0
                features["mar"] = mouth_aspect_ratio(mouth_pixels)
                features["neck_straight"] = is_neck_straight(landmarks, width)
                features["shoulder_angle"] = are_shoulders_aligned(landmarks, width, height)

        return features
    except Exception as e:
        return {"error": str(e)}


@app.route('/calibrate', methods=['POST'])
def calibrate():
    if 'image' not in request.files:
        return jsonify({"error": "No image part in the request"}), 400
    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No selected image"}), 400
    if file:
        image_bytes = file.read()
        features_list = []
        for _ in range(30):
            features = process_image(image_bytes)
            features_list.append(features)
        
        # Calculate the average of each feature
        global calibration_values
        calibration_values = {key: sum(f[key] for f in features_list if key in f and isinstance(f[key], (int, float))) / len(features_list) 
                      for key in features_list[0]}
        
        print("Calibration values:", calibration_values)
        return jsonify({"message": "Calibration successful", "calibration_values": calibration_values})
    return jsonify({"error": "Calibration failed"})

@app.route('/analyze', methods=['POST'])
def analyze():
    if not calibration_values:
        return jsonify({"error": "Please calibrate first by sending an image to /calibrate"}), 400
    if 'image' not in request.files:
        return jsonify({"error": "No image part in the request"}), 400
    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No selected image"}), 400
    if file:
        image_bytes = file.read()
        features_list = [process_image(image_bytes) for _ in range(30)]
        new_features = {key: sum(f[key] for f in features_list if key in f and isinstance(f[key], (int, float))) / len(features_list) 
                for key in features_list[0]}
        analysis_results = {}
        print("New features:", new_features)
        for key, new_value in new_features.items():
            calibration_value = calibration_values.get(key)
            if calibration_value is not None and isinstance(new_value, (int, float)):
                if abs(new_value - calibration_value) > COMPARISON_THRESHOLD.get(key):
                    analysis_results[f"{key}_deviated"] = True
                else:
                    analysis_results[f"{key}_deviated"] = False
            else:
                analysis_results[key] = new_value
        analysis_results["finger_count"] = new_features.get("finger_count", 0)
        if app.prediction_model:
            image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            image = np.asarray(image.resize((160,160)))
          
            prediction = app.prediction_model.predict(np.asarray([image]))
            
            # Imprime las probabilidades de cada clase
            print("Predictions:", prediction)
            
            itemindex = np.where(prediction == np.max(prediction))
            prediction = int(itemindex[1][0])  # Convierte a int

            analysis_results["drinking"] = prediction == 4  # Assuming class 4 is "drinking"


        else:
            analysis_results["drinking"] = "Model not loaded"
        return jsonify(analysis_results)
    return jsonify({"error": "Analysis failed"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')