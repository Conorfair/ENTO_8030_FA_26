# ENTO 8030 — Discussion 08: Poisson and Negative Binomial Regression
# Workflow: import -> explore -> visualize -> model -> diagnose -> infer -> figure
# Run from the COURSE REPOSITORY ROOT (where the data/ folder is located).

library(dplyr)
library(ggplot2)
library(glmmTMB)
library(DHARMa)
library(emmeans)
library(patchwork)

# Model principles:
# Poisson: Var(Count | predictors, Days) = mu.
# NB2: Var(Count | predictors, Days) = mu + mu^2 / theta.
# The offset(log(Days)) models counts proportional to sampling effort.
# Predictions at Days = 1 represent moths per trap-night.

# ============================================================
# PRACTICAL 1 — POISSON REGRESSION (GUIDED)
# Question: Are moth capture rates associated with habitat and temperature?
# ============================================================

# 1. LOAD AND CHECK THE DATA
pois <- read.csv("data/moth_poisson_habitat.csv")
pois$Habitat <- factor(pois$Habitat, levels = c("grass", "forest", "edge"))
pois$Rate <- pois$Count / pois$Days
head(pois)
str(pois)
summary(pois)

# 2. EXPLORE AND VISUALIZE THE DATA
pois %>% group_by(Habitat) %>%
  summarise(n = n(), moths = sum(Count), nights = sum(Days),
            crude_rate = moths / nights, .groups = "drop") %>% print()
print(ggplot(pois, aes(Temperature, Rate, color = Habitat)) +
        geom_point(alpha = .5) + theme_classic() +
        labs(x = "Temperature (°C)", y = "Observed moths per trap-night"))
# Discuss: Why use Count/Days for descriptive plots, but Count with an
# offset in the model? Why can pooled variance exceed pooled mean?

# ANSWER: Count/Days is useful for visualizing rates across unequal
# sampling durations. Modeling integer Count with offset(log(Days))
# accounts for exposure while retaining the count likelihood. Pooled
# variance may exceed the mean because habitats, temperatures, and
# sampling durations differ; this alone does not prove overdispersion
# conditional on the predictors and exposure.

# 3. FIT A POISSON GLM
mod_pois <- glm(Count ~ Habitat + Temperature + offset(log(Days)),
                family = poisson(link = "log"), data = pois)
summary(mod_pois)
exp(coef(mod_pois))
# Discuss: What does exp(Habitatforest) mean? What is the reference?

# ANSWER: With grass as the reference, exp(Habitatforest) is the 
# forest-to-grass expected capture-rate ratio at the same temperature 
# and sampling effort. A value above 1 means a higher expected rate 
# in forest. Verify levels(pois$Habitat) first.

# 4. CHECK MODEL ASSUMPTIONS
set.seed(8030)
res_pois <- simulateResiduals(mod_pois, n = 500)
plot(res_pois)
testDispersion(res_pois)
testZeroInflation(res_pois)
plotResiduals(res_pois, pois$Temperature)
# Discuss: Are residuals consistent with the fitted distribution?
# Are there unexplained trends? Are observations independent?

# ANSWER: A reasonably uniform DHARMa residual plot and nonsignificant
# dispersion/zero tests are consistent with the fitted distribution,
# and residual trends with temperature suggest a linear effect. 
# Independence comes from study design: repeated measurements of a
# trap would need special attention.

# 5. ESTIMATE AND INTERPRET EFFECTS
emm_pois <- emmeans(mod_pois, ~ Habitat,
                    at = list(Temperature = 20, Days = 1), type = "response")
print(emm_pois)
print(pairs(emm_pois, adjust = "tukey"))
# Write one sentence about a rate ratio and one about an adjusted rate.

# EXAMPLE: At a fixed temperature, the forest capture rate is estimated
# to be 3.77 moths per night, the grass capture rate is estimated to be
# 2.04, etc. with their reported 95% confidence intervals. 

# 6. PRODUCE A COMPOSITE FIGURE (GUIDED CODE)
# Panel A: temperature relationship; curves and CI describe expected rates.
new_pois <- expand.grid(Temperature = seq(min(pois$Temperature),
                                           max(pois$Temperature), length.out = 100),
                        Habitat = levels(pois$Habitat), Days = 1)
new_pois$Habitat <- factor(new_pois$Habitat, levels = levels(pois$Habitat))
pred_pois <- predict(mod_pois, newdata = new_pois,
                     type = "link", se.fit = TRUE)
