# ENTO 8030 — Discussion 07: Logistic Regression (Binomial Family)

## Overview

**SHOW ONE → DO ONE → TEACH ONE.** This expanded discussion uses the original *Binomial Family.Rmd* teaching examples (Titanic, lizards, and OME), with additional instruction on `expand.grid()`, simulated residual diagnostics with **DHARMa**, diagnostic displays with **performance**, and the **beta-binomial** distribution for extra-binomial variation.

**Important:** `lizards.csv` and `OME.csv` are the original course datasets, **not simulations**. They already reside in the course repository's top-level `data/` folder. DHARMa generates *simulated responses for diagnostics*, not replacement teaching datasets.

## Repository layout

```text
ENTO 8030 Repo/
├── ENTO 8030 Repo.Rproj
├── data/
│   ├── lizards.csv
│   └── OME.csv
└── discussions/
    └── 07_logistic_regression/
        ├── README.md
        ├── Discussion_07_Logistic_Regression.R
        └── solutions/
            └── Discussion_07_Logistic_Regression_Solutions.R
```

Open the **top-level R Project**, not the discussion subfolder, before running the scripts. Pull the latest repository changes. Do not use `setwd()` or personal absolute paths.

```r
getwd()
list.files("data")
stopifnot(file.exists("data/lizards.csv"), file.exists("data/OME.csv"))
lizards_raw <- read.csv("data/lizards.csv")
ome_raw <- read.csv("data/OME.csv")
str(lizards_raw)
str(ome_raw)
```

The scripts can be stored inside `discussions/07_logistic_regression/` while reading `data/lizards.csv` and `data/OME.csv` from the project root. No duplicate CSVs need to be copied into the discussion folder.

## Install packages once

```r
install.packages(c(
  "dplyr", "ggplot2", "titanic", "emmeans",
  "DHARMa", "performance", "glmmTMB"
))
```

`glmmTMB` may take longer to install because of compiled dependencies. Install it **before class** and restart RStudio if requested. The instructor should run the complete script on the classroom R installation before teaching; simulation-based results and plotting methods may vary across package versions.

## Learning objectives

1. Distinguish Bernoulli binary responses from grouped binomial successes out of known trials.
2. Interpret log-odds, odds ratios, and response-scale predicted probabilities.
3. Construct a prediction grid with `expand.grid()` and explain how its rows differ from observations.
4. Compute predictions and pointwise 95% intervals on the **link scale**, then back-transform with `plogis()`.
5. Recognize the distinction between conditional predictions for chosen covariate combinations and marginal means from `emmeans()`.
6. Diagnose potential lack of fit using convergence checks, Pearson dispersion, `DHARMa::simulateResiduals()`, and `performance::check_model()`.
7. Explain why a beta-binomial model can accommodate extra-binomial variability in grouped counts, while not automatically resolving repeated-subject dependence.

## Lesson sequence (allow 100–120 minutes, or split into two sessions)

| Section | SHOW | DO | TEACH |
|---|---|---|---|
| 1. Titanic | Binary GLM; odds and probabilities; `expand.grid()` combinations | Add passenger class; predict sex × class | Reference group, observational inference |
| 2. Lizards | Grouped successes/failures; `emmeans`; DHARMa and `check_model()` | Add diameter; compare predicted proportions | Denominators, sampling independence |
| 3. OME | Known trials, equivalent weighted representation; age × noise; prediction grid with CIs | Fit age × OME and draw predictions | Interactions, conditional predictions |
| 4. Diagnostics | Convergence, Pearson dispersion, DHARMa, performance | Diagnose lizard GLM | Different questions answered by each diagnostic |
| 5. Beta-binomial | Fit OME beta-binomial using `glmmTMB`; compare AIC and residuals | Fit lizard beta-binomial; interpret | Extra-binomial variation versus repeated measures |

## How `expand.grid()` works

`expand.grid()` creates **every combination** of supplied predictor values. For example:

```r
expand.grid(Sex = c("female", "male"), Pclass = c("1", "2", "3"))
```

This creates six hypothetical scenarios. When predicting from a model, `newdata` must contain all required predictors with appropriate types/levels. A prediction grid is **not** a resampled dataset. For a continuous predictor, use `seq()` to create a range and cross it with factor levels.

Use `predict(model, newdata = grid, type = "response")` for probabilities from a logit-binomial model. For approximate pointwise confidence intervals, use `type = "link", se.fit = TRUE` and transform `fit ± 1.96 * SE` using `plogis()`.

## Diagnostic interpretation guide

- **Convergence:** `model$converged` indicates that the GLM fitting algorithm finished. It does not demonstrate model adequacy.
- **Pearson ratio:** `sum(residuals(model, type="pearson")^2) / df.residual(model)` screens for extra-binomial variability. The supplied OME introductory GLM gives about **1.61** and the lizard `Site + Diameter` GLM about **2.42**. These are prompts to investigate, not proofs of a specific cause.
- **DHARMa:** `simulateResiduals(model, n=1000)` compares observed outcomes to simulated outcomes under the fitted model. Inspect the plot and tests for uniformity, dispersion, and outliers. Small sample sizes and grouping can limit power; a nonsignificant test does not establish a good model.
- **performance:** `check_model(model)` provides a multi-panel diagnostic display. Supported panels vary with model class and installed versions. Interpret relevant panels rather than assuming every check applies equally to binomial models.
- **Beta-binomial:** `glmmTMB(cbind(success, failure) ~ predictors, family=betabinomial(link="logit"), data=...)` allows extra variation in grouped binomial outcomes. Compare model assumptions, diagnostics and AIC with the ordinary binomial fit. An AIC improvement alone does not validate inference.

## Dataset-specific cautions

**Lizards:** One of 24 cells has `grahami = 0` and `opalinus = 0`, giving zero trials. Preserve `lizards_raw` and exclude that cell for binomial modeling. With only 23 nonzero cells, complex models may be unstable. Ask whether cells are independent or share sampling locations.

**OME:** There are 1,097 observations from 77 participants. The simple `glm()` and beta-binomial `glmmTMB()` demonstrations do **not** automatically account for multiple observations from the same participant. For research, investigate a participant random intercept such as `(1 | ID)` and consider the sampling/repeated-measures design. Extra-binomial variability and between-row correlation are distinct issues. The scripts use `Age_centered = Age - 40`; this changes interpretation of the intercept, not the underlying age relationship.

**Titanic:** Observational data; do not infer randomized causal effects from sex or class associations. The working sample uses complete cases for Age.

## Student workflow

1. Open the project root, **PULL** changes, and verify both CSV paths.
2. Open `discussions/07_logistic_regression/Discussion_07_Logistic_Regression.R`.
3. Run each **SHOW** demonstration, fill in **DO** exercises, and discuss **TEACH** prompts.
4. Inspect diagnostics **before** interpreting the beta-binomial as an improvement.
5. Save your work and follow the course **COMMIT → PUSH** workflow in your student repository.
6. The `solutions/` script is for instructor review.

## Exit ticket

Report a predicted probability; distinguish it from an odds ratio; explain what `expand.grid()` produces; name two diagnostic tools and what each evaluates; and explain one reason a beta-binomial model might help **and** one reason it may not solve the design problem.
