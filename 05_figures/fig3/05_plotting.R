# Plot figure 3
#
# This plots (A) a close-up of the peak of association with necrosis from figure 2
# and (B) the structure of each PacBio genome around AT2G14080 and AT2G14120.
#
# Code by Benjamin Jaegle, adapated for publication by Tom Ellis

number_of_side_genes <- 6
gene_AT        <- "AT2G14080"
blast_results  <- "05_figures/fig3/output/AT2G14080/blast_results/"
path_to_pacbio <- "01_data/pacbio_genomes/"
genome_order   <- "05_figures/fig3/output/AT2G14080/order/"
path_for_gwas  <- "04_analyses/02_multitrait_GWA/output/Necrosis_Evo_Necrosis_Anc_0.03_MTMM_G.csv"
output_file    <- '05_figures/fig3/output/AT2G14080/fig3.pdf'

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
TAIR10_gene <- TAIR10[which(TAIR10$feature=="gene"),]
TAIR10_TE <- TAIR10[which(TAIR10$feature=="transposable_element_gene"),]
TAIR10_gene$attributes <- substr(TAIR10_gene$attributes,4,12)
TAIR10_TE <- TAIR10[grep("transposa", TAIR10$feature),]
TAIR10_TE <- TAIR10_TE[-which(TAIR10_TE$feature=="transposable_element_gene"),]
TAIR10_TE$attributes <- substr(TAIR10_TE$attributes,4,13)

### necrosis phenotype
necro_pheno <- read.table("01_data/phenotypes_genotypes.csv", sep=",", header=T)

color_pheno <- c("#4285f4", "#34a853", "#ea4335", "gray")

###defining parameters
xlim_plot=c(-110000, 160000)
CHR <- as.numeric(substr(x = gene_AT, 3,3))
centering_1 <- number_of_side_genes-3
centering_2 <- number_of_side_genes+4
gene_with_link <- seq(1,(number_of_side_genes*2)+1,1)

bed_file <- c()
file_name <- c()
for(i in seq(-number_of_side_genes, number_of_side_genes,1)){
  bed_file <- rbind(bed_file,c(TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,c(1,4,5)], TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,9]))
  file_name <- c(file_name, TAIR10_gene[which(TAIR10_gene$attributes==gene_AT)+i,9])
}

start_bed <- bed_file[1,2]
end_bed <- bed_file[length(bed_file[,1]),3]
chr_te <- bed_file[1,1]
te_bed_file <- TAIR10_TE[which(TAIR10_TE$start>start_bed & TAIR10_TE$end<end_bed & TAIR10_TE$seqname==chr_te),c(1,4,5,9)]
file_name <- c(file_name,te_bed_file[,4])

PACBIO <- dir(path_to_pacbio)
PACBIO <- grep("fasta$", PACBIO, value = TRUE)

#### setting up the order of the accessions based on multiple alignement

PACBIO_order <- as.character(
  read.table(
    paste(genome_order, gene_AT,".txt", sep="")
  )[,1]
)
# PACBIO_order <- PACBIO_order[seq(1,length(PACBIO_order), 2)]
 PACBIO_order <- PACBIO_order[sort(c(
  which(PACBIO_order %in% necro_pheno$code[necro_pheno$Phenotype == "Necrotic"]), 
  which(PACBIO_order %in% necro_pheno$code[necro_pheno$Phenotype != "Necrotic"])[seq(1,130,2)]
))
]
 
match_necro_pheno <- necro_pheno[match(PACBIO_order, necro_pheno[,1]),]
 

#### setting up the color
# setwd(paste(path_for_file,gene_AT,"/", sep=""))

#"#ca0020", "#0571b0"
color_fun <- colorRampPalette(c("red", "blue", "green"))
colors_list <- color_fun((number_of_side_genes*2)+1)
if(number_of_side_genes==number_of_side_genes){
  color_genes <- colors_list
  if(length(file_name)>length(color_genes)){
    color_genes <- cbind(file_name, c(color_genes, cbind(seq(1,length(file_name)-length(color_genes),1), "orange")[,2]))[,2]
  }
}


### setting up new color
#red "#ca0020"
#purple "#8856a7"
color_genes[-which(file_name=="AT2G14120" | file_name=="AT2G14080")] <- "#bdbdbd"
color_genes[which(file_name=="AT2G14120" | file_name=="AT2G14080")] <- c("#8856a7","#d01c8b")
color_genes[grep("TE", file_name)] <- "orange"

color_genes_trans <- c("#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#8856a71A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A", "#d01c8b1A", "#bdbdbd1A", "#bdbdbd1A", "#bdbdbd1A")
#color_genes_trans <- c("#FF00001A", "#EF000F1A", "#DF001F1A", "#CF002F1A", "#BF003F1A", "#AF004F1A", "#9F005F1A", "#8F006F1A", "#7F007F1A", "#6F008F1A", "#5F009F1A", "#4F00AF1A", "#3F00BF1A", "#2F00CF1A", "#1F00DF1A", "#0F00EF1A", "#0000FF1A")



# pdf(output_file, height=20/2.54, width = 16.9/2.54)

par(cex=1, mar=c(5,1,1,0))
plot(0, type="n", xlim=xlim_plot, ylim=c(0, (length(PACBIO_order)*12.5)), xlab="Relative coordinates (kb)", axes = F, ylab="")
axis(1, at = c(-100000,-75000, -50000,-25000, 0, 25000, 50000, 75000, 100000, 125000), labels = seq(-100, 125, 25))
# ### adding the legend
text(x=c(-118000, -118000), y= c(700, 1000), labels = c("B", "A"), cex=1)


