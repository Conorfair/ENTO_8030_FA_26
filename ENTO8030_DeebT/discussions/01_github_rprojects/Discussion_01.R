# ============================================================
# ENTO 8030 - Applied Statistics for Graduate Students
# Discussion 01
#
# GitHub, R Projects, and Getting Help in R
# ============================================================


# ============================================================
# BEFORE YOU BEGIN
# ============================================================
#
# We are beginning today's discussion inside the COURSE
# repository.
#
# During this session, you will:
#
# 1. Explore the course R Project.
# 2. Practice pulling updates from the course repository.
# 3. Review basic R and R's help system.
# 4. Create your private personal ENTO 8030 repository.
# 5. Clone that repository as a separate R Project.
# 6. Copy today's working materials into your personal repository.
# 7. Continue working from your PERSONAL R Project.
# 8. Commit and push your completed work to GitHub.
#
# IMPORTANT:
#
# The course repository provides the original course materials.
# Your personal repository will contain YOUR working copies.
# ============================================================


# ============================================================
# GOALS FOR TODAY'S DISCUSSION
# ============================================================
#
# By the end of this session, you should be able to:
#
# 1. Explain the roles of R, RStudio, R Projects, Git, and GitHub.
# 2. Open and navigate an R Project.
# 3. Explain the difference between clone and pull.
# 4. Pull updates from the course repository.
# 5. Explain why relative file paths are useful.
# 6. Import and inspect a dataset in R.
# 7. Recognize objects, functions, and arguments in R code.
# 8. Use R's built-in help system.
# 9. Create your own private GitHub repository for ENTO 8030.
# 10. Add the instructor as a collaborator.
# 11. Clone a GitHub repository as an R Project.
# 12. Distinguish between the course and personal R Projects.
# 13. Copy course materials into your personal repository.
# 14. Stage and commit changes using Git.
# 15. Push a commit to GitHub.
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
#   The interface we use to write, organize, and run R code.
#
# R Project
#   Defines an organized working environment for a project.
#   Opening an R Project establishes the project directory as
#   the working directory.
#
# Git
#   A version-control system that tracks changes to files over
#   time.
#
# GitHub
#   An online platform that stores and shares Git repositories.
#
#
# A basic Git workflow for files in YOUR repository is:
#
#       EDIT
#         |
#         v
#       SAVE
#         |
#         v
#       STAGE
#         |
#         v
#       COMMIT
#         |
#         v
#       PUSH
#         |
#         v
#       GITHUB
#
#
# Git can also retrieve changes from GitHub using PULL.
#
#
# In ENTO 8030, we will maintain TWO separate repositories:
#
#
# COURSE REPOSITORY
#
#       PULL -> COPY
#
#
# PERSONAL REPOSITORY
#
#       EDIT -> SAVE -> STAGE -> COMMIT -> PUSH
#
#
# DISCUSSION:
#
# What advantages might this workflow have compared with keeping
# files scattered across your Desktop, Downloads, email, etc.?



# ------------------------------------------------------------
# 2. UPDATE THE COURSE REPOSITORY
# ------------------------------------------------------------
#
# Before beginning a weekly discussion, first make sure your
# local course repository contains the latest instructor
# materials.
#
#
# In RStudio:
#
# Open the Git pane and select:
#
#       Pull
#
#
# Alternatively, open the RStudio Terminal and enter:
#
#       git pull
#
#
# If no new changes are available, Git may report:
#
#       Already up to date.
#
#
# What does PULL do?
#
# PULL retrieves changes from the GitHub repository and
# incorporates them into the repository on your computer.
#
#
# IMPORTANT:
#
# We will primarily PULL from the COURSE repository.
#
# We will NOT push our personal course work back to the
# instructor's course repository.



