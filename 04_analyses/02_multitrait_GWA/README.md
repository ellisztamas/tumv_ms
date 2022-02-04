# Files to create figure 1

This folder contains the code to run a multitrait GWA analysis of AUDPS, infectivity, severity of symptoms and necrosis.

This is run as a SLURM job using the script `multitrait_GWA.sh`. This script sets up the Conda environment, and runs R script `format_phenoypes.R` to create phenotype files for each trait in a folder `phenotypes`. It then runs the Limix GWA script on each, and saves the ouput to `output`.