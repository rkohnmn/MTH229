import cv2
import os

# Paths
video_path = "C:/Users/RobTop/Documents/STA227 - Data Visualization/vb/pol vs ita.mp4"
frames_dir = "frames"
os.makedirs(frames_dir, exist_ok=True)

# Load video
cap = cv2.VideoCapture(video_path)
fps = 10  # frames per second to extract

frame_count = 0
saved_count = 0
video_fps = cap.get(cv2.CAP_PROP_FPS)

while True:
    ret, frame = cap.read()
    if not ret:
        break
    if frame_count % int(video_fps / fps) == 0:
        frame_file = os.path.join(frames_dir, f"frame_{saved_count:04d}.png")
        cv2.imwrite(frame_file, frame)
        saved_count += 1
    frame_count += 1

cap.release()
print(f"Saved {saved_count} frames in {frames_dir}")

from ultralytics import YOLO
import glob
import pandas as pd

# Load a YOLOv8 model (you can use yolov8n.pt for speed)
model = YOLO("yolov8n.pt")

frame_files = sorted(glob.glob("frames/*.png"))
data = []

for i, file in enumerate(frame_files):
    results = model(file)
    for r in results:
        for box in r.boxes.xyxy.cpu().numpy():  # xmin, ymin, xmax, ymax
            xmin, ymin, xmax, ymax = box
            u = (xmin + xmax)/2 / r.orig_shape[1]  # normalized X (0-1)
            v = ymax / r.orig_shape[0]             # normalized Y (0-1)
            data.append([i+1, u, v, xmin, ymin, xmax, ymax])

# Save to CSV
df = pd.DataFrame(data, columns=["frame","u","v","xmin","ymin","xmax","ymax"])
df.to_csv("ball_positions.csv", index=False)
print("CSV saved!")
