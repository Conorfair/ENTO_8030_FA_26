# Discussion 04 --- Planned Contrasts, Multiple Comparisons, and `emmeans`

## Purpose

This discussion connects the omnibus tests used in ANOVA/linear models
to the more specific biological comparisons researchers often want to
make. The emphasis is on **choosing comparisons from the research
question**, estimating those comparisons with `emmeans`, and
understanding why multiplicity matters.

## Learning objectives

By the end of Discussion 04, you should be able to:

-   distinguish an omnibus F-test from a planned contrast and a post-hoc
    comparison;
-   obtain estimated marginal means from a fitted linear model;
-   interpret comparisons within an interaction;
-   translate a biological hypothesis into contrast weights;
-   explain why the number of comparisons affects Type I error;
-   choose between Tukey and Dunnett procedures based on the scientific
    question;
-   interpret estimates, 95% confidence intervals, adjusted p-values,
    and compact letter displays;
-   explain why failure to detect a difference does not establish that
    two groups are equal.

## Files

Use the following course-repository files:

-   `discussions/04_planned_contrasts/Discussion_04_Planned_Contrasts.R`
-   `data/biomass.csv`

An instructor solution script can be maintained separately as:

-   `Discussion_04_Planned_Contrasts_Solutions.R`

## Before class

Pull the newest version of the course repository. Then copy the
Discussion 04 script and any files you will edit into your **private
personal ENTO 8030 repository**. Complete your work from your personal R
Project rather than editing the instructor course repository.

## Discussion workflow

The discussion follows one fitted two-way model so that the statistical
question---not repeated data wrangling---stays central:

1.  inspect and visualize the raw data;
2.  fit the factorial linear model and interpret the omnibus tests;
3.  obtain estimated marginal means;
4.  examine simple effects within the interaction;
5.  translate a biological hypothesis into a planned contrast;
6.  compare multiplicity approaches;
7.  use Dunnett comparisons for a treatment-versus-control question;
8.  interpret a compact letter display carefully;
9.  write a short manuscript-style result.

## Central question

Before running a comparison, ask:

> **What biological hypothesis am I trying to test?**

The comparison procedure should follow from that question. Do not choose
Tukey, Dunnett, Bonferroni, or an unadjusted contrast based on which one
produces the smallest p-value.

## Key distinction

An omnibus F-test can provide evidence that a factor or interaction
contributes to the model, but it usually does not identify the
particular group differences that explain that result. Planned contrasts
test prespecified scientific hypotheses. Post-hoc procedures address
broader sets of comparisons while accounting for multiplicity.

## GitHub workflow

After completing your work in your private repository:

`Pull → Edit → Save → Stage → Commit → Push`

Use a descriptive commit message such as:

`Complete Discussion 04 planned contrasts`

Your private repository remains separate from the public course
repository.
