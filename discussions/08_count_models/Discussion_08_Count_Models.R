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

# 3. FIT A POISSON GLM
mod_pois <- glm(Count ~ Habitat + Temperature + offset(log(Days)),
                family = poisson(link = "log"), data = pois)
summary(mod_pois)
exp(coef(mod_pois))
# Discuss: What does exp(Habitatforest) mean? What is the reference?

# 4. CHECK MODEL ASSUMPTIONS
set.seed(8030)
res_pois <- simulateResiduals(mod_pois, n = 500)
plot(res_pois)
testDispersion(res_pois)
testZeroInflation(res_pois)
plotResiduals(res_pois, pois$Temperature)
# Discuss: Are residuals consistent with the fitted distribution?
# Are there unexplained trends? Are observations independent?

# 5. ESTIMATE AND INTERPRET EFFECTS
emm_pois <- emmeans(mod_pois, ~ Habitat,
                    at = list(Temperature = 20, Days = 1), type = "response")
print(emm_pois)
print(pairs(emm_pois, adjust = "tukey"))
emm_pois <- emmeans(mod_pois, ~ Habitat | Temperature,
                    at = list(Temperature = c(20, 25, 30), Days = 1), type = "response")

print(emm_pois)
print(pairs(emm_pois, adjust = "tukey"))
# Write one sentence about a rate ratio and one about an adjusted rate.

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
              alpha = .3) +
  geom_line(data = new_pois, aes(Temperature, fit, color = Habitat), linewidth = 1) +
  theme_classic() + labs(x = "Temperature (°C)", y = "Moths per trap-night",
                         title = "A. Temperature and habitat")

# Panel B: adjusted rates and raw observations.
# emmeans summary contains response, asymp.LCL/asymp.UCL for a GLM.
pois_emm <- as.data.frame(emm_pois)
print(names(pois_emm))
# emmeans uses "rate" for this Poisson GLM response scale.
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

# Options to save figure
# dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
# ggsave("output/figures/discussion08_poisson.png", figure_pois, width = 11, height = 4.5, dpi = 300)

# Interpret: CI ribbons quantify uncertainty in the mean, not individual counts.

# CLASS CHECKPOINT: Is the Poisson model adequate? Explain using DHARMa.

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

# 5. INFERENCE AND INTERPRETATION
exp(fixef(mod_nb)$cond)
emm_nb <- emmeans(mod_nb, ~ Pesticide,
                  at = list(Temp_c = 0, Days = 1), type = "response")
print(emm_nb)
print(pairs(emm_nb, adjust = "tukey"))
# Interpret pesticide rate ratios, not additive count differences.

# 6. FIGURE: RAW DATA + MODEL PREDICTIONS
# Students: replicate the Poisson plotting workflow above for NB2.
# Make (A) pesticide adjusted means + 95% CI and raw points;
# (B) temperature trends by pesticide + 95% CI.
# Remember: predict.glmmTMB(..., type="link", se.fit=TRUE).
# YOUR CODE:

# CLASS CHECKPOINT: What changed when NB2 replaced Poisson?

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
# In a brief report: question, model choice, diagnostic evidence,
# estimated effect with units/CI, and ONE important limitation.
# The pooled sample variance > mean is NOT proof of conditional
# overdispersion; model-based diagnostics are essential.
#
# CHOOSE AND LOAD A DATASET:
# practice <- read.csv("data/Horseshoecrabs.csv")
# practice <- read.csv("data/RoadKills.csv")
# practice <- read.csv("data/Baseball.csv")
# practice <- read.csv("data/Campus.csv")
# practice <- read.csv("data/hurricanes.csv")
#
# YOUR CODE:
