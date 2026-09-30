# ==============================================================================
# Frame Extraction and Ball Detection using OpenVolley (ovml)
# Author: Robert Kohn
# Coursework: STA 227 / MTH 229, Muhlenberg College
# ==============================================================================

library(av)
library(dplyr)
library(magrittr)

# Optional packages for ovml detection
# library(ovml)
# library(imager)

video_path  <- "pol vs ita.mp4"
frames_dir  <- "frames"
output_csv  <- "ball_positions.csv"

# 1. Extract frames from video if video exists
if (file.exists(video_path)) {
  dir.create(frames_dir, showWarnings = FALSE)
  message(sprintf("Extracting frames from '%s' at 25 fps...", video_path))
  av_video_images(video_path, fps = 25, destdir = frames_dir)
  frame_files <- list.files(frames_dir, full.names = TRUE, pattern = "\\.png$")
  message(sprintf("Extracted %d frames.", length(frame_files)))
} else {
  message(sprintf("Video file '%s' not found. Ready to process existing frames if available.", video_path))
  frame_files <- list.files(frames_dir, full.names = TRUE, pattern = "\\.png$")
}

# 2. Court coordinate physical limits (in meters)
court <- list(
  xlim = c(-9, 9),  # 18 meters total length across both sides of the net
  ylim = c(0, 9)    # 9 meters court width
)

# 3. Detection and coordinate mapping logic (requires ovml package)
if (requireNamespace("ovml", quietly = TRUE) && length(frame_files) > 0) {
  library(ovml)
  library(imager)
  
  net <- ovml_yolo("4-mvb")
  
  message("Running object detection on frames...")
  results <- lapply(seq_along(frame_files), function(i) {
    img <- ovml_load_image(frame_files[i])
    dets <- ovml_yolo_detect(net, img, conf = 0.3)
    
    ball_dets <- dets %>% filter(class == "sports ball")
    if (nrow(ball_dets) == 0) return(NULL)
    
    # Compute normalized image coordinates (u, v)
    u <- (ball_dets$xmin + ball_dets$xmax) / 2 / img$width
    v <- ball_dets$ymax / img$height
    
    # Map to court physical meters
    x <- court$xlim[1] + u * (court$xlim[2] - court$xlim[1])
    y <- court$ylim[1] + v * (court$ylim[2] - court$ylim[1])
    
    data.frame(frame = i, u = u, v = v, x = x, y = y)
  })
  
  ball_positions <- do.call(rbind, results)
  write.csv(ball_positions, output_csv, row.names = FALSE)
  message(sprintf("Successfully exported %d detections to '%s'", nrow(ball_positions), output_csv))
} else {
  message("ovml package or frame files not detected. Frame conversion pipeline logic defined.")
}
