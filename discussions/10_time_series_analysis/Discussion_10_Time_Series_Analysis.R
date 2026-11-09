# ======================================================================
# ENTO 8030 | DISCUSSION 10: TIME SERIES ANALYSIS
# Student walkthrough | Source R Markdown sequence retained
# ======================================================================
# Open the course R Project from the repository root.
# Source file: Time Series Analysis R Markdown supplied for Discussion 10.
# This script intentionally retains worked examples and original section order.
# Do not use setwd(); required survival data: data/Duck survival.csv.
# Install missing packages once using the instructions in README.md.

library(dplyr)
library(tidyr)
library(ggplot2)
library(glmmTMB)
library(emmeans)
library(multcomp)
library(survival)
library(survminer)
library(performance)
library(DHARMa)
library(gganimate)
library(gifski)
library(agriTutorial)
library(agridat)
library(lattice)
library(broom.mixed)
library(AICcmodavg)
library(stringr)
library(readr)
library(here)



# ==================================================================
# TIME SERIES ANALYSIS
# ==================================================================

# How time influences a response variable is a common question in research. Time series analysis is
# used when data are collected at regular time intervals and the goal is to model the temporal
# dependence of the response variable. This dependence can be modeled in several ways including
# autoregressive integrated moving average (ARIMA) models, models that use other covariance
# structures, and models that use a simple random intercept for experimental units (subjects).
# Furthermore, depending on the type of response variable (continuous, binary, count) different
# modeling approaches are needed. We will also look into event history analysis, which is used to
# analyze the expected duration of time until one or more events happen, such as death in biological
# organisms and failure in mechanical systems. This particular type of modeling has endless
# applications in entomological research, and I encourage you to explore it further in your own
# research.


# ==================================================================
# REPEATED MEASURES
# ==================================================================

# When repeated observations are made on the same individual experimental unit this violates one of
# the linear model assumptions - no autocorrelation among errors. This analysis requires some specific
# steps to account for the temporal autocorrelation. We will first fit a model that assumes no
# autocorrelation. Then we will fit multiple models that assume different types of temporal
# autocorrelation and compare them to see which fits the data best.


# ==================================================================
# REVIEW THE EXPERIMENTAL DESIGN
# ==================================================================

# Data from a sorghum trial laid out as a randomized complete block design with five blocks and four
# sorghum varieties as the only treatment factor. The response variable - leaf area index - was
# measured in five consecutive weeks on each plot starting two weeks after emergence. The repeated
# observation variable (week) needs to be treated as a factor - all measurements were made at discrete
# time points. This dataset is comprised of 100 values resembling longitudinal data - repeated
# measures or time series analysis.

# The week factor is not a treatment factor that can be randomized. The repeated measurements of the
# same experimental unit are likely to be serially correlated, which needs to be accounted for to
# produce a appropriately estimated uncertainty for differences between varieties.


# ==================================================================
# IMPORTING THE DATA
# ==================================================================

# We also include the steps to format the necessary variables to be factors.


# ---- Source R Markdown code: load data ----
# data - reformatting agriTutorial::sorghum
sorghum_dat <- agriTutorial::sorghum %>% # data from agriTutorial package
  rename(block = Replicate, 
         weekF = factweek,  # week as factor
         weekN = varweek,   # week as numeric/integer
         plot  = factplot) %>% 
  mutate(variety = paste0("var", variety),    # variety id
         block   = paste0("block", block),    # block id
         weekF   = paste0("week", weekF),     # week id
         plot    = paste0("plot", plot),      # plot id
         unit    = paste0("obs", seq_len(n()))) %>% # observation id - needed for glmmTMB model
  mutate(across(c(variety, block, weekF, plot, unit), as.factor),
         weekF = factor(weekF, levels = paste0("week", 1:5)))
# Verify the repeated-measures data before fitting models.
stopifnot(nrow(sorghum_dat) == 100,
          !anyNA(sorghum_dat$weekF),
          length(unique(sorghum_dat$plot)) == 20)
head(sorghum_dat)
str(sorghum_dat)


# ==================================================================
# EXPLORING THE DATA
# ==================================================================

# The lack of row and column variables prevent us from using the desplot function to create a figure
# that shows the experimental design. Descriptive tables will show the arithmetic means and standard
# deviations for leaf area index per variety. We can use the pivot_wider function to get mean values
# for each week.


# ---- Source R Markdown code: data summary ----
sorghum_dat %>%
  group_by(variety) %>% 
  summarize(mean = mean(y, na.rm = TRUE), std.dev = sd(y, na.rm = TRUE)) %>% 
  arrange(desc(mean)) # sort
  
sorghum_dat %>%
  group_by(weekF, variety) %>% 
  summarize(mean = mean(y, na.rm = TRUE)) %>% 
  pivot_wider(names_from = weekF, values_from = mean) # pivot wider creates the table with each week as a column

# We can create an animated plot that shows the change in leaf area index by variety across the five
# weeks.


# ---- Source R Markdown code: animated plot ----
var_colors <- c("#8cb369", "#f4a259", "#5b8e7d", "#bc4b51")
names(var_colors) <- levels(sorghum_dat$variety)

