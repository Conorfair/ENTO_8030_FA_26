# ============================================================
# ENTO 8030 - Applied Statistics
# Discussion 01
#
# GitHub, R Projects, and Getting Help in R
# ============================================================


# ------------------------------------------------------------
# 1. R Projects and Working Directories
# ------------------------------------------------------------

# Where does R think we are?
getwd()

# What files and folders are in our project?
list.files()

# What files are contained within those folders?
list.files(recursive = TRUE)


# ------------------------------------------------------------
# 2. Import Data
# ------------------------------------------------------------

dat <- read.csv("data/week01_example.csv")


# ------------------------------------------------------------
# 3. Examine the Data
# ------------------------------------------------------------

dat

head(dat)

str(dat)

summary(dat)


# ------------------------------------------------------------
# 4. Create Output Directories
# ------------------------------------------------------------

dir.create(
  "output/figures",
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  "output/tables",
  recursive = TRUE,
  showWarnings = FALSE
)

# ------------------------------------------------------------
# 5. Working with Objects
# ------------------------------------------------------------

# Examine one variable
dat$Mortality

# Calculate its mean
mean(dat$Mortality)

# Calculate the standard deviation
sd(dat$Mortality)

# Calculate treatment means
aggregate(
  Mortality ~ Treatment,
  data = dat,
  FUN = mean
)


# ------------------------------------------------------------
# 6. Getting Help in R
# What if I don't know how mean() works?
# ------------------------------------------------------------

?mean

help(mean)

args(mean)

example(mean)

mean(c(1, 2, NA, 4))

# How would we figure out how to calculate this mean while ignoring the missing value?


mean(c(1, 2, NA, 4), na.rm = TRUE)


# Package Help

help(package = "stats")

vignette(package = "ggplot2")

# R and its packages come with documentation. Searching Google or asking AI should not automatically be your first response when you don't recognize a function.

# ------------------------------------------------------------
# 7. Create a Figure
# ------------------------------------------------------------

boxplot(
  Mortality ~ Treatment,
  data = dat,
  xlab = "Treatment",
  ylab = "Mortality"
)

# Save the figure

png(
  "output/figures/week01_mortality.png",
  width = 800,
  height = 600
)

boxplot(
  Mortality ~ Treatment,
  data = dat,
  xlab = "Treatment",
  ylab = "Mortality"
)

dev.off()

list.files(recursive = TRUE)


# Git commit language
# In the Git pane you can review the files in the repository
# You can select the file you want to stage, click "Commit" and potentially include a message describing the commit