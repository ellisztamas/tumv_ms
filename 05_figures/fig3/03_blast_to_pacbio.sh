#!/bin/bash

# BLAST TAIR10 genes to each PacBio genome
# 
# This prepares a BLAST database for each PacBio genome and uses it to look for homology
# between genes/TE from the reference genome and each PacBio.
# 
# This is set up as a job array to run on the CLIP cluster as a SLURM job.
#
# Code by Benjamin Jaegle, adapated for publication by Tom Ellis


#SBATCH --job-name=blast_against_pacbios
#SBATCH --qos=short
#SBATCH --time=1:00
#SBATCH --mem=50gb
#SBATCH --array=0-161
#SBATCH --output=./slurm/blast_against_pacbios.%J.out
#SBATCH --error=./slurm/blast_against_pacbios.%J.err

### loading modules
ml build-env/2020
ml bedtools/2.27.1-foss-2018b
### generating bed files from the coordinate in TAIR10

AT_number=AT2G14080
number_gene_side=6
path_to_output=05_figures/fig3/output # Folder to save output files
path_to_pacbio=01_data/pacbio_genomes # Folder containing FASTA files for each PacBio genome.
path_to_ncbi=02_library/ncbi-blast-2.7.1+/bin # Path to the BLAST tools library
outdir=$path_to_output/$AT_number/blast_results/

mkdir -p $outdir

pacbio=($path_to_pacbio/*.fasta)
name_pacbio=$(basename ${pacbio[$SLURM_ARRAY_TASK_ID]})

## Generate the BLAST database.
## This only needs to be run once.
echo "Generating BLAST database."

$path_to_ncbi/makeblastdb \
-in $path_to_pacbio/$name_pacbio \
-parse_seqids \
-dbtype nucl

# BLAST each TAIR10-gene or -TE against the PacBio genome
echo "BLASTing against $name_pacbio."

for file in $path_to_output/$AT_number/fasta/*.fasta
do

GENE_FASTA=$file
name_file=$(basename $GENE_FASTA)
echo "Looking for homology with $name_file"
OUT_TXT=$name_pacbio$name_file.70.txt

$path_to_ncbi/blastn \
-query $GENE_FASTA \
-db $path_to_pacbio/$name_pacbio \
-task blastn \
-evalue 1 \
-out $outdir/$OUT_TXT \
-perc_identity 70 \
-outfmt "7 qseqid qacc sacc evalue qstart qend sstart send sseqid" \
-penalty -2 \
-reward 1 \
-word_size 11 \
-gapopen 1 \
-gapextend 1
done

echo "Blast done for $name_pacbio"