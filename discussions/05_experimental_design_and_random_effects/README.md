# Discussion 05 — Experimental Design and Random Effects

## Overview

This discussion connects **experimental design** to the statistical models used to analyze data with grouped or hierarchical structure. The main goal is to practice identifying the experimental unit, true replication, blocking, and levels of randomization **before** deciding which fixed and random effects belong in a model.

The discussion progresses from a completely randomized design (CRD) to a randomized complete block design (RCBD), then introduces a random-intercept linear mixed model and finishes with a split-plot example.

## Learning objectives

By the end of the discussion, you should be able to:

- identify experimental units, observational units, replication, and subsampling;
- distinguish CRD, RCBD, factorial treatment structure, and split-plot randomization structure;
- create reproducible treatment randomizations in R;
- explain why observations within the same block or experimental unit may not be independent;
- distinguish fixed treatment effects from random grouping effects;
- fit and interpret a random-intercept linear mixed model with `lmer()`;
- interpret variance components and the intraclass correlation coefficient (ICC);
- obtain estimated marginal means and treatment comparisons from a mixed model; and
- translate the randomization structure of a split-plot experiment into an appropriate random-effects structure.

## Files

- `Discussion_05_Experimental_Design_Random_Effects.R` — student discussion script with active-learning questions.
- `Discussion_05_Experimental_Design_Random_Effects_Solutions.R` — instructor version with suggested answers.

No external dataset is required. The script creates reproducible experimental layouts and simulated responses using `set.seed(8030)` so that everyone can work from the same examples.

## Required packages

```r
install.packages(c(
  "tidyverse",
  "lme4",
  "lmerTest",
  "emmeans",
  "performance"
))
```

Then load them with:

```r
library(tidyverse)
library(lme4)
library(lmerTest)
library(emmeans)
library(performance)
```

## Recommended workflow

1. Pull the newest version of the ENTO 8030 course repository.
2. Locate the Discussion 05 files in the course repository.
3. Copy the student `.R` script into your **private personal ENTO 8030 repository**.
4. Open your personal R Project and work from the copied script.
5. Save your changes, stage the file, commit your work, and push it to GitHub.

A typical Git workflow is:

```bash
git status
git pull
git add Discussion_05_Experimental_Design_Random_Effects.R
git commit -m "Complete Discussion 05"
git push
```

## Discussion structure

### Part 1 — Experimental units and replication

Begin by distinguishing the unit that receives an independently randomized treatment from the units on which repeated or subsampled measurements are collected. Remember:

> **The experimental unit is the smallest unit that can be independently assigned to a treatment.**

More observations within an experimental unit can improve measurement, but they do not create additional independent treatment replication.

### Part 2 — CRD and RCBD randomization

Use R to create reproducible treatment layouts. Compare complete randomization across all experimental units with randomization within blocks. Consider what known nuisance variation blocking is intended to control.

### Part 3 — Random-intercept mixed model

Use a simulated RCBD response to compare a model that ignores block with a model that explicitly represents block-to-block variation:

```r
lm(biomass ~ treatment, data = rcbd_data)

lmer(
  biomass ~ treatment + (1 | block),
  data = rcbd_data,
  REML = TRUE
)
```

The random effect is motivated by the **experimental design**, not selected simply because it changes AIC or a p-value.

### Part 4 — Variance components and ICC

Use `VarCorr()` and `performance::icc()` to examine how variation is partitioned between blocks and residual variation among experimental units within blocks.

### Part 5 — Estimated marginal means

Use `emmeans()` to obtain model-based treatment estimates and Tukey-adjusted comparisons while retaining the variance structure represented by the mixed model.

### Part 6 — Split-plot design

Finish by identifying two different experimental-unit scales:

- irrigation is randomized to **whole plots**;
- insecticide is randomized to **subplots within whole plots**.

The mixed model mirrors that structure:

```r
lmer(
  biomass ~ irrigation * insecticide +
    (1 | block) +
    (1 | whole_plot_id),
  data = splitplot_data,
  REML = TRUE
)
```

The key question is not simply *"Is this variable fixed or random?"* Start with:

> **Where was each treatment randomized, and which observations share the same experimental unit or grouping structure?**

## Take-home framework

Before fitting a model, work through this sequence:

**Experimental design → randomization → experimental unit → replication/dependence → statistical model**

If the experimental design is not understood, the model structure cannot be justified reliably.