## adding GWAS results 
start_gene_D <- (
  TAIR10_gene[which(TAIR10_gene$attributes=="AT2G14080"),"start"] + 
    TAIR10_gene[which(TAIR10_gene$attributes=="AT2G14120"),"end"]
)/2
GWAS_values <- read.table(path_for_gwas, sep=",", header=T)
selected_GWAS_values <- GWAS_values[
  which(GWAS_values$chr==2 & GWAS_values$pos>(start_gene_D-100000) & GWAS_values[,2]<(start_gene_D+125000)),
]
selected_GWAS_values$pos_from_zero <- as.numeric(selected_GWAS_values$pos) - min(selected_GWAS_values$pos) - 100000

# Pull out the SNPs in AT2G14120
gene_tair_coord <- TAIR10_gene[which(TAIR10_gene$attributes=="AT2G14120"),c(4,5)]
gene_tair_coord[1] <- gene_tair_coord[1]-start_gene_D
gene_tair_coord[2] <- gene_tair_coord[2]-start_gene_D
snp_in_AT2G14120 <- (selected_GWAS_values$pos_from_zero > gene_tair_coord$start) & (selected_GWAS_values$pos_from_zero < gene_tair_coord$end)
selected_GWAS_values$colour <- ifelse(snp_in_AT2G14120, "#d01c8b", 1)
# Pull out the SNPs in AT2G14080
gene_tair_coord <- TAIR10_gene[which(TAIR10_gene$attributes=="AT2G14080"),c(4,5)]
gene_tair_coord[1] <- gene_tair_coord[1]-start_gene_D
gene_tair_coord[2] <- gene_tair_coord[2]-start_gene_D
snp_in_AT2G14080 <- (selected_GWAS_values$pos_from_zero > gene_tair_coord$start) & (selected_GWAS_values$pos_from_zero < gene_tair_coord$end)
selected_GWAS_values$colour <- ifelse(snp_in_AT2G14080, "#8856a7", selected_GWAS_values$colour)

points(
  selected_GWAS_values$pos_from_zero,
  y = -log10(selected_GWAS_values$pvalue)* 2.5 + length(PACBIO_order)*10 + 10,
  cex=0.4, pch=16,
  col = selected_GWAS_values$colour,
  xlab = "",
  ylab = expression('-log'^10*'(p)')
)
points(
  selected_GWAS_values$pos_from_zero[selected_GWAS_values$colour != "1"],
  y = -log10(selected_GWAS_values$pvalue[selected_GWAS_values$colour != "1"])* 2.5 + length(PACBIO_order)*10 + 10,
  cex=0.4, pch=16,
  col = selected_GWAS_values$colour[selected_GWAS_values$colour != "1"],
  xlab = "",
  ylab = expression('-log'^10*'(p)')
)

### axis GWAS 
segments(x0 = -105000,x1 = -105000, y0 = length(PACBIO_order)*10 + 10, y1 = length(PACBIO_order)*12.5 + 10)
segments(x0 = -105600,x1 = -105000, y0 = seq(810, 1010, 50), y1 = seq(810, 1010, 50))
text(x = -108000, y = seq(810, 1010, 50), labels = seq(0,80, 20), cex=0.7)
text(x= -116000, y = 900, labels = expression('-log'[10]*'(p)'), srt = 90, cex=0.7)

# Plot structure of each genome
for(i in c(1:length(PACBIO_order))){
  start_gene_D <- (
    read.table(
      paste(blast_results, PACBIO_order[i],".fasta", "AT2G14080", ".fasta.70.txt", sep="")
    )[1,7] +
      read.table(
        paste(blast_results, PACBIO_order[i],".fasta", "AT2G14120", ".fasta.70.txt", sep="")
      )[1,8]
  )/2
  # print(read.table(paste(PACBIO_order[i],".fasta", file_name[centering_2], ".fasta.70.txt", sep=""))[1,3])
  for(j in c(1:length(file_name))){
    this_file <-paste(blast_results, PACBIO_order[i],".fasta", file_name[j], ".fasta.70.txt", sep="")
    if( file.size(this_file) > 280 ){
      gene_coord <- read.table(this_file)
      gene_coord[,7] <- gene_coord[,7]-start_gene_D
      gene_coord[,8] <- gene_coord[,8]-start_gene_D
      gene_coord <- gene_coord[which(gene_coord[,8]>-100000 & gene_coord[,7]<125000),]
      if(length(gene_coord[,1])>=1){
        rect(xleft = gene_coord[,7], xright = gene_coord[,8], ytop = ((i-1)*10)+5, ybottom = (i-1)*10, col = color_genes[j])
      }
    }
  }
  # Plot boxes showing whether accessions showed necrosis or not.
  if(is.na(match_necro_pheno[i,2])){
    print("na")
  }else{
    if(match_necro_pheno[i,2]=="Necrotic"){
      rect(xleft = 133000, xright = 136000, ytop = ((i-1)*10)+6, ybottom = ((i-1)*10)-1, col = 'red')
    }
    if(match_necro_pheno[i,2] =="Alive"){
      rect(xleft = 133000, xright = 136000, ytop = ((i-1)*10)+6, ybottom = ((i-1)*10)-1, col = 'grey')
    }
  }
}

# dev.off()
