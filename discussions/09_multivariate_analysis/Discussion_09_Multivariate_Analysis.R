# ENTO 8030 — Multivariate Analysis Discussion (2026)
# Student version | Work through each section in order.
# Record interpretations in your own words before discussing with the class.

# ---- 0. Setup and data ---------------------------------------------------

# WHY THESE DATA AND CHECKS MATTER
# The ponds example combines a site-by-species abundance matrix (pondsdiat)
# and a site-by-environment table (pondsenv). Rows MUST refer to the same ponds
# in the same order for methods that relate the two matrices.
# read.csv(..., row.names = 1) uses the first CSV field as unique row labels;
# check.names = FALSE preserves chemistry names as supplied. A wrong first
# column or duplicated identifiers will cause an import error or misalignment.
# str() reveals data types and dimensions; stopifnot() fails early if an
# assumption is violated. Inspect NA values and whether all-zero sites occur.
# set.seed() makes randomized starts/permutation sampling reproducible, but
# results may still vary with package versions and random number settings.
#
# RESEARCH QUESTION: Are ponds similar in chemistry? How is diatom composition
# structured, and can measured chemistry account for those patterns?

required <- c("vegan", "permute", "readr", "dplyr", "tidyr", "tibble", "janitor")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {stop("Install these packages first: ", paste(missing, collapse = ", "))}
set.seed(8030)

# Import the original datasets
ponds <- read.csv("https://bit.ly/pondsfull", row.names = 1, check.names = FALSE)
pondsenv <- read.csv("https://bit.ly/pondsenv", row.names = 1, check.names = FALSE)
pondsdiat <- read.csv("https://bit.ly/pondsdiat", row.names = 1, check.names = FALSE)

# ---- Standardize pond identifiers ---------------------------------
# Environmental data use numeric identifiers such as "4" and "31".
# Diatom data use identifiers such as "X004" and "X031".
# sprintf("%03d", ...) pads each number with leading zeros
# to produce a three-digit identifier.
# paste0() adds the "X" prefix.
rownames(pondsenv) <- paste0("X", sprintf("%03d", as.integer(rownames(pondsenv))))

# ---- Validate and align observations -------------------------------
# Confirm identifiers are unique
stopifnot(!anyDuplicated(rownames(pondsenv)), !anyDuplicated(rownames(pondsdiat)))
# Confirm both datasets contain the same ponds
if (!setequal(rownames(pondsenv), rownames(pondsdiat))) {stop("Environmental and diatom datasets contain different pond IDs.")}

# Reorder diatom data to match environmental data
pondsdiat <- pondsdiat[rownames(pondsenv), , drop = FALSE]

# Verify identical row order
stopifnot(identical(rownames(pondsenv), rownames(pondsdiat)))

# Confirm no missing observations were introduced
stopifnot(!anyNA(pondsenv), !anyNA(pondsdiat))
message("Pond identifiers successfully standardized and aligned.")

# ---- 1. Cluster analysis -------------------------------------------------

# CLUSTERING: FROM VARIABLES TO GROUPS
# Step 1: scale(pondsenv) subtracts each column mean and divides by its SD.
# Without scaling, variables measured in large units can dominate Euclidean
# distances. This differs from center = FALSE: 
# dividing without centering changes the distances only by the column SD, since a
# common column shift cancels in pairwise Euclidean/Manhattan distances.
# For PCA, however, centering matters to the model representation.

# Step 2: dist() calculates pairwise site dissimilarities: Euclidean is the
# square root of the sum of squared standardized differences; Manhattan is
# the sum of absolute standardized differences. They emphasize differences
# in distinct ways. Neither metric is automatically best for ecology.

# Step 3: hclust() repeatedly merges groups; method = 'single' uses the
# smallest between-group distance and may create chains, whereas 'average'
# uses the mean of all between-group pair distances (UPGMA).

# Step 4: plot() draws the dendrogram; rect.hclust(..., k = 4) merely shows
# a chosen four-cluster cut. It does not test whether four clusters exist.

# Step 5: cophenetic() returns the dendrogram merge height for each pair;
# cor() compares those heights with original distances. A high correlation
# indicates better distance preservation, not ecological cluster validity.

# Step 6: kmeans(..., centers = 4, nstart = 100) minimizes within-cluster
# squared Euclidean distances, repeating random initializations 100 times.
# The requested k is imposed; it is not estimated by the algorithm.

# Step 7: prcomp(chem)$x[, 1:2] projects sites into the first two PCA axes
# for display; k-means was fitted in the FULL standardized variable space,
# not in just these two axes. Apparent overlap in the plot is possible.
#
# DISCUSS: Which decisions are analyst choices (variables, scaling, metric,
# linkage, k), and which are results produced by the algorithm?

# Chemistry variables use different units; standardize before Euclidean distance.
chem <- scale(pondsenv)
d_euclid <- dist(chem, method = "euclidean")
d_manhattan <- dist(chem, method = "manhattan")
h_single <- hclust(d_euclid, method = "single")
h_average <- hclust(d_euclid, method = "average")
plot(h_single, hang = -0.01, main = "Single-linkage clustering")
rect.hclust(h_single, k = 4, border = "red")
plot(h_average, hang = -0.01, main = "Average-linkage clustering")
rect.hclust(h_average, k = 4, border = "blue")
cor(as.vector(d_euclid), as.vector(cophenetic(h_single)))
cor(as.vector(d_euclid), as.vector(cophenetic(h_average)))
plot(as.vector(d_euclid), as.vector(cophenetic(h_single)),
     xlab = "Original distance", ylab = "Cophenetic distance")
abline(0, 1, lty = 2)
plot(as.vector(d_euclid), as.vector(cophenetic(h_average)),
     xlab = "Original distance", ylab = "Cophenetic distance")
abline(0, 1, lty = 2)

# Q1: What changes when the linkage method changes? Does a dendrogram reveal
#     a uniquely correct number of ecological groups?
# Q2: What does cophenetic correlation measure? Does a larger value establish
#     that clusters represent real biological groups?

# K-means: use multiple random starts to reduce dependence on initialization.
km <- kmeans(chem, centers = 4, nstart = 100)
print(table(km$cluster))
plot(prcomp(chem)$x[, 1:2], col = km$cluster, pch = 19,
     xlab = "PC1", ylab = "PC2", main = "K-means groups in PCA space")
# Q3: How is k-means different from hierarchical clustering? Why scale data?

# ---- 2. PCA: unconstrained environmental gradients -----------------------

# PCA: UNCONSTRAINED ORDINATION OF CONTINUOUS CHEMISTRY
# PCA identifies orthogonal linear combinations of the measured variables
# that successively capture the greatest remaining total variance.
# vegan::rda(pondsenv, scale = TRUE) with no explanatory formula is an
# unconstrained PCA; scale = TRUE centers and standardizes variables,
# so the analysis corresponds to a correlation-based rather than raw
# covariance-based PCA. This is helpful for mixed measurement units.
# eigenvals() extracts axis eigenvalues (inertia); summary(eigenvals(...))
# expresses their proportions. The sum of all eigenvalues is total inertia.
# screeplot(..., bstick = TRUE) compares observed eigenvalues with a
# broken-stick reference. This is a descriptive benchmark, NOT a formal
# significance test for individual axes.
# biplot(..., scaling = 'species') emphasizes variable relationships; in a
# chemistry PCA the 'species' label refers to the response columns (chemical
# variables), not biological species. Arrow directions/lengths depend on
# scaling and score conventions; use variable scores to corroborate readings.
# PCA does not test treatment differences or establish a causal gradient.
#
# DISCUSS: Which gradients are represented by PC1/PC2, and what information
# is necessarily lost when only two axes are plotted?

pca_env <- vegan::rda(pondsenv, scale = TRUE) # PCA as unconstrained RDA
print(pca_env)
print(summary(vegan::eigenvals(pca_env)))
screeplot(pca_env, type = "lines", bstick = TRUE)
biplot(pca_env, scaling = "species")
# Q4: What percentage of total environmental variation is represented by
#     PC1 and PC2? Which chemical variables define the axes?
# Q5: Does a broken-stick comparison constitute a formal significance test?

# ---- 3. CA: diatom community composition ---------------------------------