new_pois$fit <- exp(pred_pois$fit)
new_pois$lower <- exp(pred_pois$fit - 1.96 * pred_pois$se.fit)
new_pois$upper <- exp(pred_pois$fit + 1.96 * pred_pois$se.fit)
pA <- ggplot() +
  geom_point(data = pois, aes(Temperature, Rate, color = Habitat), alpha = .3) +
  geom_ribbon(data = new_pois,
              aes(Temperature, ymin = lower, ymax = upper, fill = Habitat),
              alpha = .13) +
  geom_line(data = new_pois, aes(Temperature, fit, color = Habitat), linewidth = 1) +
  theme_classic() + labs(x = "Temperature (°C)", y = "Moths per trap-night",
                         title = "A. Temperature and habitat")

# Panel B: adjusted rates and raw observations.
# emmeans summary contains response, asymp.LCL/asymp.UCL for a GLM.
pois_emm <- as.data.frame(emm_pois)
print(names(pois_emm))
pB <- ggplot(pois, aes(Habitat, Rate)) +
  geom_jitter(width = .12, alpha = .25, color = "grey45") +
  geom_pointrange(data = pois_emm,
                  aes(x = Habitat, y = rate, ymin = asymp.LCL,
                      ymax = asymp.UCL), inherit.aes = FALSE,
                  color = "firebrick", linewidth = .7) +
  theme_classic() + labs(x = "Habitat", y = "Moths per trap-night",
                         title = "B. Adjusted habitat rates")
figure_pois <- pA | pB
print(figure_pois)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
ggsave("output/figures/discussion08_poisson.png", figure_pois,
       width = 11, height = 4.5, dpi = 300)
# Interpret: CI ribbons quantify uncertainty in the mean, not individual counts.
# ANSWER: The ribbons represent uncertainty in each model-estimated
# mean rate at a given temperature and habitat. Individual trap counts
# can vary much more widely than these intervals indicate.

# CLASS CHECKPOINT: Is the Poisson model adequate? Explain using DHARMa.
# SUGGESTED ANSWER: If the simulated residuals are approximately uniform,
# dispersion and zero-frequency tests do not flag discrepancies, and
# residuals show no trend with temperature, Poisson is a defensible
# working model. Also check independence and influential observations.
# Do not infer adequacy from a nonsignificant test alone.

# ============================================================
# PRACTICAL 2 — NEGATIVE BINOMIAL REGRESSION (GUIDED)
# Question: Are pesticide and temperature associated with moth rates?
# ============================================================

# 1. LOAD AND REVIEW
nb <- read.csv("data/moth_nb_pesticide.csv")
nb$Pesticide <- factor(nb$Pesticide, levels = c("none", "low", "high"))
nb$Rate <- nb$Count / nb$Days
head(nb)
summary(nb)

# 2. VISUALIZE
print(ggplot(nb, aes(Pesticide, Rate)) +
        geom_jitter(width = .14, alpha = .4) + theme_classic() +
        labs(y = "Observed moths per trap-night"))
print(ggplot(nb, aes(Temperature, Rate, color = Pesticide)) +
        geom_point(alpha = .4) + theme_classic())

# 3. FIT POISSON, THEN NB2, WITH THE SAME MEAN STRUCTURE
mod_nb_pois <- glm(Count ~ Pesticide + Temperature + offset(log(Days)),
                   family = poisson, data = nb)
mod_nb <- glmmTMB(Count ~ Pesticide + Temperature + offset(log(Days)),
                  family = nbinom2(link = "log"), data = nb)
summary(mod_nb_pois)
summary(mod_nb)
AIC(mod_nb_pois, mod_nb)
# Discuss: Does NB2 change the mean formula, variance, or both?

# ANSWER: Here both candidates have the SAME log-linear mean formula.
# NB2 changes the conditional variance from mu (Poisson) to
# mu + mu^2/theta, allowing extra-Poisson variation. Coefficient
# estimates can nevertheless change when the likelihood changes.

# 4. DIAGNOSTICS FOR BOTH MODELS
set.seed(8030)
res_nb_pois <- simulateResiduals(mod_nb_pois, n = 500)
plot(res_nb_pois)
testDispersion(res_nb_pois)
testZeroInflation(res_nb_pois)
res_nb <- simulateResiduals(mod_nb, n = 500)
plot(res_nb)
testDispersion(res_nb)
testZeroInflation(res_nb)
plotResiduals(res_nb, nb$Temperature)
plotResiduals(res_nb, nb$Habitat)
# Compare: distributional fit, AIC, residual trends, zero frequencies.

