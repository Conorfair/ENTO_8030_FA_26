# Discussion 03 -- Linear Models in R

## Session Goals

By the end of this discussion, you should be able to:

-   fit linear models in R using `lm()`
-   recognize simple linear regression, two-group comparisons, one-way
    ANOVA, and two-way ANOVA as applications of the linear-model
    framework
-   interpret model coefficients in the context of continuous and
    categorical predictors
-   distinguish coefficient t-tests from omnibus ANOVA F-tests
-   fit additive and interaction models for two categorical predictors
-   explain what an interaction means statistically and biologically
-   evaluate linear-model assumptions using diagnostic plots
-   connect the structure of the predictors to the way a linear model is
    commonly described

## Files for This Discussion

Open the student script:

``` text
Discussion_03_Linear_Models.R
```

A completed version is stored in:

``` text
solutions/Discussion_03_Linear_Models_Solutions.R
```

The solution file is intended for checking your work after completing
the examples or as directed by the instructor.

## Before Class

Before working on Discussion 03:

1.  Open the **course repository** R Project.
2.  Pull the most recent changes from the course GitHub repository.
3.  Confirm that the `03_linear_models/` folder is present under
    `discussions/`.
4.  Read this `README.md`.
5.  Copy `Discussion_03_Linear_Models.R` into the corresponding folder
    in your **private ENTO 8030 repository**.
6.  Copy the required data files listed below from the course
    repository's `data/` folder into the `data/` folder of your private
    repository.
7.  Open your **private ENTO 8030 R Project** before editing the script.

Do not complete your personal course work directly in the
instructor-maintained course repository.

## Data Files to Copy to Your Private Repository

Discussion 03 uses the following files:

``` text
Simple_Linear_Regression.csv
T-Test_Example.csv
FlowerColourVisits.csv
growth.csv
gardens.csv
ladybirds.csv
```

Copy these files from the course repository's:

``` text
data/
```

folder into the top-level:

``` text
data/
```

folder of your private repository.

Because the discussion script uses `here()`, maintaining this folder
structure allows the same relative paths to work across computers.

## Expected Private Repository Structure

After copying the files, your private repository should contain
something similar to:

``` text
ENTO_8030_LastName_FirstInitial/
│
├── data/
│   ├── Simple_Linear_Regression.csv
│   ├── T-Test_Example.csv
│   ├── FlowerColourVisits.csv
│   ├── growth.csv
│   ├── gardens.csv
│   └── ladybirds.csv
│
├── discussions/
│   └── 03_linear_models/
│       └── Discussion_03_Linear_Models.R
│
└── output/
```

## During Class

We will use a common workflow throughout the discussion:

``` text
Import Data
    ↓
Inspect Data
    ↓
Visualize
    ↓
Specify the Model
    ↓
Fit the Model
    ↓
Evaluate Diagnostics
    ↓
Test Hypotheses
    ↓
Interpret
```

The script progresses through four related model structures:

``` text
One continuous predictor
        ↓
Simple linear regression

One categorical predictor with two levels
        ↓
Two-group comparison

One categorical predictor with several levels
        ↓
One-way ANOVA

Two categorical predictors
        ↓
Two-way / factorial ANOVA
```

The important idea is that each can be fitted with the same `lm()`
framework.

## Topics in This Discussion

### Simple Linear Regression

We begin with a quantitative response and one continuous predictor. You
will interpret the intercept, slope, model fit, and diagnostic plots.

### Two-Level Categorical Predictor

We then replace the continuous predictor with a categorical predictor
containing two groups and connect the `lm()` coefficient test to a
two-sample comparison.

### One-Way ANOVA

Next, the categorical predictor contains more than two groups. You will
distinguish:

-   the omnibus F-test, which asks whether there is evidence that at
    least one population mean differs
-   coefficient t-tests, which compare individual factor levels with the
    reference level

Formal post-hoc comparisons and compact letter displays will be covered
in a later discussion.

### Two-Way ANOVA

Finally, we include two categorical predictors. You will compare:

``` r
response ~ factor_a + factor_b
```

with:

``` r
response ~ factor_a * factor_b
```

and interpret the interaction as asking whether the effect of one factor
depends on the level of the other factor.

## Practice Examples

The student script ends with two practice problems:

1.  a two-group comparison using `gardens.csv`
2.  a two-way ANOVA using `ladybirds.csv`

Complete these in your student script before consulting the solution
file unless directed otherwise.

## Student Work and GitHub

Complete your work in your **private repository**.

After making meaningful progress:

``` text
EDIT
  ↓
SAVE
  ↓
STAGE
  ↓
COMMIT
  ↓
PUSH
```

A suitable commit message would be:

``` text
Complete Discussion 03 linear models
```

## End-of-Session Check

Before leaving, confirm that you can:

-   fit a model with `lm()`
-   identify the response and predictor variables from an R formula
-   distinguish continuous and categorical predictors
-   interpret an intercept and slope
-   explain what an omnibus F-test tells you
-   explain what coefficient t-tests tell you
-   fit an additive two-way ANOVA
-   add and interpret a two-way interaction
-   evaluate the standard linear-model diagnostic plots
-   save, commit, and push your completed work to your private GitHub
    repository