# CA: CHI-SQUARE GEOMETRY FOR COMMUNITY COMPOSITION
# Correspondence analysis decomposes associations in a nonnegative
# site-by-species table using row/column profiles and chi-square distances.
# Unlike PCA, CA weights species and sites according to their totals.
# cca(community_matrix) WITHOUT a right-hand-side formula is unconstrained
# CA; cca(community ~ predictors, data = env) later becomes constrained CCA.
# downweight() reduces the influence of rare species using a particular
# weighting rule; it is optional and changes the analysis, so compare the
# ordination with and without downweighting as a sensitivity analysis.
# summary(eigenvals()) describes proportions of total CHI-SQUARE INERTIA,
# which is not directly interchangeable with PCA variance explained.
# plot(..., scaling = 'species') favors species configurations; 'sites'
# favors among-site relationships. These are alternate score scalings of
# one fitted ordination, not separate fitted models.
# Rare species and low-count sites can disproportionately influence CA;
# inspect raw counts and site/species totals before calling points outliers.
#
# DISCUSS: Do unusual sites reflect a biological gradient, sampling effort,
# or a few low-frequency taxa?

ca_spp <- vegan::cca(vegan::downweight(pondsdiat))
print(ca_spp)
print(summary(vegan::eigenvals(ca_spp)))
plot(ca_spp, scaling = "species", main = "CA — species emphasis")
plot(ca_spp, scaling = "sites", main = "CA — site emphasis")
# Q6: Are outlying sites driven by rare taxa? What does downweighting change?
# Q7: What information is emphasized by the different ordination scalings?

# ---- 4. NMDS: rank-order dissimilarity -----------------------------------

# NMDS: PRESERVING DISSIMILARITY RANKS, NOT LINEAR VARIANCE
# metaMDS() searches for a low-dimensional configuration whose interpoint
# distances preserve the rank order of observed dissimilarities. It uses
# repeated random starts to reduce risk of a poor local solution.
# distance = 'euclidean' is used for standardized chemistry; 'bray' is used
# for nonnegative diatom abundances. Bray-Curtis is sensitive to relative
# abundance and is undefined for pairs of all-zero sites; inspect zeros.
# k = 2 requests TWO ordination dimensions; trymax = 100 limits the search
# attempts; autotransform = FALSE disables vegan's automatic transformations
# so preprocessing remains explicit; trace = FALSE suppresses iteration logs.
# The seed allows reproducible random starts. Rotations/reflections of the
# same NMDS configuration are equivalent; axis signs have no fixed meaning.
# stressplot() shows original dissimilarities against ordination distances
# with a fitted monotone relationship. Stress measures configuration error;
# there is NO PCA-like percentage of variance explained by NMDS axes.
# envfit() fits each environmental variable to an EXISTING ordination:
# arrows indicate increasing fitted values; their lengths reflect strength
# of association after plotting rescaling. permutations = 999 assesses the
# association under exchangeability, not causation or a fitted CCA model.
# When environmental rows and species sites do not align, envfit is invalid.
#
# DISCUSS: Does low stress imply significant treatment differences? No.

# Euclidean for chemistry; Bray-Curtis for nonnegative community counts.
set.seed(8030)
nmds_env <- vegan::metaMDS(chem, distance = "euclidean", k = 2,
                          trymax = 100, autotransform = FALSE, trace = FALSE)
nmds_spp <- vegan::metaMDS(pondsdiat, distance = "bray", k = 2,
                          trymax = 100, autotransform = FALSE, trace = FALSE)
print(nmds_env); print(nmds_spp)
vegan::stressplot(nmds_env)
vegan::stressplot(nmds_spp)
plot(nmds_spp, type = "t", main = "Diatom NMDS")
fit_env <- vegan::envfit(nmds_spp, pondsenv, permutations = 999)
print(fit_env)
plot(nmds_spp, type = "n"); points(nmds_spp, display = "sites", pch = 19)
plot(fit_env, add = TRUE)
# Q8: What does NMDS stress quantify? Why is low stress not a treatment test?
# Q9: What do environmental arrows represent? Are they evidence of causation?

# ---- 5. CCA: constrained diatom ordination --------------------------------

