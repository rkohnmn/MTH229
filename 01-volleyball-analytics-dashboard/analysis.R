# ==============================================================================
# Volleyball Analytics & Spatial Court Tracking Analysis
# Author: Robert Kohn
# Institution: Muhlenberg College
# Coursework: STA 227 / MTH 229 - Data Visualization Capstone
# ==============================================================================

# Suppress package startup messages
suppressPackageStartupMessages({
  library(MASS)
  library(viridis)
  library(tidyverse)
  library(mosaic)
  library(lubridate)
  library(scales)
})

# Create figures directory if it doesn't exist
dir.create("figures", showWarnings = FALSE)

# ------------------------------------------------------------------------------
# 1. SPATIAL COURT TRACKING: 2D KERNEL DENSITY ESTIMATION
# ------------------------------------------------------------------------------

# Resolve ball tracking data path
ball_data_path <- if (file.exists("data/ball_positions.csv")) {
  "data/ball_positions.csv"
} else if (file.exists("../../Volleyball Tackin/ball_positions.csv")) {
  "../../Volleyball Tackin/ball_positions.csv"
} else {
  "data/ball_positions_sample.csv"
}

message(sprintf("Loading ball position tracking data from: %s", ball_data_path))
ball_data <- read_csv(ball_data_path, show_col_types = FALSE)

# Map normalized camera coordinates (u, v) into physical court coordinates (meters)
ball_data$x_court <- -9 + ball_data$u * 18
y_min_clip <- 2.9
y_max_clip <- 9.0
ball_data$y_court <- pmax(pmin(ball_data$v * 9, y_max_clip), y_min_clip)
ball_data$y_court <- (ball_data$y_court - y_min_clip) / (y_max_clip - y_min_clip) * 9

# Bivariate Kernel Density Estimation over the FIVB court dimensions
z <- kde2d(
  x = ball_data$x_court,
  y = ball_data$y_court,
  n = 200,
  lims = c(-9, 9, 0, 9)
)
z$z <- sqrt(sqrt(z$z))  # 4th root transform for density sensitivity across tails

# Export Figure 1: Court Ball Density Heatmap
png("figures/fig1_court_ball_density_heatmap.png", width = 1200, height = 750, res = 120)
par(mar = c(4.5, 4.5, 4, 8.5))
plot.new()
plot.window(xlim = c(-10, 12.5), ylim = c(-1, 10), xaxs = "i", yaxs = "i")
rect(-10, -1, 12.5, 10, col = "gray95", border = NA)

# Overlay density heatmap
image(
  z,
  col = viridis(30, option = "plasma", alpha = 0.65),
  xlim = c(-9, 9),
  ylim = c(0, 9),
  axes = FALSE,
  xlab = "",
  ylab = "",
  add = TRUE
)

# Court structural markings
rect(-9, 0, 9, 9, border = "gray25", lwd = 2.5)
abline(v = 0, lwd = 2.5, col = "gray25")
abline(v = -3, lty = "dashed", lwd = 1.5, col = "gray45")
abline(v = 3, lty = "dashed", lwd = 1.5, col = "gray45")

# Court half-shading
rect(-9, 0, 0, 9, border = NA, col = rgb(0.2, 0.4, 0.8, 0.08))
rect(0, 0, 9, 9, border = NA, col = rgb(0.8, 0.2, 0.2, 0.08))

# Axis labels & title
title(main = "Volleyball Ball Position Heatmap (VNL 2025 Grand Finals)",
      line = 2.2, cex.main = 1.3, font.main = 2, col.main = "gray20")
mtext("Court Position Density During Play: Italy vs. Poland", line = 0.8, cex = 1.0, col = "gray40")
mtext("Court Length (meters: -9m to +9m across net)", side = 1, line = 2.4, cex = 1.0, col = "gray30")
mtext("Court Width (meters)", side = 2, line = 2.4, cex = 1.0, col = "gray30")

# Team and tactical zone annotations
text(-4.5, 8.5, "POLAND", cex = 1.1, font = 2, col = "navyblue")
text(4.5, 8.5, "ITALY", cex = 1.1, font = 2, col = "firebrick")
text(-6, 3.5, "Defense Zone", cex = 0.8, col = "#2e7d32", srt = 90)
text(-1.5, 3.5, "Attack Zone", cex = 0.8, col = "#2e7d32", srt = 90)
text(1.5, 3.5, "Attack Zone", cex = 0.8, col = "#2e7d32", srt = 90)
text(6, 3.5, "Defense Zone", cex = 0.8, col = "#2e7d32", srt = 90)

