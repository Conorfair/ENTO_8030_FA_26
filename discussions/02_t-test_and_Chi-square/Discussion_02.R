# ============================================================
# ENTO 8030 - Applied Statistics for Graduate Students
# Discussion 02
#
# t-tests, Chi-square Tests, Tidyverse Basics, and ggplot2
# ============================================================


# ============================================================
# BEFORE YOU BEGIN
# ============================================================
#
# Complete these steps BEFORE modifying this script:
#
# 1. Open the COURSE R Project.
# 2. Pull the most recent instructor updates.
# 3. Read the Discussion 02 README.
# 4. Copy the required Discussion 02 materials into your
#    PERSONAL ENTO 8030 repository.
# 5. Open your PERSONAL ENTO 8030 R Project.
# 6. Complete all work below from your personal repository.
#
#
# Files needed for today's discussion:
#
# discussions/02_t-test_and_Chi-square/Discussion_02.R
#
# data/gardens.csv
#
# data/ladybirds.csv
#
#
# Your personal repository should contain something similar to:
#
# ENTO_8030_LastName_FirstInitial/
# |
# |-- data/
# |   |-- gardens.csv
# |   `-- ladybirds.csv
# |
# |-- discussions/
# |   `-- 02_t-test_and_Chi-square/
# |       `-- Discussion_02.R
# |
# `-- output/
#
#
# At the end of class:
#
# SAVE -> STAGE -> COMMIT -> PUSH
# ============================================================


# ============================================================
# GOALS FOR TODAY'S DISCUSSION
# ============================================================
#
# By the end of this session, you should be able to:
#
# 1. Confirm that you are working in your personal R Project.
# 2. Read a CSV file using readr::read_csv().
# 3. Use a few core tidyverse verbs to inspect and summarize data.
# 4. Read a pipe (%>%) as "and then".
# 5. Build a basic ggplot in layers.
# 6. Recognize when a two-sample t-test is appropriate.
# 7. Distinguish Welch's t-test from the equal-variance t-test.
# 8. Interpret an estimated difference, confidence interval,
#    and p-value together.
# 9. Recognize when a Chi-square test is appropriate.
# 10. Build and interpret a contingency table.
# 11. Compare observed and expected counts.
# 12. Use standardized residuals to identify important cells.
# 13. Check whether expected counts are sparse.
# 14. Connect the statistical test back to the scientific question.
#
#
# IMPORTANT:
#
# The goal is not to memorize functions. Focus on:
#
# Scientific question
#        ↓
# Type of response variable
#        ↓
# Type of explanatory variable
#        ↓
# Appropriate visualization
#        ↓
# Statistical test
#        ↓
# Effect estimate / pattern
#        ↓
# Uncertainty
#        ↓
# Interpretation
#
# ============================================================



# ============================================================
# PART I: PACKAGES, PROJECTS, AND THE TIDYVERSE
# ============================================================


# ------------------------------------------------------------
# 1. LOAD PACKAGES
# ------------------------------------------------------------
#
# Packages only need to be INSTALLED once, but they must be
# LOADED again each time you start a new R session.
#
# If needed, install packages in the Console:
#
# install.packages(c("tidyverse", "here", "janitor"))
#
# Do NOT include install.packages() in a script that you intend
# to run every time.

library(tidyverse)
library(here)
library(janitor)


# ------------------------------------------------------------
# 2. CHECK THE PROJECT
# ------------------------------------------------------------
#
# Discussion 02 should be completed from YOUR personal
# ENTO 8030 R Project.


getwd()


list.files()


list.files("data")


# CHECKPOINT:
#
# Are you working in YOUR personal ENTO 8030 repository?
#
# Can you see:
#
# gardens.csv
# ladybirds.csv
#
# inside the data folder?
#
#
# If getwd() indicates that you are still in:
#
#       ENTO_8030_FA_26
#
# STOP and open your personal R Project before continuing.
#
#
# We will continue using relative file paths.
#
# The here() function builds a path beginning at the root of the
# currently open R Project.


here("data", "gardens.csv")


# DISCUSSION:
#
# Why should this path work on both your computer and another
# student's computer even though the projects are stored in
# different absolute locations?



# ------------------------------------------------------------
# 3. A VERY SHORT INTRODUCTION TO TIDYVERSE LANGUAGE
# ------------------------------------------------------------
#
# tidyverse is a collection of R packages designed to work
# together.
#
# Some packages/functions we will use today:
#
# readr     -> read_csv()
# dplyr     -> filter(), select(), mutate(), group_by(), summarise()
# ggplot2   -> ggplot(), geom_*(), labs(), theme_*()
#
#
# The pipe:
#
# %>%
#
# can often be read as:
#
# "and then..."
#
# Example:
#
# data %>%
#   filter(...) %>%
#   group_by(...) %>%
#   summarise(...)
#
# Read this as:
#
# "Start with data,
#  AND THEN filter rows,
#  AND THEN form groups,
#  AND THEN calculate summaries."



