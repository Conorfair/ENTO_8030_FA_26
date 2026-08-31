# ENTO 8030 Discussion Sessions

This folder contains materials for the applied discussion sessions in **ENTO 8030: Advanced Quantitative Analysis in Entomological Science**.

Discussion sessions are designed to complement the lectures by emphasizing practical statistical analysis, R programming, interpretation, troubleshooting, and reproducible workflows.

---

## How to Use These Materials

Each discussion session is stored in its own folder.

A typical discussion folder may contain:

- a `README.md` with the goals and instructions for the session
- an R script used during class
- datasets or other files needed for the analysis
- example output
- optional practice exercises
- solution materials released after the discussion, when applicable

### Before Each Discussion

Before beginning a discussion session:

1. Open the **ENTO 8030 course R Project**.
2. Pull the most recent changes from the course GitHub repository.
3. Open the folder for the appropriate discussion.
4. Read the weekly `README.md`.
5. Identify the R script, datasets, and other files needed for that discussion.
6. Copy the required materials into your **personal ENTO 8030 repository**.
7. Open your **personal ENTO 8030 R Project**.
8. Complete the discussion using the copies in your personal repository.

Do not complete your personal course work directly in the instructor-maintained course repository.

---

## Discussion Schedule

| Discussion | Topic | Materials |
|---|---|---|
| 01 | GitHub, R Projects, and Getting Help in R | [Open Discussion 01](01_github_rprojects/) |
| 02 | t-tests and Chi-square Tests | [Open Discussion 02](02_t-test_and_Chi-square/) |
| 03 | Linear Models | [Open Discussion 03](03_linear_models/) |
| 04 | emmeans and Compact Letter Displays | `04_emmeans_cld/` |
| 05 | Random Effects Models | `05_random_effects/` |
| 06 | ggplot2 and Data Visualization | `06_ggplot/` |
| 07 | Bernoulli and Binomial Models | `07_binomial/` |
| 08 | Poisson and Negative Binomial Models | `08_count_models/` |
| Advanced | Advanced Topics | `advanced_topics/` |

The schedule and materials may be updated during the semester.

Folders that have not yet been linked will become available as their materials are added to the course repository.

---

## Course Repository vs. Personal Repository

Throughout the semester, you will work with **two separate repositories and R Projects**.

### Course Repository

The instructor-maintained course repository contains datasets,
discussion scripts, examples, and course resources. At the beginning of
a discussion or whenever new materials are announced, open the course R
Project and **pull** the newest changes.

Do not routinely edit your working copies of course files inside the
instructor-maintained repository.

You will primarily:

```text
PULL
  ↓
READ INSTRUCTIONS
  ↓
COPY NEEDED MATERIALS
```

from the course repository.

Treat this repository as the instructor copy of the course materials. Avoid editing or completing your personal work directly in this repository.

### Personal Repository

Your private ENTO 8030 repository contains your own course work. After
pulling new materials into the course repository:

1.  Read the `README.md` for that discussion.
2.  Copy the student R script(s) listed for that week into the
    corresponding folder of your private repository.
3.  Copy any required datasets listed in the weekly `README.md` from the
    course repository's `data/` folder into the `data/` folder of your
    private repository.
4.  Open your private R Project.
5.  Edit and run the copied scripts there.
6.  Stage, commit, and push your work to your private GitHub repository.

After copying the materials needed for a discussion into your personal repository, you will:

```text
OPEN PERSONAL R PROJECT
        ↓
EDIT / ANALYZE
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

Keeping these repositories separate helps prevent conflicts when new course materials are released and provides you with your own reproducible record of the work you complete during the semester.

---

## What Should I Copy?

The weekly `README.md` will identify the materials needed for each discussion.

Depending on the activity, this may include:

```text
R script
   +
dataset(s)
   +
other supporting files
```

Copy all files necessary to reproduce the analysis into your personal repository.

For example:

```text
COURSE REPOSITORY

discussions/
└── 02_t-test_and_Chi-square/
    └── Discussion_02.R

data/
├── gardens.csv
└── ladybirds.csv

             ↓ COPY

PERSONAL REPOSITORY

discussions/
└── 02_t-test_and_Chi-square/
    └── Discussion_02.R

data/
├── gardens.csv
└── ladybirds.csv
```

The goal is for the work in your personal repository to remain understandable and reproducible without depending on files that exist only somewhere else on your computer.

---

## A Consistent Analysis Workflow

Across discussion sessions, we will repeatedly use a common analytical workflow:

```text
Scientific Question
        ↓
Import Data
        ↓
Inspect and Validate Data
        ↓
Visualize
        ↓
Fit Model
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

Not every discussion will require every step.

The statistical methods will become more advanced throughout the semester, but the general process of moving from a scientific question to a defensible interpretation will remain consistent.

---

## Working with Discussion Scripts

Discussion scripts are intended to be **working documents**, not simply files to read.

During class, you may be asked to:

- run provided code
- modify existing code
- write new code
- answer questions in comments
- interpret R output
- troubleshoot errors
- create figures or tables
- compare alternative analyses

Make these changes to the copy of the script stored in your **personal repository**.

At the end of the discussion, save your work and commit it to your personal Git repository.

A useful commit message might be:

```text
Complete Discussion 02 t-test and Chi-square exercises
```

Then push the commit to your private GitHub repository.

---

## Solutions

Some discussions may include a completed solutions script.

When provided, solutions will generally be released **after the discussion session**.

Use solution files to:

- check your code
- review analyses completed during class
- compare interpretations
- troubleshoot problems
- revisit material later in the semester

Try to work through exercises yourself before relying on the completed solutions.

---

## Getting Help

You are not expected to memorize every R function or argument.

When you encounter an unfamiliar function, begin with R's documentation:

```r
?function_name
```

or:

```r
help(function_name)
```

You can examine the arguments accepted by a function using:

```r
args(function_name)
```

and view provided examples using:

```r
example(function_name)
```

For package-level help:

```r
help(package = "package_name")
```

Many packages also include longer tutorials called **vignettes**:

```r
vignette(package = "package_name")
```

Additional course resources are available in the [`resources/`](../resources/) folder.

---

## Remember the Weekly Routine

Before class:

```text
COURSE PROJECT
     ↓
PULL
     ↓
READ WEEKLY README
     ↓
COPY REQUIRED MATERIALS
```

During and after class:

```text
PERSONAL PROJECT
     ↓
WORK
     ↓
SAVE
     ↓
STAGE
     ↓
COMMIT
     ↓
PUSH
```

**Course repository = materials provided to you**

**Personal repository = work completed by you**
