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

### Genotype data

For genome-wide associations we use the SNP matrix and kinship matrix associated with the [1001 Genomes project](https://1001genomes.org/).
Download and extract them to `01_data/1001_SNP_MATRIX` by running the following command from the folder root:

```
wget -c https://1001genomes.org/data/GMI-MPI/releases/v3.1/SNP_matrix_imputed_hdf5/1001_SNP_MATRIX.tar.gz -O - | tar -xz -C 01_data/
```

### Phenotypes

Aside from genotype files, there are six additional data files in `01_data`:

1. `phenotypes_1050_accessions.csv`: Disease symptoms in 1050 accessions from the first screen
2. `replicate_experiment.csv`: Disease symptoms in 118 accessions in a replicate screen.
3. `the1001genomes_accessions.csv`: Accession information from the 1001 Genomes database.
4. `cohort_as_dummy.txt`: Text file indicating experimental cohort as four columns of dummy variables.
5. `cohort_as_factor.csv`: Cohort information, but as a single column.
6. `chr2_5923326.csv`: SNP genotype of each accession at the SNP showing the strongest association with necrosis

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

## Author information

* Principle investigators: Santiago Elena (University of Valencia), Magnus Nordborg (Gregor Mendel Institute, Vienna)
* Data collection performed by Anamarija Butković Rubén González and others in Valencia
* Analyses with PacBio genomes were performed by Benjamin Jaegle; all other analyses were by Tom Ellis.