# GWA conditioned on the top necrosis SNP

This folder contains code to run multitrait necrosis for the replicate dataset.

This is run as a SLURM job using the script `replicate_dataset.sh`. This script sets up the Conda environment, and runs R script `format_phenoypes.R` to create the phenotype file in a folder `phenotypes`. It then runs the Limix GWA script on each, and saves the ouput to `output`.