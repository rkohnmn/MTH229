# Environmental & Retail Time-Series Dynamics

An applied longitudinal data visualization project investigating atmospheric hurricane wind velocity progressions and economic retail sales seasonality across multi-year observation windows.

## What I Worked On
- **Datetime Synthesis & Normalization**: Utilized `lubridate::make_datetime` and `lubridate::make_date` to parse heterogeneous time formats, construct continuous temporal axes, and align hourly observations with calendar seasons.
- **Meteorological Trajectory Modeling**: Extracted NOAA hurricane records from `dplyr::storms` across the 2015 Atlantic hurricane season, categorizing cyclones according to Saffir-Simpson intensity scales and mapping continuous sustained wind speeds across time.
- **Major Hurricane Isolation**: Filtered and modeled Category 3+ cyclones (including Hurricane Joaquin, Danny, Erika, and Fred) using plasma color maps and multi-panel faceted trajectory plots.
- **Economic Seasonality & Anomaly Detection**: Resolved mixed month strings in US retail sales data (3-letter abbreviations vs. full strings) via regular expressions, engineered calendar quarter variables, and applied dual-hue accent coloring to isolate systematic post-holiday January spikes.
- **Quarterly Distribution Analysis**: Evaluated seasonal variance across Q1–Q4 sales volumes using boxplot distributions, identifying persistent positive skew in early-year quarters.

## Tools
- **Language**: R (v4.4.2)
- **Core Packages**: `tidyverse`, `lubridate`, `ggplot2`, `mosaic`, `Lock5Data`, `Stat2Data`, `viridis`, `scales`, `RColorBrewer`

## Files
- [`analysis.R`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/03-environmental-and-retail-time-series/analysis.R): Standalone R script executing data cleaning, time series modeling, and figure generation.
- [`report.Rmd`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/03-environmental-and-retail-time-series/report.Rmd): Reproducible R Markdown analytical report.
- [`figures/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/03-environmental-and-retail-time-series/figures): Exported visualization artifacts:
  - `fig1_storm_wind_speeds_by_category.png`: Longitudinal hurricane wind speed curves by Saffir-Simpson category.
  - `fig2_major_hurricanes_wind_speed.png`: High-intensity Category 3+ hurricane progressions.
  - `fig3_selected_hurricanes_facet.png`: Multi-panel comparison of individual storm systems.
  - `fig4_retail_sales_seasonality_trend.png`: US retail sales longitudinal trend highlighting January spikes.
  - `fig5_retail_sales_quarterly_distribution.png`: Quarterly distribution boxplots.

## Results / Takeaways
- **Cyclonic Intensification**: Major hurricanes (such as Hurricane Joaquin) exhibit rapid intensification phases where wind speeds climb from tropical storm thresholds (< 64 knots) to Category 4 status (> 115 knots) in under 48 hours, reflected clearly in steep localized gradient spikes.
- **Retail Sales Seasonality**: Across the 2000–2011 longitudinal period, January consistently registers peak sales volume, driven by post-holiday clearances and fiscal year-end retail accounting adjustments. Highlighting these observations against baseline months removes ambiguity regarding annual cyclic peaks.
- **Quarterly Skewness**: Q1 exhibits substantial positive variance driven by January surges, whereas Q2 and Q3 display more tightly bounded, stable sales distributions.

## Running the Analysis
```R
# Run the standalone analysis script
source("analysis.R")

# Or render the HTML report
rmarkdown::render("report.Rmd")
```
