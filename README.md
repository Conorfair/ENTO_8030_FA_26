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

or this workflow.

The goal is not simply to produce an answer from R. The goal is to create an analysis that is organized, understandable, and reproducible.
