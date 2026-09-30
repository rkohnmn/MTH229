# ==============================================================================
# Environmental & Retail Time-Series Dynamics
# Author: Robert Kohn
# Institution: Muhlenberg College
# Coursework: STA 227 / MTH 229 - Data Visualization
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(mosaic)
  library(Lock5Data)
  library(Stat2Data)
  library(viridis)
  library(scales)
})

set.seed(67)
dir.create("figures", showWarnings = FALSE)

# ==============================================================================
# 1. METEOROLOGICAL DYNAMICS: NOAA STORMS TRAJECTORIES (2015 SEASON)
# ==============================================================================

message("Running Part 1: NOAA Storms Time-Series Analysis...")

data(storms)

# Construct precise timestamp using lubridate make_datetime
storms_clean <- storms %>%
  mutate(
    DateTime = make_datetime(year = year, month = month, day = day, hour = hour),
    Category = factor(category, levels = c(-1, 0, 1, 2, 3, 4, 5),
                      labels = c("TD", "TS", "Cat 1", "Cat 2", "Cat 3", "Cat 4", "Cat 5"))
  )

# Filter for the 2015 Atlantic hurricane season
storms_2015 <- storms_clean %>% filter(year == 2015)

# Figure 1: Wind speed progression across all 2015 storms colored by category
p_storms_cat <- ggplot(storms_2015, aes(x = DateTime, y = wind, group = name, color = Category)) +
  geom_line(linewidth = 0.9, alpha = 0.8) +
  scale_color_brewer(palette = "YlOrRd", direction = 1) +
  scale_x_datetime(date_breaks = "1 month", date_labels = "%b") +
  labs(
    title = "Atlantic Storm Wind Speed Trajectories (2015 Season)",
    subtitle = "Continuous wind speed tracking categorized by Saffir-Simpson intensity scale",
    x = "Date",
    y = "Sustained Wind Speed (knots)",
    color = "Storm Category",
    caption = "Data Source: NOAA / dplyr::storms"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    legend.position = "right"
  )

ggsave("figures/fig1_storm_wind_speeds_by_category.png", plot = p_storms_cat, width = 8.5, height = 5, dpi = 150)

# Figure 2: Major Hurricanes (Category >= 3)
storms_major <- storms_2015 %>% filter(as.numeric(category) >= 3)

p_major <- ggplot(storms_major, aes(x = DateTime, y = wind, group = name, color = name)) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_viridis_d(option = "plasma") +
  scale_x_datetime(date_breaks = "1 week", date_labels = "%b %d") +
  labs(
    title = "Major Hurricane Wind Speed Progression (2015)",
    subtitle = "Tracking intensity evolution of peak category 3+ cyclones",
    x = "Date",
    y = "Wind Speed (knots)",
    color = "Storm Name",
    caption = "Data Source: NOAA / dplyr::storms"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    legend.position = "right"
  )

ggsave("figures/fig2_major_hurricanes_wind_speed.png", plot = p_major, width = 8, height = 5, dpi = 150)

# Figure 3: Selected Notable Storms Faceted Progression
selected_names <- c("Joaquin", "Danny", "Erika", "Fred")
storms_selected <- storms_2015 %>% filter(name %in% selected_names)

p_selected <- ggplot(storms_selected, aes(x = DateTime, y = wind, group = name)) +
  geom_line(color = "#08519c", linewidth = 1.1) +
  geom_point(color = "#08519c", size = 1.5, alpha = 0.6) +
  facet_wrap(~ name, scales = "free_x", nrow = 2) +
  labs(
    title = "Selected Hurricane Wind Speed Profiles (2015)",
    subtitle = "Comparing rapid intensification patterns across individual cyclonic systems",
    x = "Timeline",
    y = "Wind Speed (knots)",
    caption = "Data Source: NOAA / dplyr::storms"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    strip.text = element_text(face = "bold", size = 11)
  )

ggsave("figures/fig3_selected_hurricanes_facet.png", plot = p_selected, width = 8.5, height = 5.5, dpi = 150)


# ==============================================================================
# 2. ECONOMIC SEASONALITY: RETAIL SALES ANOMALY DETECTION
# ==============================================================================

message("Running Part 2: Retail Sales Seasonality Analysis...")

data(RetailSales2011)

# Clean non-standard month strings (abbreviations vs full month names)
RetailSales_clean <- RetailSales2011 %>%
  mutate(
    Month_Clean = str_trim(as.character(Month)),
    Month_Num = ifelse(str_length(Month_Clean) == 3,
                       match(Month_Clean, month.abb),
                       match(Month_Clean, month.name)),
    Date = make_date(year = Year, month = Month_Num),
    Quarter = factor(quarter(Date), levels = 1:4, labels = c("Q1", "Q2", "Q3", "Q4")),
    IsJanuary = (Month_Num == 1)
  ) %>%
  filter(!is.na(Date))

# Figure 4: Longitudinal Sales Trend with January Peak Highlighting
p_retail_trend <- ggplot(RetailSales_clean, aes(x = Date, y = Sales)) +
  geom_line(color = "gray65", linewidth = 0.8) +
  geom_point(aes(color = IsJanuary, size = IsJanuary), alpha = 0.85) +
  scale_color_manual(values = c("FALSE" = "gray50", "TRUE" = "#d73027"),
                     labels = c("Standard Month", "January Peak")) +
  scale_size_manual(values = c("FALSE" = 1.5, "TRUE" = 3), guide = "none") +
  scale_y_continuous(labels = dollar_format(suffix = "M")) +
  labs(
    title = "US Retail Sales (2000–2011): Systematic January Spikes",
    subtitle = "Longitudinal sales pattern with recurring post-holiday inventory and reporting surges highlighted in red",
    x = "Year",
    y = "Sales Volume",
    color = "Month Type",
    caption = "Data Source: Lock5Data::RetailSales2011"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    legend.position = "bottom"
  )

ggsave("figures/fig4_retail_sales_seasonality_trend.png", plot = p_retail_trend, width = 8.5, height = 5, dpi = 150)

# Figure 5: Quarterly Distribution Boxplots
p_retail_box <- ggplot(RetailSales_clean, aes(x = Quarter, y = Sales, fill = Quarter)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red", outlier.size = 2) +
  scale_fill_brewer(palette = "Blues") +
  scale_y_continuous(labels = dollar_format(suffix = "M")) +
  labs(
    title = "Quarterly Distribution of Retail Sales Volume",
    subtitle = "Q1 exhibits substantial positive skew due to January volume spikes",
    x = "Calendar Quarter",
    y = "Sales Volume",
    caption = "Data Source: Lock5Data::RetailSales2011"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig5_retail_sales_quarterly_distribution.png", plot = p_retail_box, width = 7, height = 5, dpi = 150)

message("Time series analysis script successfully completed!")