gganimate_plot <- ggplot(
  data = sorghum_dat, aes(y = y, x = weekF,
                  group = variety,
                  color = variety)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(alpha = 0.5, size = 3) +
  scale_y_continuous(
    name = "Leaf area index",
    limits = c(0, 6.5),
    expand = c(0, 0),
    breaks = c(0:6)
  ) +
  scale_color_manual(values = var_colors) +
  theme_bw() +
  theme(legend.position = "bottom", 
        axis.title.x = element_blank()) +
  transition_time(weekN) +
  shadow_mark(exclude_layer = 2) 

animate(gganimate_plot, renderer = gifski_renderer()) # render gif


# ==================================================================
# FITTING ANOVA MODELS WITH R
# ==================================================================

# An inefficient approach is to model a subset of the data from one week using either a fixed effect
# for block or random effect.


# ---- Source R Markdown code: unnamed ----
sorghum_dat.wk1 <- sorghum_dat %>% filter(weekF == "week1") # subset data from first week only
# Block as fixed effect
mod.wk1 <- lm(y ~ variety + block, data = sorghum_dat.wk1)
anova(mod.wk1)
# Block as random effect
mod.wk1_re <- lmerTest::lmer(y ~ variety + (1|block), data = sorghum_dat.wk1)
anova(mod.wk1_re)

# Repeat for week 2
sorghum_dat.wk2 <- sorghum_dat %>% filter(weekF == "week2")
mod.wk2 <- lm(y ~ variety + block, data = sorghum_dat.wk2)
anova(mod.wk2)
mod.wk2_re <- lmerTest::lmer(y ~ variety + (1|block), data = sorghum_dat.wk2)
anova(mod.wk2_re)

#Repeat with other weeks

# However, this approach is inefficient and does not use all the data available, and this can lead to
# a concern for either type II or I errors. Type II errors occur when a true effect is not detected
# due to reduced statistical power from using only a subset of the data. Type I errors can occur when
# multiple separate tests (over multiple weeks) increase the overall chance of incorrectly rejecting a
# true null hypothesis (false positive).

# A better approach is to fit a single model that includes all weeks simultaneously while accounting
# for the repeated measures structure of the data.

# It is reasonable to assume that the treatment effects evolve over time and thus are week-specific.
# Furthermore, there could be variability among blocks over the weeks. The glmmTMB function allows us
# more flexibility than the lmer function.


# ---- Source R Markdown code: unnamed ----
sorghum_iid <- glmmTMB(y ~ weekF * variety + (1|block) + (1|unit), # add random unit term to mimic error variance
                 dispformula = ~ 0, # fix original error variance to 0 since (1|unit) is mimicking the error variance so there is no duplication
                 REML = TRUE, # needs to be stated since default is ML
                 data = sorghum_dat)

sorghum_iid %>% broom.mixed::tidy(effects = "ran_pars", scales = "vcov")
summary(sorghum_iid)
VarCorr(sorghum_iid)$cond$unit[1] # variance component estimate for error term
VarCorr(sorghum_iid)$cond$block[1] # variance component estimate for block
emmeans(sorghum_iid, specs = ~ variety|weekF) %>%
  multcomp::cld(Letters = letters)

# These results assume independent and homogeneous error term, which MAY be wrong. We will now test
# for possible covariance structures for the error term that improve overall model fit. This should be
# done before assessing the significance of any effect - the model assumptions should be met before
# assessing the significant differences among the varieties.


# ==================================================================
# AUTOCORRELATED ERRORS
# ==================================================================

# Experimental units on which repeated observations are made are often referred to as subjects. We
# would now like to allow measurements taken on the same subjects (plot in this case) to be serially
# correlated, while observations on different subjects are still considered independent. More
# specifically, we want the errors of the respective observations to be correlated in our model. It is
# also reasonable to assume a weaker correlation between errors that are further apart in time between
# measurements.

# To account for this autocorrelation, we will fit several models that assume different correlation
# structures for the error term. The four most common correlation structures for repeated measures
# data are:

# 1) AR(1) - first order autoregressive
# 2) CS - compound symmetry
# 3) Toeplitz
# 4) UN - unstructured


# ---- Source R Markdown code: unnamed ----
# Function to create correlation matrices
make_corr_matrix <- function(type, n=5, rho=0.6) {
  mat <- matrix(0, n, n)
  if(type=="AR1") {
    for(i in 1:n) for(j in 1:n) mat[i,j] <- rho^abs(i-j)
  } else if(type=="CS") {
    mat <- matrix(rho, n, n)
    diag(mat) <- 1
  } else if(type=="Toeplitz") {
    rho_seq <- seq(rho, rho^n, length.out=n)
    for(i in 1:n) for(j in 1:n) mat[i,j] <- rho_seq[abs(i-j)+1]
    diag(mat) <- 1
  } else if(type=="UN") {
    mat <- matrix(NA, n, n) # unstructured: all correlations potentially different
  }
  rownames(mat) <- colnames(mat) <- paste0("t", 1:n)
  mat
}

plot_corr_matrix <- function(mat, title) {
  melted <- as.data.frame(as.table(mat))
  ggplot(melted, aes(x = Var1, y = Var2, fill = Freq)) +
    geom_tile(color = "white") +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0,
                         limits = c(-1, 1), na.value = "grey90") +
    coord_fixed() +
    theme_minimal() +
    labs(title = title, x = "", y = "", fill = "Correlation") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Plot examples
plot_corr_matrix(make_corr_matrix("AR1"), "AR(1) Correlation")
plot_corr_matrix(make_corr_matrix("CS"), "Compound Symmetry (CS) Correlation")
plot_corr_matrix(make_corr_matrix("Toeplitz"), "Toeplitz Correlation")
plot_corr_matrix(make_corr_matrix("UN"), "Unstructured (UN) Correlation")

# - AR(1) decreases with lag
# - CS is constant
# - Toeplitz varies arbitrarily by lag
# - UN allows every entry to differ


# ==================================================================
# AR(1)
# ==================================================================

# The most popular correlation structure is called first order autoregressive AR(1). This error
# structure works best when all time points are equally spaced. Other variance structures are possible
# and should also be considered.


# ---- Source R Markdown code: unnamed ----
sorghum_AR1 <- glmmTMB(formula = y ~ weekF * variety + (1|block) +
                   ar1(weekF + 0 | plot), # ar1 structure as random term to mimic error var, and + 0 is used to remove intercept term from random term covariance specification, which is required to properly define the covariance matrix for repeated measures
                   dispformula = ~ 0, # fix original error variance to 0
                   REML = TRUE,       # needs to be stated since default = ML
                   data = sorghum_dat) 

# Extract variance component estimates
sorghum_AR1 %>% broom.mixed::tidy(effects = "ran_pars", scales = "vcov")


# ==================================================================
# COMPOUND SYMMETRY
# ==================================================================

# Compound symmetry can be modeled as standard - homogeneous (nlme only - not showing here) or
# heterogeneous (glmmTMB) to model the error term. Assumes the correlation is constant regardless of
# how far apart the measurements are. The heterogeneous compound symmetry is a simple extension of the
# homogeneous compound symmetry structure with more parameters to allow for the variances along the
# diagonal of the matrix to be different.


# ---- Source R Markdown code: unnamed ----
sorghum_hCS <- glmmTMB(formula = y ~ weekF * variety + (1|block) +
                   cs(weekF + 0 | plot), # hcs structure as random term to mimic error var
                   dispformula = ~ 0, # fix original error variance to 0
                   REML = TRUE,       # needs to be stated since default = ML
                   data = sorghum_dat) 

# show variance components
sorghum_hCS %>% broom.mixed::tidy(effects = "ran_pars", scales = "vcov")


# ==================================================================
# TOEPLITZ
# ==================================================================

# Toeplitz (glmmTMB only) can be calculated faster than similar AR(1) approach. Toeplitz is unique
# from AR(1) in that the correlations do not necessarily have the same pattern as is the case in
# AR(1). This correlation structure is only possible using the glmmTMB function.


# ---- Source R Markdown code: unnamed ----
sorghum_Toep <- glmmTMB(formula = y ~ weekF * variety + (1|block) +
                   toep(weekF + 0 | plot), # toep structure as random term to mimic err var
                   dispformula = ~ 0, # fix original error variance to 0
                   REML = TRUE,       # needs to be stated since default = ML
                   data = sorghum_dat) 

# show variance components
sorghum_Toep %>% broom.mixed::tidy(effects = "ran_pars", scales = "vcov")

# The Toeplitz fit may report NA/NaN function evaluations and false
# convergence (8). Check the convergence code and Hessian below.
# Negative covariance estimates are NOT negative variances.


# ==================================================================
# UNSTRUCTURED VARIANCE
# ==================================================================

# The unstructured variance structure is the most "liberal" that allows every term to be different. In
# doing so it requires fitting the most parameters.


# ---- Source R Markdown code: unnamed ----
sorghum_UN <- glmmTMB(formula = y ~ weekF * variety + (1|block) +
                   us(weekF + 0 | plot), # us structure as random term to mimic error var
                   dispformula = ~ 0, # fix original error variance to 0
                   REML = TRUE,       # needs to be stated since default = ML
                   data = sorghum_dat) 

# show variance components
sorghum_UN %>% broom.mixed::tidy(effects = "ran_pars", scales = "vcov")

# Negative off-diagonal covariance estimates are mathematically allowed.
# Do not reject an otherwise well-fitted UN model solely for this reason.



# ==================================================================
# INTERPRETING MODEL WARNINGS AND COVARIANCE ESTIMATES
# ==================================================================

# A variance is on the diagonal of a covariance matrix and cannot be
# negative. A covariance is off the diagonal and CAN be negative.
# Correlations range from -1 to +1; a negative correlation is allowed.
# A covariance matrix must be positive semidefinite (and positive definite
# for many standard likelihood calculations).
#
# A convergence code of 0 and a positive-definite Hessian are reassuring,
# but do not replace checks of assumptions and parameter stability.
# A false convergence warning is a numerical optimization warning;
# it is NOT proof that a negative covariance caused the problem.
#
# Observed sorghum example (verify in your own session):
# UN: convergence 0, positive-definite Hessian TRUE.
# Toeplitz: convergence 1, positive-definite Hessian TRUE.

sorghum_models <- list(
  iid = sorghum_iid,
  AR1 = sorghum_AR1,
  hCS = sorghum_hCS,
  Toeplitz = sorghum_Toep,
  UN = sorghum_UN
)

model_check <- data.frame(
  Model = names(sorghum_models),
  N = vapply(sorghum_models, nobs, numeric(1)),
  Convergence = vapply(sorghum_models, function(m) m$fit$convergence, numeric(1)),
  pdHess = vapply(sorghum_models, function(m) isTRUE(m$sdr$pdHess), logical(1)),
  AIC = vapply(sorghum_models, function(m) as.numeric(AIC(m)), numeric(1))
)
model_check$Reliable_Optimization <-
  model_check$Convergence == 0 & model_check$pdHess
print(model_check, row.names = FALSE)

# This diagnostic is especially useful for the Toeplitz warning.
if (!model_check$Reliable_Optimization[model_check$Model == "Toeplitz"]) {
  glmmTMB::diagnose(sorghum_Toep)
}

# Covariance matrices: diagonal = variance; off-diagonal = covariance.
VarCorr(sorghum_Toep)$cond$plot
VarCorr(sorghum_UN)$cond$plot

# A valid negative covariance does not imply a negative eigenvalue.
V_UN <- as.matrix(VarCorr(sorghum_UN)$cond$plot)
print(eigen(V_UN, symmetric = TRUE)$values)
print(kappa(V_UN))  # Large values can indicate near-singularity.

# Discussion:
# 1. What is the difference between variance and covariance?
# 2. Why does Toeplitz require caution, even if it prints an AIC?
# 3. Is a negative covariance sufficient to reject the UN model?
# 4. What does a positive-definite Hessian tell us? What does it not tell us?


# ==================================================================
# MODEL SELECTION
# ==================================================================

# Compare covariance structures with identical response, observations,
# and fixed-effects specification. REML-based comparisons are appropriate
# here because the fixed-effects formula is identical across models.
# AIC already penalizes additional parameters. Lower AIC is preferred
# among reliably optimized models; do not treat Delta AIC < 2 as a rule
# that automatically selects or excludes a model.

# Verify that every model refers to the sorghum experiment.
print(data.frame(
  Model = names(sorghum_models),
  Formula = vapply(sorghum_models, function(m) paste(deparse(formula(m)), collapse = " "), character(1)),
  N = vapply(sorghum_models, nobs, numeric(1))
), row.names = FALSE)

# Extract within-plot correlations; do not reuse old objects from
# other experiments in the R environment.
cor_rows <- list()
for (nm in c("AR1", "hCS", "Toeplitz", "UN")) {
  m <- sorghum_models[[nm]]
  V <- as.matrix(VarCorr(m)$cond$plot)
  C <- cov2cor(V)
  tmp <- as.data.frame(as.table(C))
  names(tmp) <- c("Week1", "Week2", "Correlation")
  tmp$Model <- nm
  tmp$Convergence_OK <- m$fit$convergence == 0 && isTRUE(m$sdr$pdHess)
  cor_rows[[nm]] <- tmp
}
df_cor <- dplyr::bind_rows(cor_rows)
df_cor$Model_Label <- ifelse(df_cor$Convergence_OK, df_cor$Model,
                             paste0(df_cor$Model, " (convergence warning)"))

ggplot(df_cor, aes(Week1, Week2, fill = Correlation)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                       midpoint = 0, limits = c(-1, 1)) +
  facet_wrap(~ Model_Label, nrow = 2) +
  coord_fixed() +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Estimated Within-Plot Correlation Structures",
       subtitle = "Warning panels are provisional",
       x = "Sampling week", y = "Sampling week", fill = "Correlation")

