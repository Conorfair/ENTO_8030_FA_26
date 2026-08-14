# ENTO 8030 – Applied Statistics for Graduate Students

**Fall 2026**

Welcome to the course GitHub repository for ENTO 8030.

This repository contains datasets, R scripts, discussion materials, and supporting resources that we will use throughout the semester.

A major goal of this course is not only to learn statistical methods, but also to develop an organized and reproducible approach to statistical analysis. We will therefore use **GitHub, Git, and R Projects throughout the semester** to organize, access, and manage course materials and your own statistical work.

---

# Getting Started

Before the first discussion session, you should have the following:

- **R** installed
- **RStudio** installed
- **Git** installed
- A **GitHub account**

During Discussion 01, we will connect these tools and practice using them together.

You will also create a **private personal GitHub repository for ENTO 8030** and add the instructor as a collaborator.

---

# R, RStudio, R Projects, Git, and GitHub

These tools have related but different purposes.

## R

R is the programming language that performs our statistical analyses.

## RStudio

RStudio is the interface we will use to write, organize, and run R code.

## R Project

An R Project defines the working directory associated with an analysis or project.

Throughout ENTO 8030, we will use R Projects so that analyses can use **relative file paths** rather than paths tied to one particular computer.

## Git

Git is a version-control system. It tracks changes to files over time and allows us to create checkpoints called **commits**.

## GitHub

GitHub is an online platform that stores and shares Git repositories.

Git and GitHub are related, but they are not the same thing.

A simplified workflow is:

```text
GitHub Repository
       |
       | clone / pull
       v
Local R Project
       |
       | edit files and perform analyses
       v
Git Commit
       |
       | push
       v
GitHub Repository
```

---

# Two Repositories Will Be Used in ENTO 8030

During the semester, you will interact with two different GitHub repositories.

## 1. Course Repository

The instructor-maintained course repository is:

**ENTO_8030_FA_26**

This repository contains:

- datasets
- discussion scripts
- examples
- course resources
- other materials distributed throughout the semester

You will primarily **pull** materials from this repository.

Conceptually:

```text
ENTO_8030_FA_26 on GitHub
            |
            | pull
            v
Course repository on your computer
```

You should generally avoid doing your personal course work directly in the instructor repository.

---

## 2. Your Personal ENTO 8030 Repository

During Discussion 01, you will create your own **private GitHub repository** for ENTO 8030.

Please name your repository using the following convention:

```text
ENTO_8030_LastName_FirstInitial
```

For example:

```text
ENTO_8030_Smith_J
```

Your personal repository will be used to store your course work and practice using Git and GitHub throughout the semester.

Your repository should be:

- **Private**
- Owned by your GitHub account
- Shared with the instructor as a collaborator

You will practice:

```text
edit
  ↓
commit
  ↓
push
```

with this repository throughout the semester.

### Instructor Access

After creating your repository, add the instructor as a collaborator.

On your repository's GitHub page:

1. Select **Settings**.
2. Under **Access**, select **Collaborators** or **Collaborators and teams**.
3. Select **Add people**.
4. Search for the instructor's GitHub username:

```text
Conorfair
```

5. Select the instructor.
6. Send the collaboration invitation.

The instructor must accept the invitation before collaborator access becomes active.

Do not make your repository public in order to share it with the instructor.

---

# Accessing the Course Repository

## Step 1 – Copy the Repository URL

On the ENTO 8030 GitHub repository page:

1. Click the green **Code** button.
2. Select **HTTPS**.
3. Copy the repository URL.

It should look similar to:

```text
https://github.com/Conorfair/ENTO_8030_FA_26.git
```

---

## Step 2 – Clone the Repository Using RStudio

Open RStudio.

Select:

**File → New Project → Version Control → Git**

Paste the repository URL into the **Repository URL** field.

Choose a location on your computer where you want the course repository stored.

Select:

**Create Project**

RStudio will download, or **clone**, the repository and open the course R Project.

---

## Step 3 – Confirm That the Project Is Open

In the R Console, run:

```r
getwd()
```

