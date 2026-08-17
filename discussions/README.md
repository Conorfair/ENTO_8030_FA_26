# ENTO 8030 Discussion Sessions

This folder contains materials for the applied discussion sessions in **ENTO 8030: Advanced Quantitative Analysis in Entomological Science**.

Discussion sessions are designed to complement the lectures by emphasizing practical statistical analysis, R programming, interpretation, troubleshooting, and reproducible workflows.

## How to Use These Materials

Each discussion session is stored in its own folder.

A typical discussion folder may contain:

* a `README.md` with the goals and instructions for the session
* an R script used during class
* datasets or links to datasets
* example output
* optional practice exercises

Before each discussion session:

1. Open the ENTO 8030 course R Project.
2. Pull the most recent changes from the course GitHub repository.
3. Open the folder for the appropriate discussion.
4. Read the weekly `README.md`.
5. Open the R script and any required files before class.

## Discussion Schedule

| Discussion | Topic                                     | Folder                 |
| ---------- | ----------------------------------------- | ---------------------- |
| 01         | GitHub, R Projects, and Getting Help in R | `01_github_rprojects/` |
| 02         | t-tests and Chi-square tests              | `02_ttest_chisquare/`  |
| 03         | Linear Models                             | `03_linear_models/`    |
| 04         | emmeans and Compact Letter Displays       | `04_emmeans_cld/`      |
| 05         | Random Effects Models                     | `05_random_effects/`   |
| 06         | ggplot2 and Data Visualization            | `06_ggplot/`           |
| 07         | Bernoulli and Binomial Models             | `07_binomial/`         |
| 08         | Poisson and Negative Binomial Models      | `08_count_models/`     |
| Advanced   | Advanced Topics                           | `advanced_topics/`     |

The schedule may be updated during the semester.

## Course Repository vs. Personal Repository

The **course repository** contains instructor-provided materials.

You will primarily:

```text
PULL
```

from the course repository.

Your **personal ENTO 8030 repository** contains your own work.

You will primarily:

```text
EDIT
  ↓
COMMIT
  ↓
PUSH
```

to your personal repository.

Keeping these two repositories separate helps prevent conflicts between course updates and your own files.

## A Consistent Analysis Workflow

Across discussion sessions, we will repeatedly use a common analytical workflow:

```text
Import Data
    ↓
Inspect Data
    ↓
Visualize
    ↓
Fit Model
    ↓
Evaluate Assumptions / Diagnostics
    ↓
Test Hypotheses
    ↓
Estimate Effects
    ↓
Visualize Results
    ↓
Interpret
```

The statistical methods will become more advanced throughout the semester, but this general workflow will remain useful.

## Getting Help

You are not expected to memorize every R function.

When you encounter an unfamiliar function or error, begin with:

```r
?function_name
help(function_name)
args(function_name)
example(function_name)
```

Additional course resources are available in the `resources/` folder.