# ------------------------------------------------------------
# 3. CLONE VS. PULL
# ------------------------------------------------------------
#
# These two terms describe different actions.
#
#
# CLONE
#
# Creates the initial local copy of a GitHub repository on your
# computer.
#
#       GitHub repository
#              |
#              | CLONE
#              v
#       New local repository
#
#
# You normally clone a repository ONCE.
#
#
# PULL
#
# Retrieves new changes from GitHub for a repository that is
# already on your computer.
#
#       GitHub repository
#              |
#              | PULL
#              v
#       Existing local repository
#
#
# For the ENTO 8030 course repository:
#
#       CLONE ONCE -> PULL THROUGHOUT THE SEMESTER



# ------------------------------------------------------------
# 4. WHERE DOES R THINK WE ARE?
# ------------------------------------------------------------
#
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
# lectures
# output
# resources
#
# You should also see the .Rproj file and README.md.
#
#
# DISCUSSION:
#
# What does the result of getwd() tell us?
#
# How is this location related to the Files pane in RStudio?



# ------------------------------------------------------------
# 5. RELATIVE FILE PATHS
# ------------------------------------------------------------
#
# Because we opened an R Project, R already knows where the
# project begins.
#
# Therefore:
#
#       data/week01_example.csv
#
# means:
#
# "Start in this project, enter the data folder, and find
# week01_example.csv."
#
#
# Avoid computer-specific paths such as:
#
# setwd("/Users/YourName/Desktop/MyResearch/")
#
# or:
#
# read.csv("C:/Users/YourName/Desktop/MyResearch/data.csv")
#
#
# Those paths refer to locations on one particular computer.
#
# Relative paths make analyses easier to move, share, and
# reproduce.



# ------------------------------------------------------------
# 6. IMPORT DATA
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
# 7. EXAMINE THE DATA
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
#
# Why might examining a dataset before analyzing it be
# important?



# ============================================================
# PART II: BASIC R AND GETTING HELP
# ============================================================


# ------------------------------------------------------------
# 8. OBJECTS, VARIABLES, AND FUNCTIONS
# ------------------------------------------------------------

# Access one variable from the data frame.


dat$Mortality


# Calculate its mean.


mean(dat$Mortality)


# Calculate its standard deviation.


sd(dat$Mortality)


# Save the mean as another object.


overall_mean <- mean(dat$Mortality)


overall_mean


# A useful way to begin reading R code is:
#
#       result <- function(object)
#
# For example:
#
#       overall_mean <- mean(dat$Mortality)
#
#
# DISCUSSION:
#
# In the expression above:
#
# What is the object being created?
#
# What function is being used?
#
# What information is being supplied to the function?



# ------------------------------------------------------------
# 9. CALCULATE TREATMENT SUMMARIES
# ------------------------------------------------------------
#
# Functions can also accept several arguments.
#
# Here we use aggregate() to calculate the mean mortality for
# each treatment.


aggregate(
  Mortality ~ Treatment,
  data = dat,
  FUN = mean
)


# DISCUSSION:
#
# What does this output tell us?
#
# How does the treatment-specific information differ from the
# overall mean calculated above?



# ------------------------------------------------------------
# 10. GETTING HELP IN R
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
#
#
# DISCUSSION:
#
# If you encounter a function you do not recognize, what kinds
# of information can you obtain from its help page?



# ------------------------------------------------------------
# 11. USE DOCUMENTATION TO SOLVE A PROBLEM
# ------------------------------------------------------------


x <- c(1, 2, NA, 4)


x


# What happens when we calculate the mean?


mean(x)


# QUESTION:
#
# Why did R return NA?
#
# Use the help page for mean() to determine how to calculate
# the mean while ignoring the missing value.
#
# Start with:
#
# ?mean


# YOUR CODE:





# After attempting the problem, compare your solution with:


mean(x, na.rm = TRUE)


# DISCUSSION:
#
# What does na.rm mean?
#
# What does TRUE change about the behavior of mean()?
#
# This illustrates an important point:
#
# You do not need to memorize every argument.
#
# You need to know how to FIND and INTERPRET documentation.



# ------------------------------------------------------------
# 12. PACKAGE HELP
# ------------------------------------------------------------
#
# Help is also available for entire packages.


help(package = "stats")