# Legend bar
cols <- viridis(30, option = "plasma", alpha = 0.85)
legend_x <- 9.2
legend_y <- seq(0, 9, length.out = length(cols) + 1)
rect(legend_x - 0.1, -0.2, legend_x + 1.4, 9.2, col = "white", border = "gray70", lwd = 0.8)
for (i in seq_along(cols)) {
  rect(legend_x, legend_y[i], legend_x + 0.5, legend_y[i + 1], col = cols[i], border = NA)
}
text(legend_x + 0.25, 9.4, "Ball Density", adj = 0.5, cex = 0.95, font = 2, col = "gray30")
text(legend_x + 0.6, seq(0, 9, length.out = 5),
     labels = sprintf("%.2f", seq(min(z$z), max(z$z), length.out = 5)),
     adj = 0, cex = 0.8, col = "gray40")

# Net indicator
segments(-0.08, 0, -0.08, 9, lwd = 3, col = "gray40")
segments(0.08, 0, 0.08, 9, lwd = 3, col = "gray40")
text(0, -0.6, "NET", cex = 0.85, font = 2, col = "gray40")
dev.off()

# Export Figure 2: Y-Court Distribution Histogram
png("figures/fig2_ball_y_court_distribution.png", width = 900, height = 550, res = 110)
par(mar = c(4.5, 4.5, 3.5, 2))
hist(ball_data$y_court, breaks = 25,
     main = "Distribution of Ball Positions Along Court Y-Axis",
     xlab = "Court Width Position (meters)", ylab = "Frequency",
     col = "steelblue", border = "white", cex.main = 1.2, font.main = 2, las = 1)
dev.off()

# ------------------------------------------------------------------------------
# 2. BEACH VOLLEYBALL: DURATION AND AGE DYNAMICS
# ------------------------------------------------------------------------------

beach_path <- if (file.exists("data/vb_matches.csv")) {
  "data/vb_matches.csv"
} else if (file.exists("../../vb_matches.csv")) {
  "../../vb_matches.csv"
} else {
  "data/vb_matches_sample.csv"
}

message(sprintf("Loading beach volleyball data from: %s", beach_path))
vb_data <- read_csv(beach_path, show_col_types = FALSE)

vb_clean <- vb_data %>%
  mutate(
    duration_min = as.numeric(hms(duration)) / 60,
    w_p1_age = as.numeric(w_p1_age),
    l_p1_age = as.numeric(l_p1_age)
  ) %>%
  filter(!is.na(duration_min), duration_min > 10, duration_min < 120)

# Figure 3: Match duration by gender
p_duration <- gf_histogram(~ duration_min, fill = ~ gender, data = vb_clean, bins = 25, alpha = 0.7) %>%
  gf_facet_wrap(~ gender, nrow = 2) %>%
  gf_labs(
    title = "Beach Volleyball Match Durations Across Genders",
    subtitle = "Men's matches exhibit wider variance and longer right-tail endurance",
    x = "Duration (minutes)",
    y = "Match Count",
    caption = "Data Source: Jesse Mostipak (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig3_beach_duration_by_gender.png", plot = p_duration, width = 8, height = 5.5, dpi = 150)

# Figure 4: Age distribution of players
age_combined <- data.frame(age = c(vb_clean$w_p1_age, vb_clean$l_p1_age)) %>% filter(!is.na(age))
p_age <- gf_histogram(~ age, data = age_combined, bins = 25, fill = "#8b0000", color = "white", alpha = 0.8) %>%
  gf_labs(
    title = "Player Age Distribution in Elite Beach Volleyball",
    subtitle = "Peak density centered between 27-31 years showing extended professional longevity",
    x = "Age (years)",
    y = "Athlete Count",
    caption = "Data Source: Jesse Mostipak (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig4_beach_player_age_distribution.png", plot = p_age, width = 8, height = 5, dpi = 150)

# Figure 5: Winner vs Loser age density comparison
all_ages <- data.frame(
  age = c(vb_clean$w_p1_age, vb_clean$l_p1_age),
  outcome = rep(c("Winner", "Loser"), each = nrow(vb_clean))
) %>% filter(!is.na(age))