# Only rank models without convergence/Hessian flags.
valid <- subset(model_check, Reliable_Optimization & is.finite(AIC))
valid <- valid[order(valid$AIC), ]
valid$Delta_AIC <- valid$AIC - min(valid$AIC)
print(valid, row.names = FALSE)

# In the supplied results: UN AIC = -9.787, AR1 AIC = -4.347,
# Delta AIC = 5.439. Toeplitz reported false convergence.
# The UN model is favored by AIC, pending residual and stability checks.
# A negative covariance is not grounds to substitute AR1.

# Select the unstructured covariance model for the next sections.
sorghum_final <- sorghum_UN

# car::Anova returns Wald CHI-SQUARE statistics for glmmTMB here,
# not F-statistics. Type III tests are conditional on factor contrasts;
# interpret main effects cautiously when the interaction is included.
car::Anova(sorghum_final, type = 3)


# ==================================================================
# ASSUMPTIONS
# ==================================================================

# Assess the selected UN model before interpreting fixed-effect tests.
# The basic plots below check gross departures from normality and
# nonconstant residual spread. Also inspect patterns by sampling week.
epsilon <- residuals(sorghum_final)
qqnorm(epsilon)
qqline(epsilon)
plot(fitted(sorghum_final), epsilon,
     xlab = "Fitted leaf area index", ylab = "Residuals")
