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

install.packages("car")
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
## negative

# Fit the model
slr_model <- lm(
  lbs_suc_a ~ density,
  data = slr_dat
)

summary(slr_model)


# QUESTION:
# Identify the following from summary(slr_model):
#
# 1. Estimated intercept: 8677.6
# 2. Estimated slope: -20644.7
# 3. p-value for density: 0.00139
# 4. R-squared: 0.3498
# 5. Residual degrees of freedom: 22


# YOUR INTERPRETATION:
# Write one sentence interpreting the slope in the units of the data.
## For every one unit change in density, there should be a 20,644.7 reduction 
## in yield. The p-value of 0.00139 rejects the null hypothesis that there was
## no relationship. t(22)= 3.657; p=0.00139 

## More representative of the data: 
## For a tenth of a unit of change in density, there should be a 2,064 reduction in yield in lbs per acre. 


# ------------------------------------------------------------------------------
# Model diagnostics
# ------------------------------------------------------------------------------

## changes the plot window to show all plots in one:
par(mfrow = c(2, 2))
# Plot:
plot(slr_model)

#restore original plot settings:
par(mfrow = c(1, 1))


# QUESTION:
# Examine the diagnostic plots.
#
# 1. Do you see evidence of curvature? No
# 2. Does residual spread change substantially across fitted values? No (no 
## trumpeting effect)
# 3. Do the Q-Q plot residuals appear reasonably normal? yes
# 4. Are any observations potentially influential? no

## The diagnostic plots show that we did not find evidence against the model we
## fit.
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
## The values are the same, but the way they are reported differ for the mean vs mean average. Same math, different ways to read what comes from the summary output.

# QUESTION:
# In the lm() output:
#
# 1. What group is represented by the intercept? dark
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
# H0: There is no difference in mean number of visits between flower color/ mean nummber of visits are all equal
#
# HA: At least one of the flower colors has a different mean number of visits


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
## tells us if there are any differences among the mean values of all levels
# We failed to reject the null hypothesis that there are no differences in the mean number of visits among the colors of flower (F(3,46)= 0.606, p-value = 0.6145)

# Does it tell us WHICH groups differ?
## no


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
## The equal variance assumption is satisfied, the relationship between X and Y/ functional form looks to be assumed, there was no extreme or influential values observed as indicated by the Cook's distance, and finally there is potentially an issue with the Q-Q plot (deviating tails) indicating that the residuals may not be normally distributed.


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
# Response variable: weight gain
# Factor A: Diet (3 levels)
# Factor B: Supplement (4 levels)


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
# 1. Is there evidence of a supplement effect? yes
# 2. Is there evidence of a diet effect? yes
# 3. What assumption are we making about the relationship between
#    supplement and diet when no interaction is included? We are assuming that the effect of supplement on weight gain is the same across/ does not depend on all levels of diet.


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
# H0: The effect of supplement on weight gain is not dependent on diet and vice versa
#
# HA: Diet effects weight gain but is dependent on the level of supplement, or vice versa


# QUESTION:
# Is there evidence that the effect of supplement depends on diet? No


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
# yes 
# How does the graph relate to the statistical interaction test?
# If we found evidence of a significant interaction, we would expect to see one of the lines cross. 


# ------------------------------------------------------------------------------
# Diagnostics
# ------------------------------------------------------------------------------

par(mfrow = c(2, 2))
plot(two_way_interaction)
par(mfrow = c(1, 1))


# YOUR INTERPRETATION:
# Briefly describe whether any diagnostic issues are apparent.
## Moderate concern with the Q-Q residual plot (deviated tails)-- could potentially try a transformation of the weight gain data to see if it improves the model assumptions


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
# slr_model: lbs_suc_a ~ density 
# continuous predictor variable

# ttest_lm: yield ~ mulch_type
# 2 categorical variables

# anova_model:number_of_visits ~ colour
# more than 2 levels of one categorical variable

# two_way_additive: gain ~ supplement + diet
# multiple categorical variables -- only considering the main effects

# two_way_interaction: gain ~ supplement * diet
# multiple categorical variables -- considers main effects and the interaction effect 

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


# QUESTION:
# Is mean ozone different between Garden A and Garden B?

## Yes. 
## There is sufficient evidence to reject the null hypothesis that there was no difference in the mean ozone between Garden A and Garden B. t(18)= 3.873; p=0.00111 

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


# QUESTION:
# Does the response differ by colour morph, habitat, or their interaction?

## Yes-- the response differs by habitat and the interaction between colour and habitat.  
## There is sufficient evidence to reject the null hypothesis that there was no difference in the response number of visits by colour, habitat, or their interaction-- there was an observed difference between habitat and the colour and habitat interaction. 
## Colour difference: (F(1,16)= 3.8503, p-value = 0.067372)
## Habitat difference: (F(1,16)= 30.9091, p-value = <0.001)
## colour:habitat interaction: (F(1,16)= 10.4813, p-value = <0.01)
## We are confident in this assessment because the diagnostic tests showed that the assumptions were well enough met.
## The equal variance assumption is satisfied, the relationship between X and Y/ functional form looks to be assumed, there was no extreme or influential values observed as indicated by the Cook's distance, and finally the Q-Q plot showed that the residuals are satisfying the normal distribution assumption.


# ==============================================================================
# END OF DISCUSSION 03
# ==============================================================================

# Before finishing:
#
# 1. Save this script.
# 2. Stage your changes.
# 3. Commit with a descriptive message.
# 4. Push your work to your private GitHub repository.