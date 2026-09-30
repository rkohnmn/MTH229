"""
Volleyball Object Tracking Pipeline using OpenCV and YOLOv8
Author: Robert Kohn
Coursework: STA 227 / MTH 229, Muhlenberg College

Description:
  Extracts frames from match broadcast video and detects ball positions using
  YOLOv8 deep learning object detection. Outputs normalized coordinates (u, v)
  for subsequent court projection and 2D spatial density modeling.
"""

import os
import glob
import argparse
import cv2
import pandas as pd

def extract_frames(video_path, output_dir="frames", target_fps=10):
    """Extracts video frames at a uniform sampling rate."""
    os.makedirs(output_dir, exist_ok=True)
    cap = cv2.VideoCapture(video_path)
    
    if not cap.isOpened():
        raise FileNotFoundError(f"Cannot open video file: {video_path}")
        
    video_fps = cap.get(cv2.CAP_PROP_FPS)
    step = max(1, int(video_fps / target_fps))
    
    frame_count = 0
    saved_count = 0
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        if frame_count % step == 0:
            frame_file = os.path.join(output_dir, f"frame_{saved_count:05d}.png")
            cv2.imwrite(frame_file, frame)
            saved_count += 1
        frame_count += 1
        
    cap.release()
    print(f"Extracted {saved_count} frames to '{output_dir}'")
    return output_dir

def detect_ball_positions(frames_dir="frames", model_weights="yolov8n.pt", output_csv="ball_positions.csv"):
    """Runs YOLO object detection on extracted frames and saves coordinates."""
    from ultralytics import YOLO
    
    model = YOLO(model_weights)
    frame_files = sorted(glob.glob(os.path.join(frames_dir, "*.png")))
    data = []
    
    print(f"Running detection on {len(frame_files)} frames...")
    for idx, file_path in enumerate(frame_files):
        results = model(file_path, verbose=False)
        for r in results:
            for box in r.boxes.xyxy.cpu().numpy():
                xmin, ymin, xmax, ymax = box
                # Compute normalized court coordinate proxies (0 to 1)
                u = (xmin + xmax) / 2.0 / r.orig_shape[1]
                v = ymax / float(r.orig_shape[0])
                data.append([idx + 1, u, v, xmin, ymin, xmax, ymax])
                
    df = pd.DataFrame(data, columns=["frame", "u", "v", "xmin", "ymin", "xmax", "ymax"])
    df.to_csv(output_csv, index=False)
    print(f"Tracking data successfully saved to '{output_csv}' ({len(df)} detections)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Volleyball Ball Tracking Pipeline")
    parser.add_argument("--video", type=str, default="pol vs ita.mp4", help="Path to input match video")
    parser.add_argument("--frames-dir", type=str, default="frames", help="Directory to store extracted frames")
    parser.add_argument("--fps", type=int, default=10, help="Frames per second to sample")
    parser.add_argument("--weights", type=str, default="yolov8n.pt", help="Path to YOLO weights")
    parser.add_argument("--output", type=str, default="ball_positions.csv", help="Output CSV path")
    args = parser.parse_args()
    
    if os.path.exists(args.video):
        extract_frames(args.video, output_dir=args.frames_dir, target_fps=args.fps)
        detect_ball_positions(frames_dir=args.frames_dir, model_weights=args.weights, output_csv=args.output)
    else:
        print(f"Input video '{args.video}' not found. Please provide a valid video file.")
