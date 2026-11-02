# ============================================================
# ENTO 8030 — Discussion 06
# Advanced ggplot2 Skills
# STUDENT VERSION
# ============================================================

# TEACHING PHILOSOPHY ----------------------------------------------------
#
# Each skill follows the same cycle:
#
# SHOW  — instructor demonstrates the skill and explains where the change
#         occurs in the ggplot code.
#
# DO    — students apply the same idea to a different figure without
#         copying the demonstration.
#
# TEACH — students explain what they changed, where they changed it,
#         and why the change affects interpretation or presentation.
#
# The goal is not to memorize ggplot syntax. The goal is to learn how to
# diagnose a figure, identify the component that needs to change, and
# explain the code used to make that change.

# LEARNING GOALS ---------------------------------------------------------
# By the end of this discussion, you should be able to:
# 1. Identify whether a figure change belongs in a geom, scale, labs,
#    theme, facet, or patchwork function.
# 2. Apply built-in themes and customize individual theme elements.
# 3. Reduce overplotting and display distributions more effectively.
# 4. Apply accessible color palettes.
# 5. Use facets and multi-panel layouts deliberately.
# 6. Explain HOW you modified a figure and WHY you made that choice.

# PACKAGES ---------------------------------------------------------------

# Install once if needed:
# install.packages(c(
#   "tidyverse", "here", "palmerpenguins", "ggbeeswarm",
#   "RColorBrewer", "viridis", "patchwork"
# ))

library(tidyverse)
library(here)
library(palmerpenguins)
library(ggbeeswarm)
library(RColorBrewer)
library(viridis)
library(patchwork)

penguins <- palmerpenguins::penguins %>%
  drop_na(flipper_length_mm, body_mass_g, bill_length_mm,
          bill_depth_mm, species, sex)

# A useful mental map:
#
# geom_*()   = HOW the data are drawn
# scale_*()  = HOW data values map to color/fill/etc.
# labs()     = WHAT labels and titles say
# theme()    = HOW non-data elements look
# facet_*()  = HOW data are separated into panels
# patchwork  = HOW complete ggplots are arranged together


# ============================================================
# 1. THEMES AND TARGETED FORMATTING
# ============================================================

# ---------------------------- SHOW ---------------------------
# Start with a complete figure, then change only the elements
# needed for the communication goal.

show_theme <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", se = TRUE) +
  theme_classic() +
  labs(
    title = "Flipper Length and Body Mass",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  )

show_theme

# Built-in themes change many non-data elements at once.
show_theme + theme_bw()
show_theme + theme_minimal()

# Individual elements are modified inside theme().
show_theme_formatted <- show_theme +
  theme(
    text = element_text(size = 13),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "top"
  )

show_theme_formatted

# Notice:
# - Nothing about the observations changed.
# - theme() changed non-data elements.
# - labs() would be used if we wanted to change the WORDING of a label.


# ----------------------------- DO ----------------------------
# Apply the same ideas to a DIFFERENT figure.

do_theme <- ggplot(
  penguins,
  aes(x = species, y = bill_length_mm, fill = species)
) +
  geom_boxplot() +
  theme_bw() +
  labs(
    title = "Bill Length by Penguin Species",
    x = "Species",
    y = "Bill Length (mm)",
    fill = "Species"
  )

do_theme

# MODIFY do_theme so that:
# 1. The title is centered and bold.
# 2. Axis titles are bold.
# 3. Axis text is black.
# 4. The redundant legend is removed.
# 5. Minor grid lines are removed.
# 6. Overall text size is increased.
#
# Do not rebuild the plot from scratch.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Explain your changes to a partner WITHOUT simply reading your code.
#
# 1. Which function contained most of your modifications?
#
# 2. Why did removing the legend make sense for this figure?
#
# 3. What is the difference between changing text with labs() and
#    changing text appearance with theme()?
#
# 4. Point to one line of your code and explain:
#       "This line changes ______ by ______."


# ============================================================
# 2. REDUCING OVERPLOTTING
# ============================================================

# ---------------------------- SHOW ---------------------------
# Ordinary points can overlap when observations share the same x value.

