# ============================================================
# ENTO 8030 — Discussion 04
# Planned Contrasts, Multiple Comparisons, and emmeans
# Fall 2026
# ============================================================

# LEARNING GOALS
# By the end of this discussion, you should be able to:
# 1. Explain the difference among an omnibus F-test, a planned contrast,
#    and a post-hoc multiple-comparison procedure.
# 2. Use emmeans() to obtain model-based means.
# 3. Translate a biological hypothesis into contrast weights.
# 4. Use pairs() with an appropriate multiplicity adjustment.
# 5. Use Dunnett comparisons when treatments are compared with a control.
# 6. Interpret estimates, confidence intervals, adjusted p-values, and CLDs.
#
# IMPORTANT:
# Choose comparisons because they answer a biological question.
# Do not choose a method only because it produces a smaller p-value.


# ------------------------------------------------------------
# 1. PACKAGES
# ------------------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(car)
library(emmeans)
library(multcomp)


# ------------------------------------------------------------
# 2. LOAD AND INSPECT THE DATA
# ------------------------------------------------------------

# This discussion uses the biomass dataset from the course repository.
biomass <- read_csv(here("data", "biomass.csv")) %>%
  clean_names() %>%
  mutate(
    fert = factor(fert),
    light = factor(light)
  )

glimpse(biomass)
levels(biomass$fert)
levels(biomass$light)

# Visualize the raw observations before fitting the model.
ggplot(biomass, aes(x = fert, y = biomass_m2, color = light)) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.08,
                                    dodge.width = 0.50),
    alpha = 0.65
  ) +
  stat_summary(
    aes(group = light),
    fun = mean,
    geom = "point",
    position = position_dodge(width = 0.50),
    size = 3
  ) +
  theme_classic() +
  labs(
    x = "Fertilizer treatment",
    y = expression("Biomass (g/m"^2*")"),
    color = "Light treatment"
  )


# ------------------------------------------------------------
# 3. FIT THE MODEL
# ------------------------------------------------------------

model_biomass <- lm(biomass_m2 ~ fert * light, data = biomass)

# Examine the model and omnibus tests.
summary(model_biomass)
car::Anova(model_biomass, type = 2)
car::Anova(model_biomass, type =3)

# Type II tests each main effect after accounting for the other main effects, but not after accounting for interactions that contain the effect. The interaction itself is tested after accounting for the main effects.

# Type III tests each term after accounting for all other terms in the model, including interactions that contain that term.

# The main difference is how they test the lower-order terms when interaction terms are present.
# When an interaction is important, a simple "main effect" is often not the most biologically informative question anyway. We usually interpret the interaction first and then exaimine the relevant conditional effects.

# MODEL CHECK
par(mfrow = c(2, 2))
plot(model_biomass)
par(mfrow = c(1, 1))

# ACTIVE LEARNING 1 ------------------------------------------
# Before running any pairwise comparisons:
#
# A. Write the biological meaning of the fert:light interaction.
#
# B. If the interaction is important, should we immediately interpret
#    the overall main effect of fertilizer by itself? Why or why not?
#
# C. What comparison(s) would answer a useful biological question?


# ------------------------------------------------------------
# 4. ESTIMATED MARGINAL MEANS
# ------------------------------------------------------------

# Estimated marginal means are predictions from the fitted model.
emm_cells <- emmeans(model_biomass, ~ fert * light)

emm_cells
confint(emm_cells)

# These are model-based estimates. They are not a replacement for
# displaying the raw observations.


# ------------------------------------------------------------
# 5. SIMPLE EFFECTS: COMPARISONS WITHIN AN INTERACTION
# ------------------------------------------------------------

# Compare fertilizer treatments separately within each light treatment.
emm_fert_within_light <- emmeans(model_biomass, ~ fert | light)

pairs(emm_fert_within_light, adjust = "tukey")

# Compare light treatments separately within each fertilizer treatment.
emm_light_within_fert <- emmeans(model_biomass, ~ light | fert)

pairs(emm_light_within_fert, adjust = "tukey")

# ACTIVE LEARNING 2 ------------------------------------------
# Compare the two outputs above.
#
# 1. What question does each analysis answer?
# 2. Which set of comparisons is more relevant to the biological question?
# 3. For one contrast, interpret:
#       estimate =
#       95% CI =
#       adjusted p-value =
# 4. Write one manuscript-style sentence.


# ------------------------------------------------------------
# 6. PLANNED CONTRASTS
# ------------------------------------------------------------