# ============================================================
# PART II: TWO-SAMPLE t-TEST
# ============================================================


# ------------------------------------------------------------
# 4. SCIENTIFIC QUESTION
# ------------------------------------------------------------
#
# Question:
#
# Are mean ozone readings different between Garden A and
# Garden B?
#
#
# Response variable:
#
# ozone -> quantitative/continuous
#
#
# Explanatory variable:
#
# garden -> categorical with TWO groups
#
#
# This structure suggests a two-sample t-test.



# ------------------------------------------------------------
# 5. IMPORT THE DATA
# ------------------------------------------------------------

gardens <- read_csv(
  here("data", "gardens.csv")
) %>%
  clean_names()


# Inspect the object.

glimpse(gardens)

head(gardens)

summary(gardens)


# ------------------------------------------------------------
# CHECKPOINT
# ------------------------------------------------------------
#
# What is one observation in this dataset?
#
# Which variable is the response?
#
# Which variable defines the two groups?
#
# How many observations are present in each garden?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 6. SUMMARIZE THE DATA WITH dplyr
# ------------------------------------------------------------

garden_summary <- gardens %>%
  group_by(garden) %>%
  summarise(
    n = n(),
    mean_ozone = mean(ozone, na.rm = TRUE),
    sd_ozone = sd(ozone, na.rm = TRUE),
    .groups = "drop"
  )

garden_summary


# ------------------------------------------------------------
# DISCUSSION
# ------------------------------------------------------------
#
# What does group_by(garden) change about the calculation?
#
# Why do we use na.rm = TRUE?
#
# Do the sample means appear different?
#
# Is looking at the means alone enough to answer our hypothesis?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 7. INTRODUCTION TO ggplot2
# ------------------------------------------------------------
#
# A ggplot is constructed in layers.
#
# Basic structure:
#
# ggplot(DATA, aes(x = X_VARIABLE, y = Y_VARIABLE)) +
#   geom_*() +
#   labs(...) +
#   theme_*()
#
#
# DATA        = what dataset?
# aes()       = which variables are mapped to visual properties?
# geom_*()    = how should observations be represented?
# labs()      = labels
# theme_*()   = general appearance



# Start with the data and axes.

ggplot(
  data = gardens,
  aes(x = garden, y = ozone)
)


# Add a geometry.

ggplot(
  data = gardens,
  aes(x = garden, y = ozone)
) +
  geom_boxplot()


# Add individual observations and labels.

