# Order PacBio genomes

# To sanitise plotting, this creates a textfile of line names ordering each PacBio
# by how large the space between AT2G14080 and AT2G14120 is.

# Code by Benjamin Jaegle, adapated for publication by Tom Ellis

number_of_side_genes <- 6
gene_AT        <- 'AT2G14080' # Gene to focus on
blast_results  <- paste0("05_figures/fig3/output/",gene_AT, "/blast_results/") # output of `03_blast_to_pacbio.sh`
path_to_pacbio <- '01_data/pacbio_genomes' # Folder containing FASTA files for each PacBio genome.
output_path    <- paste0("05_figures/fig3/output/",gene_AT, "/order/") # Folder with PacBio genomes and BLAST database

dir.create(output_path)

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
TAIR10 <- gffRead("01_data/Araport11_GFF3_genes_transposons.gff")
TAIR10_gene <- TAIR10[which(TAIR10$feature=="gene" | TAIR10$feature=="transposable_element_gene"),]
TAIR10_gene$attributes <- substr(TAIR10_gene$attributes,4,12)

bed_file <- c()
file_name <- c()
for(i in seq(-number_of_side_genes, number_of_side_genes,1)){
  bed_file <- rbind(
    bed_file,
    c(
      TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,c(1,4,5)], 
      TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,]
      )
    )
  file_name <- c(file_name, TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,9])
}

PACBIO <- dir(path_to_pacbio)
PACBIO <- PACBIO[-grep(".nhr",PACBIO, fixed=T)]
PACBIO <- PACBIO[-grep(".nin",PACBIO, fixed=T)]
PACBIO <- PACBIO[-grep(".nog",PACBIO, fixed=T)]
PACBIO <- PACBIO[-grep(".nsd",PACBIO, fixed=T)]
PACBIO <- PACBIO[-grep(".nsi",PACBIO, fixed=T)]
PACBIO <- PACBIO[-grep(".nsq",PACBIO, fixed=T)]

# setwd(paste(path_for_file, gene_AT, sep=""))

pacbio_range_all <- c()
for(i in c(1:length(PACBIO))){
  coordinate_min_max <- c()
  for(k in c(7,12)){
    gene_check <- file_name[k]
    TAIR_gene_length <- TAIR10_gene[which(TAIR10_gene$attributes==gene_check),"end"]-TAIR10_gene[which(TAIR10_gene$attributes==gene_check),"start"]
    coordinate_gene <- read.table(
      paste(blast_results, PACBIO[i], gene_check, ".fasta.70.txt", sep="")
    )
    coordinate_gene <- coordinate_gene[which((coordinate_gene[,6]-coordinate_gene[,5])>(TAIR_gene_length*0.4)),]
    # print(length(coordinate_gene[,1]))
    if(length(coordinate_gene[,1])>0){
      coordinate_gene_2 <- coordinate_gene[,c(9,7,8)]
      coordinate_gene_1 <- coordinate_gene_2
      for(k in c(1:length(coordinate_gene_2[,1]))){
        coordinate_gene_1[k,2] <- min(coordinate_gene_2[k,c(2,3)])
        coordinate_gene_1[k,3] <- max(coordinate_gene_2[k,c(2,3)])
      }
      coordinate_gene_1 <- cbind(coordinate_gene_1, PACBIO[i])
      
      
    }
    coordinate_min_max <- rbind(coordinate_min_max, coordinate_gene_1[1,])
    
  }
  pacbio_range <- c(tools::file_path_sans_ext(PACBIO[i]),min(coordinate_min_max[1,c(2,3)]), max(coordinate_min_max[2,c(2,3)]), coordinate_min_max[1,1])
  pacbio_range_all <-  rbind(pacbio_range_all, pacbio_range)
}
# pacbio_range_all[order(as.numeric(pacbio_range_all[,3])-as.numeric(pacbio_range_all[,2]), decreasing = F),1]

write.table(
  pacbio_range_all[order(as.numeric(pacbio_range_all[,3])-as.numeric(pacbio_range_all[,2]), decreasing = F),1],
  file=paste(output_path, gene_AT,".txt", sep=""),
  col.names = F, row.names = F, quote = F, sep="\t"
  )
