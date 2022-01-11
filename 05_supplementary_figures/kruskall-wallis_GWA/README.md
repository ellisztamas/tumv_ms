# GWA conditioned on the top necrosis SNP

This folder contains code to run Kruskal-Wallis GWA on necrosis in response to TuMV-Anc and TuMV-Evo separately using PyGWAS.

This is run as a SLURM job using the script `kruskall-wallis.sh`. This script sets up the Conda environment, and runs R script `format_phenoypes.R` to create the phenotype files in a folder `phenotypes`. It then runs the GWA script on each, and saves the ouput to `output`.