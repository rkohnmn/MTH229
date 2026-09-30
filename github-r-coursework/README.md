# R / Statistical Computing & Data Visualization Coursework

This repository contains selected statistical computing, data visualization, and applied quantitative analysis coursework completed at Muhlenberg College. The curated projects demonstrate end-to-end data pipelines in R, spanning computer vision object tracking and interactive dashboard engineering, large-scale Monte Carlo probability simulations, longitudinal meteorological and retail time-series modeling, and demographic exploratory data analysis.

---

## Selected Projects

| Directory | Project Focus | Key Methods & Techniques |
| :--- | :--- | :--- |
| [**`01-volleyball-analytics-dashboard/`**](01-volleyball-analytics-dashboard/) | **Volleyball Analytics & Spatial Court Tracking Dashboard** | Computer vision tracking (YOLOv8 / `ovml`), 2D spatial coordinate projection, bivariate kernel density estimation (`kde2d`), regression modeling, and full-scale `flexdashboard` implementation. |
| [**`02-monte-carlo-statistical-simulations/`**](02-monte-carlo-statistical-simulations/) | **Monte Carlo Statistical Simulations & Distribution Modeling** | Empirical Law of Large Numbers validation ($N = 100,000$), asymptotic variance convergence tracking, continuous probability modeling, bivariate normal hypothesis testing (`mnormt`), and multi-dimensional numerical quadrature (`cubature`). |
| [**`03-environmental-and-retail-time-series/`**](03-environmental-and-retail-time-series/) | **Environmental & Retail Time-Series Dynamics** | NOAA hurricane wind speed trajectories across Saffir-Simpson intensity categories, major cyclone tracking, mixed-string datetime parsing via `lubridate`, and longitudinal retail sales seasonality decomposition with dual-accent anomaly highlighting. |
| [**`04-electoral-and-behavioral-visual-analytics/`**](04-electoral-and-behavioral-visual-analytics/) | **Applied Visual Refinements & Behavioral Analytics** | Before-and-after plot refinement methodology, 2008 & 2016 US presidential election demographic modeling (income and higher education vs. partisan margin), facial dimorphism perceptual ratings, and regex survey reshaping. |

---

## Topics Demonstrated

- **Data Cleaning & Wrangling**: Transforming non-standard calendar and month strings, reshaping wide survey data into tidy factor tables (`tidyr::pivot_longer`), and regular expression pattern normalization.
- **Exploratory Data Analysis & Advanced Visualization**: Custom color palettes (`viridis`, `RColorBrewer`), dual-hue accent coloring, 2D density contour mapping, hybrid violin-boxplot geometries, and interactive dashboards (`flexdashboard`, `plotly`, `DT`).
- **Mathematical & Statistical Modeling**: Bivariate normal distribution modeling, linear regression analysis (`lm`), covariance matrix manipulation, and two-sample correlation hypothesis testing (`cor.test`).
- **Computational Simulation & Numerical Analysis**: Large-scale Monte Carlo simulations ($N = 100,000$ draws), running variance convergence estimation, 1D numerical quadrature (`integrate`), and multidimensional adaptive integration (`cubature::adaptIntegrate`).
- **Computer Vision & Spatial Analytics**: Extracting video frames, deep learning ball detection (YOLOv8), and mapping camera bounding box coordinates into physical athletic court boundaries.
- **Reproducible Analysis**: Fully reproducible workflows packaged in modular R scripts and R Markdown documents with version-controlled dependencies.

---

## Tools & Dependencies

- **Language**: R (v4.4.2), Python (v3.10+)
- **Data Manipulation & Visualization**: `tidyverse`, `ggplot2`, `dplyr`, `tidyr`, `readr`, `stringr`, `lubridate`, `scales`, `viridis`, `ggridges`, `RColorBrewer`
- **Statistical Modeling & Simulations**: `mosaic`, `MASS`, `mnormt`, `DescTools`, `cubature`
- **Interactive Dashboards**: `flexdashboard`, `DT`, `plotly`, `fontawesome`
- **Computer Vision & Video**: `opencv-python`, `ultralytics`, `av`, `ovml`

To install all R dependencies, run:
```R
source("setup.R")
```

---

## Repository Structure

```
github-r-coursework/
├── .gitignore
├── README.md
├── setup.R
├── 01-volleyball-analytics-dashboard/
│   ├── README.md
│   ├── dashboard.Rmd
│   ├── analysis.R
│   ├── tracking_pipeline/
│   │   ├── README.md
│   │   ├── vb_tracking.py
│   │   └── frame_convert.R
│   ├── data/
│   │   ├── README.md
│   │   ├── Mens-Volleyball-PlusLiga-2008-2023.csv
│   │   ├── ball_positions_sample.csv
│   │   └── vb_matches_sample.csv
│   └── figures/
├── 02-monte-carlo-statistical-simulations/
│   ├── README.md
│   ├── analysis.R
│   ├── report.Rmd
│   └── figures/
├── 03-environmental-and-retail-time-series/
│   ├── README.md
│   ├── analysis.R
│   ├── report.Rmd
│   └── figures/
└── 04-electoral-and-behavioral-visual-analytics/
    ├── README.md
    ├── analysis.R
    ├── report.Rmd
    ├── data/
    │   ├── README.md
    │   └── DatingPreferencesBinary.csv
    └── figures/
```

---

## About

**Robert Kohn**  
Muhlenberg College  
Triple Major: Mathematics, Statistics, and Physics  
Aimed at software engineering, data science, quantitative research, and technical opportunities.
