# Multivariate Analysis — ENTO 8030 (2026 Discussion Session)

**Student-facing README | R discussion and live coding**

## Folder contents

```text
09_multivariate_analysis/
├── README.md
├── Discussion_09_Multivariate_Analysis.R
└── solutions/
    └── Discussion_09_Multivariate_Analysis_Solutions.R
```

**Distribution:** Share `README.md` and `Discussion_09_Multivariate_Analysis.R` with students. Keep `solutions/` in a private instructor repository or exclude it from student distribution.

## Goals

Students should be able to explain the purpose of the most important functions and arguments, not merely run a sequence of commands; distinguish descriptive clustering/ordination from constrained hypothesis testing; identify the relevant dissimilarity or geometry; and justify permutation restrictions from the experimental design.

## Before class

1. Install R and the required packages: `install.packages(c("vegan", "permute", "readr", "dplyr", "tidyr", "tibble", "janitor"))`.
2. Open `Discussion_09_Multivariate_Analysis.R` in RStudio and run it in order. Code comments explain the scientific objective, important functions, arguments, and limitations.
3. Data are fetched from the short URLs used in the original R Markdown (`pondsfull`, `pondsenv`, `pondsdiat`, `plough-spp`, `plough-design`). Internet access and valid links are required. Consider saving local copies before class.
4. Verify pond row identifiers, numeric columns, and plot-to-design row matching. In the plough dataset, replacing NA with zero assumes NA encodes an absent species, not missing measurement.
5. The original Rmd includes exploratory observations and numerical examples; these are not hard-coded as answers because results may differ by dataset and package version.

## Session outline

| Section | Scientific purpose | Key R calls | Teaching emphasis |
|---|---|---|---|
| Clustering | Group ponds by chemical similarity | `scale`, `dist`, `hclust`, `cophenetic`, `kmeans` | Scale, distance, linkage, imposed k |
| PCA | Summarize chemistry gradients | `rda`, `eigenvals`, `screeplot`, `biplot` | Correlation PCA, inertia, biplot scaling |
| CA | Describe diatom compositional structure | `cca`, `downweight` | Chi-square inertia, rare taxa |
| NMDS | Preserve ranks of dissimilarities | `metaMDS`, `stressplot`, `envfit` | Stress, repeated starts, environmental associations |
| CCA | Relate species composition to chemistry | `cca`, `vif.cca`, `RsquareAdj`, `anova` | Constraints, collinearity, permutation |
| PERMANOVA | Test ploughing treatments in RCBD | `adonis2`, `betadisper`, `permutest` | Block restriction, pseudo-F, dispersion |
| db-RDA | Visualize treatment-related compositional differences | `dbrda`, `Condition`, `anova` | Distance geometry, conditioning, restricted permutation |

## Methodological cautions

- **Scaling is not a trivial formatting choice.** Standardization determines how chemical variables contribute to distances and ordination.
- **NMDS stress is not explained variance** and a good ordination is not a treatment significance test.
- **CA/CCA inertia and PCA variance are different geometries.** Do not compare them as equivalent percentages.
- **CCA with many correlated predictors can be unstable.** Interpret high VIFs and model complexity before interpreting arrows or marginal tests.
- **Restricted permutations are design-dependent.** With four blocks of three plots, treatment labels are exchangeable only within blocks if that matches actual randomization. The treatment row is the scientific focus in sequential PERMANOVA.
- **PERMANOVA and dispersion are distinct questions.** Check `betadisper` alongside `adonis2`; a nonsignificant dispersion result does not establish equality.
- **Ordination does not establish causality.** Causal conclusions require appropriate assignment and experimental units.

## Source provenance

The datasets, sequence of methods, original discussion prompts, and ecological examples derive from the supplied `Multivariate Statistics.Rmd`. The annotated 2026 scripts build on the supplied `09_multivariate_analysis.zip`, preserving its filenames and `solutions/` directory. Explanatory additions, methodological qualifications, and function-argument notes draw on official package documentation and ecological ordination references below.

## Package references and further reading

- **vegan official function reference:** https://vegandevs.github.io/vegan/reference/
- **vegan ordination FAQ:** https://stat.ethz.ch/CRAN/web/packages/vegan/vignettes/FAQ-vegan.html
- **vegan `cca`/`rda`/`pca` reference:** https://vegandevs.github.io/vegan/reference/cca.html
- **vegan restricted permutations:** https://vegandevs.github.io/vegan/reference/permutations.html
- **vegan `adonis2`, `betadisper`, `dbrda`, `metaMDS`, `envfit`:** search these function names in the official vegan index above.
- Legendre, P. & Legendre, L. (2012). *Numerical Ecology*, 3rd English ed. Elsevier.
- Anderson, M. J. (2001). A new method for non-parametric multivariate analysis of variance. *Austral Ecology*, 26, 32–46. https://doi.org/10.1111/j.1442-9993.2001.01070.pp.x
- Anderson, M. J. (2006). Distance-based tests for homogeneity of multivariate dispersions. *Biometrics*, 62, 245–253. https://doi.org/10.1111/j.1541-0420.2005.00440.x