# CCA: EXPLAINING CHI-SQUARE COMMUNITY INERTIA WITH PREDICTORS
# cca(pondsdiat ~ ., data = pondsenv) fits a constrained ordination in
# which ALL columns of pondsenv enter as environmental constraints; the
# formula dot means every supplied predictor. With 30 ponds and many
# correlated chemistry variables, overfitting and aliasing are concerns.
# The constrained axes represent linear combinations of environmental
# predictors that account for patterns in species composition in CA geometry.
# RsquareAdj() reports raw and adjusted measures of explained inertia;
# adjusted values temper the optimism of models with many constraints.
# vif.cca() diagnoses collinearity among environmental constraints; large
# values indicate that individual variable effects may be unstable.
# anova(cca_full, permutations = 999) is a permutation test of the FULL
# constrained model, not proof that each variable independently matters.
# plot(..., scaling = 'sites') emphasizes site configurations; environmental
# arrows are associations in the fitted constrained space.
# Partial CCA uses Condition() to account for named variables before
# estimating the remaining constrained relationships. Variables being
# conditioned upon should not ALSO appear among tested constraints.
#
# DISCUSS: Is 'explains 50% of inertia' a causal claim? What does a high VIF
# mean for interpretation of individual chemistry coefficients?

cca_full <- vegan::cca(pondsdiat ~ ., data = as.data.frame(pondsenv))
print(cca_full)
print(vegan::RsquareAdj(cca_full))
print(vegan::vif.cca(cca_full))
plot(cca_full, scaling = "sites")
set.seed(8030)
print(anova(cca_full, permutations = 999))
# Q10: How is CCA different from CA? What do constrained axes represent?
# Q11: Which environmental variables appear redundant? Why avoid automatic
#      stepwise selection as the sole basis for scientific conclusions?

# Partial CCA, retaining two environmental gradients as conditioned variables.
cca_partial <- vegan::cca(pondsdiat ~ . - Maxdepth - Secchid + Condition(Maxdepth + Secchid),
                          data = as.data.frame(pondsenv))
set.seed(8030)
print(anova(cca_partial, permutations = 999))
# Q12: What is being tested after conditioning on Maxdepth and Secchid?

# ---- 6. PERMANOVA: randomized-block weed experiment ----------------------

# PERMANOVA: A MULTIVARIATE TEST WITH A RANDOMIZATION DESIGN
# The plough experiment has 12 plots in four complete blocks and three
# ploughing-time treatments. Rows are plots; columns are weed species.
# read_csv(skip = 1) skips the file's first line;
# rename(), select(), clean_names(), filter(), and column_to_rownames()
# construct a community matrix and a matching experimental-design table.
# Match rows by plot labels, not assumed file order. Converting NA to 0 is
# appropriate ONLY if the source coding really means 'not observed' rather
# than 'not measured'; inspect source documentation first.
# vegdist(..., method = 'bray') calculates Bray-Curtis dissimilarity from
# nonnegative community abundances; total abundance differences can matter.
# permute::how(blocks = block, nperm = 999) prevents plots being exchanged
# ACROSS blocks, reflecting within-block treatment randomization. There
# are only 3!^4 = 1296 possible within-block permutations before accounting
# for other restrictions; effective distinct permutations may be limited.
# adonis2() partitions dissimilarity-based sums of squares and produces a
# pseudo-F statistic. Formula 'block + ploughing_time' accounts for blocks;
# by = 'terms' reports SEQUENTIAL tests, with treatment after block.
# Do not interpret the block P value under a permutation scheme that keeps
# blocks fixed. The treatment row is the intended scientific contrast.
# Permutation validity depends on exchangeability under the null, which
# must be justified by the actual design, not by code alone.
# betadisper() calculates distances to group centroids/medians in a
# principal-coordinate space. permutest() checks multivariate dispersion;
# location and dispersion can both influence PERMANOVA interpretation.
# A nonsignificant dispersion test does not prove dispersions identical.
#
# DISCUSS: What is the experimental unit? Why is permutation within blocks
# necessary, and why does a pseudo-F not automatically mean a causal effect?

plough <- readr::read_csv("https://bit.ly/plough-spp", skip = 1, show_col_types = FALSE) |>
  dplyr::rename(label = "...1") |>
  dplyr::select(-dplyr::any_of("...2")) |>
  janitor::clean_names() |>
  dplyr::filter(!is.na(label)) |>
  tibble::column_to_rownames("label")
plough_design <- readr::read_csv("https://bit.ly/plough-design", skip = 1, show_col_types = FALSE) |>
  dplyr::rename(label = "...1", ploughing_time = "Treatmnt") |>
  dplyr::select(-dplyr::any_of("...2")) |>
  janitor::clean_names() |>
  dplyr::filter(!is.na(label)) |>
  tibble::column_to_rownames("label")
