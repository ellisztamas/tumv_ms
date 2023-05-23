# Extract BED files for each genes around the major association
# 
# This looks into the Araport 11 annotation of the reference genome and creates 
# a BED file for each annotated gene or feature. This script takes arguments,
# so it assumed to call run this via `02_prepare_fasta.sh` rather than directly.
#
# Code by Benjamin Jaegle, adapated for publication by Tom Ellis

args <- commandArgs(trailingOnly = TRUE)
gene_AT <- as.character(args[1])
number_of_side_genes <- as.numeric(args[2])
path_for_file <- args[3]

# number_of_side_genes <- 6
# gene_AT <- "AT2G14080"
# path_for_file <- "/groups/nordborg/projects/tumv_resistance/005_results/018_structural_rearrangements/out_all/AT2G14080/bed"

#### extracting bed file of neigbouring genes

### function
gffRead <- function(gffFile, nrows = -1) {
  cat("Reading ", gffFile, ": ", sep="")
  gff = read.table(gffFile, sep="\t", as.is=TRUE, quote="",
                   header=FALSE, comment.char="#", nrows = nrows,
                   colClasses=c("character", "character", "character", "integer",  
                                "integer",
                                "character", "character", "character", "character"))
  colnames(gff) = c("seqname", "source", "feature", "start", "end",
                    "score", "strand", "frame", "attributes")
  cat("found", nrow(gff), "rows with classes:",
      paste(sapply(gff, class), collapse=", "), "\n")
  stopifnot(!any(is.na(gff$start)), !any(is.na(gff$end)))
  return(gff)
}


### preparing the TAIR10 gff
CHR <- as.numeric(substr(x = gene_AT, 3,3))
TAIR10 <- gffRead("01_data/Araport11_GFF3_genes_transposons.gff")
TAIR10_gene <- TAIR10[which(TAIR10$feature=="gene"),]
TAIR10_TE <- TAIR10[which(TAIR10$feature=="transposable_element_gene"),]
TAIR10_gene$attributes <- substr(TAIR10_gene$attributes,4,12)
TAIR10_TE <- TAIR10[grep("transposa", TAIR10$feature),]
TAIR10_TE <- TAIR10_TE[-which(TAIR10_TE$feature=="transposable_element_gene"),]
TAIR10_TE$attributes <- substr(TAIR10_TE$attributes,4,13)

if(length(which(TAIR10_gene$attributes==gene_AT))==0){
  print("This gene is not in TAIR10")
}else{
  bed_file <- c()
  file_name <- c()
  seq(-number_of_side_genes, number_of_side_genes,1)
  for(i in seq(-number_of_side_genes, number_of_side_genes,1)){
    bed_file <- rbind(bed_file,c(TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,c(1,4,5)], TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,9]))
    file_name <- c(file_name, TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,9])
  }
  
  start_bed <- bed_file[1,2]
  end_bed <- bed_file[length(bed_file[,1]),3]
  chr_te <- bed_file[1,1]
  te_bed_file <- TAIR10_TE[which(TAIR10_TE$start>start_bed & TAIR10_TE$end<end_bed & TAIR10_TE$seqname==chr_te),c(1,4,5,9)]
  
  for(j in c(1:length(bed_file[,1]))){
    write.table(
      bed_file[j,c(1,2,3)], 
      paste(path_for_file, bed_file[j,4], ".bed",sep="") , 
      col.names = F, row.names = F, quote = F, sep="\t")
  }
  if(length(te_bed_file[,1])>0){
    for(j in c(1:length(te_bed_file[,1]))){
      write.table(
        te_bed_file[j,c(1,2,3)],
        paste(path_for_file, te_bed_file[j,4], ".bed",sep="") ,
        col.names = F, row.names = F, quote = F, sep="\t")
    }
  }
}