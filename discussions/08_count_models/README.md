# ENTO 8030 — Discussion 08: Poisson and Negative Binomial Count Models

**Format:** Guided practicals followed by an independent analysis, consistent with Discussions 01–07. **Suggested duration:** 70 minutes. This session covers Poisson and NB2; zero-inflated models remain lecture material.

## Learning outcomes
Students will import and inspect count data; distinguish counts from effort-standardized descriptive rates; fit log-link Poisson and NB2 regressions with a log-exposure offset; diagnose dispersion, zero frequencies, and predictor-dependent residual patterns with DHARMa; interpret exponentiated coefficients and emmeans on the response scale; and produce a publication-style two-panel figure with raw observations, model predictions and 95% confidence intervals.

## Files and repository layout
Copy `Discussion_08_Count_Models.R`, `README.md`, and
`solutions/Discussion_08_Count_Models_Solutions.R` to
`discussions/08_count_models/`. The instructor will separately add the
CSV files to the course repository's **root** `data/` directory.
Run RStudio from the repository root so relative paths work. No
simulation or helper scripts are required.

```
course-repo/
├── data/
│   ├── moth_poisson_habitat.csv        # guided Poisson
│   ├── moth_nb_pesticide.csv           # guided NB2
│   ├── Horseshoecrabs.csv             # independent choice
│   ├── RoadKills.csv                  # independent choice
│   ├── Baseball.csv                   # independent choice
│   ├── Campus.csv                     # independent choice
│   └── hurricanes.csv                 # independent choice
└── discussions/08_count_models/
    ├── README.md
    ├── Discussion_08_Count_Models.R
    └── solutions/Discussion_08_Count_Models_Solutions.R
```

The two guided moth datasets are synthetic teaching examples. The five
independent-choice CSVs were supplied by the instructor and should not
be assumed to have independent observations or a known count family.
The scripts use their exact filenames and actual column names.

## Packages
`dplyr`, `ggplot2`, `glmmTMB`, `DHARMa`, `emmeans`, `patchwork`. Install missing packages once using `install.packages(c("dplyr","ggplot2","glmmTMB","DHARMa","emmeans","patchwork"))`.

## Class agenda
| Minutes | Activity |
|---|---|
| 0–5 | Review count distributions, log link, exposure offset and sampling unit |
| 5–25 | **Practical 1:** Poisson moth counts: load, explore, plot, fit, diagnose, infer, two-panel figure |
| 25–30 | Class interpretation and diagnostics checkpoint |
| 30–50 | **Practical 2:** NB2 counts: repeat workflow; fit Poisson first to expose overdispersion |
| 50–55 | Class comparison of Poisson and NB2 estimates and uncertainty |
| 55–68 | **Practical 3:** Students choose a different CSV and repeat workflow independently |
| 68–70 | Share one model choice, one effect, and one limitation |

## Guided datasets and five independent choices

| CSV file | Observational unit / response | Candidate research question | Modeling caution |
|---|---|---|---|
| `moth_poisson_habitat.csv` | Simulated trap / `Count` | Habitat and temperature vs moths per trap-night | `Days` is exposure; use offset |
| `moth_nb_pesticide.csv` | Simulated trap / `Count` | Pesticide and temperature vs moths per trap-night | Compare Poisson and NB2 on same mean model |
| `Horseshoecrabs.csv` | Female crab (173) / `Sat` | Is satellite-male abundance associated with crab `Width` and `Col`? | No exposure measure; width and weight may correlate |
| `RoadKills.csv` | Road sector (52) / `TOT.N` or `BufoCalamita` | Is roadkill abundance associated with `URBAN` and `D.WAT.RES`? | No road-length or monitoring exposure; potential spatial dependence |
| `Baseball.csv` | Team-season (838) / `runs.scored` | Does runs scored vary by `league` and `year`? | Repeated `franchise`; no games-played denominator supplied |
| `Campus.csv` | Campus (81) / `num_prop` or `num_viol` | Do property-crime rates differ by `type` and `region`? | `Enrollment` may be used as a qualified exposure proxy |
| `hurricanes.csv` | Hurricane (90) / `alldeaths` | Is death count associated with `Category` and `Year`? | Extreme counts; no population-at-risk exposure |

**Independent work:** Choose one of the five new datasets. The student
script provides a brief data dictionary, a research-question example,
a candidate model formula, and data-specific warnings for each. Students
must decide whether a log-exposure offset is justified; it is **not**
automatically included for every dataset. They then repeat the six-step
workflow and present a two-panel figure plus a concise interpretation.
The solutions file provides one worked independent example using
`Horseshoecrabs.csv`, not an answer key declaring a correct model for all
five observational datasets.

## Teaching notes
- **Data first:** inspect structure, missingness, count distribution, crude rates, and predictor-response relationships before fitting models.
- **Offset:** `offset(log(Days))` assumes expected counts are proportional to exposure, conditional on predictors. If this is implausible, the model needs reconsideration.
- **Dispersion:** Poisson conditional variance equals its mean; NB2 uses `mu + mu^2/theta`. The pooled mean/variance are not a formal dispersion diagnostic when means differ by predictors.
- **Diagnostics:** use `simulateResiduals`, `plot`, `testDispersion`, `testZeroInflation`, and `plotResiduals`. Residual diagnostics cannot establish independence from a flawed experimental design. A nonsignificant test does not prove correct specification.
- **Inference:** exponentiated slopes are multiplicative rate ratios; estimated marginal means at `Days = 1` are rates per trap-night. Report reference levels and confidence intervals.
- **Figures:** the plotted raw `Count/Days` is descriptive; fit the original integer `Count` with an exposure offset. The 95% ribbons describe uncertainty about the fitted mean, not the range of future individual counts. Do not add smoothers that refit a different model from the one diagnosed.
- **Student deliverable:** one composite figure and a three-sentence explanation of model choice, effect magnitude, and limitation. Independent examples may contain repeated, spatially clustered, or otherwise dependent observations; students must state limitations rather than treating Poisson/NB2 as a cure for design problems.

## Basis for instructional sequence
Adapted in teaching structure (not copied verbatim) from the supplied **Practical: Poisson and NB regression**, **Practical: residual diagnostics in GLMs**, and **Count Data Solutions** R Markdown. These references motivate progressing from data exploration to Poisson regression, assessing residual dispersion, considering NB2, interpreting coefficients and confidence intervals, and plotting fitted relationships.

## Validation
The files were checked for consistent paths, filenames, and code organization. The R scripts have **not** been executed in R in this environment; instructors should run the solutions script once before class. DHARMa simulation p-values may vary slightly with package version and RNG.
