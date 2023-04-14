# A major virus-resistance association in *Arabidopsis thaliana* is consistent with frequency-depednent selection

## Symptoms in figure 2

14th April 2023

Rejigged figure 2 to show G and GxE for symptoms and necrosis, plus phenotypes
for the minor alleles, mutants, and TE inserts.

Repeated conditional GWAS for all phenotypes, but moved results to the SI
Merged G and GxE GWAS results for AUDPS and infectivity in the SI.
Reordered stuff in the SI to match the order of the text.

May or may not have messed up removing the relative risk stuff from fig2.

## Added phenotype differences

12th April 2023

Edited figure 1 to show differences between phenotype for each line

## 0.9 edits to figure 4

Changed fig 4 to be just a made with a table.
Colours in the table reflect colours on the map.

##0.8 Edits to Figures 1 and 2
    
Removed scale from figure 1, and arranged remaining figures horizontally.
Removed zoomed in manhattan plot from figure 2.
Other minor tweaks to each.

## 0.7 Filled out README

Filled out project README. Added `session_info.txt` giving R package versions.

## 0.6 Kruskall-Walli GWA

Added files to run the Kruskall-Wallis GWA. Also added doc strings to the GWA scripts in `02_library`.

## 0.5 Supplementary figures

Added code to create supplementary figures to `05_supplementary_figures`. Added code to run the multitrait GWA conditioned on the top necrosis SNP and the replciate dataset, plus an Rmarkdown file to create the figures.

## 0.4 Code for figure 1

Added code for figure 1, icnluding a readme.

## 0.3 Code to create the map

Commit of code to create figure 4, including a README file.

## 0.2 Multitrait GWA results

Commit of code to create figure 2. Added a README to that subfolder, and modified
the Limix script to accommodate new SNP file names.

## 0.7 Filled out README

Filled out project README. Added `session_info.txt` giving R package versions.

## 0.6 Kruskall-Walli GWA

Added files to run the Kruskall-Wallis GWA. Also added doc strings to the GWA scripts in `02_library`.

## 0.5 Supplementary figures

Added code to create supplementary figures to `05_supplementary_figures`. Added code to run the multitrait GWA conditioned on the top necrosis SNP and the replciate dataset, plus an Rmarkdown file to create the figures.

## 0.4 Code for figure 1

Added code for figure 1, icnluding a readme.

## 0.3 Code to create the map

Commit of code to create figure 4, including a README file.

## 0.2 Multitrait GWA results

Commit of code to create figure 2. Added a README to that subfolder, and modified
the Limix script to accommodate new SNP file names.

## 0.1 Initial commit

Set up a clean repository for files that will make it into the manuscript.
`.Rmd` files currently exist to do this, but the files are cumbersome because
the GWAS plots are so huge, so save these as .png files and upload those
instead.

Here is the structure I am aiming for

01_data
02_library
03_scripts
04_main_figures
    - 01_disease_phenotypes
    - 02_multitrait_GWA
    - 03_structural_variants
    - 04_geographic_distribution
05_supplementary figures
    - supplementary_figures.Rmd
    - S1_conditional_GWA
    - S2_multitrait_G
    - S3_multitrait_GxE
    - S4_kruskall_wallis_GWA
    - S5_replicate_experiment
manuscript.docx
limix.yml
README.md
change_log.md

In this commit I added data files, library code and scripts.
Also copied the README from the old repo and added a line to download the SNP data.
