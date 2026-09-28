# Discussion 06 --- Advanced ggplot2 Skills

## Overview

This discussion uses a **Show One → Do One → Teach One** structure to
develop advanced `ggplot2` skills.

The goal is not for students to follow a completed plotting script
line-by-line. Each major skill is first demonstrated with one figure,
then applied by students to a different figure, and finally explained in
their own words.

The repeated cycle is:

**SHOW → DO → TEACH**

-   **SHOW:** the instructor demonstrates a plotting or formatting skill
    and identifies where that change occurs in the `ggplot2` code.
-   **DO:** students apply the same principle to a new figure without
    copying the demonstration.
-   **TEACH:** students explain what they changed, where they changed it
    in the code, and why the modification affects the communication of
    the data.

A student should leave the discussion able to say more than *"I used
this code because that was the example."* The goal is to be able to
diagnose a figure and explain both **how** and **why** it was modified.

## Learning objectives

By the end of the discussion, students should be able to:

-   identify whether a desired change belongs in a `geom_*()`,
    `scale_*()`, `labs()`, `theme()`, `facet_*()`, or `patchwork`
    function;
-   apply built-in themes and modify individual non-data figure
    elements;
-   reduce overplotting with beeswarm or quasirandom point arrangements;
-   compare alternative representations of a distribution;
-   apply accessible discrete color palettes;
-   use faceting while explaining the consequences of panel structure
    and scale choices;
-   combine complementary plots into a multi-panel figure; and
-   verbally explain the code and scientific rationale behind their
    formatting decisions.

## Files

-   `Discussion_06_Advanced_ggplot2.R` --- student script containing
    demonstrations, new applications, and peer-explanation prompts.
-   `Discussion_06_Advanced_ggplot2_Solutions.R` --- instructor version
    containing suggested solutions for the **DO** exercises.
-   `data/simulated_moth_flush_data.csv` --- simulated dataset used for
    the applied portion of the discussion.

The guided examples use `palmerpenguins::penguins`.

## Required packages

``` r
install.packages(c(
  "tidyverse",
  "here",
  "palmerpenguins",
  "ggbeeswarm",
  "RColorBrewer",
  "viridis",
  "patchwork"
))
```

Load them with:

``` r
library(tidyverse)
library(here)
library(palmerpenguins)
library(ggbeeswarm)
library(RColorBrewer)
library(viridis)
library(patchwork)
```

## Before class

1.  Pull the newest version of the ENTO 8030 course repository.
2.  Confirm that `data/simulated_moth_flush_data.csv` is available.
3.  Copy `Discussion_06_Advanced_ggplot2.R` into your private ENTO 8030
    repository.
4.  Copy `moth_flush_data.csv` into the `data/` folder of your private ENTO 8030 repository.    
5.  Open your personal R Project.
6.  Run the package-loading section and confirm that all packages load.
7.  Confirm that R can locate the moth-flush dataset:

## The ggplot mental map

Students should repeatedly return to this question:

> **What am I trying to change?**

A useful guide is:

  Goal                                          Where to look
  --------------------------------------------- ---------------
  Change how observations/summaries are drawn   `geom_*()`
  Change mapping of values to color/fill        `scale_*()`
  Change wording of labels/titles               `labs()`
  Change non-data appearance                    `theme()`
  Separate data into panels                     `facet_*()`
  Arrange complete figures                      `patchwork`

The discussion intentionally asks students to identify the appropriate
component before changing code.

## Discussion structure

### 1. Themes and targeted formatting

**SHOW:** Format a flipper-length/body-mass scatterplot using built-in
themes and individual `theme()` elements.

**DO:** Apply the same concepts to a bill-length boxplot.

**TEACH:** Explain the distinction between `labs()` and `theme()`, why a
redundant legend was removed, and which code controls each modification.

### 2. Reducing overplotting

**SHOW:** Compare jittered points, beeswarm points, and quasirandom
points using body mass.

**DO:** Choose and apply an overlap-reducing geom to a different
response: bill depth.

**TEACH:** Explain the selected geom, `alpha`, `dodge.width`, and
whether the underlying data changed.

### 3. Showing distribution shape

**SHOW:** Compare boxplots and violin plots of body mass.

**DO:** Construct a violin plot of flipper length.

**TEACH:** Explain what violin width represents and what information is
emphasized or de-emphasized relative to a boxplot.

### 4. Accessible color palettes

**SHOW:** Compare Brewer, viridis, and a manually specified accessible
palette.

**DO:** Apply both viridis and manual palettes to a different
bill-morphology scatterplot.

**TEACH:** Explain why the modification belongs in `scale_color_*()`
rather than `theme()`, why the scale is discrete, and which palette is
preferred for the figure.

### 5. Faceting

**SHOW:** Separate the flipper-length/body-mass relationship by species
and format the facet strips.

**DO:** Facet a bill-morphology figure by species.

**TEACH:** Explain the panel variable, the choice to retain common
scales, and what becomes easier or harder to compare after faceting.

### 6. Patchwork

**SHOW:** Combine a distribution plot and scatterplot into a tagged,
multi-panel figure with a shared legend.

**DO:** Combine two different bill-morphology plots.

**TEACH:** Distinguish code that controls individual panels from code
that controls the combined figure.

### 7. Applied moth-flush example

**SHOW:** Build a polished treatment figure that combines a boxplot, raw
quasirandom observations, accessible colors, labels, and theme
formatting.

**DO:** Recreate the same general communication strategy for crop
differences without copying the treatment code directly.

**TEACH:** Explain the completed figure from the scientific question
outward: summary geom, raw-data geom, scales, legend, labels, and
clarity choices.

### 8. Final challenge

Students construct a multi-panel moth-flush figure communicating at
least two biological patterns.

The final activity combines **DO** and **TEACH**. Students first build
the figure independently and then present it to another student or
group. They should explain the scientific message before explaining the
code.

Peer feedback should result in one proposed revision. The student then
decides whether to adopt the suggestion and explains that decision.

## Expectations for the TEACH step

Students should avoid explanations such as:

> "I changed this because the instructions said to."

Instead, aim for explanations such as:

> "I used `theme(legend.position = "none")` because species was already
> identified on the x-axis, so the legend repeated information that was
> already visible."

or:

> "I used `scale_color_viridis_d()` because species is a discrete
> variable and the scale controls how the species levels are mapped to
> colors."

A useful explanation has three parts:

**WHAT changed → HOW the code changed it → WHY the change helps the
figure**

## Take-home framework

When modifying a figure, ask two questions.

### 1. What am I trying to change?

**Data representation → geom**\
**Color/fill mapping → scale**\
**Wording → labs**\
**Non-data appearance → theme**\
**Separate panels → facet**\
**Multiple plots → patchwork**

### 2. Why am I changing it?

-   **Accurate:** Does the figure represent the data appropriately?
-   **Accessible:** Can readers distinguish the important information?
-   **Clear:** Does the formatting support the scientific message?

Students should be able to explain both the **HOW** and the **WHY** of a
finished figure.
