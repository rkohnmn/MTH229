# ==============================================================================
# Setup Script: R Coursework Portfolio Dependencies
# Author: Robert Kohn
# Institution: Muhlenberg College
# ==============================================================================

required_packages <- c(
  # Core data manipulation & visualization
  "tidyverse",
  "ggplot2",
  "dplyr",
  "tidyr",
  "readr",
  "stringr",
  "lubridate",
  "scales",
  
  # Modeling, distributions & Monte Carlo simulations
  "mosaic",
  "DescTools",
  "mnormt",
  "MASS",
  "cubature",
  
  # Interactive dashboards & visual styling
  "flexdashboard",
  "DT",
  "plotly",
  "viridis",
  "ggridges",
  "fontawesome",
  
  # Coursework datasets
  "Lock5Data",
  "Stat2Data",
  "palmerpenguins"
)

# Identify missing packages
missing_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

# Install missing packages
if (length(missing_packages) > 0) {
  message(sprintf("Installing %d missing packages: %s", length(missing_packages), paste(missing_packages, collapse = ", ")))
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
} else {
  message("All required packages are already installed!")
}

message("Setup complete. You are ready to run all analyses in this repository.")
