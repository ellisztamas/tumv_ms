"""
Tom Ellis, 31st January 2022

Script to pull out genotypes for the SNP most strongly associated with necrosis
(Chr2:5927469).
"""

import pandas as pd
import numpy as np
import h5py

from snp_2_hdf5 import snp_2_hdf5

# Import the 10-million-SNP matrix as an HDF5 file
genoFile = '01_data/1001_SNP_MATRIX/all_chromosomes_binary.hdf5'
geno_hdf = h5py.File(genoFile, 'r')

# Row numbers for the 9 GWAS hits.
locus = (2,5927469)
ix = snp_2_hdf5(geno_hdf, locus)

# Retrieve SNP genotypes, using a shockingly poor-style list comprehension
snp = geno_hdf['snps'][ix]
snp = pd.DataFrame(snp, columns = ['geno'])
  
# Insert a colum of accession names
code = [ x.decode(encoding = 'UTF-8') for x in  geno_hdf['accessions'][()] ]
snp.insert(0, 'code', code )

# write to disk
path = "01_data/top_snp.csv"
snp.to_csv(path, header=True, index= False)