abline(h = 0, lty = 2)

# Compare with the independence model.
plot(fitted(sorghum_iid), residuals(sorghum_iid),
     xlab = "Fitted values: iid model", ylab = "Residuals")
abline(h = 0, lty = 2)

boxplot(epsilon ~ sorghum_dat$weekF, xlab = "Sampling week",
        ylab = "UN model residuals")
performance::check_model(sorghum_final, check = c("normality", "homogeneity"))
# Shapiro-Wilk is optional and should not replace graphical diagnostics.
shapiro.test(epsilon)
# Simple residual plots do not establish that temporal dependence is
# completely accounted for. Examine residuals by plot and week as needed.
# ==================================================================
# MEAN COMPARISONS
# ==================================================================

# The primary question is how varieties differ WITHIN each week.
# Use Tukey-adjusted pairwise comparisons separately by week.
withinWeek_UN <- emmeans(sorghum_final, specs = ~ variety | weekF)
pairs(withinWeek_UN, adjust = "tukey")
withinWeek_UN_CLD <- multcomp::cld(withinWeek_UN, Letters = letters)
print(withinWeek_UN_CLD)

# A letter display is a compact summary of pairwise tests, not a measure
# of the magnitude of a treatment difference. Report means and CIs too.
# ==================================================================
# DATA VISUALIZATION
# ==================================================================

