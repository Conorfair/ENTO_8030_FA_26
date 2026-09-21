# ============================================================
# ENTO 8030 — Discussion 05
# Experimental Design and Random Effects
# STUDENT VERSION
# ============================================================

# LEARNING GOALS ---------------------------------------------------------
# By the end of this discussion, you should be able to:
# 1. Identify the experimental unit and true treatment replication.
# 2. Distinguish CRD, RCBD, factorial, and split-plot structures.
# 3. Randomize treatments reproducibly in R.
# 4. Explain why observations from the same block/group may be dependent.
# 5. Fit and interpret a random-intercept linear mixed model.
# 6. Translate a split-plot randomization structure into random effects.
# 7. Use estimated marginal means to summarize fixed treatment effects.

# PACKAGES ---------------------------------------------------------------
# Install these once if needed:
# install.packages(c("tidyverse", "lme4", "lmerTest", "emmeans", "performance"))

library(tidyverse)
library(lme4)
library(lmerTest)
library(emmeans)
library(performance)

set.seed(8030)

# ============================================================
# 1. EXPERIMENTAL UNIT, REPLICATION, AND SUBSAMPLING
# ============================================================

# Scenario:
# Four insecticide treatments are independently assigned to 24 field plots.
# Five pitfall traps are placed within every plot.
#
# ACTIVE LEARNING 1 ------------------------------------------
# 1. What is the experimental unit?
#
# 2. What is the observational/sampling unit?
#
# 3. How many independent treatment replicates are there?
#
# 4. If we add five more traps to every plot, does treatment replication increase?
#
# Key rule:
# The experimental unit is the smallest unit that can be independently
# assigned to a treatment.

# ============================================================
# 2. COMPLETELY RANDOMIZED DESIGN (CRD)
# ============================================================

# Suppose 3 diets will be assigned to 18 insect cages.
# In a CRD, treatments are randomized across all experimental units.

crd <- tibble(
  cage = 1:18,
  row = rep(1:3, each = 6),
  column = rep(1:6, times = 3)
) %>%
  mutate(
    diet = sample(rep(c("Control", "Diet_A", "Diet_B"), each = 6))
  )

crd
count(crd, diet)

ggplot(crd, aes(x = column, y = row, fill = diet)) +
  geom_tile(color = "black") +
  geom_text(aes(label = diet), size = 3) +
  scale_y_reverse(breaks = 1:3) +
  coord_equal() +
  theme_classic() +
  labs(
    x = "Cage position",
    y = "Row",
    fill = "Diet",
    title = "Completely Randomized Design"
  )

# ACTIVE LEARNING 2 ------------------------------------------
# Imagine there is a strong temperature gradient from Row 1 to Row 3.
#
# 1. Is the randomization above still valid?
#
# 2. Could we design the experiment to explicitly account for this
#    known nuisance source of variation?
#
# 3. What design would you recommend?

# ============================================================
# 3. RANDOMIZED COMPLETE BLOCK DESIGN (RCBD)
# ============================================================

# Now suppose there are 6 greenhouse benches (blocks).
# Each bench contains all 4 treatments exactly once.
# Treatments are randomized independently WITHIN each bench.

blocks <- paste0("Block_", 1:6)
treatments <- c("Control", "Low", "Medium", "High")

rcbd <- crossing(
  block = blocks,
  position = 1:4
) %>%
  group_by(block) %>%
  mutate(treatment = sample(treatments)) %>%
  ungroup()

rcbd
count(rcbd, block, treatment)

ggplot(rcbd, aes(x = position, y = block, fill = treatment)) +
  geom_tile(color = "black") +
  geom_text(aes(label = treatment), size = 3) +
  theme_classic() +
  labs(
    x = "Position within block",
    y = "Block",
    fill = "Treatment",
    title = "Randomized Complete Block Design"
  )

# ACTIVE LEARNING 3 ------------------------------------------
# 1. What is the experimental unit?
#
# 2. How many independent replicates does each treatment have?
#
# 3. Is block a treatment of biological interest or a nuisance source
#    of variation?
#
# 4. Why do we randomize treatment separately within each block?

