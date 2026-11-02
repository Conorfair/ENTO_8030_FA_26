# ENTO 8030 – Applied Statistics for Graduate Students

**Fall 2026**

Welcome to the course GitHub repository for **ENTO 8030: Advanced Quantitative Analysis in Entomological Science**.

This repository contains datasets, R scripts, discussion materials, and supporting resources that we will use throughout the semester.

A major goal of this course is not only to learn statistical methods, but also to develop an organized and reproducible approach to statistical analysis. We will therefore use **R, RStudio, R Projects, Git, and GitHub throughout the semester** to organize, access, document, and manage course materials and your own statistical work.

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

**R** is the programming language that performs our statistical analyses.

## RStudio

**RStudio** is the interface we will use to write, organize, and run R code.

## R Projects

An **R Project** provides an organized working environment for an analysis or project.

Throughout ENTO 8030, we will use R Projects so that analyses can use **relative file paths** rather than paths tied to one particular computer.

For example, instead of using a computer-specific path such as:

```text
/Users/yourname/Documents/ENTO8030/data/example.csv
```

we can use:

```r
read.csv("data/example.csv")
```

This makes code easier to move between computers and easier for someone else to reproduce.

## Git

**Git** is a version-control system. It tracks changes to files over time and allows us to create checkpoints called **commits**.

A basic Git workflow is:

```text
Edit files
    ↓
Save
    ↓
Stage changes
    ↓
Commit
    ↓
Push to GitHub
```

Git can also retrieve changes from a remote repository using **pull**.

## GitHub

**GitHub** is an online platform that stores and shares Git repositories.

Git and GitHub are related, but they are not the same thing.

- **Git** tracks changes on your computer.
- **GitHub** stores a remote copy of the repository online.

In ENTO 8030, we will use these tools with **two separate repositories**: an instructor-maintained course repository and your own private course repository.

---

# Two Repositories Will Be Used in ENTO 8030

Throughout the semester, you will maintain **two separate ENTO 8030 repositories and R Projects** on your computer.

These repositories serve different purposes.

---

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
Instructor updates course materials
              ↓
     Course repository on GitHub
              ↓
            PULL
              ↓
     Course R Project on your computer
```

### Important

Treat the course repository as the **instructor copy of the course materials**.

You should generally **not complete or save your personal course work directly in this repository**.

Keeping your own changes out of the course repository will make it easier to pull new instructor materials throughout the semester without creating conflicts between your work and updated course files.

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

You will also clone this repository to your computer and use it as a **separate R Project**.

Your personal repository is where you will:

- complete discussion exercises
- modify course examples
- practice R
- save your own analyses
- create figures and other output
- track changes to your work
- commit changes
- push your work to GitHub

Your personal repository should be:

- **Private**
- Owned by your GitHub account
- Shared with the instructor as a collaborator

Your basic workflow in this repository will be:

```text
Edit
  ↓
Save
  ↓
Stage
  ↓
Commit
  ↓
Push
```

---

# Instructor Access to Your Personal Repository

After creating your personal repository, add the instructor as a collaborator.

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

**Do not make your repository public in order to share it with the instructor.**

---

# ENTO 8030 Weekly Workflow

The two repositories have different roles throughout the semester.

A typical discussion workflow will be:

```text
COURSE REPOSITORY
on your computer
       │
       │ 1. Pull instructor updates
       ↓
Updated course materials
       │
       │ 2. Copy the files needed for this week's work
       ↓
PERSONAL REPOSITORY
on your computer
       │
       │ 3. Open your personal R Project
       ↓
Edit / analyze / create output
       │
       │ 4. Save your work
       ↓
Stage → Commit → Push
       │
       ↓
PERSONAL PRIVATE REPOSITORY
on GitHub
```

A simpler way to remember this is:

### Course Repository

```text
PULL → COPY
```

### Personal Repository

```text
EDIT → SAVE → STAGE → COMMIT → PUSH
```

---

# Before Each Discussion

Before beginning a weekly discussion:

1. Open the **course R Project**.
2. Pull the latest changes from the course GitHub repository.
3. Locate the materials for that week's discussion.
4. Copy the files needed for the discussion into your **personal ENTO 8030 repository**.
5. Open your **personal R Project**.
6. Complete the discussion using the copies in your personal repository.
7. Save your work.
8. Stage and commit your changes.
9. Push your commits to your private GitHub repository.

When a discussion requires a dataset or another supporting file, copy that file along with the R script so that your personal project contains the materials necessary to reproduce your analysis.

---

# Accessing the Course Repository for the First Time

You only need to **clone** the course repository once.

After it has been cloned to your computer, you will normally use **pull** to retrieve new materials.

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
lectures
output
resources
README.md
ENTO 8030 Repo.Rproj
```

If you see these files, you are working inside the ENTO 8030 course R Project.

---

# Clone vs. Pull

These terms describe different actions.

## Clone

**Clone** creates the initial local copy of a GitHub repository on your computer.

You normally clone each repository only once.

```text
GitHub repository
       ↓
     CLONE
       ↓
New local repository
```

## Pull

**Pull** retrieves new changes from GitHub and incorporates them into a repository that is already on your computer.

```text
GitHub repository
       ↓
      PULL
       ↓
Existing local repository is updated
```

For the course repository, your normal semester workflow will therefore be:

```text
Clone once
    ↓
Pull regularly
```

---

# Repository Organization

The course repository is organized into several folders.