show_points <- ggplot(
  penguins,
  aes(x = species, y = body_mass_g, color = sex)
) +
  geom_jitter(width = 0.15, alpha = 0.6) +
  theme_classic() +
  labs(
    x = "Species",
    y = "Body Mass (g)",
    color = "Sex"
  )

show_points

# ggbeeswarm provides alternatives that deliberately arrange points
# so that individual observations are easier to see.

show_beeswarm <- ggplot(
  penguins,
  aes(x = species, y = body_mass_g, color = sex)
) +
  geom_beeswarm(
    size = 2,
    alpha = 0.7,
    dodge.width = 0.8
  ) +
  theme_classic() +
  labs(
    x = "Species",
    y = "Body Mass (g)",
    color = "Sex"
  )

show_beeswarm

show_quasirandom <- ggplot(
  penguins,
  aes(x = species, y = body_mass_g, color = sex)
) +
  geom_quasirandom(
    size = 2,
    alpha = 0.7,
    dodge.width = 0.8
  ) +
  theme_classic() +
  labs(
    x = "Species",
    y = "Body Mass (g)",
    color = "Sex"
  )

show_quasirandom

# size controls point size.
# alpha controls transparency.
# dodge.width separates groups mapped to color within each x category.


# ----------------------------- DO ----------------------------
# Use BILL DEPTH rather than body mass for a new example.

do_overlap <- ggplot(
  penguins,
  aes(x = species, y = bill_depth_mm, color = sex)
) +
  geom_point() +
  theme_classic() +
  labs(
    x = "Species",
    y = "Bill Depth (mm)",
    color = "Sex"
  )

do_overlap

# MODIFY do_overlap so that:
# 1. Individual observations are easier to distinguish.
# 2. Sexes remain separated within species.
# 3. Points are partially transparent.
# 4. The legend is moved to the top.
# 5. The legend title becomes "Penguin sex".
#
# Choose geom_beeswarm() OR geom_quasirandom().

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Explain:
#
# 1. Which geom did you choose, and why?
#
# 2. What did alpha change?
#
# 3. What did dodge.width change?
#
# 4. Did you change the DATA, or only how the observations are displayed?
#
# 5. When might an ordinary geom_point() be preferable?


# ============================================================
# 3. SHOWING DISTRIBUTION SHAPE
# ============================================================

# ---------------------------- SHOW ---------------------------

show_boxplot <- ggplot(
  penguins,
  aes(x = species, y = body_mass_g, fill = species)
) +
  geom_boxplot() +
  theme_classic() +
  theme(legend.position = "none") +
  labs(
    x = "Species",
    y = "Body Mass (g)"
  )

show_boxplot

show_violin <- ggplot(
  penguins,
  aes(x = species, y = body_mass_g, fill = species)
) +
  geom_violin(alpha = 0.65) +
  theme_classic() +
  theme(legend.position = "none") +
  labs(
    x = "Species",
    y = "Body Mass (g)"
  )

show_violin

# Boxplot:
# - makes median and quartiles explicit.
#
# Violin:
# - emphasizes the shape/density of the observed distribution.
#
# Neither is universally "better"; the geom should match the information
# you want readers to see.


# ----------------------------- DO ----------------------------

do_distribution <- ggplot(
  penguins,
  aes(x = species, y = flipper_length_mm, fill = sex)
)

# Create a violin plot from do_distribution.
#
# Requirements:
# 1. Fill should represent sex.
# 2. Use partial transparency.
# 3. Use theme_classic().
# 4. Add informative axis labels.
# 5. Put the legend on the right.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Explain to a partner:
#
# 1. What information does the WIDTH of a violin communicate?
#
# 2. What would be easier to identify from a boxplot?
#
# 3. What would be easier to identify from the violin plot?
#
# 4. If you were writing a manuscript, how would you justify your choice?


# ============================================================
# 4. ACCESSIBLE COLOR PALETTES
# ============================================================

# ---------------------------- SHOW ---------------------------

show_color <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point(alpha = 0.7, size = 2) +
  theme_classic() +
  labs(
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  )

show_color

# Brewer palette:
show_color +
  scale_color_brewer(palette = "Set1")

