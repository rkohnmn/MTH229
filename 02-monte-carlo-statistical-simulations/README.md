# Monte Carlo Statistical Simulations & Distribution Modeling

Computational probability and mathematical statistics analysis implementing Monte Carlo simulations, convergence validation, bivariate normal modeling, and multi-dimensional numerical quadrature in R.

## What I Worked On
- **Monte Carlo Convergence Validation**: Simulated $N = 100,000$ draws across discrete parametric families (Binomial, Poisson, Geometric, Negative Binomial) to empirically evaluate the Law of Large Numbers against exact analytic moments.
- **Asymptotic Variance Tracking**: Implemented running sample variance tracking across sample sizes $N \in [500, 100,000]$ to demonstrate rate of variance convergence to theoretical $Var(X) = 21.00$.
- **Continuous Distribution Modeling**: Simulated realization vectors for Uniform $\mathcal{U}(3, 10)$, Exponential $\text{Exp}(\lambda = 2)$, Chi-Squared $\chi^2(5)$, and Beta $\text{Beta}(2, 4)$ distributions, generating comparative kernel density plots.
- **Bivariate Normal Distribution & Hypothesis Testing**: Modeled bivariate normal random vectors using `mnormt::rmnorm` with covariance matrix $\mathbf{\Sigma} = \mathbf{I}_2$. Evaluated rectangular probabilities $P([-2, 2]^2)$ via joint cumulative integration versus independent marginal products, and conducted two-tailed Pearson correlation hypothesis tests (`cor.test`) to evaluate empirical Type I error rates.
- **Numerical Quadrature**: Implemented 1D numerical quadrature (`integrate`) and multi-dimensional adaptive cubature (`cubature::adaptIntegrate`) to compute single and double definite integrals against exact symbolic antiderivatives.
- **Combinatorics**: Implemented sampling scenarios (unordered without replacement) via `DescTools::CombSet` to verify subset cardinality against analytic binomial coefficients $\binom{n}{k}$.

## Tools
- **Language**: R (v4.4.2)
- **Specialized Packages**: `mosaic`, `mnormt`, `DescTools`, `cubature`, `ggplot2`, `dplyr`, `tidyr`, `scales`

## Files
- [`analysis.R`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/02-monte-carlo-statistical-simulations/analysis.R): Standalone executable simulation script performing all Monte Carlo draws, hypothesis tests, and figure exports.
- [`report.Rmd`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/02-monte-carlo-statistical-simulations/report.Rmd): Reproducible R Markdown report with mathematical formulations, code chunks, and compiled figures.
- [`figures/`](file:///c:/Users/RobTop/Downloads/MTH229/github-r-coursework/02-monte-carlo-statistical-simulations/figures): Generated high-resolution visualization artifacts:
  - `fig1_discrete_mc_variance_convergence.png`: Sample size convergence to theoretical variance.
  - `fig2_bivariate_normal_simulated_scatter.png`: Bivariate normal scatter with 2D contour lines.
  - `fig3_bivariate_normal_contour.png`: Theoretical bivariate probability surface.
  - `fig4_continuous_distributions_mc.png`: Multi-panel continuous density distributions.

## Results / Takeaways
- **Moment Convergence**: For $\text{Binomial}(100, 0.30)$, the empirical Monte Carlo variance converged to $21.0478$ at $N = 100,000$, matching the theoretical value $21.0000$ within an absolute error of $0.048$.
- **Linear Expectation**: For independent variables $X \sim \text{Pois}(2)$ and $Y \sim \text{Geom}(0.5)$, empirical mean $E[X + Y] = 2.9965$, confirming theoretical expectation $2 + 1 = 3.0000$ (error $< 0.004$).
- **Tail Probability**: The Negative Binomial tail probability $P(X > 6)$ yielded an empirical estimate of $0.04924$, closely matching the analytic summation value of $0.05014$.
- **Bivariate Independence**: For uncorrelated standard bivariate normal draws ($N = 2,000$), the sample correlation was $r = -0.0123$ with a $p$-value of $0.5827$, failing to reject the null hypothesis of independence ($\alpha = 0.05$). The rectangular probability $P([-2, 2]^2) = 0.911070$ perfectly matched the squared univariate standard normal probability $(P(-2 \le Z \le 2))^2$.
- **Numerical Integration**: Adaptive 1D quadrature on $f(x) = x^2 + 3x - 4$ over $[0, 2]$ yielded $0.666667$, matching the analytic solution $\frac{2}{3}$.

## Running the Analysis
```R
# Run the simulation script and generate all figures
source("analysis.R")

# Or render the full HTML report
rmarkdown::render("report.Rmd")
```
