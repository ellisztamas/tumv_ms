import numpy as np

def snp_2_hdf5(geno_hdf, position):
    """
    Give a chromosome and SNP position in the reference genome coordinates, and
    get back a SNP position in the SNP matrix.

    Parameters
    ==========
    geno_hdf5: h5py
        HDF5 file with values for accession names, SNP positions, and a SNP matrix
    position: tuple
        SNP position to be retrieved. A tuple giving (chromosome, SNP).

    Returns 
    =======
    A integer giving the row index in geno_hdf['snps'] for the SNP

    Example
    =======
    # Genotype (G)
    genoFile = '/scratch-cbe/shared/genotypes_for_pygwas/1.0.0/full_imputed/all_chromosomes_binary.hdf5'
    # genoFile = "/groups/nordborg/projects/nordborg_common/datasets/genotypes_for_pygwas/1.0.0/all_chromosomes_binary.hdf5"
    geno_hdf = h5py.File(genoFile, 'r')

    snp_2_hdf5( geno_hdf, position = (2,5921620) )

    # Returns an error, because this SNP isn't in the matrix
    snp_2_hdf5( geno_hdf, position = (2,5980000) )

    Authors
    =======
    Tom Ellis, modifying code by Pieter Clauw
    """
    # Get the genotypes at the focal SNP
    chrIdx = geno_hdf['positions'].attrs['chr_regions']
    # get indices for covariate chromosome
    covarChr_Idx = chrIdx[position[0] - 1]

    pos_match = geno_hdf['positions'][covarChr_Idx[0]:covarChr_Idx[1]] == position[1]

    if any(pos_match):
        # get the index in the SNP matrix of the covariate locus
        covarLocus_Idx = np.where(geno_hdf['positions'][covarChr_Idx[0]:covarChr_Idx[1]] == position[1])[0][0] + covarChr_Idx[0]

        return covarLocus_Idx
    else:
        raise ValueError("There is no SNP matching this position in the SNP matrix.")