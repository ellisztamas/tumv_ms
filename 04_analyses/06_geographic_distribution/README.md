Scripts in this folder compare pairwise distances between lines with susceptible
alleles at significant SNPs and, and between lines with the minor allele at
10,0000 randomly chosen SNPs of similar frequency.

`distance_matrix.R` creates and saves a
matrix of all pairwise distances between all 1135 accessions.

`distance_by_MAC.py`:
- Import the whole SNP matrix, and filter for those with a sufficient minor 
    allele count to estimate median distances, between 10 and 200 (roughly
    0.01 to 0.2 global allele frequency)
- Take a subsample of 10000 of those loci, and store who has the minor allele at
    each
- For each locus, subset the geographic distance matrix for the accessions 
    showing the minor allele
- Calculate mean distance between them