# ============================================================
# ENTO 8030 - Applied Statistics for Graduate Students
# Discussion 02
#
# t-tests, Chi-square Tests, Tidyverse Basics, and ggplot2
# ============================================================
#
# Goals for today's discussion:
#
# By the end of this session, you should be able to:
#
# 1. Read a CSV file using readr::read_csv().
# 2. Use a few core tidyverse verbs to inspect and summarize data.
# 3. Read a pipe (%>%) as "and then".
# 4. Build a basic ggplot in layers.
# 5. Recognize when a two-sample t-test is appropriate.
# 6. Distinguish Welch's t-test from the equal-variance t-test.
# 7. Recognize when a Chi-square test is appropriate.
# 8. Build and interpret a contingency table.
# 9. Check the expected counts used by a Chi-square test.
# 10. Connect the statistical test back to the scientific question.
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

getwd()

list.files()


# We will continue using relative file paths.
#
# The here() function builds a path beginning at the root of the
# R Project.

here("data", "gardens.csv")



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


# Optional numerical normality checks.

gardens %>%
  group_by(garden) %>%
  summarise(
    shapiro_p = shapiro.test(ozone)$p.value,
    .groups = "drop"
  )



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
# 4. Expected counts should generally not be too small.
#
#
# Always inspect:

ladybird_chisq$expected


# If expected counts are too small in a small contingency table,
# Fisher's exact test may be more appropriate.

# fisher.test(ladybird_table)



# ============================================================
# PART IV: OPTIONAL CHI-SQUARE GOODNESS-OF-FIT EXAMPLE
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
# Two-sample t-test
#
#
# SCENARIO B
#
# Response = survived/died
# Explanatory variable = treatment
#
# Test:
# Chi-square test of independence (or another categorical/binomial
# model depending on the study design)
#
#
# SCENARIO C
#
# Response = wing length (mm)
# Explanatory variable = sex (female vs male)
#
# Test:
# Two-sample t-test
#
#
# SCENARIO D
#
# Variables = habitat type and color morph
#
# Test:
# Chi-square test of independence
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
# SOLUTION:

gardens %>%
  group_by(garden) %>%
  summarise(
    median_ozone = median(ozone, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(
  gardens,
  aes(x = garden, y = ozone)
) +
  geom_jitter(
    width = 0.08,
    height = 0,
    alpha = 0.65
  ) +
  labs(
    title = "Raw ozone readings by garden",
    x = "Garden",
    y = "Ozone (ppb)"
  ) +
  theme_classic()

t.test(
  ozone ~ garden,
  data = gardens
)

# Example interpretation:
#
# Replace the wording below with the direction, estimated difference,
# confidence interval, and p-value shown by your output.
#
# "Mean ozone readings differed between the two gardens
# (Welch two-sample t-test, ...)."


# ------------------------------------------------------------
# EXERCISE 2: CHI-SQUARE
# ------------------------------------------------------------
#
# Using ladybirds:
#
# 1. Recreate the contingency table.
# 2. Run the Chi-square test.
# 3. Print the expected counts.
# 4. Write one sentence interpreting the result.
#
# SOLUTION:

ladybird_table_practice <- xtabs(
  number ~ colour + habitat,
  data = ladybirds
)

ladybird_chisq_practice <- chisq.test(
  ladybird_table_practice
)

ladybird_table_practice
ladybird_chisq_practice
ladybird_chisq_practice$expected

# Example interpretation:
#
# "The distribution of ladybird color morphs was [associated/not
# associated] with habitat type (Chi-square test, ...)."


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
# SOLUTIONS:
#
# t.test():
#   conf.level
#
# chisq.test():
#   simulate.p.value = TRUE
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
# 9. How does the type of response variable help determine
#    which analysis is appropriate?
#
# ============================================================