garden_plot <- ggplot(
  data = gardens,
  aes(x = garden, y = ozone)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(
    width = 0.08,
    height = 0,
    alpha = 0.65
  ) +
  labs(
    title = "Ozone readings by garden",
    x = "Garden",
    y = "Ozone (ppb)"
  ) +
  theme_classic()

garden_plot


# ------------------------------------------------------------
# DISCUSSION
# ------------------------------------------------------------
#
# Why might it be helpful to show BOTH a boxplot and the raw
# observations?
#
# What do you notice about:
#
# - center?
# - spread?
# - potential outliers?
# - sample size?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 8. t-TEST HYPOTHESES
# ------------------------------------------------------------
#
# For a two-sided two-sample t-test:
#
# H0: mean ozone in Garden A = mean ozone in Garden B
#
# HA: mean ozone in Garden A != mean ozone in Garden B
#
#
# The t-test compares the observed difference in group means
# with the amount of variation expected under H0.



# ------------------------------------------------------------
# 9. WELCH'S TWO-SAMPLE t-TEST
# ------------------------------------------------------------
#
# In R, t.test() uses Welch's t-test by default.
#
# Welch's t-test does NOT require the two groups to have equal
# variances and is generally a useful default for independent
# two-group comparisons.

garden_ttest <- t.test(
  ozone ~ garden,
  data = gardens
)

garden_ttest


# ------------------------------------------------------------
# INTERPRET THE OUTPUT
# ------------------------------------------------------------
#
# Identify:
#
# 1. estimated group means
# 2. t statistic
# 3. degrees of freedom
# 4. p-value
# 5. 95% confidence interval for the difference
#
#
# QUESTION:
#
# Based on the p-value and confidence interval, what would you
# conclude about mean ozone readings in the two gardens?
#
# Write the conclusion in biological/scientific language rather
# than only writing "significant" or "not significant."
#
#
# IMPORTANT:
#
# Statistical interpretation should not begin and end with the
# p-value.
#
# Ask:
#
# 1. Which group had the larger estimated mean?
# 2. How large was the estimated difference?
# 3. What values are compatible with the 95% confidence interval?
# 4. How strong is the evidence against H0?
#
# The p-value addresses evidence against H0.
#
# The estimated difference and confidence interval tell us about
# the magnitude and uncertainty of the effect.
# ------------------------------------------------------------



# ------------------------------------------------------------
# 10. WHAT ABOUT THE EQUAL-VARIANCE t-TEST?
# ------------------------------------------------------------
#
# The traditional Student two-sample t-test assumes equal
# population variances.
#
# It can be requested using:
#
# var.equal = TRUE
#
# We include it here for comparison, but Welch's test is the
# default analysis above.

garden_ttest_equal_var <- t.test(
  ozone ~ garden,
  data = gardens,
  var.equal = TRUE
)

garden_ttest_equal_var


# Compare the two results.

garden_ttest
garden_ttest_equal_var


# ------------------------------------------------------------
# DISCUSSION
# ------------------------------------------------------------
#
# Did the scientific conclusion change?
#
# Did the degrees of freedom change?
#
# Why might Welch's procedure be preferable when equal
# variances are uncertain?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 11. t-TEST ASSUMPTIONS
# ------------------------------------------------------------
#
# Important considerations include:
#
# 1. Observations should be independent.
#    -> This comes primarily from the experimental/sampling design.
#
# 2. The response should be quantitative.
#
# 3. Within each group, the data should not have extreme
#    departures from the distributional assumptions, especially
#    with small sample sizes.
#
# 4. Extreme outliers can strongly influence means and t-tests.
#
#
# IMPORTANT:
#
# A Shapiro-Wilk test is NOT proof that data are or are not
# "normal." Visual inspection and knowledge of the study design
# are also important.



# Visualize each group.

ggplot(
  gardens,
  aes(sample = ozone)
) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ garden) +
  labs(
    title = "Q-Q plots of ozone readings by garden"
  ) +
  theme_classic()


# Optional demonstration:
#
# Statistical tests of normality are often less informative than
# examining the distribution graphically and considering the
# sample size and study design.
#
# A Shapiro-Wilk test can be demonstrated, but its p-value should
# not be treated as proof that data are or are not "normal."


gardens %>%
  group_by(garden) %>%
  summarise(
    shapiro_p = shapiro.test(ozone)$p.value,
    .groups = "drop"
  )


# DISCUSSION:
#
# Why is "p > 0.05" not the same as proving that a population is
# normally distributed?
#
# Which assumption above cannot be diagnosed from a Q-Q plot or
# Shapiro-Wilk test?
#
# Answer to consider:
#
# Independence comes primarily from the experimental or sampling
# design.



# ============================================================
# PART III: CHI-SQUARE TEST OF INDEPENDENCE
# ============================================================


# ------------------------------------------------------------
# 12. SCIENTIFIC QUESTION
# ------------------------------------------------------------
#
# We now have a different kind of question.
#
# Suppose we sampled ladybird beetles from two habitat types and
# classified each beetle by color morph.
#
# Question:
#
# Is color morph associated with habitat type?
#
#
# Response:
#
# counts of observations in CATEGORY combinations
#
#
# Variables:
#
# colour  -> categorical
# habitat -> categorical
#
#
# This structure suggests a Chi-square test of independence.



# ------------------------------------------------------------
# 13. IMPORT THE LADYBIRD DATA
# ------------------------------------------------------------

ladybirds <- read_csv(
  here("data", "ladybirds.csv")
) %>%
  clean_names()

glimpse(ladybirds)

ladybirds


# The source dataset contains a count variable named number.
#
# Therefore, each row represents a color-habitat combination
# with the number of beetles observed in that combination.



# ------------------------------------------------------------
# 14. SUMMARIZE CATEGORICAL DATA
# ------------------------------------------------------------

ladybird_summary <- ladybirds %>%
  group_by(colour, habitat) %>%
  summarise(
    count = sum(number),
    .groups = "drop"
  )

ladybird_summary



# ------------------------------------------------------------
# 15. VISUALIZE THE COUNTS
# ------------------------------------------------------------

ladybird_count_plot <- ggplot(
  ladybird_summary,
  aes(
    x = habitat,
    y = count,
    fill = colour
  )
) +
  geom_col(
    position = "dodge"
  ) +
  labs(
    title = "Ladybird color morph counts by habitat",
    x = "Habitat",
    y = "Number of beetles",
    fill = "Color morph"
  ) +
  theme_classic()

