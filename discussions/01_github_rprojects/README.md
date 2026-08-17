# Discussion 01 – GitHub, R Projects, and Getting Help in R

This discussion introduces the computing and file-management workflow that we will use throughout **ENTO 8030: Advanced Quantitative Analysis in Entomological Science**.

The goal is not to become a Git or GitHub expert. Instead, we will establish a consistent system for accessing course materials, organizing your own work, and creating a reproducible record of the analyses you complete throughout the semester.

---

## Session Goals

By the end of this discussion, you should be able to:

- distinguish among R, RStudio, R Projects, Git, and GitHub
- open and navigate an R Project
- understand the difference between the course and personal repositories
- clone a GitHub repository to your computer
- pull updates from the course repository
- copy course materials into your personal repository
- use relative file paths within an R Project
- import and inspect a dataset
- recognize basic R objects, functions, and arguments
- use R's built-in help system
- create a private GitHub repository
- add the instructor as a collaborator
- stage and commit changes with Git
- push changes to your private GitHub repository

---

## Before Class

Please make sure you have:

- **R** installed
- **RStudio** installed
- **Git** installed
- a **GitHub account**
- access to the ENTO 8030 course repository

You can verify that Git is installed by opening a Terminal and entering:

```bash
git --version
```

If Git is installed correctly, you should see a version number similar to:

```text
git version 2.x.x
```

---

# Part 1 – The ENTO 8030 Repository Workflow

Throughout the semester, you will work with **two separate Git repositories and R Projects**.

They serve different purposes.

## Course Repository

The course repository is maintained by the instructor.

It contains:

- discussion materials
- datasets
- examples
- course resources
- other files distributed throughout the semester

Your primary workflow with this repository is:

```text
PULL
  ↓
READ INSTRUCTIONS
  ↓
COPY NEEDED MATERIALS
```

Treat this repository as the instructor copy of the course materials.

**Do not complete your personal course work directly in the course repository.**

---

## Personal Repository

You will also maintain your own **private ENTO 8030 repository**.

This repository contains the work that you complete during the course.

Your primary workflow with this repository is:

```text
EDIT
  ↓
SAVE
  ↓
STAGE
  ↓
COMMIT
  ↓
PUSH
```

By keeping the two repositories separate, you can continue receiving course updates without those updates conflicting with the files you have modified.

---

## The Complete Weekly Workflow

Throughout the semester, the general workflow will be:

```text
COURSE REPOSITORY
on your computer
       │
       │ Pull instructor updates
       ↓
Updated course materials
       │
       │ Copy files needed for the activity
       ↓
PERSONAL REPOSITORY
on your computer
       │
       │ Open personal R Project
       ↓
Edit / analyze / create output
       │
       │ Save
       ↓
Stage → Commit → Push
       │
       ↓
PERSONAL PRIVATE REPOSITORY
on GitHub
```

During today's discussion, we will set up and practice this entire workflow.

---

# Part 2 – Access the Course Repository

If you have not already cloned the course repository, we will do so now.

## Clone the Course Repository

On the ENTO 8030 GitHub repository page:

1. Select the green **Code** button.
2. Select **HTTPS**.
3. Copy the repository URL.

In RStudio, select:

**File → New Project → Version Control → Git**

Paste the repository URL into the **Repository URL** field.

Choose where you would like the repository stored on your computer and select:

**Create Project**

RStudio will clone the repository and open the course R Project.

### Clone vs. Pull

You normally **clone a repository once**.

```text
GitHub
   ↓
 CLONE
   ↓
Local repository created
```

After that, you use **pull** to retrieve new changes.

```text
GitHub
   ↓
 PULL
   ↓
Existing local repository updated
```

For the course repository:

```text
CLONE ONCE → PULL THROUGHOUT THE SEMESTER
```

---

# Part 3 – Navigate the Course R Project

Open the course R Project.

In the R Console, run:

```r
getwd()
```

This shows the current working directory.

Next, run:

```r
list.files()
```

You should see folders and files similar to:

```text
data
discussions
lectures
output
resources
README.md
ENTO 8030 Repo.Rproj
```

To examine files inside the project folders, run:

```r
list.files(recursive = TRUE)
```

---

## Files for This Discussion

The R script for today's discussion is:

[Open Discussion_01.R](Discussion_01.R)

The example dataset is stored in the course repository at:

```text
data/week01_example.csv
```

The script can therefore import the dataset using the relative path:

```r
dat <- read.csv("data/week01_example.csv")
```

Notice that we do not need to specify the complete location of the file on the computer.

For example, we do **not** need something like:

```text
/Users/yourname/Documents/ENTO8030/data/week01_example.csv
```

Using relative paths is one reason R Projects are useful for reproducible analyses.

---

# Part 4 – Basic R and Getting Help

We will use the Discussion 01 R script to review several basic features of R.

These include:

- importing data
- examining objects
- using functions
- specifying function arguments
- calculating simple summaries
- creating output
- using R's help system

You are **not expected to memorize every R function or argument**.

Part of becoming proficient with R is learning how to find reliable information when you need it.

---

## R Help Pages

If you want information about a function, you can use:

```r
?mean
```

or:

```r
help(mean)
```

To examine the arguments accepted by a function:

```r
args(mean)
```

To run examples included with the function documentation:

```r
example(mean)
```

For package-level documentation:

```r
help(package = "stats")
```

Many packages also contain longer tutorials called **vignettes**.

For example:

```r
vignette(package = "ggplot2")
```

R's documentation should be one of the resources you consider when you encounter an unfamiliar function or argument.

---

# Part 5 – Create Your Personal ENTO 8030 Repository

You will now create a separate repository for your own course work.

