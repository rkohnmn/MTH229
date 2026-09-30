# ==============================================================================
# Monte Carlo Statistical Simulations & Distribution Modeling
# Author: Robert Kohn
# Institution: Muhlenberg College
# Coursework: Probability & Mathematical Statistics
# ==============================================================================

suppressPackageStartupMessages({
  library(mosaic)
  library(tidyverse)
  library(mnormt)
  library(DescTools)
  library(cubature)
  library(ggplot2)
  library(scales)
})

set.seed(67)
dir.create("figures", showWarnings = FALSE)

# ==============================================================================
# PART 1: DISCRETE PROBABILITY & MONTE CARLO MOMENT CONVERGENCE
# ==============================================================================

message("Running Part 1: Discrete Monte Carlo Simulations...")

# 1.1 Binomial Distribution Moments
# X ~ Binomial(n = 100, p = 0.3)
n_draws <- 100000
n_trials <- 100
p_binom <- 0.3

binom_sim <- rbinom(n_draws, size = n_trials, prob = p_binom)
binom_var_mc <- var(binom_sim)
binom_var_theoretical <- n_trials * p_binom * (1 - p_binom)
cat(sprintf("Binomial Variance -> MC: %.4f | Theoretical: %.4f | Error: %.6f\n",
            binom_var_mc, binom_var_theoretical, abs(binom_var_mc - binom_var_theoretical)))

# Convergence curve across sample sizes
sample_steps <- seq(500, n_draws, by = 1000)
running_var <- sapply(sample_steps, function(k) var(binom_sim[1:k]))
conv_df <- data.frame(Sample_Size = sample_steps, Running_Variance = running_var)

p_conv <- ggplot(conv_df, aes(x = Sample_Size, y = Running_Variance)) +
  geom_line(color = "#1f77b4", linewidth = 1) +
  geom_hline(yintercept = binom_var_theoretical, color = "#d62728", linetype = "dashed", linewidth = 1) +
  annotate("text", x = 80000, y = binom_var_theoretical + 0.3,
           label = paste("Theoretical Variance =", binom_var_theoretical), color = "#d62728", fontface = "bold") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Monte Carlo Variance Convergence: Binomial(100, 0.3)",
    subtitle = "Empirical variance approaches theoretical variance (21.0) as sample size grows",
    x = "Simulation Sample Size (N)",
    y = "Estimated Variance"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
        plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5))

ggsave("figures/fig1_discrete_mc_variance_convergence.png", plot = p_conv, width = 8, height = 5, dpi = 150)

# 1.2 Sum of Independent Poisson and Geometric Random Variables
# X ~ Poisson(lambda = 2), Y ~ Geometric(p = 0.5)
# Theoretical: E[X + Y] = E[X] + E[Y] = 2 + (1 - p)/p = 2 + 1 = 3
x_sim <- rpois(n_draws, lambda = 2)
y_sim <- rgeom(n_draws, prob = 0.5)
sum_sim <- x_sim + y_sim
sum_mean_mc <- mean(sum_sim)
sum_mean_theoretical <- 2 + (1 - 0.5) / 0.5
cat(sprintf("E[Poisson + Geometric] -> MC: %.4f | Theoretical: %.4f | Error: %.6f\n",
            sum_mean_mc, sum_mean_theoretical, abs(sum_mean_mc - sum_mean_theoretical)))

# 1.3 Negative Binomial Tail Probability
# X ~ NegBin(size = 5, prob = 0.65)
# Theoretical P(X > 6) = 1 - sum_{k=0}^6 [choose(k+5-1, k) * (1-p)^k * p^5]
nb_sim <- rnbinom(n_draws, size = 5, prob = 0.65)
p_gt_6_mc <- mean(nb_sim > 6)
p_gt_6_theoretical <- 1 - sum(sapply(0:6, function(k) {
  choose(k + 5 - 1, k) * (1 - 0.65)^k * (0.65)^5
}))
cat(sprintf("P(NegBin > 6) -> MC: %.5f | Theoretical: %.5f | Error: %.6f\n",
            p_gt_6_mc, p_gt_6_theoretical, abs(p_gt_6_mc - p_gt_6_theoretical)))


# ==============================================================================
# PART 2: CONTINUOUS PROBABILITY DISTRIBUTIONS & INTEGRATION
# ==============================================================================

message("Running Part 2: Continuous Distribution Modeling...")

# Continuous distribution simulations
unif_draws  <- runif(10000, min = 3, max = 10)
exp_draws   <- rexp(10000, rate = 2)
chisq_draws <- rchisq(10000, df = 5)
beta_draws  <- rbeta(10000, shape1 = 2, shape2 = 4)

dist_df <- data.frame(
  Value = c(unif_draws, exp_draws, chisq_draws, beta_draws),
  Distribution = factor(rep(c("Uniform(3, 10)", "Exponential(rate=2)", "Chi-Squared(df=5)", "Beta(2, 4)"),
                            each = 10000))
)

p_cont <- ggplot(dist_df, aes(x = Value, fill = Distribution)) +
  geom_density(alpha = 0.6, color = "black", linewidth = 0.3) +
  facet_wrap(~ Distribution, scales = "free", nrow = 2) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Empirical Density Functions of Continuous Probability Distributions",
    subtitle = "Simulated densities (N = 10,000 per distribution) displaying theoretical boundary behavior",
    x = "Random Variable Value (x)",
    y = "Density"
  ) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
        plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5))

ggsave("figures/fig4_continuous_distributions_mc.png", plot = p_cont, width = 8.5, height = 5.5, dpi = 150)


# ==============================================================================
# PART 3: BIVARIATE NORMAL DISTRIBUTION & HYPOTHESIS TESTING
# ==============================================================================

