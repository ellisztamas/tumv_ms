#!/usr/bin/env bash

# SLURM
#SBATCH --mem=40GB
#SBATCH --output=./04_analyses/02_multitrait_GWA/log
#SBATCH --qos=medium
#SBATCH --time=24:00:00
#SBATCH --array=0-3

# ENVIRONMENT #
module load build-env/2020
module load r/3.5.1-foss-2018b
module load anaconda3/2019.03
source $EBROOTANACONDA3/etc/profile.d/conda.sh
conda activate limix

export PYTHONPATH=$PYTHONPATH:./02_library/

# DATA #
branch=02_multitrait_GWA # don't forget to change the log destination as well!
GENO=./01_data/1001_SNP_MATRIX
DIR=./04_analyses/${branch}
# Mapping script
MTMM=./02_library/multitrait_with_covariate.py

# format phenotypes
echo "Formatting phenotypes.\n"
Rscript ${DIR}/format_phenotypes.R
FILES=(${DIR}/phenotypes/*.csv)
# Create covariate file with SNP to condition on.
COV=./01_data/cohort_as_dummy.txt

# Output foler
OUT=${DIR}/output
mkdir $OUT -p

# Run the script
echo "Running GWAS analysis\n"
srun python $MTMM \
--phenotype ${FILES[$SLURM_ARRAY_TASK_ID]} \
--genotype $GENO \
--covariates $COV \
--maf 0.03 \
--outDir $OUT