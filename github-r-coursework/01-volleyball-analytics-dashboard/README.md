# Volleyball Analytics & Spatial Court Tracking Dashboard

An interactive sports analytics dashboard and computer vision tracking pipeline analyzing spatial court dynamics, match duration variability, and team performance metrics across professional indoor and beach volleyball.

## What I Worked On
- **Computer Vision Ball Tracking Pipeline**: Built a frame extraction and deep learning object detection pipeline in Python and R (`opencv`, `ultralytics` YOLOv8, and `ovml`) to process broadcast footage from the VNL 2025 Grand Finals (Italy vs. Poland).
- **Spatial Coordinate Projection**: Formulated coordinate transformation functions mapping normalized frame bounding boxes $(u, v)$ to physical court coordinates $(x \in [-9, 9]\text{m}, y \in [0, 9]\text{m})$.
- **2D Kernel Density Estimation**: Computed bivariate spatial density across 200 grid points using `MASS::kde2d` with a 4th-root transformation to highlight court coverage patterns without washing out tail densities.
- **Custom Court Rendering**: Created a custom graphics script rendering an international FIVB regulation court with attack lines, net demarcation, defense zones, and an overlaid `viridis` plasma heatmap.
- **Beach Volleyball Dynamics**: Analyzed match duration distributions by gender and examined player age distributions to compare winner versus loser age profiles using kernel density estimates.
- **PlusLiga Match Modeling**: Evaluated 15 seasons (2008–2023) of Polish PlusLiga matches, analyzing the relationship between serve efficiency and match outcomes, fitting a linear regression model relating reception performance to attack kill percentage, and estimating total match block distributions.
- **Interactive Flexdashboard**: Integrated the analyses into a multi-tab `flexdashboard` interface with custom CSS styling, KPI metrics, and tactical interpretations.

## Tools
- **Language**: R (v4.4.2), Python (v3.10+)
- **Core R Packages**: `flexdashboard`, `ggplot2`, `mosaic`, `MASS`, `dplyr`, `tidyr`, `lubridate`, `readr`, `viridis`, `scales`, `plotly`, `DT`
- **Tracking Libraries**: `opencv-python`, `ultralytics` (YOLOv8), `av`, `ovml`

## Files
- [`dashboard.Rmd`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/01-volleyball-analytics-dashboard/dashboard.Rmd): Full interactive flexdashboard source file with responsive layout, custom CSS cards, and tactical commentary.
- [`analysis.R`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/01-volleyball-analytics-dashboard/analysis.R): Standalone R script executing the 2D KDE court modeling, regression analysis, and figure exports.
- [`tracking_pipeline/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/01-volleyball-analytics-dashboard/tracking_pipeline): Frame extraction and YOLOv8 object tracking pipeline scripts (`vb_tracking.py`, `frame_convert.R`).
- [`data/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/01-volleyball-analytics-dashboard/data): Data directory containing data dictionary and match records:
  - `Mens-Volleyball-PlusLiga-2008-2023.csv`: Polish PlusLiga match statistics.
  - `ball_positions_sample.csv`: Sample of 10,000 spatial tracking records.
  - `vb_matches_sample.csv`: Sample of 3,500 beach volleyball match records.
- [`figures/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/01-volleyball-analytics-dashboard/figures): High-resolution exported figures and visualizations:
  - `fig1_court_ball_density_heatmap.png`: Spatial court density heatmap.
  - `fig2_ball_y_court_distribution.png`: Ball distribution along court width.
  - `fig3_beach_duration_by_gender.png`: Match duration comparison across genders.
  - `fig4_beach_player_age_distribution.png`: Beach volleyball player age profile.
  - `fig5_beach_winner_vs_loser_density.png`: Winner vs. loser age densities.
  - `fig6_plusliga_serve_efficiency_vs_outcome.png`: Serve efficiency vs. winner outcome.
  - `fig7_plusliga_reception_vs_attack_kill.png`: Reception performance vs. kill percentage.
  - `fig8_plusliga_block_distributions.png`: Combined match block distribution.

## Results / Takeaways
- **Spatial Court Utilization**: The central corridor around the net exhibits high density due to setter positioning, first-tempo middle quicks, and transition play. Secondary density peaks cluster near the antenna pins (outside and opposite attack zones) and 3 meters behind the net (back-row attacks).
- **Beach Match Durations**: Match durations cluster around 40 minutes for both genders, but men's matches display significantly higher dispersion with a long right tail extending past 60 minutes.
- **Athlete Longevity**: Beach volleyball players peak in their late 20s and early 30s. Winners and losers display nearly overlapping age density distributions, indicating that strategic experience effectively offsets marginal declines in athletic peak.
- **Service vs. Phase Play**: In professional indoor volleyball (PlusLiga), serve efficiency is symmetrically distributed between winning and losing teams, showing that serve effectiveness alone does not dictate victory. What follows the serve (serve receive, setter decision-making, and transition attack) proves decisive.
- **Offensive-Defensive Coupling**: A statistically significant positive linear relationship exists between perfect reception percentage and attack kill conversion, quantifying how defensive control directly unlocks offensive scoring.
- **Blocking Frequency**: PlusLiga matches average between 14 and 19 combined blocks per match, establishing clear baseline expectations for tactical net disruption.

## Running the Analysis

### 1. Run the Standalone Script
```R
# From the project directory:
source("analysis.R")
```

### 2. Knit the Interactive Dashboard
Open `dashboard.Rmd` in RStudio and click **Knit**, or execute from the terminal:
```R
rmarkdown::render("dashboard.Rmd")
```
