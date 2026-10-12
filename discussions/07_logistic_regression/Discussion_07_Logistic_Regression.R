# ============================================================
# ENTO 8030 — Discussion 07: Logistic Regression (Binomial Family)
# STUDENT VERSION
# SHOW ONE → DO ONE → TEACH ONE
# ============================================================
# Based on: Titanic, lizards, and OME examples.
# Lizard and OME CSVs are the user-provided datasets from Binomial Family.Rmd.
# Open the course .Rproj at the repository root; data/ is at that root.
# Install once: install.packages(c("dplyr", "ggplot2", "titanic", "emmeans", "DHARMa", "performance", "glmmTMB"))

library(dplyr)
library(ggplot2)
library(emmeans)
library(DHARMa)
library(performance)
library(glmmTMB)

# Data paths are relative to the course R Project ROOT, not this script.
stopifnot(file.exists("data/lizards.csv"), file.exists("data/OME.csv"))
set.seed(8030) # Reproducible simulation-based diagnostics

# The model: Y ~ Bernoulli(p), or K ~ Binomial(n, p).
# logit(p) = log(p / (1-p)) = beta0 + beta1 * X + ...
# inverse logit converts a linear predictor to probability.
inv_logit <- plogis

# ============================================================
# 1. BINARY DATA — TITANIC PASSENGER SURVIVAL
# ============================================================
# SHOW: Survival is a 0/1 Bernoulli outcome. Passenger records are
# observational units; this is not a randomized experiment.
# The titanic package supplies the original teaching dataset.

titanic_dat <- titanic::titanic_train %>%
  transmute(Survived = as.integer(Survived),
            Sex = factor(Sex),
            Pclass = factor(Pclass),
            Age = Age) %>%
  filter(!is.na(Age))

print(titanic_dat %>% group_by(Sex) %>%
        summarise(n = n(), survival = mean(Survived), .groups = "drop"))
mod_titanic <- glm(Survived ~ Sex, family = binomial(link = "logit"),
                   data = titanic_dat)
summary(mod_titanic)
exp(coef(mod_titanic)) # intercept = baseline odds; slopes = odds ratios
predict(mod_titanic, newdata = data.frame(Sex = levels(titanic_dat$Sex)),
        type = "response")

# SHOW: expand.grid() constructs ALL combinations of supplied predictor values.
# Each row represents one scenario, not an additional observed passenger.
example_grid <- expand.grid(Sex = levels(titanic_dat$Sex),
                            Pclass = levels(titanic_dat$Pclass))
print(example_grid)
# A prediction grid must contain EVERY predictor in the fitted model.
# DO: Add Pclass as a second predictor and fit a new logistic model.
# Compare the model-based survival probabilities by class and sex.

# YOUR CODE:



# TEACH: Which outcome is defined as "success"? What does the
# reference level mean? Is exp(beta) a probability or an odds ratio?
# Why would causal claims about passenger class be inappropriate?

# ============================================================
# 2. GROUPED BINOMIAL — LIZARD SPECIES COUNTS
# ============================================================
# SHOW: grahami = successes, opalinus = failures within a sampled cell.
# Confirm the project working directory with getwd(); do not use setwd().
lizards_raw <- read.csv("data/lizards.csv")
# One cell has zero lizards of either species; no binomial trials occurred.
# Preserve the raw file and exclude only that row from the analysis.
lizards <- lizards_raw %>%
  mutate(across(c(Site, Diameter, Height, Time), factor),
         total = grahami + opalinus) %>%
  filter(total > 0) %>%
  mutate(prop_grahami = grahami / total)
cat("Lizard rows excluded because total = 0:", nrow(lizards_raw) - nrow(lizards), "\n")
stopifnot(all(lizards$total > 0))
print(head(lizards))
print(lizards %>% group_by(Site) %>%
        summarise(grahami = sum(grahami), total = sum(total),
                  observed_p = grahami / total, .groups = "drop"))
mod_lizard <- glm(cbind(grahami, opalinus) ~ Site,
                  family = binomial(), data = lizards)
summary(mod_lizard)
print(emmeans(mod_lizard, ~ Site, type = "response"))

