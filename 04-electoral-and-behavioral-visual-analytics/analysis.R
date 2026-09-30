# ==============================================================================
# Applied Visual Refinements & Behavioral Analytics
# Author: Robert Kohn
# Institution: Muhlenberg College
# Coursework: STA 227 / MTH 229 - Data Visualization
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(mosaic)
  library(Stat2Data)
  library(ggridges)
  library(scales)
})

set.seed(67)
dir.create("figures", showWarnings = FALSE)

# ==============================================================================
# 1. ELECTORAL DEMOGRAPHICS & PARTISAN LEAN (2008 & 2016 US ELECTIONS)
# ==============================================================================

message("Running Part 1: Electoral Demographics Analysis...")

# 1.1 2008 Election: State Per Capita Income vs Winner
data(Election08)
Election08_clean <- Election08 %>%
  mutate(Winner = ifelse(ObamaWin == 1, "Obama (Democrat)", "McCain (Republican)"))

# Figure 1: Violin Plot of Per Capita Income by Candidate
p_violin_08 <- ggplot(Election08_clean, aes(x = Winner, y = Income, fill = Winner)) +
  geom_violin(trim = FALSE, alpha = 0.7, color = "gray30") +
  geom_boxplot(width = 0.15, fill = "white", outlier.size = 1.5, alpha = 0.9) +
  scale_fill_manual(values = c("Obama (Democrat)" = "#2b83ba", "McCain (Republican)" = "#d7191c")) +
  scale_y_continuous(labels = dollar_format()) +
  labs(
    title = "State Per Capita Income Distribution by 2008 Presidential Winner",
    subtitle = "States carried by Obama displayed higher median and upper-quartile per capita income",
    x = "Winning Candidate",
    y = "Per Capita Income",
    caption = "Data Source: Stat2Data::Election08"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig1_electoral_income_violin_2008.png", plot = p_violin_08, width = 7.5, height = 5.5, dpi = 150)

# 1.2 2016 Election: Bachelor's Degree Attainment vs Partisan Lean
data(Election16)

# Figure 2: Scatterplot with 2D Density Contours & Baseline Reference
p_scatter_16 <- ggplot(Election16, aes(x = BA, y = Dem.Rep)) +
  geom_density_2d_filled(alpha = 0.35) +
  geom_point(color = "black", alpha = 0.75, size = 2) +
  geom_hline(yintercept = 0, linetype = "solid", color = "gray25", linewidth = 0.8) +
  geom_smooth(method = "lm", color = "#7b3294", se = TRUE, linewidth = 1) +
  annotate("text", x = 20, y = 25, label = "Democratic Lean (>0)", color = "#08519c", fontface = "bold") +
  annotate("text", x = 36, y = -25, label = "Republican Lean (<0)", color = "#cb181d", fontface = "bold") +
  scale_fill_viridis_d(option = "mako", guide = "none") +
  scale_x_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title = "Higher Education Attainment vs. Partisan Lean (2016 Election)",
    subtitle = "Positive correlation between state bachelor's degree percentage (BA) and Democratic margin",
    x = "Adults with Bachelor's Degree or Higher (%)",
    y = "Democratic - Republican Point Margin",
    caption = "Data Source: Stat2Data::Election16"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5)
  )

ggsave("figures/fig2_bachelors_degree_vs_partisan_lean_2016.png", plot = p_scatter_16, width = 8, height = 5.5, dpi = 150)


# ==============================================================================
# 2. PERCEPTUAL PSYCHOLOGY: SEXUAL DIMORPHISM RATINGS BY RATER SEX
# ==============================================================================

message("Running Part 2: Perceptual Psychology Analysis...")

data(FaithfulFaces)

FaithfulFaces_clean <- FaithfulFaces %>%
  mutate(Rater_Gender = factor(RaterSex, levels = c("F", "M"), labels = c("Female Raters", "Male Raters")))

# Figure 3: Faceted Density with Ridge Profiles
p_dimorph <- ggplot(FaithfulFaces_clean, aes(x = SexDimorph, fill = Rater_Gender)) +
  geom_density(alpha = 0.5, color = "black", linewidth = 0.4) +
  facet_wrap(~ Rater_Gender, ncol = 1) +
  scale_fill_manual(values = c("Female Raters" = "#e7298a", "Male Raters" = "#1f78b4")) +
  labs(
    title = "Perceptions of Facial Sexual Dimorphism by Rater Sex",
    subtitle = "Female raters systematically evaluate faces with higher mean perceived sexual dimorphism",
    x = "Sexual Dimorphism Rating Score",
    y = "Density",
    caption = "Data Source: Stat2Data::FaithfulFaces"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    strip.text = element_text(face = "bold", size = 11)
  )

ggsave("figures/fig3_sexual_dimorphism_perception_by_rater_sex.png", plot = p_dimorph, width = 7.5, height = 5.5, dpi = 150)


# ==============================================================================
# 3. SURVEY WRANGLING: RELATIONSHIP DEALBREAKER PREFERENCES
# ==============================================================================

message("Running Part 3: Survey Wrangling Analysis...")

dating_path <- if (file.exists("data/DatingPreferencesBinary.csv")) {
  "data/DatingPreferencesBinary.csv"
} else {
  "../../DatingPreferencesBinary.csv"
}

dating_raw <- read_csv(dating_path, show_col_types = FALSE)

# Reshape wide survey columns into tidy percentage summary
dr_summary <- dating_raw %>%
  summarise(across(everything(), ~ sum(. == "Yes", na.rm = TRUE) / n() * 100)) %>%
  pivot_longer(everything(), names_to = "Dealbreaker", values_to = "Percentage") %>%
  mutate(
    # Insert spaces between camelCase letters via regex
    Dealbreaker_Clean = str_replace_all(Dealbreaker, pattern = "(?<=.)([A-Z])", replacement = " \\1"),
    Dealbreaker_Factor = fct_reorder(Dealbreaker_Clean, Percentage),
    Majority_Dealbreaker = Percentage >= 50
  )

# Figure 4: Lollipop / Linerange Chart of Ranked Dealbreakers
p_dealbreakers <- ggplot(dr_summary, aes(x = Percentage, y = Dealbreaker_Factor)) +
  geom_segment(aes(x = 0, xend = Percentage, y = Dealbreaker_Factor, yend = Dealbreaker_Factor,
                   color = Majority_Dealbreaker), linewidth = 1.2) +
  geom_point(aes(color = Majority_Dealbreaker), size = 3.5) +
  geom_text(aes(label = sprintf("%.1f%%", Percentage)), hjust = -0.3, size = 3.5, fontface = "bold") +
  scale_color_manual(values = c("FALSE" = "#74add1", "TRUE" = "#d73027"),
                     labels = c("< 50% Consensus", ">= 50% Consensus")) +
  scale_x_continuous(limits = c(0, 100), labels = function(x) paste0(x, "%")) +
  labs(
    title = "Ranked Relationship Dealbreaker Consensus (N = 52 Respondents)",
    subtitle = "84.6% of participants identify unpleasant personality as an absolute dealbreaker",
    x = "Percentage of Respondents Identifying Attribute as Dealbreaker",
    y = "Surveyed Personality / Lifestyle Trait",
    color = "Consensus Level",
    caption = "Data Source: DatingPreferencesBinary.csv"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
    plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
    legend.position = "bottom"
  )

ggsave("figures/fig4_dating_dealbreakers_percentage_ranking.png", plot = p_dealbreakers, width = 8.5, height = 5.5, dpi = 150)

message("Electoral and behavioral visual analytics script successfully completed!")
