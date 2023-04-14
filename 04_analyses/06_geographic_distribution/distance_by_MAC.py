"""
Tom Ellis, 22nd June 2022

Python script to retrieve the mean distances between pairs of accessions 
harbouring the minor allele at each locus associated with necrosis. It also 
calculates the same for a random sample of loci of similar allele frequency.
"""

import pandas as pd
import numpy as np
import h5py
from importlib.machinery import SourceFileLoader
# Import custom functions
smf = SourceFileLoader('snp_matrix_functions', '02_library/snp_matrix_functions.py').load_module()

# Import the 10-million-SNP matrix as an HDF5 file
genoFile = '01_data/1001_SNP_MATRIX/all_chromosomes_binary.hdf5'
geno_hdf = h5py.File(genoFile, 'r')
# Convert accesion names form byte to string
code = [ x.decode(encoding = 'UTF-8') for x in  geno_hdf['accessions'][()] ]

# Import a geographic distance matrix for all 1135 accessions.
# See `04_analyses/07_geographic_distribution/distance_matrix.R` for how that's generated.
dmat = np.genfromtxt("04_analyses/07_geographic_distribution/output/distance_matrix.csv", delimiter = ",")

# Import GWAS results
gwas = pd.read_csv("05_figures/fig2/relative_risk/output/top_gwas_results.csv")
# List of tuples giving (chr, position)
coords = [(x,y) for x,y in zip(gwas['chr'], gwas['pos']) ]
# Row numbers for the 9 GWAS hits.
gwas_hits = [smf.snp_2_hdf5(geno_hdf, x) for x in coords]

# Phenotype data, to get a list of accession names that were phenotyped.
pheno = pd.read_csv("01_data/phenotypes_1050_accessions.csv")
# Get a vector of indices for those accessions included in the study
phenotyped_accessions = pheno['code'].astype('str').to_list()
phenotyped_indices    = np.where( [x in phenotyped_accessions for x in code] )[0]

# Minor allele counts at each locus
mac = geno_hdf['snps'][()].sum(1)
# Boolean vector of which have minor allele counts between 10 and 200
rare_alleles = np.where(
    ( (mac > 10)   & (mac < 200) ) |
    ( (mac < 1125) & (mac > 935) ) # allow for loci where the minor allele is coded as 0
)[0]
# Choose the index positions for a random set of loci
random_loci = np.random.choice(rare_alleles, size = 10000, replace = False)

# Get the indices of subsets of accessions in the genotype HDF5 file.
random_accessions   = smf.accession_indices(geno_hdf, mac, random_loci)
observed_accessions = smf.accession_indices(geno_hdf, mac, gwas_hits)
# Keep only those that were phenotyped.
random_accessions   = [x[np.in1d(x, phenotyped_indices)] for x in random_accessions]
observed_accessions = [x[np.in1d(x, phenotyped_indices)] for x in observed_accessions]

# Mean distances between pairs of accessions for observed and random loci.
random_distances   = smf.mean_pairwise_distances(dmat, random_accessions)
observed_distances = smf.mean_pairwise_distances(dmat, observed_accessions)
# For the observed loci, add some columns giving chromosome and SNP position
observed_distances['chr'] = gwas['chr']
observed_distances['pos'] = gwas['pos']

# Write to disk
random_distances.to_csv(
    "04_analyses/07_geographic_distribution/output/distances_between_random_loci.csv",
    index = False
    )
observed_distances.to_csv(
    "04_analyses/07_geographic_distribution/output/distances_between_observed_loci.csv",
    index= False
    )