# SHOW: DHARMa simulates new outcomes from the fitted model and compares
# observed residual behavior to that simulation-based reference.
# For small datasets, interpret tests and plots cautiously.
sim_lizard <- DHARMa::simulateResiduals(mod_lizard, n = 1000)
plot(sim_lizard)
DHARMa::testUniformity(sim_lizard)
DHARMa::testDispersion(sim_lizard)
DHARMa::testOutliers(sim_lizard)
# performance::check_model gives a broader diagnostic overview.
performance::check_model(mod_lizard)

# DO: Add Diameter as a predictor and produce adjusted probabilities
# for Site x Diameter with emmeans(type = "response").

# YOUR CODE:



# TEACH: Why use cbind(successes, failures), not grahami alone?
# What is the unit of sampling, and what assumptions justify
# treating these rows as independent binomial observations?

# ============================================================
# 3. KNOWN DENOMINATORS AND INTERACTIONS — OME
# ============================================================
# SHOW: Correct out of Trials; failure count = Trials - Correct.
ome <- read.csv("data/OME.csv") %>%
  mutate(ID = factor(ID), Noise = factor(Noise),
         OME = factor(OME),
         Age_centered = Age - 40,
         Proportion = Correct / Trials)
# IMPORTANT: Multiple rows share a participant ID. The introductory glm()
# below assumes independent binomial observations conditional on predictors;
# that assumption may not hold here. Treat it as a teaching model, not a
# final inferential analysis. A subject-level mixed model or other approach
# accounting for repeated observations should be evaluated for research.
cat("OME rows:", nrow(ome), "unique participant IDs:", n_distinct(ome$ID), "\n")
stopifnot(all(ome$Correct >= 0), all(ome$Correct <= ome$Trials),
          all(ome$Trials > 0))
mod_ome <- glm(cbind(Correct, Trials - Correct) ~ Age_centered * Noise,
               family = binomial(), data = ome)
summary(mod_ome)
# Equivalent coefficient estimates for the same data:
mod_ome_weighted <- glm(Proportion ~ Age_centered * Noise,
                        weights = Trials, family = binomial(), data = ome)
print(all.equal(unname(coef(mod_ome)),
                unname(coef(mod_ome_weighted)), tolerance = 1e-8))

# SHOW: expand.grid() crosses a sequence of ages with each Noise category.
# Inspect the first and last rows: these are hypothetical predictor settings,
# NOT observations copied from the dataset.
# Use predict(type = "link", se.fit = TRUE) to calculate 95% confidence
# intervals on the logit scale, then back-transform with plogis().
# Use expand.grid to create a prediction grid of ages by noise type
ome_grid <- expand.grid(Age_centered = seq(min(ome$Age), max(ome$Age), by = 1) - 40,
                        Noise = levels(ome$Noise))
ome_grid$probability <- predict(mod_ome, newdata = ome_grid,
                                type = "response")
print(head(ome_grid))
ome_pred_link <- predict(mod_ome, newdata = ome_grid,
                         type = "link", se.fit = TRUE)
ome_grid$lower_95 <- plogis(ome_pred_link$fit - 1.96 * ome_pred_link$se.fit)
ome_grid$upper_95 <- plogis(ome_pred_link$fit + 1.96 * ome_pred_link$se.fit)
# Pointwise Wald confidence intervals describe parameter uncertainty under
# this GLM; they do not account for repeated participant observations.
ggplot(ome_grid, aes(Age_centered + 40, probability, color = Noise)) +
  geom_ribbon(aes(ymin = lower_95, ymax = upper_95, fill = Noise),
              alpha = 0.5, color = NA) +
  geom_line(linewidth = 1) +
  labs(x = "Age (years)", y = "Predicted probability correct",
       title = "Predicted performance by age and noise") +
  theme_classic()


# DO: Create a prediction grid of ages spanning the observed range by OME type.
# Predict response-scale probabilities and plot a line per OME level.

# YOUR CODE:



# TEACH: What does the interaction allow to change across OME
# categories? Why are predicted probabilities easier to communicate
# than the interaction coefficient on the log-odds scale?