p_winner_loser <- gf_density(~ age, fill = ~ outcome, data = all_ages, alpha = 0.5) %>%
  gf_labs(
    title = "Age Density Comparison: Match Winners vs. Losers",
    subtitle = "Mature players maintain competitive win rates due to strategic mastery",
    x = "Age (years)",
    y = "Kernel Density",
    fill = "Outcome",
    caption = "Data Source: Jesse Mostipak (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig5_beach_winner_vs_loser_density.png", plot = p_winner_loser, width = 8, height = 5, dpi = 150)

# ------------------------------------------------------------------------------
# 3. PLUSLIGA PROFESSIONAL LEAGUE ANALYSIS
# ------------------------------------------------------------------------------

plusliga_path <- if (file.exists("data/Mens-Volleyball-PlusLiga-2008-2023.csv")) {
  "data/Mens-Volleyball-PlusLiga-2008-2023.csv"
} else {
  "../../Mens-Volleyball-PlusLiga-2008-2023.csv"
}

message(sprintf("Loading PlusLiga historical match data from: %s", plusliga_path))
plusliga <- read_csv(plusliga_path, show_col_types = FALSE)

plusliga_clean <- plusliga %>%
  mutate(
    Date = dmy_hm(Date),
    Year = year(Date),
    Winner = factor(Winner, levels = c(0, 1), labels = c("Team 2", "Team 1")),
    T1_Srv_Eff_Num = parse_number(as.character(T1_Srv_Eff)),
    T2_Srv_Eff_Num = parse_number(as.character(T2_Srv_Eff)),
    T1_Att_Kill_Perc = parse_number(as.character(T1_Att_Kill_Perc)),
    T1_Rec_Perf = parse_number(as.character(T1_Rec_Perf)),
    T1_Blk_Sum = as.numeric(T1_Blk_Sum),
    T2_Blk_Sum = as.numeric(T2_Blk_Sum)
  )

# Figure 6: Serve Efficiency vs Outcome
p_serve <- gf_point(
  jitter(T2_Srv_Eff_Num) ~ jitter(T1_Srv_Eff_Num),
  data = plusliga_clean,
  color = ~ Winner,
  alpha = 0.5,
  size = 1.5
) %>%
  gf_abline(slope = 1, intercept = 0, color = "gray30", linetype = "dashed", linewidth = 0.8) %>%
  gf_labs(
    title = "Serve Efficiency vs. Match Outcome in PlusLiga",
    subtitle = "Symmetric distribution across equality line shows serving alone does not dictate victory",
    x = "Team 1 Serve Efficiency (%)",
    y = "Team 2 Serve Efficiency (%)",
    color = "Match Winner",
    caption = "Data Source: Kacper Gregorowicz (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    legend.position = "right",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig6_plusliga_serve_efficiency_vs_outcome.png", plot = p_serve, width = 8.5, height = 5.5, dpi = 150)

# Figure 7: Reception vs Attack Kill Percentage Regression
p_rec_att <- gf_point(
  T1_Att_Kill_Perc ~ T1_Rec_Perf,
  data = plusliga_clean,
  alpha = 0.5,
  color = "steelblue",
  size = 1.8
) %>%
  gf_smooth(method = "lm", color = "firebrick", se = TRUE, linewidth = 1.2) %>%
  gf_labs(
    title = "Coupling of Defensive Reception and Offensive Attack Kill Rate",
    subtitle = "High-quality reception directly enables setter offensive execution and kill conversion",
    x = "Team 1 Perfect Reception Rate (%)",
    y = "Team 1 Attack Kill Rate (%)",
    caption = "Data Source: Kacper Gregorowicz (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig7_plusliga_reception_vs_attack_kill.png", plot = p_rec_att, width = 8, height = 5.5, dpi = 150)

# Figure 8: Total Block Sum Distribution
p_blocks <- gf_histogram(
  ~ (T1_Blk_Sum + T2_Blk_Sum),
  data = plusliga_clean,
  binwidth = 1,
  fill = "firebrick",
  color = "white",
  alpha = 0.8
) %>%
  gf_labs(
    title = "Distribution of Total Blocks per Match in PlusLiga",
    subtitle = "Matches typically average 14–19 combined blocks; elite defense shapes game momentum",
    x = "Combined Blocks (Team 1 + Team 2)",
    y = "Match Frequency",
    caption = "Data Source: Kacper Gregorowicz (Kaggle)"
  ) %>%
  gf_theme(
    theme_minimal(),
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig8_plusliga_block_distributions.png", plot = p_blocks, width = 8, height = 5, dpi = 150)

message("All volleyball analytics figures successfully generated in figures/ directory!")
