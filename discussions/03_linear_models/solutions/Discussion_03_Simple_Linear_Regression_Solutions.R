# ==============================================================================
# ENTO 8030 - Discussion 03
# Linear Models in R: Regression, t-tests, and ANOVA
# Solutions Version
# ==============================================================================

# This discussion uses lm() to connect several analyses that may look different
# at first:
#
#   1. Simple linear regression
#   2. Two-sample comparisons
#   3. One-way ANOVA
#   4. Two-way/factorial ANOVA
#
# The common idea is that all of these can be written as linear models.
#
# During class, work through the questions marked:
#
#   # QUESTION:
#   # YOUR INTERPRETATION:
#   # YOUR CODE:
#
# Complete your work in your PRIVATE ENTO 8030 repository.


# ==============================================================================
# 1. PACKAGES
# ==============================================================================

library(tidyverse)
library(here)
library(janitor)
library(car)


# ==============================================================================
# 2. SIMPLE LINEAR REGRESSION
# ==============================================================================

# Load the data
slr_dat <- read_csv(
  here("data", "Simple_Linear_Regression.csv")
) %>%
  clean_names()

# Inspect the data
glimpse(slr_dat)
summary(slr_dat)


# Visualize the relationship
ggplot(
  slr_dat,
  aes(x = density, y = lbs_suc_a)
) +
  geom_point() +
  geom_smooth(
    method = "lm",
    se = TRUE
  ) +
  theme_classic() +
  labs(
    title = "Sugar Yield vs. Volunteer Corn Density",
    x = "Density (plants per ft of row)",
    y = "Sugar yield (lbs/A)"
  )


# QUESTION:
# Based on the figure, do you expect the slope to be positive or negative?


# Fit the model
slr_model <- lm(
  lbs_suc_a ~ density,
  data = slr_dat
)

summary(slr_model)


# QUESTION:
# Identify the following from summary(slr_model):
#
# 1. Estimated intercept:
# 2. Estimated slope:
# 3. p-value for density:
# 4. R-squared:
# 5. Residual degrees of freedom:


# YOUR INTERPRETATION:
# Write one sentence interpreting the slope in the units of the data.



# ------------------------------------------------------------------------------
# Model diagnostics
# ------------------------------------------------------------------------------

par(mfrow = c(2, 2))
plot(slr_model)
par(mfrow = c(1, 1))


# QUESTION:
# Examine the diagnostic plots.
#
# 1. Do you see evidence of curvature?
# 2. Does residual spread change substantially across fitted values?
# 3. Do the Q-Q plot residuals appear reasonably normal?
# 4. Are any observations potentially influential?


# ==============================================================================
# 3. A TWO-LEVEL CATEGORICAL PREDICTOR
# ==============================================================================

# A two-level categorical predictor can also be fitted with lm().
# This connects the linear-model framework to a two-sample comparison.

ttest_dat <- read_csv(
  here("data", "T-Test_Example.csv")
) %>%
  clean_names()

glimpse(ttest_dat)