# Raw observations + UN-model marginal means, 95% CIs and letters.
# emmeans may label its limits lower.CL/upper.CL or asymp.LCL/asymp.UCL.
plot_means <- as.data.frame(withinWeek_UN_CLD)
lo <- intersect(c("lower.CL", "asymp.LCL"), names(plot_means))[1]
hi <- intersect(c("upper.CL", "asymp.UCL"), names(plot_means))[1]
stopifnot(!is.na(lo), !is.na(hi))
names(plot_means)[names(plot_means) == lo] <- "LCL"
names(plot_means)[names(plot_means) == hi] <- "UCL"
plot_means$.group <- trimws(plot_means$.group)

withinWeek_UN_Plot <- ggplot() +
  facet_wrap(~ weekF, labeller = label_both, nrow = 1) +
  geom_point(data = sorghum_dat, aes(x = variety, y = y),
             alpha = 0.5, position = position_jitter(width = 0.08, height = 0)) +
  geom_point(data = plot_means, aes(x = variety, y = emmean),
             color = "red", position = position_nudge(x = 0.15), size = 2.5) +
  geom_errorbar(data = plot_means, aes(x = variety, ymin = LCL, ymax = UCL),
                color = "red", width = 0.1, position = position_nudge(x = 0.15)) +
  geom_text(data = plot_means, aes(x = variety, y = emmean, label = .group),
            color = "red", position = position_nudge(x = 0.27), hjust = 0) +
  scale_y_continuous(name = "Leaf area index", expand = expansion(mult = c(0.05, 0.18))) +
  labs(x = NULL,
       caption = "Black points: observations; red points and bars: UN-model estimated marginal means and 95% CIs. Letters summarize within-week Tukey comparisons.") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(withinWeek_UN_Plot)
# EVENT HISTORY MODELS
# ==================================================================

# Event history analysis (also known as survival analysis or time-to-event analysis) examines the time
# until a defined event occurs - such as death of an insect, emergence from pupae, or failure of an
# experimental unit. There are so many ways to apply event history models to your research depending
# on how you conceptualize the event of interest.

# We will start by importing the necessary data and cleaning it up for analysis. Our example dataset
# is comprised of survival times of two age classes of birds (young and old) that were monitored for
# 63 days. The response variable is the time until death (in days) and an indicator variable that
# specifies whether the bird died (1) or was right censored (0) at the end of the study period.

# The dataset has four variables:

# Bird - unique identifier for each bird
# Time - time until death or censoring (in days)
# Indicator - event indicator (1 = death, 0 = censored)
# Age - age class of bird (0 = Young, 1 = Old)

# We will treat age as a factor to compare survival between old and young birds.


# ---- Source R Markdown code: Import and Clean Data ----
Birdsurv <- read_csv(here("data", "Duck survival.csv")) %>%
  mutate(Age = factor(Age, levels = c(0, 1), labels = c("Young", "Old")))

str(Birdsurv)
table(Birdsurv$Age)

Surv(Birdsurv$Time, Birdsurv$Indicator) #Survival object - how many events occurred, when they occurred, and how many were right censored - still "alive" at end of study


# ==================================================================
# KAPLAN-MEIER SURVIVAL ESTIMATION
# ==================================================================

# Kaplan-Meier survival estimates provide a non-parametric estimate of the survival curves and
# log-rank test for differences among groups. We can use the `survfit()` function to estimate the
# survival function for each age class and plot the results. The `survdiff()` function tests for
# equality of survival curves between the two age classes.


# ---- Source R Markdown code: Kaplan-Meier Survival Esimation ----
km_fit <- survfit(Surv(Time, Indicator) ~ Age, data = Birdsurv)

# Test equality of survival curves
survdiff(Surv(Time, Indicator) ~ Age, data = Birdsurv)

# Plot Kaplan-Meier survival functions
plot(km_fit, xlab = "Time (days)", ylab = "Survival Probability", lty = c(2, 3), mark.time = TRUE)
legend("topright", bty = "n", c("Old", "Young"), lty = 2:3)
#Approximately 0.58 survival probability for old birds, and 0.62 for young birds after 63 days
#The presence of censored data means that the results indicate conditional probabilities of 
#experiencing death after the duration of the study - we do not reach the median (0.5) survival rates

# [Original numerical claim omitted: verify against course data before teaching.]

# Life expectancy can be approximated for each age class by summing the area under the Kaplan-Meier
# survival curves.


# ---- Restricted mean survival time (common follow-up horizon) ----
# RMST integrates the survival function only to an identified time horizon.
# The original script's sum(diff(event times) * survival) omitted initial intervals.
# Here we use the step-function area from time 0 to tau for each age group.
tau <- min(tapply(Birdsurv$Time, Birdsurv$Age, max))
km_summary <- summary(km_fit, times = tau, extend = TRUE)
# For group-specific RMST, survival::summary.survfit provides rmean
summary(km_fit, rmean = tau)$table
# Avoid interpreting this restricted estimate as unrestricted life expectancy.


# ==================================================================
# COX PROPORTIONAL HAZARDS MODEL
# ==================================================================