Go to GitHub and create a new repository.

Use the following naming convention:

```text
ENTO_8030_LastName_FirstInitial
```

For example:

```text
ENTO_8030_Smith_J
```

Your repository should be:

- **Private**
- owned by your GitHub account

When creating the repository, you may initialize it with a `README.md`.

---

# Part 6 – Add the Instructor as a Collaborator

On your personal repository's GitHub page:

1. Select **Settings**.
2. Under **Access**, select **Collaborators** or **Collaborators and teams**.
3. Select **Add people**.
4. Search for:

```text
Conorfair
```

5. Select the instructor account.
6. Send the invitation.

The instructor must accept the invitation before collaborator access becomes active.

**Do not make your repository public.**

---

# Part 7 – Clone Your Personal Repository

Your personal repository also needs a local copy on your computer.

On your personal repository's GitHub page:

1. Select the green **Code** button.
2. Select **HTTPS**.
3. Copy the repository URL.

In RStudio, select:

**File → New Project → Version Control → Git**

Paste your personal repository URL into the **Repository URL** field.

Choose a location on your computer and select:

**Create Project**.

You should now have **two separate R Projects** on your computer:

```text
ENTO 8030/
│
├── ENTO_8030_FA_26/
│   └── Course R Project
│
└── ENTO_8030_LastName_FirstInitial/
    └── Personal R Project
```

The exact folder names and locations may differ on your computer.

---

# Part 8 – Copy Today's Materials to Your Personal Repository

Before modifying today's R script, copy the files needed for the activity from the **course repository** into your **personal repository**.

For Discussion 01, copy:

```text
Discussion_01.R
```

and:

```text
week01_example.csv
```

Your personal repository should contain an organized location for these files.

For example:

```text
ENTO_8030_LastName_FirstInitial/
│
├── data/
│   └── week01_example.csv
│
├── discussions/
│   └── 01_github_rprojects/
│       └── Discussion_01.R
│
└── ENTO_8030_LastName_FirstInitial.Rproj
```

You may need to create the `data/` and `discussions/` folders in your personal repository.

---

# Part 9 – Switch to Your Personal R Project

After copying the files, open your **personal ENTO 8030 R Project**.

This is an important step.

From this point forward, any changes you make during the discussion should be made to the copies stored in your personal repository.

Run:

```r
getwd()
```

and:

```r
list.files()
```

to confirm that you are now working inside your personal project.

You should be able to import the copied dataset using:

```r
dat <- read.csv("data/week01_example.csv")
```

The same relative path works because the personal repository uses the same organized folder structure.

---

# Part 10 – Make a Change

Open your personal copy of:

```text
Discussion_01.R
```

Make a small change to the file.

For example, add a comment near the top:

```r
# My first ENTO 8030 Git commit
```

Save the file.

Git should now recognize that the file has changed.

---

# Part 11 – Stage and Commit the Change

Open the **Git** pane in RStudio.

You should see the modified R script listed.

## Stage

Select the checkbox next to the file.

This **stages** the change and tells Git that you want the file included in the next commit.

## Commit

Select **Commit**.

Enter a descriptive commit message such as:

```text
Complete initial Discussion 01 Git practice
```

Then select **Commit**.

A commit creates a checkpoint in the history of your repository.

---

# Part 12 – Push to Your Private GitHub Repository

After committing the change, select **Push**.

Conceptually:

```text
Personal R Project
       ↓
     COMMIT
       ↓
Local Git repository
       ↓
      PUSH
       ↓
Personal private repository on GitHub
```

If GitHub asks you to authenticate, use your GitHub credentials and the authentication method configured for your account.

For HTTPS authentication, GitHub may require a **personal access token (PAT)** rather than your GitHub account password.

---

# Part 13 – Verify the Push

Open your personal repository on GitHub.

Navigate to your Discussion 01 R script.

Confirm that:

1. the file appears in the repository
2. your change appears in the file
3. your commit appears in the repository history

You have now completed the full ENTO 8030 workflow:

```text
COURSE REPOSITORY
       ↓
     PULL
       ↓
COPY COURSE MATERIALS
       ↓
PERSONAL R PROJECT
       ↓
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
PERSONAL PRIVATE GITHUB REPOSITORY
```

---

# What Happens Next Week?

You do **not** need to repeat the entire setup process every week.

Both repositories are now cloned to your computer.

Beginning with Discussion 02, the routine will generally be:

## Course Repository

```text
Open course R Project
        ↓
Pull
        ↓
Read weekly README
        ↓
Copy required materials
```

## Personal Repository

```text
Open personal R Project
        ↓
Complete discussion
        ↓
Save
        ↓
Stage
        ↓
Commit
        ↓
Push
```

This will become our normal workflow throughout the semester.

---

# End-of-Session Check

Before leaving, confirm that you can:

- identify the difference between R, RStudio, an R Project, Git, and GitHub
- distinguish between the course repository and your personal repository
- open the course R Project
- pull changes from the course repository
- locate the weekly discussion materials
- copy course materials into your personal repository
- open your personal R Project
- use relative file paths
- import and inspect a dataset
- use R's built-in help system
- create and access your private GitHub repository
- confirm that the instructor has been invited as a collaborator
- edit and save a file in your personal repository
- stage a change
- create a commit
- push the commit to GitHub
- verify the updated file on GitHub

---

## The Most Important Workflow to Remember

If you remember only one Git/GitHub workflow from today's discussion, remember:

```text
COURSE PROJECT
PULL → COPY

PERSONAL PROJECT
EDIT → SAVE → STAGE → COMMIT → PUSH
```

The course repository provides the materials.

Your personal repository contains **your work**.
