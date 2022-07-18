"""
Functions for interacting with the SNP matrix in Python.
"""

import numpy as np
import pandas as pd

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


def accession_indices(geno_hdf, mac, locus_indices):
    """
    Get the position indices for a subset of accessions in the genotype HDF file.

    Parameters
    ==========
    geno_hdf: HDF5 file
        HDF5 file with values for accession names, SNP positions, and a SNP matrix
    mac: numpy.ndarray
        Vector of integers giving minor allele counts at each SNP.
    locus_indices: numpy.ndarray
        Vector of integers giving indices of SNPs to retreive.

    Returns
    =======
    A tuple of numpy vectors, with a vector for each locus. Each vector gives
    the integer index position of the accessions in `geno_hdf` with the 1 allele
    at the SNP in question.
    """
    # Pull out the genotypes of those loci for all 1135 accessions.
    selected_snps = np.array([geno_hdf['snps'][i] for i in locus_indices])
    # It is possible that the minor allele could be coded as a zero. If so, flip it to a one.
    loci_to_flip = mac[locus_indices] > 900
    selected_snps[loci_to_flip] = 1- selected_snps[loci_to_flip]
    # Index positions for accessions with the minor allele at each SNP. 
    accession_indices = [np.where(i == 1)[0] for i in selected_snps]

    return accession_indices

def mean_pairwise_distances(dmat, accession_indices):
    """
    Get the mean distances between all pairs of accessions in subsets of 
    accessions

    Parameters
    ==========
    dmat: array
        Distance matrix between all 1135 pairs of accessions.
    accession_indices: tuple of vectors
        A tuple of numpy vectors, with a vector for each locus. Each vector gives
        the integer index position of the accessions in `geno_hdf` with the 1 allele
        at the SNP in question. This is the output of `accession_indices()`.
    
    Returns
    =======
    A DataFrame with a row for each locus, and colulms giving minor allele count
    and mean distance between all pairs of accessions.
    """
    mean_distances = [None] * len(accession_indices)
    counter = 0
    for i in accession_indices:
        # filter only the selected rows and columns
        submat = dmat[i][:, i]
        # take the upper triangular matrix
        submat = submat[ np.triu_indices(len(i), k = 1) ]
        # Remove NA distances
        submat = submat[~(np.isnan(submat))]

        mean_distances[counter] = np.mean(submat)
        counter += 1
    # Minor allele count for each locus
    mac = [len(i) for i in accession_indices]
    # output a DataFrame giving MAC and mean distance between accessions
    output = pd.DataFrame(
        {
            'mac' : mac,
            'mean_distance' : mean_distances
            })

    return output