library(ovml)
library(magrittr)
library(dplyr)
library(imager)
library(devtools)
library(av)

video_path <- "C:/Users/RobTop/Documents/STA227 - Data Visualization/vb/pol vs ita.mp4"
dir.create("frames", showWarnings = FALSE)
av_video_images(video_path, fps = 25, destdir = "frames")
frame_files <- list.files("frames", full.names = TRUE, pattern = "\\.png$")



# 2. Load the detection model (volleyball-specific YOLO model)
net <- ovml_yolo("4-mvb")


#define court
court <- list(
  xlim = c(-9, 9),
  ylim = c(0, 9)
)

# 5️⃣ Loop over frames and detect ball
results <- lapply(seq_along(frame_files), function(i) {
  img <- ovml_load_image(frame_files[i])
  
  # Detect objects
  dets <- ovml_yolo_detect(net, img, conf = 0.3)
  
  # Keep only ball detections
  ball_dets <- dets %>% filter(class == "sports ball")
  if (nrow(ball_dets) == 0) return(NULL)
  
  # Compute normalized coordinates (u,v)
  u <- (ball_dets$xmin + ball_dets$xmax) / 2 / img$width
  v <- ball_dets$ymax / img$height
  
  # Map to court meters
  x <- court$xlim[1] + u * (court$xlim[2] - court$xlim[1])
  y <- court$ylim[1] + v * (court$ylim[2] - court$ylim[1])
  
  data.frame(frame = i, u = u, v = v, x = x, y = y)
})

# 6️⃣ Combine into single data frame and remove NULLs
ball_positions <- do.call(rbind, results)

# 7️⃣ Save to CSV
write.csv(ball_positions, "ball_positions.csv", row.names = FALSE)
print("success")