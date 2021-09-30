
# Main Workflow: ruokay-twitter-academic
# 
# This workflow queries the academic Twitter API for tweets about R U Okay day
#
# Contributors: @lachlandeer

# --- Dictionaries --- #

# ALL_YEARS = ["2019"]

ALL_YEARS = ["2009",
             "2010",
             "2011", 
             "2012", 
             "2013",
             "2014",
             "2015",
             "2016",
             "2017",
             "2018",
             "2019",
             "2020"
             ]

# --- Variable Declarations ---- #
runR = "Rscript --no-save --no-restore --verbose"
logAll = "2>&1"

# --- Main Rules --- #

rule all:
    input:
        data = expand("out/data/rds/{iYear}_ruokay.rds", 
                        iYear = ALL_YEARS)

rule get_tweets:
    input:
        script    = "src/code/get_tweets.R",
        query     = "src/query-specs/tweet_terms.json",
        daterange = "src/query-specs/ruokay_2019.json",
    output:
        "out/data/rds/{iYear}_ruokay.rds"
    log:
        "logs/get_tweets_{iYear}_ruokay.txt"
    shell:
        "{runR} {input.script} \
            --query {input.query} \
            --daterange {input.daterange} \
            > {log} {logAll}"

# --- renv rules --- #
# Rules to control the R environment

## renv_install: installs renv onto machine
rule renv_install:
    shell:
        "R -e 'install.packages('renv')'"

## renv_consent: permission for renv to write files to system 
rule renv_consent:
    shell:
        "R -e 'renv::consent(provided = TRUE)'"

## renv_install: initialize a renv environment for this project
rule renv_init:
    shell:
        "R -e 'renv::init()'"

## renv_snap   : Look for new R packages in files & archives them
rule renv_snap:
    shell:
        "R -e 'renv::snapshot()'"

## renv_restore: Installs archived packages onto a new machine
rule renv_restore:
    shell:
        "R -e 'renv::restore()'"

# --- Workflow Visualization --- #
# Rules to visualize the workflow

## dag                : create the DAG as a pdf from the Snakefile
rule dag:
    input:
        "Snakefile"
    output:
        "dag.pdf"
    shell:
        "snakemake --dag | dot -Tpdf > {output}"

## filegraph          : create the file graph as pdf from the Snakefile 
##                     (i.e what files are used and produced per rule)
rule filegraph:
    input:
        "Snakefile"
    output:
        "filegraph.pdf"
    shell:
        "snakemake --filegraph | dot -Tpdf > {output}"

## rulegraph          : create the graph of how rules piece together 
rule rulegraph:
    input:
        "Snakefile"
    output:
        "rulegraph.pdf"
    shell:
        "snakemake --rulegraph | dot -Tpdf > {output}"

## rulegraph_to_png
rule rulegraph_to_png:
    input:
        "rulegraph.pdf"
    output:
        "assets/rulegraph.png"
    shell:
        "pdftoppm -png {input} > {output}"


# --- INSTALL GRAPHVIZ --- #

## install_graphviz   : install necessary packages to visualize Snakemake workflow 
rule graphviz:
    shell:
        "sudo apt-get install graphviz"

## install_graphviz_mac : install necessary packages to visualize Snakemake workflow on a mac 
rule graphviz_mac:
    shell:
        "brew install graphviz"

## install_poppler: install poppler-utils on ubuntu
rule install_poppler:
    shell:
        "sudo apt-get install -y poppler-utils"
