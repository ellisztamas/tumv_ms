# A major virus-resistance association in *Arabidopsis thaliana* is consistent with frequency-depednent selection

# 0.13 Overdispersion vs allele at the same frequency

I need to compare distances between accessions with similar allele frequencies.

`04_analyses/07_geographic_distribution/distance_matrix.R` creates and saves a
matrix of all pairwise distances between all 1135 accessions.

`04_analyses/07_geographic_distribution/distance_by_MAC.py`:
- Import the whole SNP matrix, and filter for those with a sufficient minor 
    allele count to estimate median distances, between 10 and 200 (roughly
    0.01 to 0.2 global allele frequency)
- Take a subsample of 10000 of those loci, and store who has the minor allele at
    each
- For each locus, subset the geographic distance matrix for the accessions 
    showing the minor allele
- Calculate mean distance between them

# 0.12 Updated supplementary figures

Changed script on SNP heritability to use the kinship matrix with only 1135, and
to remove the joint effects of kinship and major SNP.
Moved the plot for this from figure 2 to the supp figures.

Moved the code to plot LD between SNPs to the supp figures from relative_risk.R.

Fixed paths to GWAS files in supp figures.

## 0.11 Figures 1 and 2

Repeated figures 1 and 2.

Fig 1 now shows the phenotype scale, a correlation matrix and phenotype
differences. The cor matrix is much smaller, and gives correlations within virus
and between viruses.

Fig 2 now gives G and GxE results with an without the top snp as a covariate,
followed by a plot of effect sizes for 10 SNPs.

For the supplementary I need SNP heritability, a table of small loci and linkage 
matrix

## 0.10 Split up analyses from figures

I have new results that suggest I need to move what were supplementary results 
to main results. To facilitate that I am rearranging the folder form being 
organised by main and supplementary figures (with folders `04_main_figures` and
`05_supplementary_figures`), to splitting code to run all the analyses from code
 to create figures.

I created `03_data_preparation/ top_snp.py` to create a datafile for the genotypes at
Chr2:5927469 in `01_data`. To do this, I also added `02_library/snp_2_hdf5.py`
as a library function to do this.

Here is the structure I want to create after that:

- 04_analyses
    - 01_snp_heritability
    - 02_multitrait_GWA
    - 03_GWA_condition_on_top_SNP
    - 04_replicate_dataset
    - 05_gene_expression
    - 06_structural_variants
    - 07_geographic_distribution
- 05_figures
    - fig1
    - fig2
    - fig3
    - fig4
    - supplementary_materials

In this commit I moved files to where they need to go and went through the
results 1, 2, 3, 4 and 7 to make sure they run.

I still need to add results 05 and 06, and go through the figures.

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
03_data_preparation
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