# A contrast is a weighted comparison of model-based means.
#
# Example with four treatment means:
#
#   Control    Low    Medium    High
#      -1      1/3      1/3     1/3
#
# asks:
# "Does the control differ from the average of the three treatments?"
#
# Contrast weights must sum to zero.
# NOTE: weights summing to zero makes a valid contrast.
# It does NOT automatically make a set of contrasts orthogonal.

# First inspect the order of the estimated means:
emm_cells

# ACTIVE LEARNING 3 ------------------------------------------
# Write a biological hypothesis involving the fert × light treatment cells.
# Then write the contrast weights that represent that hypothesis.
#
# H0 in words:
#
# H1 in words:
#
# Contrast weights:
#
# Check:
# sum(c(...))


# Example syntax after you determine the correct order and weights:
#
# planned <- contrast(
#   emm_cells,
#   method = list(
#     "Biological comparison" = c(...)
#   ),
#   adjust = "none"
# )
#
# summary(planned, infer = TRUE)

# QUESTION:
# Why might adjust = "none" be defensible for a small number of genuinely
# prespecified comparisons, but inappropriate after looking through many
# possible comparisons?


# ------------------------------------------------------------
# 7. MULTIPLE COMPARISONS AND TYPE I ERROR
# ------------------------------------------------------------

# If a factor has k levels, the number of all pairwise comparisons is:
#
# k(k - 1) / 2
#
# ACTIVE LEARNING 4 ------------------------------------------
# Calculate the number of pairwise comparisons for:
#
# k = 3:
#
# k = 5:
#
# k = 10:
#
# Why does the number of comparisons matter for Type I error?


# Tukey adjustment: designed for a family of all pairwise comparisons.
pairs(emm_cells, adjust = "tukey")

# Holm adjustment: general familywise-error-rate adjustment.
pairs(emm_cells, adjust = "holm")

# Bonferroni: simple and often conservative.
pairs(emm_cells, adjust = "bonferroni")

# IMPORTANT:
# The estimated marginal means themselves do not change because the
# multiplicity method changes. The inferential adjustment affects the
# comparison p-values and/or confidence intervals.


# ------------------------------------------------------------
# 8. DUNNETT COMPARISONS: TREATMENTS VS. A CONTROL
# ------------------------------------------------------------

# Dunnett's procedure is useful when the scientific question is:
# "Which treatments differ from the control?"
#
# First identify the order of factor levels:
levels(biomass$fert)

# If the first level is the desired control:
emm_fert <- emmeans(model_biomass, ~ fert)

contrast(
  emm_fert,
  method = "trt.vs.ctrl",
  ref = 1,
  adjust = "dunnettx"
) %>%
  summary(infer = TRUE)

# ACTIVE LEARNING 5 ------------------------------------------
# Suppose the experiment has one untreated control and four insecticides.
#
# Would you choose:
#   A. all pairwise Tukey comparisons
#   B. Dunnett comparisons to the control
#
# Explain your choice based on the research question rather than which
# procedure is more likely to produce p < 0.05.


# ------------------------------------------------------------
# 9. COMPACT LETTER DISPLAYS
# ------------------------------------------------------------

# CLDs can be convenient summaries of many pairwise comparisons.
# However, do not let the letters replace estimates and confidence intervals.

emm_cld <- emmeans(model_biomass, ~ fert * light) %>%
  multcomp::cld(
    adjust = "tukey",
    Letters = letters,
    sort = FALSE
  ) %>%
  as_tibble() %>%
  mutate(.group = stringr::str_trim(.group))

emm_cld

# Interpretation:
# Groups that do not share a letter have evidence of a difference under
# the selected multiple-comparison procedure.
#
# Groups that share a letter should NOT be described as "the same."
# The analysis simply did not detect a difference at the chosen threshold.


# ------------------------------------------------------------
# 10. FINAL SYNTHESIS
# ------------------------------------------------------------

# For the biomass experiment, write a short results paragraph that includes:
#
# 1. The biological interpretation of the interaction.
# 2. One model-based contrast estimate.
# 3. Its 95% confidence interval.
# 4. The multiplicity method used, if applicable.
# 5. The biological meaning of the result.
#
# Avoid reporting only "significant" or "not significant."


# ------------------------------------------------------------
# END-OF-DISCUSSION CHECK
# ------------------------------------------------------------

# You should now be able to answer:
#
# 1. What does an omnibus F-test tell you?
# 2. What is a planned contrast?
# 3. What is the difference between planned and post-hoc comparisons?
# 4. Why does performing many tests increase the chance of false positives?
# 5. When is Tukey appropriate?
# 6. When is Dunnett appropriate?
# 7. What does emmeans() estimate?
# 8. Why should effect estimates and confidence intervals accompany p-values?
# 9. Why does "shares a CLD letter" not mean "the groups are equal"?
