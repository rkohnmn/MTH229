# Applied Visual Refinements & Behavioral Analytics

An applied data wrangling and exploratory data visualization project demonstrating systematic plot refinement methodologies across demographic, electoral, perceptual, and survey datasets.

## What I Worked On
- **Visual Refinement Iteration**: Applied an intentional plot-refinement workflow: taking early exploratory graphics and systematically addressing aspect ratios, alpha transparency, dual-hue party-aligned palettes, zero-line baselines, and directional annotations.
- **Electoral Demographics**: Modeled state-level per capita income distributions across 2008 presidential election outcomes using hybrid violin-boxplot geometries. Evaluated the correlation between higher education rates (`BA`) and partisan margins (`Dem.Rep`) in the 2016 election using filled 2D bivariate density contours.
- **Perceptual Trait Distributions**: Modeled facial sexual dimorphism ratings from the `FaithfulFaces` study, comparing female and male rater distributions using faceted kernel density curves and ridge plot profiles.
- **Categorical Survey Reshaping**: Restructured raw binary survey records (`DatingPreferencesBinary.csv`) from wide format into a tidy consensus summary via `tidyr::pivot_longer`, normalized camelCase headers using regular expression lookbehinds, and generated an ordered lollipop/linerange visualization ranked by consensus severity (`forcats::fct_reorder`).

## Tools
- **Language**: R (v4.4.2)
- **Core Packages**: `tidyverse`, `ggplot2`, `mosaic`, `Stat2Data`, `ggridges`, `scales`, `stringr`, `forcats`

## Files
- [`analysis.R`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/04-electoral-and-behavioral-visual-analytics/analysis.R): Executable script executing all wrangling pipelines, statistical transformations, and figure exports.
- [`report.Rmd`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/04-electoral-and-behavioral-visual-analytics/report.Rmd): Reproducible R Markdown report with analysis commentary and embedded plots.
- [`data/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/04-electoral-and-behavioral-visual-analytics/data): Contains data dictionary and `DatingPreferencesBinary.csv`.
- [`figures/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/04-electoral-and-behavioral-visual-analytics/figures): Exported visualization artifacts:
  - `fig1_electoral_income_violin_2008.png`: State per capita income by 2008 presidential winner.
  - `fig2_bachelors_degree_vs_partisan_lean_2016.png`: Higher education vs. 2016 partisan margin contour plot.
  - `fig3_sexual_dimorphism_perception_by_rater_sex.png`: Density profiles of dimorphism ratings by rater sex.
  - `fig4_dating_dealbreakers_percentage_ranking.png`: Ranked consensus lollipop chart of dealbreaker traits.

## Results / Takeaways
- **Electoral Demographics**: States carried by Barack Obama in 2008 exhibited higher median and upper-quartile per capita income than states carried by John McCain. In the 2016 election, state bachelor's degree attainment percentage displayed a strong positive linear relationship with Democratic margin, with states exceeding 30% college attainment concentrating consistently above the zero-margin baseline.
- **Perceptual Rating Asymmetry**: Female raters systematically assigned higher perceived sexual dimorphism scores across identical visual stimuli than male raters, reflected in a distinct rightward density shift.
- **Survey Dealbreaker Hierarchy**: Unpleasant personality ranked as the single highest dealbreaker (84.6% consensus), followed by tobacco usage and incompatible political beliefs as the only other attributes achieving majority (> 50%) consensus.

## Running the Analysis
```R
# Run the analysis script
source("analysis.R")

# Or render the HTML report
rmarkdown::render("report.Rmd")
```
