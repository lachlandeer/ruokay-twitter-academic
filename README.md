# Using Twitter's Academic API to get Tweets on R U Okay Day

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![lifecycle](https://img.shields.io/badge/version-0.1.0-red.svg)]()

## Introduction

This workflow queries Twitter's Academic API for tweets about R U Okay day over multiple time periods.

We use R's `academictwitteR` package to interact with the API, and `Snakemake` to execute to the entire workflow.

## Installation Instructions

Follow these Steps to install the necessary software on your system.

**We assume you are using a Debian flavoured Linux system**

You need to have the following software and packages installed:

1. Python 3 (Python 3.6 or higher)
2. Snakemake (we'll install the correct version in a couple of lines time!)
3. R (version 4.0.x)

### Installing Python


Install Python using the deadsnakes ppa:

- Here's how to add the deadsnakes ppa and install Python 3.8

```bash
$ sudo add-apt-repository ppa:deadsnakes/ppa
$ sudo apt-get install software-properties-common
$ sudo apt-get update
$ sudo apt-get install python3.8
```

### Installing Snakemake

We have included a `requirements.txt` file that we can use to install a specific version of snakemake.
This makes sure that our example runs on your machine (or at least won't break because you use a different version of snakemake than we do)

``` bash
pip3 install -r requirements.txt
```

you may need to replace `pip3` with `pip`

### Installing `R`

We provide instructions on how to install R [here](https://pp4rs.github.io/2020-uzh-installation-guide/r)

### Install the Required `R` libraries

We utilize many additional R packages inside the scripts that build our project.
To ensure that our project runs on every machine without issues relating to R packages not being installed we utilize `renv` to control the list of packages needed to run this example, and to monitor the version of the package we use.

Once you have completed the installation instructions above, we have provided a simple command to install renv.
Open a terminal and navigate to this directory.
Then in the terminal enter the following command to install renv:

``` bash
snakemake --cores 1 renv_install
```

Then you will need to provide consent for `renv` to be able to write files to your system:

``` bash
snakemake --cores 1 renv_consent
```

Once this is complete you can use renv to create a separate R environment that contains the packages we use in our example by entering the following command into the terminal:

``` bash
snakemake --cores 1 renv_init
```

The above command will initialize a separate R environment for this project.

Now we will install the necessary packages (and their precise versions) which are stored in the `renv.lock` file:

``` bash
snakemake --cores 1 renv_restore
```

This will install all the packages we need. It may take a while.

## Running the Workflow

Once the installation instructions are complete, we can run the project.
The result will be datasets for containing tweets about R U Okay day.
Each data set (which in our case is a folder of data) contains one year of data.

Before running the project, you must store the Twitter API Bearer Token in your `.Renviron` file under the name TWITTER_BEARER. 

For more details see the documentation of the function `set_bearer()` from the `academictwitteR` package.

To run the project, enter the following into the terminal:

``` bash
snakemake --cores 1 all
```

This will run through the pipeline and collect all data for the project.
Notice you may get constrained by Twitter's API limits - thus you might need to run the workflow multiple times over multiple months, adjusting the `ALL_YEARS` list in the `Snakefile`.