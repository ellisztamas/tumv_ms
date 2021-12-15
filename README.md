# TuMV resistance in *A. thaliana*

A collaboration with Santiago Elena’s group at the University of Valencia investigating the genetic basis of resistance to turnip-mosaic virus in *Arabidopsis thaliana* as part of Anamarija Butkovic's PhD project.

## Table of contents

1. [Experimental set up](#experimental-set-up)
	1. [Screening](#screening)
	2. [Phenotypes](#phenotypes)
	3. [Analysis](#analysis)
3. [Data files](#data-files)
4. [Dependencies](#dependencies)
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
4. **Resistance** binary trait; 0 meant none of the plants showed symptoms of infection and 1 obvious symptoms of infection in at least one plant.
5. **Symptomatology** a semi-quantitative scale ranging from 0 - 5:
    0. no symptoms or healthy plant
    1. mild symptoms without chlorosis
    2. chlorosis is visible
    3. advanced chlorosis
    4. strong chlorotic symptoms and beginning of necrosis
    5. clear necrosis and death of the plant.

#### Analysis

Various analyses on the data were carried out by Tom Ellis. These are detailled in the folder `005_results/`. Each subfolder of that directory contains a markdown file `result_summary.md`, which is a markdown file listing what the folder was meant to investigate, and what the conclusion was.

## Data files

### Phenotypes

Raw data on phenotypes are found at `/groups/nordborg/raw.data/athaliana/phenotypes/tumv_resistance/`, but are linked to from `001_data/001_raw_data` inside the project folder.

There are two phenotype files, with an accompanying README: 

1. `GWAS_virus_fixed.csv`: Disease symptoms in 1050 accessions from the first screen
2. `replicate_experiment.csv` Disease symptoms in 118 accessions fom the second screen.

### Genotype data

For genome-wide associations we use the SNP matrix and kinship matrix associated with the [1001 Genomes project](https://1001genomes.org/).
Download and extract them to `01_data/1001_SNP_MATRIX` by running the following command from the folder root:

```
wget -c https://1001genomes.org/data/GMI-MPI/releases/v3.1/SNP_matrix_imputed_hdf5/1001_SNP_MATRIX.tar.gz -O - | tar -xz -C 01_data/
```

## Dependencies

### Genome-wide associations

GWA is done using the Python package *Limix*. A [conda](https://docs.conda.io/en/latest/) environment file `limix.yml` is provided to recapitulate dependencies. Assuming conda is installed on your machine, install the environment with
```
conda env create -f limix.yml
```
Activate it before running analyses with
```
conda activate limix
```

### R

Formatting phenotypes is done in R using the `tidyverse` bundle of packages. Maps are plotted using `maps` and `mapdata`, and rendered in `ggplot2`.

This project uses `renv` to ensure package versions match between machines. Open the project file `virus_resistance.Rproj` in the root directory of this project into RStudio (it won't work through the terminal!) and run `renv::refresh()`, and `renv` should automatically set up a local environment with the same package versions as were used to create the results. See the very good documentation on `renv` for more: https://rstudio.github.io/renv/articles/renv.html.

## Author information

* Principle investigator: Santiago Elena (University of Valencia)
* Data collection performed by Anamarija Butkovic Ruben Gonzales and others in Valencia
* Analyses run at GMI by Tom Ellis and Benjamin Jaegle.