```text
ENTO 8030 Repo/
│
├── data/
├── discussions/
├── lectures/
├── output/
├── resources/
├── ENTO 8030 Repo.Rproj
└── README.md
```

## `data/`

Contains datasets used during course discussions and exercises.

## `discussions/`

Contains R scripts and supporting materials for discussion sessions.

Each discussion has its own folder.

For example:

```text
discussions/
│
├── README.md
│
├── 01_github_rprojects/
│   ├── README.md
│   └── Discussion_01.R
│
└── 02_t-test_and_Chi-square/
    ├── README.md
    ├── Discussion_02.R
    └── solutions/
```

The `discussions/README.md` file provides a landing page for the discussion materials.

Each individual discussion folder may also contain a `README.md` with instructions specific to that week's session.

## `lectures/`

Contains materials associated with course lectures.

## `output/`

Provides a location for figures, tables, and other outputs generated by R.

## `resources/`

Contains reference materials for using R, troubleshooting problems, and other topics that will be useful throughout the semester.

## `README.md`

This document provides general instructions for accessing, navigating, and using the course repository.

---

# Working with Relative File Paths

One reason we use R Projects is to avoid file paths that only work on one computer.

Suppose a dataset is stored here:

```text
ENTO 8030 Repo/
│
├── data/
│   └── example.csv
│
└── ENTO 8030 Repo.Rproj
```

We can import it using:

```r
dat <- read.csv("data/example.csv")
```

rather than specifying its complete location on the computer.

You can check where R currently thinks you are working using:

```r
getwd()
```

You can examine the contents of the current project using:

```r
list.files()
```

and:

```r
list.files(recursive = TRUE)
```

Throughout the semester, avoid using `setwd()` to manually change the working directory when working within a course R Project.

---

# Pulling Course Updates

Before beginning a new discussion or working with newly released course materials, update your local copy of the course repository.

In RStudio, you can use the **Git** pane to pull changes.

You can also use the RStudio Terminal:

```bash
git pull
```

If the pull is successful, Git will either download the new changes or report:

```text
Already up to date.
```

### Important

Pull course updates **before modifying or copying that week's course materials**.

This helps ensure that you are working from the most recent version provided by the instructor.

---

# Saving Work to Your Personal Repository

After copying the necessary course materials into your personal repository, open your **personal ENTO 8030 R Project**.

Make your changes there.

A typical workflow is:

```text
Modify files
     ↓
Save files
     ↓
Review changes
     ↓
Stage files
     ↓
Commit
     ↓
Push
```

A **commit** creates a checkpoint in the history of your repository.

Commit messages should briefly describe what changed.

Examples include:

```text
Complete Discussion 02 exercises
```

```text
Add t-test analysis and figure
```

```text
Update data cleaning code
```

```text
Revise model diagnostics
```

Avoid vague commit messages such as:

```text
stuff
```

or:

```text
changes
```

when a more informative description is possible.

---

# Getting Help in R

You are not expected to memorize every R function or argument.

R and its packages include extensive documentation.

If you encounter an unfamiliar function, try:

```r
?mean
```

or:

```r
help(mean)
```

To examine the arguments for a function:

```r
args(mean)
```

To run examples provided with a function:

```r
example(mean)
```

To examine package documentation:

```r
help(package = "stats")
```

Many packages also provide longer tutorials called **vignettes**.

For example:

```r
vignette(package = "ggplot2")
```

Documentation, textbooks, package websites, online forums, and AI tools can all be useful resources. Part of learning statistical computing is learning **which resource is appropriate for the question you are trying to answer**.

---

# A Reproducible Statistical Workflow

Git and GitHub are only one part of reproducible statistical analysis.

Throughout ENTO 8030, we will repeatedly use a general workflow similar to:

```text
Scientific Question
        ↓
Import Data
        ↓
Inspect and Validate Data
        ↓
Visualize
        ↓
Fit Statistical Model
        ↓
Evaluate Assumptions / Diagnostics
        ↓
Test Hypotheses
        ↓
Estimate Effects
        ↓
Visualize Results
        ↓
Interpret
        ↓
Communicate Results
```

The specific statistical methods will change throughout the semester, but the general workflow will remain useful.

---

# Keep Raw Data Raw

Whenever possible, avoid manually editing the original dataset used for an analysis.

Instead:

```text
Raw data
    ↓
Import with R
    ↓
Clean / transform with code
    ↓
Analysis-ready data
    ↓
Statistical analysis
```

This creates a reproducible record of how the original data were converted into the data used for analysis.

Your R scripts should document important data-management and analysis decisions whenever possible.

---

# The Goal: Reproducible Statistical Analysis

The goal of ENTO 8030 is not simply to produce an answer from R.

Throughout the semester, we will work toward analyses that are:

- **organized**
- **documented**
- **transparent**
- **reproducible**
- **statistically appropriate**
- **understandable to someone other than the original analyst**

Using consistent R Projects, relative file paths, Git, and GitHub helps create a record of how an analysis developed and provides the foundation for the statistical workflows we will build throughout the semester.

When in doubt, remember the basic repository workflow:

```text
COURSE REPOSITORY
PULL
  ↓
COPY COURSE MATERIALS
  ↓
PERSONAL REPOSITORY
EDIT
  ↓
SAVE
  ↓
STAGE
  ↓
COMMIT
  ↓
PUSH
  ↓
PRIVATE GITHUB REPOSITORY
```
