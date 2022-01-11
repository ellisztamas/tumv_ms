# GWA conditioned on the top necrosis SNP

This folder contains code to run multitrait GWA on AUDPS, infectivity, severity 
of symptoms and necrosis in response, including the genotype at the most strongly
associated SNP as a cofactor. Cohort is also included as a cofactor.

This is run as a SLURM job using the script `GWA_condition_on_top_SNP.sh`. This script sets up the Conda environment, and runs R script `format_phenoypes.R` to create phenotype files for each trait and a single covariate file in a folder `phenotypes`. It then runs the Limix GWA script on each, and saves the ouput to `output`.