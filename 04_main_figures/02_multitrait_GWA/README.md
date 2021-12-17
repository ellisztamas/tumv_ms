# Files to create figure 1

This folder contains the code to recreate figure 1, showing results of a multitrait GWA analysis of AUDPS, infectivity, severity of symptoms and necrosis.

This is run as a SLURM job using the script `01_job_submission.sh`. This script sets up the Conda environment, and runs R script `format_phenoypes.R` to create phenotype files for each trait in a folder `phenotypes`. It then runs the Limix GWA script on each, and saves the ouput to `output`.

There is also an Rmarkdown file `SNP_heritability.Rmd` to calculate SNP heritabilities using the R package `Sommer`. This file uses some Python via the `reticulate` package. It outputs the file `pseudoheritability.R` which is needed for plotting.

Plotting the figure is done by `fig1.R`