Your path will depend on where you saved the repository.

Then run:

```r
list.files()
```

You should see files and folders similar to:

```text
data
discussions
ENTO 8030 Repo.Rproj
output
README.md
resources
```

If you see these files, you are working inside the ENTO 8030 course R Project.

---

# Repository Organization

The course repository is organized into several folders.

```text
ENTO 8030 Repo/
│
├── data/
│
├── discussions/
│
├── output/
│
├── resources/
│
├── ENTO 8030 Repo.Rproj
│
└── README.md
```

## `data/`

Contains datasets used during course discussions and exercises.

## `discussions/`

Contains R scripts and other materials for discussion sessions.

For example:

```text
discussions/
└── 01_github_rprojects/
    └── Discussion 01.R
```

## `output/`

Provides a location for figures, tables, and other outputs generated by R.

## `resources/`

Contains reference materials for using R, troubleshooting problems, and other topics that will be useful throughout the semester.

## `README.md`

This document provides instructions for accessing and navigating the repository.

---

# Discussion 01

## GitHub, R Projects, and Getting Help in R

Open:

```text
discussions/01_github_rprojects/Discussion 01.R
```

During the first discussion, we will cover:

- R, RStudio, and R Projects
- Git and GitHub
- repositories
- cloning
- working directories
- relative file paths
- importing and examining data
- R objects
- functions and arguments
- R help pages
- creating a private personal GitHub repository
- adding the instructor as a collaborator
- commits
- pushes
- pulls
- basic GitHub authentication

---

# Relative File Paths

Throughout ENTO 8030, we will avoid code that depends on the location of files on one particular computer.

Avoid code such as:

```r
setwd("/Users/YourName/Desktop/Research/")
```

or:

```r
dat <- read.csv(
  "C:/Users/YourName/Documents/Research/data/mydata.csv"
)
```

These paths may work on your computer but will usually fail on someone else's computer.

Instead, open the appropriate R Project and use paths relative to the project:

```r
dat <- read.csv("data/mydata.csv")
```

This makes analyses easier to share and reproduce.

---

# Basic Git Vocabulary

Several terms will be used throughout the semester.

## Repository

A project whose files and changes are tracked by Git.

## Clone

Create a local copy of a repository that already exists on GitHub.

## Pull

Bring new changes from a GitHub repository onto your computer.

## Commit

Create a checkpoint recording changes to your local files.

A useful commit message briefly explains what changed.

For example:

```text
Complete Discussion 01 exercises
```

## Push

Send your local commits to GitHub.

A common workflow is:

```text
PULL
  ↓
EDIT
  ↓
COMMIT
  ↓
PUSH
```

---

# GitHub Authentication

GitHub may require you to authenticate before allowing RStudio/Git to push changes to your repository.

GitHub does **not** accept your regular GitHub account password for command-line Git operations over HTTPS.

Depending on your computer configuration, you may need to authenticate using a supported credential method such as a **personal access token**.

If authentication is required during Discussion 01, we will work through the process together.

**Never place passwords or personal access tokens inside an R script, README file, or other file that will be committed to GitHub.**

---

# Getting Help in R

You are **not expected to memorize every R function or command**.

An important skill is learning how to find reliable information when you encounter something unfamiliar.

For example:

```r
?mean
```

opens the help page for `mean()`.

You can also use:

```r
help(mean)
args(mean)
example(mean)
```

R help pages commonly contain sections such as:

- Description
- Usage
- Arguments
- Details
- Value
- Examples

We will practice using these resources during Discussion 01.

---

# Course Workflow

Throughout ENTO 8030, we will build toward an analytical workflow that connects:

```text
Scientific Question
        ↓
Data
        ↓
Data Exploration
        ↓
Statistical Model
        ↓
Model Evaluation
        ↓
Hypothesis Testing and Estimation
        ↓
Figures and Tables
        ↓
Scientific Interpretation
```

GitHub and R Projects provide the organizational foundation for this workflow.

The goal is not simply to produce an answer from R. The goal is to create an analysis that is organized, understandable, and reproducible.