ladybird_count_plot


# A proportional version can be useful when total sample sizes
# differ among habitats.

ladybird_prop_plot <- ggplot(
  ladybird_summary,
  aes(
    x = habitat,
    y = count,
    fill = colour
  )
) +
  geom_col(
    position = "fill"
  ) +
  labs(
    title = "Proportion of ladybird color morphs by habitat",
    x = "Habitat",
    y = "Proportion",
    fill = "Color morph"
  ) +
  theme_classic()

ladybird_prop_plot



# ------------------------------------------------------------
# 16. BUILD A CONTINGENCY TABLE
# ------------------------------------------------------------
#
# chisq.test() expects a table of observed counts.
#
# xtabs() can build this table from a data frame containing
# frequencies.

ladybird_table <- xtabs(
  number ~ colour + habitat,
  data = ladybirds
)

ladybird_table


# Row and column totals.

addmargins(ladybird_table)



# ------------------------------------------------------------
# 17. CHI-SQUARE HYPOTHESES
# ------------------------------------------------------------
#
# H0:
# Color morph and habitat are independent.
#
# HA:
# Color morph and habitat are associated.
#
#
# Another way to phrase H0:
#
# The distribution of color morphs is the same across habitats.



# ------------------------------------------------------------
# 18. RUN THE CHI-SQUARE TEST
# ------------------------------------------------------------

ladybird_chisq <- chisq.test(
  ladybird_table
)

ladybird_chisq


# ------------------------------------------------------------
# INTERPRET THE OUTPUT
# ------------------------------------------------------------
#
# Identify:
#
# 1. Chi-square statistic
# 2. degrees of freedom
# 3. p-value
#
#
# QUESTION:
#
# Is there evidence that ladybird color morph and habitat are
# associated?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 19. OBSERVED COUNTS VS. EXPECTED COUNTS
# ------------------------------------------------------------
#
# The Chi-square statistic compares OBSERVED counts with the
# EXPECTED counts that would occur if H0 were true.

ladybird_table

ladybird_chisq$expected


# Examine each cell's contribution to the Chi-square statistic.

(ladybird_table - ladybird_chisq$expected)^2 /
  ladybird_chisq$expected



# Standardized residuals provide another useful way to examine
# which cells contribute most strongly to the association.


ladybird_chisq$stdres


# As a rough descriptive guide:
#
# values near 0
#   -> observed counts are close to expectation
#
# positive values
#   -> more observations than expected
#
# negative values
#   -> fewer observations than expected
#
# larger absolute values
#   -> stronger departures from the independence model


# ------------------------------------------------------------
# DISCUSSION
# ------------------------------------------------------------
#
# Which cells differ most from their expected counts?
#
# How does that help explain the overall Chi-square result?
#
# ------------------------------------------------------------



# ------------------------------------------------------------
# 20. CHI-SQUARE ASSUMPTIONS
# ------------------------------------------------------------
#
# Important considerations:
#
# 1. The data are counts/frequencies.
#
# 2. Categories are mutually exclusive.
#
# 3. Observations are independent.
#
# 4. The Chi-square approximation becomes less reliable when
#    expected cell counts are very small.
#
#
# Always inspect:


ladybird_chisq$expected


# Avoid using a rigid rule such as "every expected count must be
# at least 5" without considering the size and structure of the
# contingency table.
#
# For a small contingency table with sparse expected counts,
# Fisher's exact test may be preferable.


# fisher.test(ladybird_table)



# ============================================================
# PART IV: OPTIONAL / IF TIME - CHI-SQUARE GOODNESS-OF-FIT
# ============================================================
#
# The Chi-square test can also compare one observed categorical
# distribution with a hypothesized distribution.
#
# Example:
#
# Suppose four trap orientations would be expected to capture
# equal numbers of insects if orientation had no effect.

trap_counts <- c(
  North = 28,
  East = 19,
  South = 31,
  West = 22
)

trap_counts


# Equal expected proportions:

trap_gof <- chisq.test(
  trap_counts,
  p = rep(0.25, 4)
)

trap_gof

trap_gof$expected


# QUESTION:
#
# Does the observed distribution differ from equal proportions?
#
# How is this scientific question different from the ladybird
# test of independence?



