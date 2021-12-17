#!/usr/bin/env bash

# SLURM
#SBATCH --mem=40GB
#SBATCH --output=./05_supplementary_figures/replicate_dataset/log
#SBATCH --qos=medium
#SBATCH --time=5:00:00

# ENVIRONMENT #
module load build-env/2020
module load r/3.5.1-foss-2018b
module load anaconda3/2019.03
source $EBROOTANACONDA3/etc/profile.d/conda.sh
conda activate limix

export PYTHONPATH=$PYTHONPATH:./02_library/

# DATA #
branch=replicate_dataset # don't forget to change the log destination as well!
GENO=./01_data/1001_SNP_MATRIX
DIR=./05_supplementary_figures/${branch}
# Mapping script
MTMM=./02_library/multitrait.py

# format phenotypes
Rscript ${DIR}/format_phenotypes.R

# Output folder
OUT=${DIR}/output
mkdir -p $OUT

# Run the script
srun python $MTMM \
--phenotype ${DIR}/phenotypes/binary_necrosis.csv \
--genotype $GENO \
--maf 0.1 \
--outDir $OUT \