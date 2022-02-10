#!/usr/bin/env bash

# SLURM
#SBATCH --mem=40GB
#SBATCH --output=./04_analyses/03_condition_on_top_snp/log
#SBATCH --qos=medium
#SBATCH --time=12:00:00

# ENVIRONMENT #
module load build-env/2020
module load r/3.5.1-foss-2018b
module load anaconda3/2019.03
source $EBROOTANACONDA3/etc/profile.d/conda.sh
conda activate limix

export PYTHONPATH=$PYTHONPATH:./02_library/

# DATA #
branch=03_condition_on_top_snp # don't forget to change the log destination as well!
GENO=./01_data/1001_SNP_MATRIX/
DIR=./04_analyses/${branch}
# Mapping script
MTMM=./02_library/multitrait_with_covariate.py

# Get the genotype at the most stongly associated SNP
python 03_data_preparation/top_snp.py
# format phenotypes
Rscript ${DIR}/format_phenotypes.R
FILES=(${DIR}/phenotypes/*.csv)
# Covariate file with SNP to condition on. This is created by `format_phenotypes.R`
COV=${DIR}/phenotypes/covariates.txt

# Output folder
OUT=${DIR}/output
mkdir $OUT -p

# Run the script
srun python $MTMM \
--phenotype ${DIR}/phenotypes/necrosis.csv \
--genotype $GENO \
--covariates $COV \
--maf 0.03 \
--outDir $OUT