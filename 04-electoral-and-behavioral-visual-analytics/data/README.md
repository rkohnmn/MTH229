# Data Sources & Schema: Electoral & Behavioral Visual Analytics

This directory contains survey data used for categorical wrangling and ranking analysis.

---

## Dating Dealbreakers Survey (`DatingPreferencesBinary.csv`)

- **Format**: CSV, 52 participant rows across 9 binary attributes.
- **Attributes**:
  - `Personality`: Whether unpleasant personality is considered a relationship dealbreaker (`Yes` / `No`).
  - `Tobacco`: Tobacco usage dealbreaker.
  - `Political`: Incompatible political views dealbreaker.
  - `Appearance`: Physical appearance dealbreaker.
  - `Dependent`: Excessive dependency dealbreaker.
  - `Underplanner`: Lack of future planning dealbreaker.
  - `Overplanner`: Excessive rigidity / overplanning dealbreaker.
  - `Marijuana`: Cannabis usage dealbreaker.
  - `Independent`: Excessive independence / detachment dealbreaker.
- **Wrangling Transformation**:
  The raw dataset presents survey responses in wide format with camelCase column headers. The analysis script:
  1. Converts binary `Yes`/`No` indicators to logical flags.
  2. Calculates the percentage of respondents endorsing each trait as a dealbreaker:
     $$\text{Percentage} = \frac{\sum I(\text{response} = \text{"Yes"})}{N} \times 100$$
  3. Uses regular expression lookbehinds (`(?<=.)([A-Z]) -> " \1"`) to split camelCase headers into human-readable labels.
  4. Applies `forcats::fct_reorder` to sort traits in ascending order of dealbreaker severity.