# Viridis discrete palette:
show_color +
  scale_color_viridis_d(option = "H")

# Manual accessible palette:
accessible_colors <- c(
  "Adelie" = "#E69F00",
  "Chinstrap" = "#56B4E9",
  "Gentoo" = "#009E73"
)

show_color +
  scale_color_manual(values = accessible_colors)

# Key idea:
# scale_color_*() changes how the levels of the DATA are mapped to colors.
# theme() would not be the correct place to change a data-based color scale.


# ----------------------------- DO ----------------------------

do_color <- ggplot(
  penguins,
  aes(x = bill_length_mm, y = bill_depth_mm, color = species)
) +
  geom_point() +
  theme_classic() +
  labs(
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species"
  )

do_color

# MODIFY do_color:
# 1. Apply a discrete viridis palette.
# 2. Make points slightly larger.
# 3. Make points partially transparent.
# 4. Move the legend to the bottom.
#
# Then create a SECOND version using accessible_colors instead.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Explain:
#
# 1. Why was scale_color_*() used instead of theme()?
#
# 2. Why did we use a DISCRETE viridis scale?
#
# 3. What does alpha control?
#
# 4. Which palette would you choose for this figure and why?
#
# Avoid the answer "because it looks better." Be specific.


# ============================================================
# 5. FACETING
# ============================================================

# ---------------------------- SHOW ---------------------------

show_facet <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", se = TRUE) +
  facet_wrap(~ species) +
  scale_color_manual(values = accessible_colors) +
  theme_classic() +
  theme(legend.position = "none") +
  labs(
    x = "Flipper Length (mm)",
    y = "Body Mass (g)"
  )

show_facet

# Format the facet strips and panel spacing.
show_facet_formatted <- show_facet +
  theme(
    strip.text = element_text(face = "bold"),
    strip.background = element_rect(fill = "lightgray"),
    panel.spacing = unit(1, "lines")
  )

show_facet_formatted

# Compare fixed and free scales.
show_facet
show_facet + facet_wrap(~ species, scales = "free")

# Free scales can reveal within-panel patterns but make direct comparisons
# of absolute magnitudes among panels more difficult.


# ----------------------------- DO ----------------------------

do_facet <- ggplot(
  penguins,
  aes(x = bill_length_mm, y = bill_depth_mm, color = sex)
) +
  geom_point(alpha = 0.65) +
  theme_classic() +
  labs(
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Sex"
  )

do_facet

# MODIFY do_facet:
# 1. Create one panel per species.
# 2. Keep the SAME x and y scales among panels.
# 3. Make facet labels bold.
# 4. Add spacing between panels.
# 5. Move the sex legend to the top.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Explain:
#
# 1. What variable determines the panels?
#
# 2. Why did you keep common scales?
#
# 3. What comparison becomes easier after faceting?
#
# 4. What information may become harder to see after splitting the data
#    into panels?


# ============================================================
# 6. COMBINING FIGURES WITH PATCHWORK
# ============================================================

# ---------------------------- SHOW ---------------------------
# First, create two COMPLETE plots that use the SAME variable mapped
# to the SAME aesthetic: color = species.

show_panel_a <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point(alpha = 0.65) +
  scale_color_manual(values = accessible_colors) +
  theme_classic() +
  labs(
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  )

show_panel_b <- ggplot(
  penguins,
  aes(x = bill_length_mm, y = bill_depth_mm, color = species)
) +
  geom_point(alpha = 0.65) +
  scale_color_manual(values = accessible_colors) +
  theme_classic() +
  labs(
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species"
  )

# Combine them WITHOUT collecting guides.
show_panel_a + show_panel_b

# Both panels map species to COLOR using the same scale, so each plot
# initially produces the same Species color legend.

# Now tell patchwork to collect compatible guides.
show_combined <- (
  show_panel_a + show_panel_b +
    plot_layout(guides = "collect") +
    plot_annotation(
      title = "Penguin Body Morphology",
      tag_levels = "A"
    )
) &
  theme(legend.position = "bottom")

show_combined