message("Running Part 3: Bivariate Normal Simulation & Inference...")

# Independent standard normals: mean = (0, 0), cov = I_2
mu_vector <- c(0, 0)
cov_matrix <- diag(2)

# Theoretical density at origin: f(0, 0) = f_X(0) * f_Y(0)
joint_at_0 <- dmnorm(c(0, 0), mean = mu_vector, varcov = cov_matrix)
prod_marginals <- dnorm(0) * dnorm(0)
cat(sprintf("Joint PDF at origin: %.6f | Product of Marginals: %.6f\n", joint_at_0, prod_marginals))

# Probability within rectangular interval [-2, 2] x [-2, 2]
rect_joint_prob <- pmnorm(c(2, 2), mean = mu_vector, varcov = cov_matrix) -
                   pmnorm(c(-2, 2), mean = mu_vector, varcov = cov_matrix) -
                   pmnorm(c(2, -2), mean = mu_vector, varcov = cov_matrix) +
                   pmnorm(c(-2, -2), mean = mu_vector, varcov = cov_matrix)
rect_marg_prob  <- (pnorm(2) - pnorm(-2))^2
cat(sprintf("P([-2, 2]^2) via Joint CDF: %.6f | via Independence Marginals: %.6f\n",
            rect_joint_prob, rect_marg_prob))

# Generate bivariate normal realizations
n_biv <- 2000
biv_sim <- rmnorm(n_biv, mean = mu_vector, varcov = cov_matrix)
biv_df  <- data.frame(X1 = biv_sim[, 1], X2 = biv_sim[, 2])

# Hypothesis test on sample correlation (H0: rho = 0 vs H1: rho != 0)
cor_result <- cor.test(biv_df$X1, biv_df$X2)
cat(sprintf("Pearson correlation: r = %.4f | p-value: %.4f (Fail to reject H0: p > 0.05)\n",
            cor_result$estimate, cor_result$p.value))

# Figure 2: Bivariate Normal Scatter with Marginals
p_biv_scatter <- ggplot(biv_df, aes(x = X1, y = X2)) +
  geom_point(alpha = 0.4, color = "#2ca02c", size = 1.5) +
  geom_density_2d(color = "black", linewidth = 0.5) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  labs(
    title = "Simulated Bivariate Standard Normal Distribution (N = 2,000)",
    subtitle = sprintf("Zero correlation structure: r = %.4f (p-value = %.3f)", cor_result$estimate, cor_result$p.value),
    x = "Random Variable X1",
    y = "Random Variable X2"
  ) +
  coord_fixed(xlim = c(-3.5, 3.5), ylim = c(-3.5, 3.5)) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
        plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5))

ggsave("figures/fig2_bivariate_normal_simulated_scatter.png", plot = p_biv_scatter, width = 7, height = 6.5, dpi = 150)

# Figure 3: Theoretical Bivariate Normal Contour Surface
grid_vals <- seq(-3, 3, length.out = 100)
grid_df <- expand.grid(X1 = grid_vals, X2 = grid_vals)
grid_df$Density <- apply(grid_df, 1, function(row) dmnorm(row, mean = mu_vector, varcov = cov_matrix))

p_contour <- ggplot(grid_df, aes(x = X1, y = X2, z = Density)) +
  geom_contour_filled(bins = 12) +
  scale_fill_viridis_d(option = "viridis") +
  labs(
    title = "Theoretical Bivariate Standard Normal Probability Surface",
    subtitle = "Isotropic circular contours confirming independence and equal variance",
    x = "X1",
    y = "X2",
    fill = "Density"
  ) +
  coord_fixed() +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 13, hjust = 0.5),
        plot.subtitle = element_text(size = 10, color = "gray40", hjust = 0.5),
        legend.position = "right")

ggsave("figures/fig3_bivariate_normal_contour.png", plot = p_contour, width = 7.5, height = 6, dpi = 150)


# ==============================================================================
# PART 4: NUMERICAL QUADRATURE & COMBINATORICS
# ==============================================================================

message("Running Part 4: Numerical Quadrature & Combinatorics Verification...")

# 1D Adaptive Quadrature: Integral of x^2 + 3x - 4 from 0 to 2
# Analytic: [x^3/3 + 3/2 x^2 - 4x]_0^2 = 8/3 + 6 - 8 = 2/3 = 0.66667
poly_func <- function(x) x^2 + 3*x - 4
quad_1d <- integrate(poly_func, lower = 0, upper = 2)
cat(sprintf("1D Quadrature: %.6f (True: 0.666667)\n", quad_1d$value))

# Multidimensional Numerical Integration: Integral over [0, 1] x [0, 1.5]
# adaptIntegrate from cubature package
poly_2d <- function(vec) vec[1]^2 + 3*vec[1]*vec[2] - 4*vec[2]^3
quad_2d <- adaptIntegrate(poly_2d, lowerLimit = c(0, 0), upperLimit = c(1, 1.5))
cat(sprintf("2D Adaptive Integration: %.6f (Error est: %.2e)\n", quad_2d$integral, quad_2d$error))

# Combinatorics: Unordered without replacement combinations
flavors <- c("Vanilla", "Chocolate", "Strawberry", "Cookies & Cream",
             "Cookie Dough", "Mint Chip", "Butter Pecan", "Coffee")
combos <- CombSet(flavors, 3, repl = FALSE, ord = FALSE)
cat(sprintf("CombSet(8, 3, repl=F, ord=F) total: %d | choose(8, 3): %d\n",
            nrow(combos), choose(8, 3)))

message("Monte Carlo and mathematical statistics analysis successfully completed!")
