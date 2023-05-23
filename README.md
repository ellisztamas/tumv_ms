# TuMV resistance in *A. thaliana*

A collaboration with Santiago Elena’s group at the University of Valencia investigating the genetic basis of resistance to turnip-mosaic virus in *Arabidopsis thaliana* as part of Anamarija Butkovic's PhD project.

## Table of contents

1. [Experimental set up](#experimental-set-up)
3. [Data files](#data-files)
4. [Analysis](#analysis)
5. [Author information](#author-information)

## Experimental set up

### Screening

* Experiments were performed by Santiago Elena's lab at Valencia. Accessions were screened for infection symptoms when infected with (1) and ‘ancestral’ virus isolated from *Nicotiana benthiama*, and (2) an ‘evolved’ virus which had been through multiple generations on *A. thaliana*.
* In the initial main phenotyping effect, 1050 accessions were screened with 8 plants per accession. Owing to growth room requirements, accessions were split into four cohorts, with all plants of the same replicate included in the same cohort.
* Since neither accessions or individual plants were randomised over cohorts in the initial phenotyping effort, Santiago's group repeated the screen using 51 accessions that initial showed necrosis and 67 that did not, chosen from across the cohorts.

### Phenotypes

Plants were monitored for 21 days after inocculation and phenotyped for the following symptoms:

1. **AUDUPS**: The area under the disease progression stairs (a measure of both the speed and severity of infection)
2. **Infectivity**: proportion of infected plants per number of inoculated plants
3. **Necrosis** binary trait; 0 meant no necrosis and 1 necrosis. For the initial phenotyping screen 1 indicates necrosis in *any* individual of an accession; in the replicate experiment they scored necrosis on each plant individually.
4. **Symptomatology** a semi-quantitative scale ranging from 0 - 5:
    0. no symptoms or healthy plant
    1. mild symptoms without chlorosis
    2. chlorosis is visible
    3. advanced chlorosis
    4. strong chlorotic symptoms and beginning of necrosis
    5. clear necrosis and death of the plant.

## Data files

### SNP data

For genome-wide associations we use the SNP matrix and kinship matrix associated with the [1001 Genomes project](https://1001genomes.org/).
Download and extract them to `01_data/1001_SNP_MATRIX` by running the following command from the folder root:

```
wget -c https://1001genomes.org/data/GMI-MPI/releases/v3.1/SNP_matrix_imputed_hdf5/1001_SNP_MATRIX.tar.gz -O - | tar -xz -C 01_data/
```

PyGWAS requires specific file names for the input files which don't match the default names from this link. Rename the SNP matrix with:

```
mv 01_data/1001_SNP_MATRIX/imputed_snps_binary.hdf5 01_data/1001_SNP_MATRIX/all_chromosomes_binary.hdf5
```

### TAIR 10 genome

Download and the TAIR10 reference genome from:
```
https://www.arabidopsis.org/download/index-auto.jsp?dir=%2Fdownload_files%2FGenes%2FTAIR10_genome_release%2FTAIR10_chromosome_files
```

Unpack it to 01_data. The specific file needed is `TAIR10_chr_all.fas`

### Araport annotation

Download the Araport 11 annotation file an unzip it to `01_data`:
https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_GFF3_genes_transposons.current.gff.gz

Note! The Araport file will likely have the date of download as part of the file
(e.g. `Araport11_GFF3_genes_transposons.May2023.gff`), which makes it difficult
to keep scripts reproducible. As a workaround, delete the date manually, so the
filename looks something like `Araport11_GFF3_genes_transposons.gff`.

### Phenotypes

Aside from genotype files, there are nine additional data files in `01_data`:

1. `phenotypes_1050_accessions.csv`: Disease symptoms in 1050 accessions from the first screen
2. `replicate_experiment.csv`: Disease symptoms in 118 accessions in a replicate screen.
3. `the1001genomes_accessions.csv`: Accession information from the 1001 Genomes database.
4. `cohort_as_dummy.txt`: Text file indicating experimental cohort as four columns of dummy variables.
5. `cohort_as_factor.csv`: Cohort information, but as a single column.
6. `chr2_5923326.csv`: SNP genotype of each accession at the SNP showing the 
    strongest association with necrosis
7. `GWAS_clean_symptoms_mutants.csv`: Necrosis phenotypes of 10 replicates each 
    for Col-0 controls, at2G14080 mutants and at2g14120 mutants in response to 
    ancestral and evolved viruses.
8. `lines_with_TE_insert.txt`: Which accessions were identified to have a TE
    insertion in AT2G14080 by Benjamin Jaegle.
9. `phenotypes_genotypes.csv`: A summary (to plot figure 3) of whether each line
    showed necrosis in response to either virus, and its genotype at the most 
    strongly associated SNP.

## Analysis

Code to create the main and supplementary figures are given in the folder `04_main_figures` and `05_supplementary_figures`.
Each analysis has its own README file giving more information.

### Dependencies

Analysis were run on the GMI high-performance cluster. As such, dependencies may be somewhat idiosyncratic, but I have done my best to make the results reproducible on other machines.

#### Genome-wide associations

GWA is done using the Python package *Limix*. A [conda](https://docs.conda.io/en/latest/) environment file `limix.yml` is provided to recapitulate dependencies. Assuming conda is installed on your machine, install the environment with
```
conda env create -f limix.yml
```
Activate it before running analyses with
```
conda activate limix
```

#### R

This project uses R 4.0.3 with the following packages:

- The `tidyverse` bundle of packages, including `ggplot2`
- `ggtext`
- `grid`
- `magick`. On Ubuntu at least, this depends on the Linux library `librsvg2-dev`, which is best installed outside of R via apt.
- `cowplot`
- `ggpubr`
- `reshape2`
- `maps` and `mapsdata`
- `geosphere` 
- `patchwork`

Full package versions are given in `session_info.txt` (this is the output of `devtools::session_info()`).

### BLAST software

Download `ncbi-blast-2.7.1+` from the NCBI website, and unpack it to `02_library`:
```
https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html
```

## Author information

* Principle investigators: Santiago Elena (University of Valencia), Magnus Nordborg (Gregor Mendel Institute, Vienna)
* Data collection performed by Anamarija Butković Rubén González and others in Valencia
* Analyses with PacBio genomes were performed by Benjamin Jaegle; all other analyses were by Tom Ellis.