# ANSWER: Prefer a model with acceptable residual diagnostics and a
# defensible mean/variance structure; lower AIC is additional relative
# evidence among models fitted to the same observations. NB2 may account
# for extra zeros without a separate zero-inflation component. Check
# residual patterns as well as dispersion and zero-frequency tests.

# 5. INFERENCE AND INTERPRETATION
exp(fixef(mod_nb)$cond)
emm_nb <- emmeans(mod_nb, ~ Pesticide,
                  at = list(Temp_c = 0, Days = 1), type = "response")
print(emm_nb)
print(pairs(emm_nb, adjust = "tukey"))
# Interpret pesticide rate ratios, not additive count differences.

# ANSWER: exp(beta_low) compares the low-pesticide expected moth rate
# with the no-pesticide rate, holding temperature and exposure fixed;
# for example, 0.70 would mean an estimated 30% lower rate, not 0.30
# fewer moths. Use actual fitted estimates for class interpretation.

# 6. FIGURE: RAW DATA + MODEL PREDICTIONS
# Students: replicate the Poisson plotting workflow above for NB2.
# Make (A) pesticide adjusted means + 95% CI and raw points;
# (B) temperature trends by pesticide + 95% CI.
# Remember: predict.glmmTMB(..., type="link", se.fit=TRUE).

# INSTRUCTOR SOLUTION — NB2 COMPOSITE
nb_emm <- as.data.frame(emm_nb)
print(names(nb_emm))
nbA <- ggplot(nb, aes(Pesticide, Rate)) +
  geom_jitter(width = .12, alpha = .25, color = "grey50") +
  geom_pointrange(data = nb_emm,
                  aes(x = Pesticide, y = response,
                      ymin = asymp.LCL, ymax = asymp.UCL),
                  inherit.aes = FALSE, color = "firebrick") +
  theme_classic() + labs(title = "A. Pesticide-adjusted rates",
                         y = "Moths per trap-night")
# Note: for glmmTMB emmeans the response-scale mean column is often
# 'response'; verify with names(nb_emm) if package versions differ.
new_nb <- expand.grid(Temperature = seq(min(nb$Temperature),
                                         max(nb$Temperature), length.out = 100),
                      Pesticide = levels(nb$Pesticide), Days = 1)
new_nb$Pesticide <- factor(new_nb$Pesticide, levels = levels(nb$Pesticide))
pr_nb <- predict(mod_nb, newdata = new_nb, type = "link", se.fit = TRUE)
new_nb$fit <- exp(pr_nb$fit)
new_nb$lower <- exp(pr_nb$fit - 1.96 * pr_nb$se.fit)
new_nb$upper <- exp(pr_nb$fit + 1.96 * pr_nb$se.fit)
nbB <- ggplot() +
  geom_point(data = nb, aes(Temperature, Rate, color = Pesticide), alpha = .25) +
  geom_ribbon(data = new_nb,
              aes(Temperature, ymin = lower, ymax = upper, fill = Pesticide),
              alpha = .3) +
  geom_line(data = new_nb, aes(Temperature, fit, color = Pesticide),
            linewidth = 1) + theme_classic() +
  labs(title = "B. Temperature relationships", x = "Temperature (°C)",
       y = "Moths per trap-night")
figure_nb <- nbA | nbB
print(figure_nb)
# ggsave("output/figures/discussion08_nb2.png", figure_nb, width = 11, height = 4.5, dpi = 300)

# Expected teaching conclusion: the NB2 candidate can accommodate
# extra-Poisson variation; its uncertainty may differ substantially
# from the Poisson fit. Decide from actual diagnostics.

# CLASS CHECKPOINT: What changed when NB2 replaced Poisson?

# SUGGESTED ANSWER: The predictors, log link, and exposure offset stayed
# the same, but NB2 added a dispersion parameter (theta) and allowed
# variance to exceed the conditional mean. This can improve residual
# behavior and change standard errors, confidence intervals, and
# inference. Confirm improvement using DHARMa and AIC, not the model name.