# Many packages contain longer tutorials called vignettes.
#
# If ggplot2 is installed, try:


vignette(package = "ggplot2")


# Documentation, textbooks, package websites, online forums,
# and AI tools can all be useful.
#
# Part of learning statistical computing is learning which
# resource is appropriate for the question you are trying to
# answer.



# ============================================================
# PART III: CREATE YOUR PERSONAL ENTO 8030 REPOSITORY
# ============================================================
#
# We will use TWO repositories during this course.
#
#
# COURSE REPOSITORY
#
#       ENTO_8030_FA_26
#
# Purpose:
#
#   Receive datasets, scripts, examples, and course materials.
#
# You will primarily:
#
#       PULL -> COPY
#
#
# YOUR PERSONAL REPOSITORY
#
# Naming convention:
#
#       ENTO_8030_LastName_FirstInitial
#
# Example:
#
#       ENTO_8030_Smith_J
#
# Purpose:
#
#   Store your own course work and practice using Git.
#
# Your repository will be PRIVATE.
#
# You will primarily:
#
#       EDIT -> SAVE -> STAGE -> COMMIT -> PUSH



# ------------------------------------------------------------
# 13. CREATE YOUR PERSONAL GITHUB REPOSITORY
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
# 3. Name your repository using:
#
#       ENTO_8030_LastName_FirstInitial
#
#    For example:
#
#       ENTO_8030_Smith_J
#
# 4. Add a description if desired.
#
# 5. Select:
#
#       PRIVATE
#
# 6. Initialize the repository with a README.
#
# 7. Add the R .gitignore.
#
# 8. Create the repository.
#
#
# CHECKPOINT:
#
# Before continuing, confirm that your repository says:
#
#       Private
#
# near the repository name.



# ------------------------------------------------------------
# 14. ADD THE INSTRUCTOR AS A COLLABORATOR
# ------------------------------------------------------------
#
# Your repository is private, so the instructor cannot access
# it unless you explicitly provide access.
#
#
# On your GitHub repository page:
#
# 1. Select:
#
#       Settings
#
# 2. Under Access, select:
#
#       Collaborators
#
#    or:
#
#       Collaborators and teams
#
#    The exact wording may vary slightly depending on your
#    GitHub interface.
#
# 3. Select:
#
#       Add people
#
# 4. Search for the instructor's GitHub username:
#
#       Conorfair
#
# 5. Select the instructor.
#
# 6. Send the collaboration invitation.
#
#
# The instructor must accept the invitation before collaborator
# access becomes active.
#
#
# CHECKPOINT:
#
# Your repository should now show a pending invitation for:
#
#       Conorfair
#
#
# IMPORTANT:
#
# Do NOT make your repository public simply to share it with
# the instructor.



# ------------------------------------------------------------
# 15. COPY THE REPOSITORY URL
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
# https://github.com/YourUsername/ENTO_8030_Smith_J.git



# ============================================================
# IMPORTANT TRANSITION
# ============================================================
#
# We are now going to create a NEW R Project.
#
# The R session containing this script currently belongs to the
# COURSE repository.
#
# Save anything you need before continuing.
#
# After cloning your personal repository, RStudio should open
# the PERSONAL R Project.
#
# ============================================================



# ------------------------------------------------------------
# 16. CLONE YOUR PERSONAL REPOSITORY
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
# Paste your personal repository URL.
#
# Choose where you want the repository stored.
#
# Select:
#
#       Create Project
#
#
# RStudio should now open YOUR personal repository as a
# new R Project.
#
#
# Remember:
#
# You normally need to CLONE this repository only once.
#
# After today, you will simply reopen the existing R Project.



# ============================================================
# PART IV: WORKING IN YOUR PERSONAL REPOSITORY
# ============================================================
#
# IMPORTANT:
#
# The remaining work should be completed inside YOUR personal
# ENTO 8030 repository.
#
# ============================================================



# ------------------------------------------------------------
# 17. VERIFY YOUR NEW R PROJECT
# ------------------------------------------------------------


getwd()


list.files()


