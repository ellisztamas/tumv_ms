#!/usr/bin/env bash

# SLURM
#SBATCH --mem=40GB
#SBATCH --output=./05_supplementary_figures/kruskall-wallis_GWA/log
#SBATCH --qos=medium
#SBATCH --time=8:00:00

# ENVIRONMENT #
module load build-env/2020
module load r/3.5.1-foss-2018b
module load anaconda3/2019.03
source $EBROOTANACONDA3/etc/profile.d/conda.sh
conda activate limix

export PYTHONPATH=$PYTHONPATH:./02_library/

# DATA #
branch=kruskall-wallis_GWA # don't forget to change the log destination as well!
DIR=./05_supplementary_figures/${branch}
GENO=./01_data/1001_SNP_MATRIX/

# format phenotypes
Rscript ${DIR}/format_phenotypes.R

# Output folder
OUT=${DIR}/output
mkdir -p $OUT

# load PyGWAS.
# Python needs to be reloaded wiuth version 2.7
module load pygwas/1.7.2-foss-2018b-python-2.7.15

# Run GWAS on the ancestral phenotypes
PHENO=${DIR}/phenotypes/ancestral.csv
pygwas run $PHENO \
--analysis kw \
--genotype $GENO \
--calc-ld \
--output_file ${OUT}/ancestral.csv
# Plot it
pygwas plot ${OUT}/ancestral.csv \
--output ${OUT}/ancestral.png \
--macs 105

# Run GWAS on the evolved phenotypes
PHENO=${DIR}/phenotypes/evolved.csv
pygwas run $PHENO \
--analysis kw \
--genotype $GENO \
--calc-ld \
--output_file ${OUT}/evolved.csv
# Plot it
pygwas plot ${OUT}/evolved.csv \
--macs 105 \
--output ${OUT}/evolved.png