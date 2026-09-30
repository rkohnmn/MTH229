# Volleyball Computer Vision & Tracking Pipeline

This pipeline demonstrates how match video footage is transformed into structured coordinate data for spatial court analytics.

---

## Architecture Overview

```
Broadcast Video (.mp4)
         │
         ▼
[Frame Extraction] (OpenCV / av)
         │
         ▼
[Object Detection] (YOLOv8 / OpenVolley ovml)
         │
         ▼
[Coordinate Normalization & Court Mapping]
   u, v ∈ [0, 1]  ──►  x ∈ [-9, 9]m, y ∈ [0, 9]m
         │
         ▼
Structured Tracking Output (ball_positions.csv)
```

---

## Scripts

1. **`vb_tracking.py` (Python)**:
   - Uses `opencv-python` to decode match video into frames at a specified sampling rate (10 fps).
   - Utilizes `ultralytics` YOLOv8 (`yolov8n.pt`) to detect the ball bounding box (`xmin, ymin, xmax, ymax`).
   - Computes normalized center coordinates $u = \frac{x_{\min} + x_{\max}}{2 \cdot W}$ and $v = \frac{y_{\max}}{H}$.
   - Exports detected frame positions to `ball_positions.csv`.

2. **`frame_convert.R` (R)**:
   - Uses `av` to sample frames at 25 fps.
   - Loads volleyball-specific detection weights via `ovml` (`4-mvb` model).
   - Maps normalized coordinates $(u, v)$ directly to physical court boundaries:
     $$x = -9 + 18u \quad (x \in [-9, 9] \text{ meters})$$
     $$y = 9v \quad (y \in [0, 9] \text{ meters})$$
   - Saves structured spatial observations to CSV.

---

## Setup & Prerequisites

### Python Dependencies
```bash
pip install opencv-python ultralytics pandas
```

### R Dependencies
```R
install.packages(c("av", "imager", "dplyr", "magrittr"))
# remotes::install_github("openvolley/ovml")
```
