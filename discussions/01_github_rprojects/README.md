# Discussion 01 – GitHub, R Projects, and Getting Help in R

## Session Goals

By the end of this discussion, you should be able to:

* distinguish among R, RStudio, R Projects, Git, and GitHub
* open and navigate an R Project
* use relative file paths
* import and inspect a dataset
* recognize R objects, functions, and arguments
* use R's built-in help system
* create a private GitHub repository
* add the instructor as a collaborator
* commit and push changes to GitHub

## Files for This Discussion

Open:

[Discussion 01.R](Discussion%2001.R)

The example dataset is located at:

```text
../../data/week01_example.csv
```

Because the course repository is an R Project, the script will use the relative path:

```r
dat <- read.csv("data/week01_example.csv")
```

## Before Class

Please make sure you have:

* R installed
* RStudio installed
* Git installed
* a GitHub account
* access to the ENTO 8030 course repository

## During Class

We will work through the R script together.

The session is organized into four major parts:

1. Navigating the course R Project
2. Basic R and getting help
3. Creating your personal ENTO 8030 repository
4. Committing and pushing your first file to GitHub

## Personal Repository

Create a **private** repository using the naming convention:

```text
ENTO_8030_LastName_FirstInitial
```

Example:

```text
ENTO_8030_Smith_J
```

Add the instructor's GitHub account as a collaborator:

```text
Conorfair
```

## End-of-Session Check

Before leaving, confirm that you can:

* open your personal R Project
* create or edit a file
* stage the change
* create a commit
* push the commit
* see the updated file on GitHub
