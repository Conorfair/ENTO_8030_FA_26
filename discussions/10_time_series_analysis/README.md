# Discussion 10 — Time Series Analysis

These files retain the original R Markdown teaching sequence: sorghum repeated measures, covariance structures, model selection and inference, survival analysis, and the lettuce practice example.

## Before class

1. Open the ENTO 8030 R project at the repository root. Do not use `setwd()`.
2. Install packages used by the scripts as needed (see `library()` calls).
3. Confirm `data/Duck survival.csv` is present for the survival section; it is not included in this package.
4. Run the script from the top in a fresh R session. Avoid executing only selected lines from older analyses.

## Key updates

- Sorghum objects now use `sorghum_dat`, `sorghum_AR1`, `sorghum_UN`, etc.; lettuce objects use `lettuce_` names to prevent overwriting.
- Verify model response, sample size, convergence code, and positive-definite Hessian before comparing covariance structures.
- Toeplitz convergence warning is not evidence that negative covariance is invalid.
- UN was the lowest-AIC converged model in the supplied sorghum results (UN −9.787; AR1 −4.347; Toeplitz 0.696 with convergence warning). Students should verify their own results.
- UN is used for sorghum fixed-effect tests, diagnostics, marginal means, and plots, conditional on satisfactory additional diagnostics.
- Wald chi-square tests are not F tests. Confidence interval names are handled robustly.
- Survival-curve area estimates are restricted to observed follow-up, not interpreted as unrestricted life expectancy.

The instructor script follows the same sequence with additional notes and prompts. The scripts have been reviewed structurally but **not executed in R** in this environment.