# ============================================================
# 4. DIAGNOSTICS AND TROUBLESHOOTING
# ============================================================
# SHOW: Convergence is not equivalent to a well-fitting model.
print(mod_ome$converged)
print(summary(mod_ome)$coefficients)
# Pearson dispersion is a descriptive check; its interpretation
# depends on grouping, independence, and adequacy of the mean model.
pearson_dispersion <- sum(residuals(mod_ome, type = "pearson")^2) /
  df.residual(mod_ome)
print(pearson_dispersion)
plot(fitted(mod_ome), residuals(mod_ome, type = "pearson"),
     xlab = "Fitted probability", ylab = "Pearson residual")
abline(h = 0, lty = 2)

# SHOW: Interpret convergence and the Pearson dispersion screen.
# The OME GLM converged, meaning the algorithm completed successfully.
# Its Pearson ratio is about 1.61, suggesting possible extra-binomial
# variation relative to the independent-binomial assumptions.
# Repeated measurements on 77 IDs, unmodeled predictors, and individual
# heterogeneity could contribute; this ratio alone cannot identify a cause.
# Neither convergence nor a non-significant residual test proves fit.

# SHOW: Simulation-based residual diagnostics for the OME binomial GLM.
set.seed(8030)
sim_ome <- DHARMa::simulateResiduals(mod_ome, n = 1000)
plot(sim_ome)
DHARMa::testUniformity(sim_ome)
DHARMa::testDispersion(sim_ome)
DHARMa::testOutliers(sim_ome)
performance::check_model(mod_ome)

# SHOW: A beta-binomial model permits extra-binomial variation among
# grouped success counts (when Trials > 1).
# Unlike a quasibinomial model, this is a likelihood-based model.
mod_ome_bb <- glmmTMB::glmmTMB(
  cbind(Correct, Trials - Correct) ~ Age_centered * Noise,
  family = glmmTMB::betabinomial(link = "logit"),
  data = ome
)
summary(mod_ome_bb)
# Compare models cautiously: AIC is defined for these likelihood models,
# but AIC alone does not address ignored within-participant dependence.
AIC(mod_ome, mod_ome_bb)
set.seed(8030)
sim_ome_bb <- DHARMa::simulateResiduals(mod_ome_bb, n = 1000)
plot(sim_ome_bb)
DHARMa::testUniformity(sim_ome_bb)
DHARMa::testDispersion(sim_ome_bb)
performance::check_model(mod_ome_bb)

# WHY beta-binomial?
# Binomial: Var(Y | n,p) = n*p*(1-p).
# Beta-binomial: p can vary between observational groups, introducing
# additional variation (positive intragroup correlation of trials).
# A beta-binomial likelihood DOES NOT automatically account for repeated
# rows from the same participant. For research, consider adding (1 | ID)
# to a glmmTMB model and evaluating the repeated-measures structure.
# With few trials per row, extra dispersion may be difficult to identify.
# Do not infer that a beta-binomial model is necessarily the final model.

# DO: Check the dispersion ratio for the lizard model from Section 2.
# Check the convergence flag. Write a short interpretation.

# YOUR CODE:



# DO: Fit a beta-binomial model to the grouped lizard counts using
# glmmTMB(..., family = betabinomial(link = "logit")).
# Compare its AIC and DHARMa diagnostics with mod_lizard2.
# Can you claim the beta-binomial fixes dependence between sampling cells?
# YOUR CODE:


# TEACH: Distinguish (1) failed optimization, (2) complete separation,
# and (3) overdispersion. Which issue can be addressed by rescaling a
# predictor? Which requires a change in statistical assumptions?
# Before adding random effects, ask whether the design has clustering.
# In OME, repeated ID is a concrete reason to investigate dependence.
# A dispersion ratio alone does not establish its cause.

# EXIT TICKET:
# 1. Write one sentence interpreting a predicted probability.
# 2. Explain the difference between odds and probability.
# 3. Explain why Trials matters in the OME data.
# 4. Identify one design question you would ask before fitting a GLM.

# YOUR CODE:



