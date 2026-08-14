# ============================================================
# ENTO 8030 - Applied Statistics for Graduate Students
# Discussion 01
#
# GitHub, R Projects, and Getting Help in R
# ============================================================
#
# Goals for today's discussion:
#
# By the end of this session, you should be able to:
#
# 1. Explain the roles of R, RStudio, R Projects, Git, and GitHub.
# 2. Open and navigate an R Project.
# 3. Explain why relative file paths are useful.
# 4. Import and inspect a dataset in R.
# 5. Recognize objects, functions, and arguments in R code.
# 6. Use R's built-in help system.
# 7. Create your own GitHub repository for ENTO 8030.
# 8. Connect a GitHub repository to an R Project.
# 9. Make a Git commit.
# 10. Push a commit to GitHub.
#
# ============================================================



# ============================================================
# PART I: THE COURSE REPOSITORY
# ============================================================


# ------------------------------------------------------------
# 1. R, RSTUDIO, R PROJECTS, GIT, AND GITHUB
# ------------------------------------------------------------
#
# R
#   The programming language that performs our analyses.
#
# RStudio
#   The interface we use to write and run R code.
#
# R Project
#   Defines the working directory for a particular project.
#
# Git
#   Tracks changes to files over time.
#
# GitHub
#   Stores and shares Git repositories online.
#
#
# A simplified workflow:
#
# GitHub repository
#       |
#       | clone / pull
#       v
# Local R Project
#       |
#       | edit files
#       v
# Git commit
#       |
#       | push
#       v
# GitHub repository
#
#
# DISCUSSION:
#
# What advantages might this workflow have compared with keeping
# files scattered across your Desktop, Downloads, email, etc.?



# ------------------------------------------------------------
# 2. WHERE DOES R THINK WE ARE?
# ------------------------------------------------------------

# Every R session has a working directory.
#
# Opening an R Project establishes the project directory as the
# working directory.

getwd()


# What files and folders are in the project?

list.files()


# What files are contained inside those folders?

list.files(recursive = TRUE)


# CHECKPOINT:
#
# You should see folders such as:
#
# data
# discussions
# output
# resources
#
# You should also see the .Rproj file and README.md.



# ------------------------------------------------------------
# 3. RELATIVE FILE PATHS
# ------------------------------------------------------------
#
# Because we opened an R Project, R already knows where the
# project begins.
#
# Therefore:
#
# data/week01_example.csv
#
# means:
#
# "Start in this project, enter the data folder, and find
# week01_example.csv."
#
#
# Avoid:
#
# setwd("/Users/YourName/Desktop/MyResearch/")
#
# or:
#
# read.csv("C:/Users/YourName/Desktop/MyResearch/data.csv")
#
#
# Those paths refer to one particular computer.
#
# Relative paths make analyses easier to share and reproduce.



# ------------------------------------------------------------
# 4. IMPORT DATA
# ------------------------------------------------------------

dat <- read.csv("data/week01_example.csv")


# What happened above?
#
# read.csv() is a FUNCTION.
#
# "data/week01_example.csv" is an ARGUMENT.
#
# <- assigns the result to an OBJECT called dat.


dat



# ------------------------------------------------------------
# 5. EXAMINE THE DATA
# ------------------------------------------------------------

head(dat)

str(dat)

summary(dat)


# DISCUSSION:
#
# How many observations are present?
#
# How many variables are present?
#
# What type of variable is Treatment?
#
# What type of variable is Mortality?



# ============================================================
# PART II: BASIC R AND GETTING HELP
# ============================================================


# ------------------------------------------------------------
# 6. OBJECTS, VARIABLES, AND FUNCTIONS
# ------------------------------------------------------------

# Access one variable from the data frame.

dat$Mortality


# Calculate its mean.

mean(dat$Mortality)


# Save the result as another object.

overall_mean <- mean(dat$Mortality)

overall_mean


# A useful way to read R code is:
#
# result <- function(object)
#
# For example:
#
# overall_mean <- mean(dat$Mortality)



# ------------------------------------------------------------
# 7. GETTING HELP IN R
# ------------------------------------------------------------
#
# You are NOT expected to memorize every R function.
#
# An important skill is learning how to find reliable
# documentation.


?mean


# Equivalent:

help(mean)


# Examine the arguments accepted by the function.

args(mean)


# Run examples supplied with R.

example(mean)


# Important sections of an R help page commonly include:
#
# Description
# Usage
# Arguments
# Details
# Value
# Examples



# ------------------------------------------------------------
# 8. USE DOCUMENTATION TO SOLVE A PROBLEM
# ------------------------------------------------------------

x <- c(1, 2, NA, 4)

x


# What happens?

mean(x)


# QUESTION:
#
# Use the help page for mean() to determine how to calculate
# the mean while ignoring the missing value.
#
# Start with:
#
# ?mean


# YOUR CODE:




# SOLUTION:

mean(x, na.rm = TRUE)



# ============================================================
# PART III: CREATE YOUR PERSONAL ENTO 8030 REPOSITORY
# ============================================================
#
# We will use TWO repositories during this course.
#
#
# COURSE REPOSITORY
#
# ENTO_8030_FA_26
#
# Purpose:
#   Receive datasets, scripts, examples, and course materials.
#
# You will primarily PULL from this repository.
#
#
# YOUR PERSONAL REPOSITORY
#
# Suggested name:
#
# ENTO_8030_Work
#
# or:
#
# YourName_ENTO8030
#
# Purpose:
#   Store your own course work and practice using Git.
#
# You will COMMIT and PUSH to this repository.



# ------------------------------------------------------------
# 9. CREATE A GITHUB REPOSITORY
# ------------------------------------------------------------
#
# In your web browser:
#
# 1. Sign into GitHub.
#
# 2. Select:
#
#       New repository
#
# 3. Give the repository a name such as:
#
#       ENTO_8030_Work
#
# 4. Add a description if desired.
#
# 5. Select PUBLIC or PRIVATE as directed by the instructor.
#
# 6. Initialize the repository with a README.
#
# 7. Add the R .gitignore.
#
# 8. Create the repository.
#
#
# STOP HERE until everyone has created a repository.



# ------------------------------------------------------------
# 10. COPY THE REPOSITORY URL
# ------------------------------------------------------------
#
# On your new GitHub repository:
#
# 1. Click the green "Code" button.
#
# 2. Select HTTPS.
#
# 3. Copy the repository URL.
#
# It should look similar to:
#
# https://github.com/YourUsername/ENTO_8030_Work.git



# ============================================================
# IMPORTANT:
#
# We are now going to create a NEW R Project.
#
# The R session containing this script belongs to the COURSE
# repository.
#
# Save anything you need before continuing.
# ============================================================



# ------------------------------------------------------------
# 11. CLONE YOUR PERSONAL REPOSITORY
# ------------------------------------------------------------
#
# In RStudio:
#
# File
#   ->
# New Project
#   ->
# Version Control
#   ->
# Git
#
#
# Paste your repository URL.
#
# Choose where you want the repository stored.
#
# Select:
#
# Create Project
#
#
# RStudio should now open YOUR personal repository as a
# new R Project.



# ============================================================
# PART IV: WORKING IN YOUR PERSONAL REPOSITORY
# ============================================================
#
# IMPORTANT:
#
# The remaining commands should be completed inside YOUR
# personal ENTO 8030 repository.
# ============================================================



# ------------------------------------------------------------
# 12. VERIFY YOUR NEW R PROJECT
# ------------------------------------------------------------

getwd()

list.files()


# DISCUSSION:
#
# Compare the result of getwd() with the result from the
# beginning of class.
#
# Why did it change?



# ------------------------------------------------------------
# 13. CREATE YOUR FIRST R SCRIPT
# ------------------------------------------------------------
#
# In RStudio:
#
# File -> New File -> R Script
#
#
# Save the file as:
#
# Discussion_01_Practice.R
#
#
# Add the following code to that script:
#
#
# # ENTO 8030
# # Discussion 01 Git Practice
#
# x <- c(1, 2, 3, 4, 5)
#
# mean(x)
#
#
# SAVE THE FILE.



# ------------------------------------------------------------
# 14. CHECK GIT
# ------------------------------------------------------------
#
# Open the Git pane in RStudio.
#
# You should see:
#
# Discussion_01_Practice.R
#
# listed as a changed or untracked file.
#
#
# Git knows that something in the repository has changed.



# ------------------------------------------------------------
# 15. STAGE THE FILE
# ------------------------------------------------------------
#
# In the Git pane:
#
# Check the box beside:
#
# Discussion_01_Practice.R
#
#
# This STAGES the file.
#
# Staging tells Git:
#
# "Include this change in my next commit."



# ------------------------------------------------------------
# 16. CREATE A COMMIT
# ------------------------------------------------------------
#
# Click:
#
# Commit
#
#
# Enter a useful commit message such as:
#
# Complete Discussion 01 Git practice
#
#
# Then select:
#
# Commit
#
#
# A commit is a checkpoint in the history of the repository.



# ------------------------------------------------------------
# 17. PUSH TO GITHUB
# ------------------------------------------------------------
#
# After committing, select:
#
# Push
#
#
# PUSH sends your local commits to GitHub.
#
#
# You may be asked to authenticate with GitHub.
#
# IMPORTANT:
#
# GitHub does NOT accept your normal GitHub password for Git
# operations over HTTPS.
#
# Depending on your computer configuration, you may need to
# authenticate using a supported credential method such as a
# personal access token.
#
#
# NEVER put a password or personal access token inside:
#
# - an R script
# - a README
# - your Git repository
# - course assignments



# ------------------------------------------------------------
# 18. VERIFY THE PUSH
# ------------------------------------------------------------
#
# Return to your GitHub repository in your browser.
#
# Refresh the page.
#
# You should now see:
#
# Discussion_01_Practice.R
#
#
# If the file appears on GitHub:
#
# SUCCESS!
#
# You have completed the workflow:
#
#
#        LOCAL COMPUTER
#
#        Create/Edit
#             |
#             v
#           Stage
#             |
#             v
#          Commit
#             |
#             v
#           Push
#             |
#             v
#
#           GITHUB



# ============================================================
# PART V: THE WORKFLOW WE WILL USE THIS SEMESTER
# ============================================================
#
#
# COURSE MATERIALS
#
# Instructor GitHub Repository
#          |
#          | PULL
#          v
# Local Course Repository
#
#
#
# YOUR WORK
#
# Personal R Project
#          |
#          | edit
#          v
#        COMMIT
#          |
#          | PUSH
#          v
# Personal GitHub Repository
#
#
# Keeping these repositories separate reduces conflicts between
# course updates and your own work.



# ============================================================
# OPTIONAL R EXERCISES
# ============================================================
#
# Complete these exercises if time permits or after class.
#
# The goal is to practice using R's documentation rather than
# memorizing commands.



# ------------------------------------------------------------
# OPTIONAL EXERCISE 1
# ------------------------------------------------------------
#
# Return to the COURSE repository and open Discussion 01 again.
#
# Use R's help system to determine how to calculate the median
# mortality.
#
# Start with:
#
# ?median


# YOUR CODE:




# ------------------------------------------------------------
# OPTIONAL EXERCISE 2
# ------------------------------------------------------------
#
# Find a function that reports both the minimum AND maximum
# mortality values.
#
# Hint:
#
# ?range


# YOUR CODE:




# ------------------------------------------------------------
# OPTIONAL EXERCISE 3
# ------------------------------------------------------------
#
# Use the help page for head() to determine how to display
# only the first THREE observations of dat.
#
# Start with:
#
# ?head


# YOUR CODE:




# ============================================================
# END-OF-DISCUSSION CHECK
# ============================================================
#
# By the end of today's session, you should be able to explain:
#
# 1. What is R?
#
# 2. What is RStudio?
#
# 3. What does an R Project do?
#
# 4. What is the difference between Git and GitHub?
#
# 5. What is a repository?
#
# 6. What does it mean to clone a repository?
#
# 7. Why are relative file paths useful?
#
# 8. What is an R object?
#
# 9. What is an R function?
#
# 10. What is a function argument?
#
# 11. How can you find help for an unfamiliar R function?
#
# 12. What does PULL do?
#
# 13. What does COMMIT do?
#
# 14. What does PUSH do?
#
# 15. Why are we keeping the course repository separate from
#     your personal ENTO 8030 repository?
#
#
# These concepts will provide the organizational foundation
# for the rest of ENTO 8030.
#
# ============================================================