# Align community and design rows by plot label; do not assume CSV order.
stopifnot(setequal(rownames(plough), rownames(plough_design)))
plough_design <- plough_design[rownames(plough), , drop = FALSE]
# IMPORTANT: this recoding assumes NA in species fields denotes zero counts.
# If NA instead means unmeasured/missing, obtain corrected source data.
plough[] <- lapply(plough, function(x) {x <- as.numeric(x); x[is.na(x)] <- 0; x})
plough_design$block <- factor(plough_design$block)
plough_design$ploughing_time <- factor(plough_design$ploughing_time)
perms <- permute::how(blocks = plough_design$block, nperm = 999)
set.seed(8030)
permanova <- vegan::adonis2(plough ~ block + ploughing_time,
  data = plough_design, method = "bray", permutations = perms,
  by = "terms")
print(permanova)
# Q13: Why restrict permutations within blocks? Why include block in the model?
# Q14: What does PERMANOVA test? Does a significant result prove centroid
#      differences rather than differences in within-group dispersion?

# Check multivariate dispersion separately.
# The treatment row (after block) is the planned test; avoid interpreting
# the block P value under within-block permutations.
bray_plough <- vegan::vegdist(plough, method = "bray")
disp <- vegan::betadisper(bray_plough, plough_design$ploughing_time)
plot(disp)
set.seed(8030)
print(vegan::permutest(disp, permutations = perms))
# Q15: How would significant dispersion differences change your interpretation?

# ---- 7. db-RDA: constrained distance-based ordination ---------------------

# db-RDA: CONSTRAINED ORDINATION OF DISTANCE-BASED VARIATION
# dbrda() performs distance-based redundancy analysis: it relates a
# community dissimilarity structure to explanatory variables and supplies
# constrained ordination axes for visualization and interpretation.
# The formula 'ploughing_time + Condition(block)' asks whether treatment
# explains community differences AFTER accounting for blocks. This is
# complementary to the treatment test in PERMANOVA, but the exact test
# statistic/geometry can differ depending on options and distance corrections.
# distance = 'bray' specifies Bray-Curtis. Because Bray-Curtis can produce
# negative principal-coordinate eigenvalues, add = 'lingoes' applies an
# additive correction to make the geometry Euclidean; explain the choice
# and use comparable settings if comparing distance-based analyses.
# plot(..., scaling = 'sites') emphasizes distances among site scores;
# read the axes and relative site positions rather than assuming axis 1
# is always an environmental variable.
# anova(dbrda_mod, permutations = perms) tests the constrained effect using
# the same within-block exchangeability restrictions as the study design.
# Do not claim that the plot alone tests treatment effects.
#
# DISCUSS: How does db-RDA extend a PERMANOVA test by showing the structure
# of the treatment-related compositional variation?

dbrda_mod <- vegan::dbrda(plough ~ ploughing_time + Condition(block),
  data = plough_design, distance = "bray", add = "lingoes")
plot(dbrda_mod, scaling = "sites")
set.seed(8030)
print(anova(dbrda_mod, permutations = perms))
# Q16: Compare the scientific questions addressed by PERMANOVA and db-RDA.
# Q17: Why must the randomization/permutation scheme match the study design?

# ---- 8. Wrap-up ----------------------------------------------------------

# SYNTHESIS: METHODS ANSWER DIFFERENT QUESTIONS
# Clustering, PCA, CA, and NMDS are primarily descriptive/exploratory.
# CCA and db-RDA model constrained multivariate associations and permit
# permutation tests. PERMANOVA is a hypothesis test of multivariate
# location-like differences but can be sensitive to dispersion.
# For EVERY analysis: name the sampling/experimental unit, preprocessing,
# distance or geometry, model constraints, validation/diagnostics, and
# biological interpretation. Do not compare 'percent variance explained'
# across PCA, CA, and NMDS as though they were the same quantity.

# Q18: Which analyses are primarily descriptive, and which include formal
#      tests of environmental or treatment associations?
# Q19: Which conclusions are sensitive to scaling, dissimilarity, or outliers?
# Q20: Which analyses can support causal inference, and under what design?