# DISCUSSION:
#
# Compare the result of getwd() with the result from the
# beginning of class.
#
# Why did it change?
#
# Which repository are you currently working in?



# ------------------------------------------------------------
# 18. CHECKPOINT: WHICH PROJECT AM I IN?
# ------------------------------------------------------------
#
# This is an important habit to develop.
#
# Before editing course work, make sure you know which R Project
# is currently open.
#
#
# Run:


getwd()


# You can also examine:


list.files()


# DISCUSSION:
#
# How could you determine whether you are currently in:
#
# A. the instructor's course repository
#
# or
#
# B. your personal repository?
#
#
# What might happen later in the semester if you accidentally
# modify files in the course repository and then try to PULL
# instructor updates?
#
#
# If you are uncertain which project is open, STOP and verify
# before editing files.



# ------------------------------------------------------------
# 19. COPY TODAY'S MATERIALS INTO YOUR PERSONAL REPOSITORY
# ------------------------------------------------------------
#
# We do NOT want to continue modifying files in the instructor
# course repository.
#
# Copy the materials needed for today's discussion from the
# COURSE repository into your PERSONAL repository.
#
#
# Copy:
#
#       discussions/01_github_rprojects/Discussion_01.R
#
# and:
#
#       data/week01_example.csv
#
#
# Recreate the same general folder organization in your
# personal repository:
#
#
# ENTO_8030_LastName_FirstInitial/
# |
# |-- data/
# |   |
# |   `-- week01_example.csv
# |
# |-- discussions/
# |   |
# |   `-- 01_github_rprojects/
# |       |
# |       `-- Discussion_01.R
# |
# `-- README.md
#
#
# You may need to create:
#
#       data/
#
# and:
#
#       discussions/01_github_rprojects/
#
#
# WHY COPY THE DATA TOO?
#
# The goal is for your personal repository to contain the files
# necessary to reproduce your analysis.
#
# A script that depends on a dataset stored somewhere else on
# your computer is harder to reproduce.



# ------------------------------------------------------------
# 20. OPEN YOUR PERSONAL COPY OF DISCUSSION 01
# ------------------------------------------------------------
#
# In the Files pane, open:
#
# discussions/01_github_rprojects/Discussion_01.R
#
#
# IMPORTANT:
#
# You should now be reading YOUR COPY of this script rather than
# the copy in the instructor's repository.
#
#
# Confirm your location again:


getwd()


list.files()


list.files(recursive = TRUE)


# CHECKPOINT:
#
# Can you see:
#
#       data/week01_example.csv
#
# and:
#
#       discussions/01_github_rprojects/Discussion_01.R
#
# in YOUR personal repository?



# ------------------------------------------------------------
# 21. TEST THE RELATIVE FILE PATH AGAIN
# ------------------------------------------------------------
#
# Earlier, we imported the dataset from the COURSE repository
# using:
#
#       data/week01_example.csv
#
# Try exactly the same command from your PERSONAL R Project.


dat <- read.csv("data/week01_example.csv")


head(dat)


# DISCUSSION:
#
# Your personal repository is stored in a different absolute
# location on your computer.
#
# Why does this code still work?
#
#
#       dat <- read.csv("data/week01_example.csv")
#
#
# This is one of the major advantages of organizing analyses
# using R Projects and relative file paths.



# ------------------------------------------------------------
# 22. MAKE A CHANGE TO YOUR PERSONAL SCRIPT
# ------------------------------------------------------------
#
# We need Git to have a change to track.
#
# Add your name below:
#
# Student:
#
#
# Then add a short comment describing one thing you learned
# during today's discussion.
#
# For example:
#
# # Git tracks changes locally; GitHub stores the remote
# # repository online.
#
#
# SAVE THIS SCRIPT.
#
#
# You have now modified the copy of Discussion_01.R stored in
# YOUR personal repository.