# Cox proportional hazards model allows us to estimate the effect of covariates (like age) on the
# hazard rate. We can fit a Cox model using the `coxph()` function and check the proportional hazards
# assumption using `cox.zph()`.


# ---- Source R Markdown code: Cox Proportional Hazards Model ----
cox_model <- coxph(Surv(Time, Indicator) ~ Age, data = Birdsurv, model = TRUE)
summary(cox_model)
# Check proportional hazards assumption
cox.zph(cox_model)

# Tests for overall significance of the model:
# [Original numerical claim omitted: verify against course data before teaching.]

# Compares the fit of the model to the fit of the null model by estimating the ratio of their
# likelihoods (or difference in log likelihoods).
# [Original numerical claim omitted: verify against course data before teaching.]
# Tests how far the estimated parameters are from zero.
# [Original numerical claim omitted: verify against course data before teaching.]
# The test is based on the slope of the likelihood function at the observed values of the variables in
# the model. The estimated score estimates the improvement in model fit if additional variables are
# included in the model.


# If proportional-hazards diagnostics are reasonably consistent with the assumption, we can use the fitted Cox model to predict
# survival probabilities and plot them.


# ---- Source R Markdown code: Predicted Survival Probabilities ----
cox_surv_fit <- survfit(cox_model, newdata = data.frame(Age = c("Young", "Old")))

plot(cox_surv_fit, xlab = "Time (days)", ylab = "Predicted Survival Probabilities", lty = c(2, 3), mark.time = TRUE)
legend("topright", bty = "n", c("Young", "Old"), lty = 2:3)

survfit(cox_model,newdata= data.frame(Age=c("Young", "Old")))$surv #survival function
survfit(cox_model,newdata= data.frame(Age=c("Young", "Old")))$time #time point for each observation

# These model-based curves show estimated survival probabilities for each group after adjusting for
# covariates.

# We can further investigate the hazard function by looking at predicted cumulative hazard functions
# and life expectancy based on the fitted Cox model. The predicted cumulative hazard function summarizes accumulated hazard.
# Survival time summaries must be restricted to a common observed horizon unless
# a defensible extrapolation model is specified.


# ---- Source R Markdown code: Predicted Cumulative Hazard Function and Life Expectancy ----
# Extract survival estimates by group
S_young <- cox_surv_fit$surv[,1]
S_old <- cox_surv_fit$surv[,2]
time_pts <- cox_surv_fit$time

# Convert to cumulative hazard: H(t) = -log(S(t))
H_young <- -log(S_young)
H_old <- -log(S_old)

plot(time_pts, H_young, type="l", lty=2, ylab = "Predicted cumulative hazard", xlab = "Time (days)")
lines(time_pts, H_old, lty=3)
legend("topleft", bty="n", legend = c("Young","Old"), lty = 2:3)

Survival_vector_young <- diff(S_young)
Survival_vector_old   <- diff(S_old)
# Largest stepwise decrease in the estimated survival curve (not instantaneous hazard)
min(Survival_vector_young)
# Largest single decline in survival probability was about 4.7% for young birds
which.min(Survival_vector_young)
time_pts[which.min(Survival_vector_young) + 1]
# The biggest change happens at time point 15 for young birds, which is day 34
min(Survival_vector_old)
# Largest single decline in survival probability was about 5.2% for old birds
which.min(Survival_vector_old)
time_pts[which.min(Survival_vector_old) + 1]
# The biggest change happens at time point 15 for old, which is day 34 

# The cumulative-hazard curve shows how quickly risk accumulates over time; a steeper slope indicates
# greater instantaneous risk of death.


# ---- Restricted mean survival time through a common horizon ----
# Integrate the survival step function from day 0 through tau.
tau <- min(tapply(Birdsurv$Time, Birdsurv$Age, max))
summary(km_fit, rmean = tau)$table
keep <- time_pts < tau
boundaries <- c(0, time_pts[keep], tau)
cox_rmst_young <- sum(diff(boundaries) * c(1, S_young[keep]))
cox_rmst_old <- sum(diff(boundaries) * c(1, S_old[keep]))
c(Young = cox_rmst_young, Old = cox_rmst_old)

# Visualizing predicted survival functions
plot(time_pts, S_young, type="l", lty=2, ylim=c(0,1), col=("blue"),
     xlab="Time (days)", ylab="Survival probability")
lines(time_pts, S_old, lty=3, col=("red"))
legend("topright", legend=c("Young","Old"), lty=2:3, col=c("blue", "red"),bty="n")

# Highlight largest estimated survival-curve drops (not instantaneous hazard)
points(time_pts[which.min(Survival_vector_young)+1],
       S_young[which.min(Survival_vector_young)+1],
       col="blue", pch=19)
points(time_pts[which.min(Survival_vector_old)+1],
       S_old[which.min(Survival_vector_old)+1],
       col="red", pch=19)

# RMST integrates from day 0 through a common observed follow-up horizon.

# These estimates are restricted areas under survival curves, not unrestricted life expectancy.
# [Original numerical claim omitted: verify against course data before teaching.]
# [Original numerical claim omitted: verify against course data before teaching.]

# Compare Cox and Kaplan-Meier survival estimates only over a common
# follow-up horizon; neither model estimates unrestricted life expectancy
# without additional assumptions about survival beyond observed follow-up.

# Cox and Kaplan-Meier RMST should be compared over the same horizon.
# Neither approach automatically identifies survival beyond follow-up.

