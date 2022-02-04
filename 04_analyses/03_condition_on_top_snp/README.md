# GWA conditioned on the top necrosis SNP

This folder contains code to run multitrait GWA on necrosis including the 
genotype at the most strongly associated SNP as a cofactor. Cohort is also
included as a cofactor.

This is run as a SLURM job using the script `GWA_condition_on_top_SNP.sh`. This 
script sets up the Conda environment, and runs the `top_snp.py` to pull out the 
genotype at Chr2:5927469, and then the `format_phenoypes.R` to 
create phenotype files for each trait and a single covariate file in a folder 
`phenotypes`. It then runs the Limix MTMM script, and saves the ouput to 
`output`.