# ------------------------------------------------------------
# 23. CHECK GIT
# ------------------------------------------------------------
#
# Open the Git pane in RStudio.
#
# You should see files that are new or have changed.
#
# Depending on how you created your folders, these may include:
#
#       Discussion_01.R
#
#       week01_example.csv
#
# and possibly other files associated with your R Project.
#
#
# Git recognizes that the contents of the repository have
# changed.



# ------------------------------------------------------------
# 24. STAGE YOUR FILES
# ------------------------------------------------------------
#
# In the Git pane, check the boxes beside the files you want to
# include in your first commit.
#
#
# At minimum, your course materials should include:
#
#       Discussion_01.R
#
#       week01_example.csv
#
#
# This STAGES the files.
#
#
# Staging tells Git:
#
#       "Include these changes in my next commit."
#
#
# DISCUSSION:
#
# Why might it be useful to review the files being staged before
# creating a commit?



# ------------------------------------------------------------
# 25. CREATE A COMMIT
# ------------------------------------------------------------
#
# Select:
#
#       Commit
#
#
# Enter a useful commit message such as:
#
#       Complete Discussion 01 and initialize course materials
#
#
# Then select:
#
#       Commit
#
#
# A commit creates a checkpoint in the history of your
# repository.
#
#
# Useful commit messages briefly describe what changed.
#
# Examples:
#
#       Complete Discussion 01 exercises
#
#       Add mortality summary figure
#
#       Revise data cleaning code
#
#
# Less useful messages include:
#
#       stuff
#
#       changes
#
#       update
#
#
# A future version of you should be able to look at the commit
# message and understand what happened.



# ------------------------------------------------------------
# 26. PUSH TO GITHUB
# ------------------------------------------------------------
#
# After committing, select:
#
#       Push
#
#
# PUSH sends your LOCAL commits to the remote GitHub repository.
#
#
# Conceptually:
#
#       Personal R Project
#              |
#              | COMMIT
#              v
#       Local Git repository
#              |
#              | PUSH
#              v
#       Personal GitHub repository
#
#
# You may be asked to authenticate with GitHub.
#
#
# IMPORTANT:
#
# GitHub does NOT accept your normal GitHub account password for
# Git operations over HTTPS.
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
# 27. VERIFY THE PUSH
# ------------------------------------------------------------
#
# Return to your PERSONAL GitHub repository in your browser.
#
# Refresh the page.
#
#
# Navigate to:
#
#       discussions/
#       01_github_rprojects/
#       Discussion_01.R
#
#
# Confirm that:
#
# 1. Discussion_01.R appears in the repository.
#
# 2. week01_example.csv appears in the data folder.
#
# 3. Your change appears in Discussion_01.R.
#
# 4. Your commit appears in the repository history.
#
#
# If those changes appear on GitHub:
#
# SUCCESS!
#
# You have completed the workflow:
#
#
#       PERSONAL COMPUTER
#
#            Edit
#              |
#              v
#            Save
#              |
#              v
#            Stage
#              |
#              v
#           Commit
#              |
#              v
#            Push
#              |
#              v
#
#       PERSONAL GITHUB
#          REPOSITORY



# ============================================================
# PART V: THE WORKFLOW WE WILL USE THIS SEMESTER
# ============================================================
#
#
# Beginning with Discussion 02, you do NOT need to recreate or
# clone these repositories.
#
# They are already on your computer.
#
#
# BEFORE EACH DISCUSSION:
#
#
# COURSE REPOSITORY
#
# Instructor GitHub Repository
#          |
#          | PULL
#          v
# Local Course Repository
#          |
#          | READ WEEKLY README
#          v
# Identify Required Materials
#          |
#          | COPY
#          v
#
#
# PERSONAL REPOSITORY
#
# Personal R Project
#          |
#          | EDIT / ANALYZE
#          v
#         SAVE
#          |
#          v
#        STAGE
#          |
#          v
#        COMMIT
#          |
#          | PUSH
#          v
# Personal Private GitHub Repository
#
#
# Your personal repository is PRIVATE.
#
# The instructor has access because you added:
#
#       Conorfair
#
# as a collaborator.
#
#
# Keeping these repositories separate reduces conflicts between
# instructor updates and your own work.
#
#
# THE SHORT VERSION:
#
#
# COURSE PROJECT
#
#       PULL -> COPY
#
#
# PERSONAL PROJECT
#
#       EDIT -> SAVE -> STAGE -> COMMIT -> PUSH