# Visualize the response by group
ggplot(
  ttest_dat,
  aes(x = mulch_type, y = yield)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(
    width = 0.08,
    height = 0
  ) +
  theme_classic() +
  labs(
    title = "Yield by Mulch Type",
    x = "Mulch type",
    y = "Yield (lbs/A)"
  )


# Fit the model
ttest_lm <- lm(
  yield ~ mulch_type,
  data = ttest_dat
)

summary(ttest_lm)


# Compare with the equal-variance two-sample t-test
t.test(
  yield ~ mulch_type,
  data = ttest_dat,
  var.equal = TRUE
)


# QUESTION:
# Compare the t statistic and p-value from summary(ttest_lm)
# with those from t.test().
#
# What do you notice?


# QUESTION:
# In the lm() output:
#
# 1. What group is represented by the intercept?
# 2. What does the mulch-type coefficient estimate?


# ==============================================================================
# 4. ONE-WAY ANOVA AS A LINEAR MODEL
# ==============================================================================

anova_dat <- read_csv(
  here("data", "FlowerColourVisits.csv")
) %>%
  clean_names()

glimpse(anova_dat)


# Visualize the response by flower colour
ggplot(
  anova_dat,
  aes(x = colour, y = number_of_visits)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(
    width = 0.08,
    height = 0
  ) +
  theme_classic() +
  labs(
    title = "Flower Visits by Colour",
    x = "Flower colour",
    y = "Number of visits"
  )


# QUESTION:
# State the null and alternative hypotheses for the omnibus ANOVA F-test.
#
# H0:
#
# HA:


# Fit the one-way ANOVA as a linear model
anova_model <- lm(
  number_of_visits ~ colour,
  data = anova_dat
)

summary(anova_model)


# Obtain the omnibus F-test
car::Anova(
  anova_model,
  type = 2
)


# QUESTION:
# What does the omnibus F-test tell us?
#
# Does it tell us WHICH groups differ?


# QUESTION:
# Compare summary(anova_model) with car::Anova(anova_model, type = 2).
#
# What is the F-test testing?
#
# What are the individual coefficient t-tests testing?


# ------------------------------------------------------------------------------
# Diagnostics
# ------------------------------------------------------------------------------

par(mfrow = c(2, 2))
plot(anova_model)
par(mfrow = c(1, 1))


# YOUR INTERPRETATION:
# Briefly describe whether any diagnostic issues are apparent.



# ==============================================================================
# 5. TWO-WAY / FACTORIAL ANOVA
# ==============================================================================

two_way_dat <- read_csv(
  here("data", "growth.csv")
) %>%
  clean_names()

glimpse(two_way_dat)


# Examine the factor levels
table(two_way_dat$supplement)
table(two_way_dat$diet)


# Visualize the two factors together
ggplot(
  two_way_dat,
  aes(
    x = diet,
    y = gain,
    fill = supplement
  )
) +
  geom_boxplot(
    position = position_dodge(width = 0.8)
  ) +
  theme_classic() +
  labs(
    title = "Gain by Diet and Supplement",
    x = "Diet",
    y = "Gain"
  )


# QUESTION:
# Identify:
#
# Response variable:
# Factor A:
# Factor B:


# ------------------------------------------------------------------------------
# Additive model
# ------------------------------------------------------------------------------

two_way_additive <- lm(
  gain ~ supplement + diet,
  data = two_way_dat
)

summary(two_way_additive)

car::Anova(
  two_way_additive,
  type = 2
)


# QUESTION:
# In the additive model:
#
# 1. Is there evidence of a supplement effect?
# 2. Is there evidence of a diet effect?
# 3. What assumption are we making about the relationship between
#    supplement and diet when no interaction is included?


# ------------------------------------------------------------------------------
# Interaction model
# ------------------------------------------------------------------------------

two_way_interaction <- lm(
  gain ~ supplement * diet,
  data = two_way_dat
)

summary(two_way_interaction)

car::Anova(
  two_way_interaction,
  type = 3
)


# QUESTION:
# What does the supplement:diet interaction test?
#
# H0:
#
# HA:


# QUESTION:
# Is there evidence that the effect of supplement depends on diet?


# Visualize group means with an interaction plot
interaction_means <- two_way_dat %>%
  group_by(diet, supplement) %>%
  summarise(
    mean_gain = mean(gain, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(
  interaction_means,
  aes(
    x = diet,
    y = mean_gain,
    group = supplement,
    linetype = supplement
  )
) +
  geom_line() +
  geom_point(size = 2) +
  theme_classic() +
  labs(
    title = "Interaction Plot: Diet × Supplement",
    x = "Diet",
    y = "Mean gain",
    linetype = "Supplement"
  )


# QUESTION:
# Are the lines approximately parallel?
#
# How does the graph relate to the statistical interaction test?


# ------------------------------------------------------------------------------
# Diagnostics
# ------------------------------------------------------------------------------

par(mfrow = c(2, 2))
plot(two_way_interaction)
par(mfrow = c(1, 1))


# YOUR INTERPRETATION:
# Briefly describe whether any diagnostic issues are apparent.



# ==============================================================================
# 6. THE COMMON LINEAR-MODEL FRAMEWORK
# ==============================================================================

# Compare the formulas used today:

formula(slr_model)
formula(ttest_lm)
formula(anova_model)
formula(two_way_additive)
formula(two_way_interaction)


# QUESTION:
# Match each model to the structure of its predictors:
#
# slr_model:
#
# ttest_lm:
#
# anova_model:
#
# two_way_additive:
#
# two_way_interaction:


# Main takeaway:
#
# The response remains quantitative, while the type and number of predictors
# determine how we commonly describe the linear model.


# ==============================================================================
# 7. PRACTICE
# ==============================================================================

# ------------------------------------------------------------------------------
# Practice 1: Two-group comparison
# ------------------------------------------------------------------------------

# gardens.csv contains ozone measurements from two gardens.
#
# Research question:
# Is mean ozone different between Garden A and Garden B?

# YOUR CODE:
# 1. Import gardens.csv.
# 2. Inspect the variables.
# 3. Create an appropriate figure.
# 4. Fit the comparison using lm().
# 5. Interpret the coefficient table.
# 6. Check model diagnostics.

gardens <- read_csv(
  here("data", "gardens.csv")
) %>%
  clean_names()

glimpse(gardens)

# Check the variable names before running the model and update these names
# if the dataset uses different capitalization/spelling.
ggplot(
  gardens,
  aes(x = garden, y = ozone)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.08) +
  theme_classic()

gardens_model <- lm(
  ozone ~ garden,
  data = gardens
)

summary(gardens_model)

par(mfrow = c(2, 2))
plot(gardens_model)
par(mfrow = c(1, 1))


# ------------------------------------------------------------------------------
# Practice 2: Two-way ANOVA
# ------------------------------------------------------------------------------

# ladybirds.csv contains ladybird beetle counts classified by colour morph
# and habitat.
#
# Research question:
# Does the response differ by colour morph, habitat, or their interaction?

# YOUR CODE:
# 1. Import ladybirds.csv.
# 2. Inspect the variables.
# 3. Create a figure showing both categorical predictors.
# 4. Fit an additive model.
# 5. Fit a model containing the interaction.
# 6. Test and interpret the interaction.
# 7. Check model diagnostics.

ladybirds <- read_csv(
  here("data", "ladybirds.csv")
) %>%
  clean_names()

glimpse(ladybirds)

# Inspect names and adapt the response variable if necessary.
# If the file contains aggregated counts in a variable named `number`,
# the following model uses those counts as the quantitative response.

ggplot(
  ladybirds,
  aes(
    x = habitat,
    y = number,
    fill = colour
  )
) +
  geom_boxplot(
    position = position_dodge(width = 0.8)
  ) +
  theme_classic()

ladybird_additive <- lm(
  number ~ colour + habitat,
  data = ladybirds
)

ladybird_interaction <- lm(
  number ~ colour * habitat,
  data = ladybirds
)

car::Anova(
  ladybird_additive,
  type = 2
)

car::Anova(
  ladybird_interaction,
  type = 3
)

par(mfrow = c(2, 2))
plot(ladybird_interaction)
par(mfrow = c(1, 1))


# ==============================================================================
# END OF DISCUSSION 03
# ==============================================================================

# Before finishing:
#
# 1. Save this script.
# 2. Stage your changes.
# 3. Commit with a descriptive message.
# 4. Push your work to your private GitHub repository.