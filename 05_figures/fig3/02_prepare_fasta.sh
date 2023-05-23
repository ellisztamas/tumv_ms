#!/bin/bash

# Script to prepare data for BLASTING
#
# This finds the sequences corresponding to six genes/TEs
# on either side of AT2G14080 annotated in the reference genome.
#
# This is set up as a SLURM job to run on the CLIP cluster.
#
# Code by Benjamin Jaegle, adapated for publication by Tom Ellis

#SBATCH --job-name=prepare_to_blast_off
#SBATCH --qos=short
#SBATCH --time=1:00
#SBATCH --mem=50gb
#SBATCH --output=./slurm/prepare_to_blast_off.%J.out
#SBATCH --error=./slurm/prepare_to_blast_off.%J.err

### Load modules for the CLIP cluster (via SLURM)
ml build-env/2020
ml r/3.5.1-foss-2018b
ml bedtools/2.27.1-foss-2018b

echo "Starting script to plot genome structures.\n"

# Parameters for data processing
AT_number=AT2G14080 # Gene to focus on
number_gene_side=6 # How many annotated features either side of `AT_number` to extract.
path_to_output=05_figures/fig3/output # Folder to save output files

# Extract BED files for each of the annotated features around AT2G14080
echo "Extracting BED files"
outdir_bed=$path_to_output/$AT_number/bed/
mkdir -p $outdir_bed
Rscript 05_figures/fig3/01_extract_bed_files.R \
$AT_number \
$number_gene_side \
$outdir_bed

## Convert BED to FASTA
echo "Extracting FASTA files from BED."
mkdir -p $path_to_output/$AT_number/fasta

for bed_file in $path_to_output/$AT_number/bed/*.bed
do
echo "Extracting bed file for ${bed_file}"
bedtools getfasta \
-fi 01_data/TAIR10_chr_all.fas \
-bed $bed_file \
-name \
-fo ${bed_file//bed/fasta}
done
echo "Extraction of fasta for blast done"