# ============================================================
# PRACTICAL 3 — INDEPENDENT COUNT-DATA ANALYSIS (CHOOSE ONE)
# ============================================================
# These five CSVs are supplied separately and must be placed in data/.
# Unlike the guided synthetic moth data, they are observational examples.
# None has a known correct distribution in advance: fit and CHECK models.
# Do not assume all rows are independent or that an association is causal.
#
# DATASET 1: Horseshoecrabs.csv (173 female crabs)
#   Response: Sat = number of satellite male crabs around each female.
#   Predictors: Width (carapace width), Wt (weight), Col (color),
#               Spine (spine condition).
#   Question: Does expected satellite count change with female width,
#             after accounting for color? Could color modify that trend?
#   Starter formula: Sat ~ Width + Col
#   NOTE: No exposure offset is provided. Consider collinearity if using
#         Width and Wt together. Counts include zeros.
#
# DATASET 2: RoadKills.csv (52 road sectors)
#   Response: TOT.N = total recorded road-killed animals per sector;
#             alternatively BufoCalamita = count of that species.
#   Predictors: OPEN.L, URBAN, OLIVE (land-cover measures),
#               D.WAT.RES (distance to reservoir), among others.
#   Question: Is roadkill count associated with urban land cover or
#             distance to water? Are effects nonlinear?
#   Starter formula: TOT.N ~ URBAN + D.WAT.RES
#   NOTE: Sector is an identifier; X and Y are spatial coordinates.
#         No road length, traffic volume, or monitoring-time exposure
#         is provided. Adjacent sectors may be spatially correlated.
#         Avoid fitting every landscape predictor to only 52 sectors.
#
# DATASET 3: Baseball.csv (838 team-season records)
#   Response: runs.scored (or wins, with care about games played).
#   Predictors: league, division, year, attendance, runs.allowed.
#   Question: Do runs scored differ by league after accounting for year?
#   Starter formula: runs.scored ~ league + year
#   NOTE: year uses two-digit coding in this file; inspect its values.
#         franchise repeats across seasons: independence is questionable.
#         The file lacks a direct games-played column, so do not invent
#         a games offset. Analyzing wins also has a bounded denominator.
#
# DATASET 4: Campus.csv (81 campuses)
#   Response: num_prop = property-crime count; alternatively num_viol.
#   Predictors: type (U/C), region; Enrollment = number of students.
#   Question: Do property-crime rates differ by campus type, adjusting
#             for geographic region?
#   Starter formula: num_prop ~ type + region + offset(log(Enrollment))
#   NOTE: Enrollment is a candidate exposure measure, not necessarily
#         the complete population at risk. Use count as response, NOT
#         prop_rate_10000 as response with a Poisson/NB count family.
#
# DATASET 5: hurricanes.csv (90 storm records)
#   Response: alldeaths = deaths associated with each storm.
#   Predictors: Category, Minpressure_Updated_2014, Year, NDAM.
#   Question: Is storm intensity associated with death counts, after
#             accounting for year? Does the relationship look nonlinear?
#   Starter formula: alldeaths ~ Category + Year
#   NOTE: Storm exposure/population at risk is not supplied. Deaths
#         can be extreme; check influential observations. Category is
#         numeric as imported: decide whether to treat it as ordered
#         numeric or factor. Associations do not establish causation.
#
# YOUR SIX-STEP ANALYSIS (repeat the guided examples):
# 1. Choose one file; write a biological or substantive question and
#    identify observational unit, count response, predictors, exposure
#    (if available), and possible dependence/confounding.
# 2. Load with read.csv("data/<exact filename>.csv"); use head(), str(),
#    summary(), colSums(is.na(...)), table(), and group summaries.
#    Explicitly convert categorical variables to factors.
# 3. Make two exploratory predictor-response plots (categorical and/or
#    continuous), showing raw observations rather than only averages.
# 4. Fit Poisson and NB2 candidates with the SAME predictor formula.
#    Include offset(log(exposure)) ONLY if a defensible positive
#    exposure exists. Compare coefficients and AIC.
# 5. Use DHARMa simulated residuals, dispersion and zero tests, and
#    residuals vs a predictor. Discuss independence and influence.
# 6. Report a rate ratio and/or response-scale emmeans (95% CI), then
#    create a two-panel composite figure: raw + fitted relationship and
#    adjusted group means or a second fitted relationship.
#
# In a 60-second report: question, model choice, diagnostic evidence,
# estimated effect with units/CI, and ONE important limitation.
# The pooled sample variance > mean is NOT proof of conditional
# overdispersion; model-based diagnostics are essential.
#
# CHOOSE AND LOAD A DATASET (uncomment ONE line):
# practice <- read.csv("data/Horseshoecrabs.csv")
# practice <- read.csv("data/RoadKills.csv")
# practice <- read.csv("data/Baseball.csv")
# practice <- read.csv("data/Campus.csv")
# practice <- read.csv("data/hurricanes.csv")
#
# YOUR CODE:

# ============================================================
# INSTRUCTOR ILLUSTRATION — HORSESHOE CRABS (ONE POSSIBLE PATH)
# ============================================================
# This is a worked example, NOT a claim that NB2 must be selected.
# Results and DHARMa tests should be interpreted after running R.
practice <- read.csv("data/Horseshoecrabs.csv")
practice$Col <- factor(practice$Col)
practice$Spine <- factor(practice$Spine)
head(practice)
str(practice)
summary(practice)
colSums(is.na(practice))
mean(practice$Sat == 0)

# Exploratory plots: raw counts against width and by color.
p_crab_raw1 <- ggplot(practice, aes(Width, Sat)) +
  geom_jitter(width = 0, height = 0.15, alpha = 0.5) +
  theme_classic() + labs(x = "Carapace width", y = "Satellite males")
p_crab_raw2 <- ggplot(practice, aes(Col, Sat)) +
  geom_jitter(width = 0.15, height = 0.15, alpha = 0.5) +
  theme_classic() + labs(x = "Crab color", y = "Satellite males")
print(p_crab_raw1 | p_crab_raw2)

# Fit candidate models to the same rows, predictors and response.
crab_pois <- glm(Sat ~ Width + Col, family = poisson, data = practice)
crab_nb <- glmmTMB(Sat ~ Width + Col, family = nbinom2, data = practice)
summary(crab_pois)
summary(crab_nb)
AIC(crab_pois, crab_nb)

set.seed(8030)
crab_res_pois <- simulateResiduals(crab_pois, n = 500)
plot(crab_res_pois)
testDispersion(crab_res_pois)
testZeroInflation(crab_res_pois)
crab_res_nb <- simulateResiduals(crab_nb, n = 500)
plot(crab_res_nb)
testDispersion(crab_res_nb)
testZeroInflation(crab_res_nb)
plotResiduals(crab_res_nb, practice$Width)

# The following figure illustrates NB2 predictions. If Poisson is
# supported instead, replace crab_nb with crab_pois throughout.
exp(fixef(crab_nb)$cond)  # width is a ratio per one width unit
crab_emm <- emmeans(crab_nb, ~ Col,
                    at = list(Width = mean(practice$Width)),
                    type = "response")
print(crab_emm)

crab_grid <- expand.grid(
  Width = seq(min(practice$Width), max(practice$Width), length.out = 100),
  Col = levels(practice$Col))
crab_grid$Col <- factor(crab_grid$Col, levels = levels(practice$Col))
crab_pred <- predict(crab_nb, newdata = crab_grid,
                     type = "link", se.fit = TRUE)
crab_grid$fit <- exp(crab_pred$fit)
crab_grid$lo <- exp(crab_pred$fit - 1.96 * crab_pred$se.fit)
crab_grid$hi <- exp(crab_pred$fit + 1.96 * crab_pred$se.fit)

crab_A <- ggplot() +
  geom_point(data = practice, aes(Width, Sat, color = Col), alpha = 0.4) +
  geom_ribbon(data = crab_grid,
              aes(Width, ymin = lo, ymax = hi, fill = Col), alpha = 0.12) +
  geom_line(data = crab_grid, aes(Width, fit, color = Col), linewidth = 0.9) +
  theme_classic() + labs(x = "Carapace width", y = "Expected satellite males",
                         title = "A. Width relationship")
crab_emm_df <- as.data.frame(crab_emm)
# emmeans versions can use 'response' or another response-scale label.
crab_mean_col <- intersect(c("response", "rate", "emmean"), names(crab_emm_df))[1]
crab_lower_col <- intersect(c("asymp.LCL", "lower.CL"), names(crab_emm_df))[1]
crab_upper_col <- intersect(c("asymp.UCL", "upper.CL"), names(crab_emm_df))[1]
crab_emm_df$fit <- crab_emm_df[[crab_mean_col]]
crab_emm_df$lo <- crab_emm_df[[crab_lower_col]]
crab_emm_df$hi <- crab_emm_df[[crab_upper_col]]
crab_B <- ggplot(practice, aes(Col, Sat)) +
  geom_jitter(width = 0.13, height = 0.1, alpha = 0.25) +
  geom_pointrange(data = crab_emm_df,
                  aes(x = Col, y = fit, ymin = lo, ymax = hi),
                  inherit.aes = FALSE, color = "firebrick") +
  theme_classic() + labs(x = "Crab color", y = "Expected satellite males",
                         title = "B. Color-adjusted means")
print(crab_A | crab_B)
# IMPORTANT: This is an observational association, not a causal effect.
# Width and color may correlate with other unmeasured characteristics.