# ============================================================
# PART V: CHOOSING BETWEEN THE TESTS
# ============================================================
#
# Complete the following decision questions as a class.
#
#
# SCENARIO A
#
# Response = body mass (g)
# Explanatory variable = treatment (control vs insecticide)
#
# Test:
#
#
#
# SCENARIO B
#
# Suppose independent individuals are summarized as:
#
#                 Survived     Died
# Control             ?          ?
# Insecticide         ?          ?
#
# Question:
#
# Is survival category associated with treatment?
#
# What simple test from TODAY'S material could be used?
#
# Test:
#
#
# NOTE:
#
# Later in the course we will introduce Bernoulli/binomial and
# logistic-regression approaches that provide a more flexible
# framework for binary response data.
#
#
# SCENARIO C
#
# Response = wing length (mm)
# Explanatory variable = sex (female vs male)
#
# Test:
#
#
#
# SCENARIO D
#
# Variables = habitat type and color morph
#
# Test:
#
#
#
# The important distinction:
#
# t-test:
#   compares a QUANTITATIVE response between TWO groups
#
# Chi-square:
#   evaluates COUNTS/FREQUENCIES across CATEGORIES



# ============================================================
# PART VI: INDEPENDENT PRACTICE
# ============================================================


# ------------------------------------------------------------
# EXERCISE 1: t-TEST
# ------------------------------------------------------------
#
# Using gardens:
#
# 1. Calculate the median ozone reading in each garden.
# 2. Create a plot showing the raw observations.
# 3. Run Welch's two-sample t-test.
# 4. Write one sentence interpreting the result.
#
# YOUR CODE:





# ------------------------------------------------------------
# EXERCISE 2: CHI-SQUARE
# ------------------------------------------------------------
#
# Using ladybirds:
#
# 1. Recreate the contingency table.
# 2. Run the Chi-square test.
# 3. Print the expected counts.
# 4. Examine the standardized residuals.
# 5. Identify the cell(s) with the strongest departures from
#    expectation.
# 6. Write one sentence interpreting the overall result.
#
# YOUR CODE:





# ------------------------------------------------------------
# EXERCISE 3: HELP PAGES
# ------------------------------------------------------------
#
# Use R's help system to answer:
#
# What argument in t.test() determines the confidence level?
#
# ?t.test
#
#
# What option in chisq.test() requests a simulated p-value?
#
# ?chisq.test
#
#
# YOUR ANSWERS:
#
#
# ============================================================



# ============================================================
# PART VII: SAVE FIGURES
# ============================================================

dir.create(
  "output/figures",
  recursive = TRUE,
  showWarnings = FALSE
)

ggsave(
  here("output", "figures", "discussion02_gardens_ttest.png"),
  plot = garden_plot,
  width = 6,
  height = 4,
  dpi = 300
)

ggsave(
  here("output", "figures", "discussion02_ladybird_counts.png"),
  plot = ladybird_count_plot,
  width = 6,
  height = 4,
  dpi = 300
)



# ============================================================
# PART VIII: SAVE, COMMIT, AND PUSH YOUR WORK
# ============================================================
#
# Before leaving:
#
# 1. Save Discussion_02.R.
#
# 2. Confirm that your figures were saved in:
#
#       output/figures/
#
# 3. Open the Git pane.
#
# 4. Review the files you changed or created.
#
# 5. Stage the files you want to keep.
#
# 6. Commit with a descriptive message such as:
#
#       Complete Discussion 02 t-test and Chi-square analyses
#
# 7. Push the commit to your PRIVATE GitHub repository.
#
# 8. Open GitHub and verify that your work appears.
#
#
# Remember:
#
# COURSE PROJECT
#
#       PULL -> COPY
#
#
# PERSONAL PROJECT
#
#       EDIT -> SAVE -> STAGE -> COMMIT -> PUSH
#
# ============================================================



# ============================================================
# END-OF-DISCUSSION CHECK
# ============================================================
#
# By the end of today's session, you should be able to explain:
#
# 1. What does %>% mean conceptually?
#
# 2. What do group_by() and summarise() do?
#
# 3. What are the major components of a ggplot?
#
# 4. When is a two-sample t-test appropriate?
#
# 5. Why does R use Welch's t-test by default?
#
# 6. What is the null hypothesis of a Chi-square test of
#    independence?
#
# 7. What is the difference between observed and expected
#    counts?
#
# 8. Why should you inspect expected counts?
#
# 9. What information does a standardized residual provide?
#
# 10. How does the type of response variable help determine
#     which analysis is appropriate?
#
# 11. Why should interpretation include the estimated effect
#     and uncertainty rather than only a p-value?
#
# 12. Which repository should contain the work you completed
#     today?
#
# 13. What Git workflow should you complete before leaving?
#
# ============================================================