# ============================================================
# 4. SIMULATE A RESPONSE FROM THE RCBD
# ============================================================

# We will now generate a response for the randomized design above.
# Imagine the response is insect biomass (mg) collected from each plot.
#
# Treatment effects are fixed quantities we want to estimate.
# Blocks differ in baseline biomass because of environmental variation.

block_effects <- tibble(
  block = blocks,
  block_effect = rnorm(length(blocks), mean = 0, sd = 8)
)

rcbd_data <- rcbd %>%
  left_join(block_effects, by = "block") %>%
  mutate(
    treatment_effect = case_when(
      treatment == "Control" ~ 0,
      treatment == "Low"     ~ 5,
      treatment == "Medium"  ~ 12,
      treatment == "High"    ~ 18
    ),
    biomass = 50 + treatment_effect + block_effect + rnorm(n(), 0, 5),
    treatment = factor(treatment, levels = c("Control", "Low", "Medium", "High")),
    block = factor(block)
  )

rcbd_data

# Visualize observations by treatment and block.
ggplot(rcbd_data, aes(x = treatment, y = biomass, group = block, color = block)) +
  geom_point(size = 3) +
  geom_line(alpha = 0.6) +
  theme_classic() +
  labs(
    x = "Treatment",
    y = "Insect biomass (mg)",
    color = "Block"
  )

# ACTIVE LEARNING 4 ------------------------------------------
# Look at the figure before fitting a model.
#
# 1. Do blocks appear to differ in baseline biomass?
#
# 2. Why might observations from the same block be more similar than
#    observations from different blocks?
#
# 3. What could be lost if we completely ignore block in the analysis?

# ============================================================
# 5. LM VS. RANDOM-INTERCEPT MIXED MODEL
# ============================================================

# Model that ignores the block structure:
mod_lm <- lm(biomass ~ treatment, data = rcbd_data)

# Mixed model that represents variation among blocks:
mod_lmm <- lmer(
  biomass ~ treatment + (1 | block),
  data = rcbd_data,
  REML = TRUE
)

summary(mod_lm)
summary(mod_lmm)

# IMPORTANT:
# We are not adding block merely because it improves a fit statistic.
# The random effect follows from the experimental design: observations
# were organized into blocks, and treatment was randomized within blocks.

# Examine estimated variance components.
VarCorr(mod_lmm)

# Intraclass correlation coefficient (ICC):
# What proportion of the residual variation is associated with differences
# among blocks?
performance::icc(mod_lmm)

# ACTIVE LEARNING 5 ------------------------------------------
# Compare summary(mod_lm) and summary(mod_lmm).
#
# 1. Are the treatment estimates similar?
#
# 2. Do the standard errors change?
#
# 3. What does the block variance represent biologically?
#
# 4. Why is (1 | block) called a RANDOM INTERCEPT?

# ============================================================
# 6. FIXED EFFECTS AND RANDOM EFFECTS
# ============================================================

# In this experiment:
#
# treatment = FIXED EFFECT
#   We care about these specific treatment levels and want to estimate
#   differences among them.
#
# block = RANDOM EFFECT
#   Blocks represent a grouping/nuisance source of variation. We are
#   interested primarily in the variance among blocks rather than in
#   reporting a separate biological treatment effect for each block.
#
# Random effects should be motivated by the design and sampling structure,
# not selected only because they improve AIC or produce a desired p-value.

# Extract estimated random deviations for blocks.
ranef(mod_lmm)

# ============================================================
# 7. ESTIMATED MARGINAL MEANS FROM THE MIXED MODEL
# ============================================================

emm_treatment <- emmeans(mod_lmm, ~ treatment)
emm_treatment

# All pairwise treatment comparisons.
pairs(emm_treatment, adjust = "tukey")

# Plot model-based treatment estimates.
plot(emm_treatment, comparisons = TRUE)

# ACTIVE LEARNING 6 ------------------------------------------
# 1. What do the EMMs represent here?
#
# 2. Why are treatment comparisons based on the fitted mixed model rather
#    than simply ignoring the block structure?
#
# 3. Write one manuscript-style sentence describing one treatment contrast.

# ============================================================
# 8. FROM FACTORIAL RCBD TO SPLIT-PLOT
# ============================================================