# What did guides = "collect" do?
#
# It identified the compatible/redundant Species color guides from the
# two plots and displayed one shared guide for the combined figure.
#
# IMPORTANT:
# guides = "collect" does NOT mean "force every legend into one legend."
# The guides need to be compatible. For example, a fill guide from one
# plot and a color guide from another are different guides and may remain
# separate even when they represent the same variable.

# patchwork combines COMPLETE ggplot objects.
# plot_layout() controls arrangement and guide collection.
# plot_annotation() controls figure-level titles and panel tags.
# The & operator can apply a theme change across the combined figure.


# ----------------------------- DO ----------------------------
# Now apply the same idea to two different bill-morphology figures.
#
# In BOTH plots, species is mapped to COLOR so the resulting guides
# are compatible and can be collected.

do_panel_a <- ggplot(
  penguins,
  aes(x = species, y = bill_length_mm, color = species)
) +
  geom_boxplot() +
  scale_color_manual(values = accessible_colors) +
  theme_classic() +
  labs(
    x = "Species",
    y = "Bill Length (mm)",
    color = "Species"
  )

do_panel_b <- ggplot(
  penguins,
  aes(x = bill_length_mm, y = bill_depth_mm, color = species)
) +
  geom_point(alpha = 0.65) +
  scale_color_manual(values = accessible_colors) +
  theme_classic() +
  labs(
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species"
  )

# FIRST:
# Combine do_panel_a and do_panel_b WITHOUT guides = "collect".
# Confirm that each panel produces its own Species legend.

# YOUR CODE:


# SECOND:
# Modify the combined figure so that:
# 1. The plots remain side-by-side.
# 2. Compatible Species guides are collected into one shared legend.
# 3. The shared legend appears at the bottom.
# 4. Panel tags A and B are added.
# 5. The title is "Penguin Bill Morphology".

# YOUR CODE:


# --------------------- WHY GUIDES MAY NOT COLLECT ----------------------
# Compare the example above with this alternative Panel A:

do_panel_a_fill <- ggplot(
  penguins,
  aes(x = species, y = bill_length_mm, fill = species)
) +
  geom_boxplot() +
  scale_fill_manual(values = accessible_colors) +
  theme_classic() +
  labs(
    x = "Species",
    y = "Bill Length (mm)",
    fill = "Species"
  )

# Here Panel A maps species to FILL, while do_panel_b maps species to COLOR.
# Try collecting the guides:

do_panel_fill_color <- (
  do_panel_a_fill + do_panel_b +
    plot_layout(guides = "collect") +
    plot_annotation(
      title = "Penguin Bill Morphology",
      tag_levels = "A"
    )
) &
  theme(legend.position = "bottom")

do_panel_fill_color

# The two guides are not redundant copies:
#
# Panel A: species -> fill
# Panel B: species -> color
#
# Therefore, guides = "collect" does not automatically turn them into
# one common legend.
#
# In this particular figure, the fill legend in Panel A is also redundant
# because species is already labeled on the x-axis. A cleaner alternative
# is to remove that legend and retain the useful color legend from Panel B.

do_panel_a_fill_clean <- do_panel_a_fill +
  theme(legend.position = "none")

do_panel_clean <- (
  do_panel_a_fill_clean + do_panel_b +
    plot_annotation(
      title = "Penguin Bill Morphology",
      tag_levels = "A"
    )
) &
  theme(legend.position = "bottom")

do_panel_clean


# --------------------------- TEACH ---------------------------
# Explain:
#
# 1. Which code controls the individual plots?
#
# 2. Which code controls the combined figure?
#
# 3. What does guides = "collect" accomplish?
#
# 4. Why could patchwork collect the guides when BOTH plots mapped
#    species to color?
#
# 5. Why did the fill + color example still produce two guides?
#
# 6. Why might removing a redundant legend be preferable to trying
#    to force every guide into a single legend?
#
# 7. Why should two panels be combined only when they contribute
#    complementary information?


# ============================================================
# 7. APPLY THE WORKFLOW: MOTH-FLUSH DATA
# ============================================================

moth_flush <- read.csv(
  here("data", "moth_flush_data.csv")
)

glimpse(moth_flush)

# ---------------------------- SHOW ---------------------------
# We will combine several skills in one example.

show_moth <- ggplot(
  moth_flush,
  aes(x = Treatment, y = Moth_Flush, fill = Treatment)
) +
  geom_boxplot(
    outlier.shape = NA,
    alpha = 0.65
  ) +
  geom_quasirandom(
    aes(color = Treatment),
    width = 0.18,
    alpha = 0.50,
    size = 1.8,
    show.legend = FALSE
  ) +
  scale_fill_viridis_d(option = "D") +
  scale_color_viridis_d(option = "D") +
  theme_classic(base_size = 13) +
  theme(
    legend.position = "none",
    axis.title.y = element_text(face = "bold")
  ) +
  labs(
    x = "Treatment",
    y = "Moth Flush"
  )

show_moth

# What happened?
#
# geom_boxplot()       -> summarized the distribution.
# geom_quasirandom()   -> showed the individual observations.
# scale_*_viridis_d()  -> mapped treatment levels to accessible colors.
# theme()              -> changed non-data formatting.
# labs()               -> supplied readable labels.
#
# outlier.shape = NA prevents boxplot outlier points from being drawn
# separately when every raw observation is already displayed.


# ----------------------------- DO ----------------------------
# Create a NEW figure showing Moth_Flush among Crop groups.

do_moth <- ggplot(
  moth_flush,
  aes(x = Crop, y = Moth_Flush, fill = Crop)
)

# Complete the figure so that:
# 1. A boxplot summarizes each crop.
# 2. Raw observations are visible without severe overlap.
# 3. The colors are accessible.
# 4. The redundant crop legend is removed.
# 5. The theme and text are appropriate for a manuscript figure.
# 6. The axes have informative labels.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Without looking at the SHOW code, explain your figure from the outside in:
#
# 1. What scientific comparison does the figure make?
#
# 2. Which geom displays the summary?
#
# 3. Which geom displays individual observations?
#
# 4. Where did you control the colors?
#
# 5. Where did you control the legend?
#
# 6. Where did you control the wording of the axes?
#
# 7. Identify one formatting choice you made for CLARITY rather than
#    because it was required by the code.


# ============================================================
# 8. FINAL CHALLENGE — DO + TEACH
# ============================================================

# Build a publication-style figure using the moth-flush data.
#
# Your figure must communicate at least TWO distinct biological patterns.
# Examples:
# - treatment differences;
# - crop differences;
# - association with temperature;
# - seasonal pattern across Sampling_Day;
# - variation among blocks.
#
# Requirements:
# 1. Include at least two panels.
# 2. Use a consistent theme.
# 3. Use accessible colors.
# 4. Show raw observations where appropriate.
# 5. Remove redundant legends.
# 6. Use informative labels.
# 7. Add panel tags.
# 8. Add one overall figure title.
#
# There is NOT one correct figure.

# YOUR CODE:


# --------------------------- TEACH ---------------------------
# Present your figure to another student/group.
#
# Do NOT begin by reading your code.
#
# First explain:
# 1. What biological question does the figure communicate?
# 2. What should the reader notice first?
#
# Then explain the code:
# 3. Which geoms did you choose and why?
# 4. Which scale functions did you use and why?
# 5. Which theme changes did you make?
# 6. How did you organize the panels?
# 7. What did you intentionally remove?
#
# Finally:
# 8. Name ONE change your partner suggests.
# 9. Decide whether you would adopt that change and explain why.


# ============================================================
# TAKE-HOME: DIAGNOSE BEFORE YOU FORMAT
# ============================================================

# When you want to modify a ggplot, first ask:
#
# "WHAT am I trying to change?"
#
# Data representation?       -> geom_*()
# Color/fill mapping?        -> scale_*()
# Wording?                   -> labs()
# Non-data appearance?       -> theme()
# Separate panels?           -> facet_*()
# Multiple complete plots?   -> patchwork
#
# Then ask:
#
# "WHY am I making this change?"
#
# ACCURATE   — does the figure represent the data appropriately?
# ACCESSIBLE — can readers distinguish the important information?
# CLEAR      — does the formatting support the scientific message?
#
# You should be able to explain both the HOW and the WHY.