# We can follow up these results with analogous post-hoc tests for both the Kaplan-Meier and Cox model
# results using the `survminer::pairwise_survdiff()` and `emmeans()` functions, respectively.

# For only two levels these post-hoc tests are not strictly necessary, but they illustrate how to
# perform pairwise comparisons when more than two groups are present.


# ==================================================================
# POST-HOC TESTS
# ==================================================================


# ---- Source R Markdown code: Post-Hoc Tests ----
# Pairwise log-rank tests
survminer::pairwise_survdiff(Surv(Time, Indicator) ~ Age,
                  data = Birdsurv,
                  p.adjust.method = "holm")  # or "bonferroni", "BH", etc.

# Estimated marginal means on the log-hazard (linear predictor) scale
em_cox <- emmeans(cox_model, ~ Age) 

# Pairwise contrasts with multiplicity adjustment
pairs(em_cox, adjust = "tukey")

# There are other parametric approaches to event history modeling such as the Weibull, Exponential,
# and Gompertz models that specify an explicit functional form for the baseline hazard function and
# assume specific distributions for survival times. These models can be fit using the `survreg()`
# function in R. They can perform better with more efficient estimates of survival, hazard, and
# cumulative hazard functions, but the model (functional form) has to be correct - not an easy task.

# However, we will not be covering these models in this tutorial - they are quite advanced and beyond
# the scope of this introduction.



# ==================================================================
# REPEATED MEASURES PRACTICE EXAMPLE
# ==================================================================

# We will use the data from an experiment conducted in a greenhouse in Silver Bay, Minnesota. Plants
# exposed to different (three) treatments were observed over a 40 day period. Make sure to modify the
# variable types to factor for the repeated measures analysis. Fit a linear model assuming no random
# effects, a linear mixed effects model with a random intercept for each plant, and a linear mixed
# effects model that tests unstructured variance, heterogeneous compound symmetry, autoregressive
# order-1, homogeneous diagonal variance, and heterogeneous diagonal variance structures.


# ---- Source R Markdown code: unnamed ----
data(pederson.lettuce.repeated, package = "agridat")
lettuce_dat <- agridat::pederson.lettuce.repeated
library(lattice)
lettuce_dat <- lettuce_dat[order(lettuce_dat$day),]
xyplot(weight ~ day|trt, lettuce_dat, type = 'l', group = plant, layout = c(3, 1),
main = "pederson.lettuce.repeated")


# ---- Source R Markdown code: unnamed ----
# Remember to change the necessary variables to factors
str(lettuce_dat)
lettuce_dat$plant <- as.factor(lettuce_dat$plant)
lettuce_dat$day <- as.factor(lettuce_dat$day)

# Fitting linear model with no random effect
lettuce_lm <- lm(weight ~ trt * day, data = lettuce_dat)

# Fitting linear mixed model with random effect
lettuce_ri <- glmmTMB(weight ~ trt * day + (1|plant), data = lettuce_dat)

# Code to try when issues of convergence pop up
# control = glmmTMBControl(optimizer = optim, optArgs = list(method = "BFGS"))
# control = glmmTMBControl(maxfun = 20000)