# Treatment structure and randomization structure are different ideas.
#
# A factorial treatment structure tells us WHICH treatment combinations
# are studied.
# A split-plot design tells us that factors are randomized at DIFFERENT
# experimental-unit scales.
#
# Scenario:
# - 6 blocks
# - irrigation has 2 levels and is applied to WHOLE PLOTS
# - insecticide has 3 levels and is randomized to SUBPLOTS within each
#   irrigation whole plot

set.seed(8030)

splitplot <- crossing(
  block = factor(paste0("Block_", 1:6)),
  whole_plot = 1:2,
  subplot = 1:3
) %>%
  group_by(block) %>%
  mutate(
    irrigation = rep(sample(c("Low", "High")), each = 3)
  ) %>%
  group_by(block, whole_plot) %>%
  mutate(
    insecticide = sample(c("Control", "A", "B"))
  ) %>%
  ungroup() %>%
  mutate(
    irrigation = factor(irrigation, levels = c("Low", "High")),
    insecticide = factor(insecticide, levels = c("Control", "A", "B")),
    whole_plot_id = interaction(block, whole_plot, drop = TRUE)
  )

splitplot

# ACTIVE LEARNING 7 ------------------------------------------
# Before fitting any model:
#
# 1. What is the experimental unit for irrigation?
#
# 2. What is the experimental unit for insecticide?
#
# 3. How many independently randomized irrigation units are there?
#
# 4. How many subplot observations are there?
#
# 5. Why would treating all 36 observations as independent irrigation
#    replicates be pseudoreplication?

# ============================================================
# 9. TRANSLATE THE SPLIT-PLOT DESIGN INTO A MODEL
# ============================================================

# Generate a continuous response only so we can focus on the design.
block_re <- rnorm(6, 0, 8)
names(block_re) <- levels(splitplot$block)

whole_re <- rnorm(nlevels(splitplot$whole_plot_id), 0, 5)
names(whole_re) <- levels(splitplot$whole_plot_id)

splitplot_data <- splitplot %>%
  mutate(
    irrigation_effect = if_else(irrigation == "High", 8, 0),
    insecticide_effect = case_when(
      insecticide == "Control" ~ 0,
      insecticide == "A" ~ 6,
      insecticide == "B" ~ 12
    ),
    interaction_effect = if_else(irrigation == "High" & insecticide == "B", 15, 0),
    biomass = 60 + irrigation_effect + insecticide_effect + interaction_effect +
      block_re[as.character(block)] +
      whole_re[as.character(whole_plot_id)] +
      rnorm(n(), 0, 4)
  )

# The random-effects structure mirrors the randomization structure:
# (1 | block)                 = variation among blocks
# (1 | whole_plot_id)         = variation among whole plots within blocks

mod_split <- lmer(
  biomass ~ irrigation * insecticide +
    (1 | block) +
    (1 | whole_plot_id),
  data = splitplot_data,
  REML = TRUE
)

summary(mod_split)
VarCorr(mod_split)

# Conditional EMMs are useful because the model contains an interaction.
emm_split <- emmeans(mod_split, ~ insecticide | irrigation)
emm_split
pairs(emm_split, adjust = "tukey")

# ACTIVE LEARNING 8 ------------------------------------------
# 1. Which fixed effects correspond to the treatment structure?
#
# 2. Which random effects correspond to the design/randomization structure?
#
# 3. Why does the whole-plot random effect matter for inference about
#    irrigation?
#
# 4. If the interaction is biologically important, why should we examine
#    insecticide effects separately within irrigation levels?

# ============================================================
# 10. TAKE-HOME WORKFLOW
# ============================================================

# When you encounter a new experiment, ask these questions BEFORE fitting
# the model:
#
# 1. What are the treatment factors?
# 2. What is the experimental unit for each treatment factor?
# 3. Where and how was treatment randomized?
# 4. What constitutes true treatment replication?
# 5. Which observations share a block, plot, cage, subject, site, etc.?
# 6. Which sources of variation must the model represent?
# 7. Only then: what fixed and random effects belong in the model?
#
# Experimental design -> dependence structure -> statistical model