# ============================================================
# PART VI: OPTIONAL R EXERCISES
# ============================================================
#
# Complete these exercises in YOUR PERSONAL copy of
# Discussion_01.R if time permits or after class.
#
# The goal is to practice using R's documentation rather than
# memorizing commands.
#
# These exercises also give you another opportunity to modify
# your script and create a meaningful Git commit.



# ------------------------------------------------------------
# OPTIONAL EXERCISE 1
# ------------------------------------------------------------
#
# Use R's help system to determine how to calculate the median
# mortality.
#
# Start with:


?median


# YOUR CODE:





# ------------------------------------------------------------
# OPTIONAL EXERCISE 2
# ------------------------------------------------------------
#
# Find a function that reports both the minimum AND maximum
# mortality values.
#
# Hint:


?range


# YOUR CODE:





# ------------------------------------------------------------
# OPTIONAL EXERCISE 3
# ------------------------------------------------------------
#
# Use the help page for head() to determine how to display only
# the first THREE observations of dat.
#
# Start with:


?head


# YOUR CODE:





# ------------------------------------------------------------
# OPTIONAL EXERCISE 4
# ------------------------------------------------------------
#
# Use R's documentation to determine how to count the number of
# observations in the dataset.
#
# Hint:
#
# Look at the help page for nrow().


?nrow


# YOUR CODE:





# ------------------------------------------------------------
# OPTIONAL EXERCISE 5
# ------------------------------------------------------------
#
# Calculate the treatment-specific standard deviation of
# Mortality.
#
# Earlier we used:
#
# aggregate(
#   Mortality ~ Treatment,
#   data = dat,
#   FUN = mean
# )
#
# What needs to change if we want the standard deviation instead
# of the mean?
#
#
# YOUR CODE:





# ------------------------------------------------------------
# OPTIONAL: COMMIT YOUR ADDITIONAL WORK
# ------------------------------------------------------------
#
# If you completed the optional exercises after your first
# commit:
#
# 1. Save Discussion_01.R.
#
# 2. Open the Git pane.
#
# 3. Stage Discussion_01.R.
#
# 4. Commit with a message such as:
#
#       Complete optional Discussion 01 exercises
#
# 5. Push the commit to GitHub.
#
#
# Notice that Git now contains separate checkpoints documenting
# how your work developed.



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
# 6. What does it mean to CLONE a repository?
#
# 7. What does PULL do?
#
# 8. Why are relative file paths useful?
#
# 9. What is an R object?
#
# 10. What is an R function?
#
# 11. What is a function argument?
#
# 12. How can you find help for an unfamiliar R function?
#
# 13. Why do we have TWO ENTO 8030 repositories?
#
# 14. Which repository should receive instructor updates?
#
# 15. Which repository should contain your personal work?
#
# 16. How can you determine which R Project is currently open?
#
# 17. Why do we copy both scripts and required datasets?
#
# 18. What does STAGE mean?
#
# 19. What does COMMIT do?
#
# 20. What does PUSH do?
#
# 21. Why is your personal repository private?
#
# 22. Why has the instructor been added as a collaborator?
#
# 23. Why are we keeping the course repository separate from
#     your personal ENTO 8030 repository?
#
#
# These concepts provide the organizational foundation for the
# rest of ENTO 8030.



# ============================================================
# FINAL WORKFLOW
# ============================================================
#
# If you remember only one Git/GitHub workflow from today's
# discussion, remember:
#
#
#       COURSE PROJECT
#
#       PULL -> COPY
#
#
#       PERSONAL PROJECT
#
#       EDIT -> SAVE -> STAGE -> COMMIT -> PUSH
#
#
# The course repository provides the materials.
#
# Your personal repository contains YOUR work.
#
# ============================================================