lettuce_UN <- glmmTMB(weight ~ trt * day + us(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat)
lettuce_UN_BFGS <- glmmTMB(weight ~ trt * day + us(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat,
                control = glmmTMBControl(optimizer = optim, optArgs = list(method = "BFGS")))

# Unstructured Correlation - fit estimate for each pair of observations over time
# Overparameterized model warning message - makes sense this unstructured covariance option fits a covariance estimate for every pair of observations


lettuce_CS <- glmmTMB(weight ~ trt * day + cs(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat)
lettuce_CS_BFGS <- glmmTMB(weight ~ trt * day + cs(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat,
                control = glmmTMBControl(optimizer = optim, optArgs = list(method = "BFGS")))
lettuce_HomD <- glmmTMB(weight ~ trt * day + homdiag(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat)
lettuce_HetD <- glmmTMB(weight ~ trt * day + diag(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat) 
# Convergence warning - try different optimizer
# Very common to get convergence warnings for small datasets of some covariance structures
lettuce_HetD_BFGS <- glmmTMB(weight ~ trt * day + diag(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat,
                control = glmmTMBControl(optimizer = optim, optArgs = list(method = "BFGS")))
lettuce_AR1 <- glmmTMB(weight ~ trt * day + ar1(day + 0|plant),
                dispformula = ~ 0, REML = TRUE, data = lettuce_dat) 

# Only compare models that use the same response and observations.
lettuce_models <- list(iid = lettuce_ri, hCS = lettuce_CS,
                       HomD = lettuce_HomD, HetD = lettuce_HetD,
                       AR1 = lettuce_AR1)
lettuce_check <- data.frame(
  Model = names(lettuce_models),
  Convergence = vapply(lettuce_models, function(m) m$fit$convergence, numeric(1)),
  pdHess = vapply(lettuce_models, function(m) isTRUE(m$sdr$pdHess), logical(1)),
  AIC = vapply(lettuce_models, function(m) as.numeric(AIC(m)), numeric(1))
)
print(lettuce_check)
# AIC comparisons across transformed and untransformed responses are not valid.


# ==================================================================
# LETTUCE: BRIEF DIAGNOSTIC WALKTHROUGH
# ==================================================================
# The initial AR(1) model has the lowest AIC among the converged
# glmmTMB candidates above, but AIC alone does not establish adequacy.
# First inspect whether the residual spread changes with sampling day.
# These are marginal (population-level) residuals, NOT normalized
# residuals; they are useful for exploring the variance pattern.

lettuce_dat$day_numeric <- as.numeric(as.character(lettuce_dat$day))
lettuce_dat$pred_marginal <- predict(lettuce_AR1, re.form = NA)
lettuce_dat$resid_marginal <- lettuce_dat$weight - lettuce_dat$pred_marginal

ggplot(lettuce_dat, aes(x = day, y = resid_marginal)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.25) +
  geom_jitter(width = 0.15, alpha = 0.3) +
  geom_hline(yintercept = 0, linetype = 2) +
  facet_wrap(~ trt) +
  theme_classic() +
  labs(x = "Sampling day", y = "Marginal residual",
       title = "Does residual variability change over time?")

# A heterogeneous residual variance model can address changing spread.
# nlme also allows a plant-specific random slope. Here AR(1) indexes
# successive measurement OCCASIONS, not actual elapsed days.
# Both models have identical fixed effects and use REML.

library(nlme)

lettuce_nlme <- lettuce_dat %>%
  mutate(
    day_factor = factor(day_numeric, levels = sort(unique(day_numeric))),
    occasion = as.integer(day_factor),
    day_scaled = as.numeric(scale(day_numeric)),
    plant = factor(plant),
    trt = factor(trt)
  ) %>%
  arrange(plant, occasion)

stopifnot(!anyDuplicated(lettuce_nlme[c("plant", "occasion")]))

lettuce_AR1_het <- nlme::lme(
  fixed = weight ~ trt * day_factor,
  random = ~ 1 | plant,
  correlation = nlme::corAR1(form = ~ occasion | plant),
  weights = nlme::varIdent(form = ~ 1 | day_factor),
  method = "REML",
  data = lettuce_nlme,
  control = nlme::lmeControl(opt = "optim", maxIter = 200, msMaxIter = 200)
)

lettuce_AR1_het_slope <- nlme::lme(
  fixed = weight ~ trt * day_factor,
  random = ~ day_scaled | plant,
  correlation = nlme::corAR1(form = ~ occasion | plant),
  weights = nlme::varIdent(form = ~ 1 | day_factor),
  method = "REML",
  data = lettuce_nlme,
  control = nlme::lmeControl(opt = "optim", maxIter = 300,
                             msMaxIter = 300, niterEM = 50)
)

# Compare the two models with the same fixed-effects specification.
anova(lettuce_AR1_het, lettuce_AR1_het_slope)

# Normalized residuals account for the modeled covariance structure.
# Look for approximately constant spread, extreme tails, and remaining
# autocorrelation; no single diagnostic establishes model adequacy.
lettuce_nlme$norm_resid <- residuals(lettuce_AR1_het_slope,
                                     type = "normalized")
lettuce_nlme$fitted_pop <- predict(lettuce_AR1_het_slope, level = 0)

qqnorm(lettuce_nlme$norm_resid,
       main = "Lettuce: normalized residual Q-Q plot")
qqline(lettuce_nlme$norm_resid)

ggplot(lettuce_nlme, aes(x = fitted_pop, y = norm_resid, color = trt)) +
  geom_point(alpha = 0.4) +
  geom_hline(yintercept = 0, linetype = 2) +
  theme_classic() +
  labs(x = "Population-level fitted weight",
       y = "Normalized residual")

nlme::ACF(lettuce_AR1_het_slope, resType = "normalized")

# Discussion: The random-slope heterogeneous AR(1) fit improves AIC
# and reduces short-lag dependence, but the Q-Q tails still deviate.
# This is an improvement, not proof that every assumption is satisfied.

# ==================================================================
# LETTUCE: TREATMENT COMPARISONS AND VISUALIZATION
# ==================================================================
# Compare treatments WITHIN each sampling day using the selected
# original-scale model. Avoid interpreting log-scale means as grams.
lettuce_emm <- emmeans::emmeans(lettuce_AR1_het_slope, ~ trt | day_factor)
pairs(lettuce_emm, adjust = "tukey")
lettuce_letters <- as.data.frame(
  multcomp::cld(lettuce_emm, Letters = letters)
)
lettuce_letters$.group <- trimws(lettuce_letters$.group)

# Use a CI display together with raw observations.
lettuce_plot <- ggplot(lettuce_nlme, aes(x = trt, y = weight)) +
  facet_wrap(~ day_factor, labeller = label_both) +
  geom_point(alpha = 0.35,
             position = position_jitter(width = 0.1, height = 0)) +
  geom_point(data = lettuce_letters,
             aes(x = trt, y = emmean), inherit.aes = FALSE,
             color = "red", position = position_nudge(x = 0.18)) +
  geom_errorbar(data = lettuce_letters,
                aes(x = trt, ymin = lower.CL, ymax = upper.CL),
                inherit.aes = FALSE, color = "red", width = 0.1,
                position = position_nudge(x = 0.18)) +
  geom_text(data = lettuce_letters,
            aes(x = trt, y = upper.CL, label = .group),
            inherit.aes = FALSE, color = "red", hjust = 0,
            position = position_nudge(x = 0.28)) +
  labs(x = NULL, y = "Plant weight",
       caption = "Raw observations (gray); model marginal means, 95% CIs and Tukey letters (red).") +
  theme_classic()
print(lettuce_plot)
