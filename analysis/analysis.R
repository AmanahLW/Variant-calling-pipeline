if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install("gdsfmt", force=TRUE)
BiocManager::install("SeqArray")
BiocManager::install("SNPRelate")

library("gdsfmt")
library("SeqArray")
library("SNPRelate")
#snp.fn<- "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsamplesfilteredqual80.vcf"
#snp.fn<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30nogvcfnonomssingvarqual.vcf"
#strelka.fn<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesfilteredqual30removedphist.vcf"


gds<-seqVCF2GDS(strelka.fn, "samples50_strelka_WT.gds", parallel = 10)
gdsopen <- seqOpen(gds)
  # remove snp with high LD 

prunedsnp <- snpgdsLDpruning(gdsopen, ld.threshold=0.9 , num.thread = 17) 

prunedsnp.id <- unlist(unname(prunedsnp)) # list to vector 


### load population data 
strains <- "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/analysis/samples_notSLpop.txt"
population<-read.delim(strains, header = TRUE, sep = "\t")

calculatepca<-function(genofile){
  ### load sample id 
  sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))
  ## check sample id equal to population id if not reorder population
  result<-setequal(sample.id , as.vector(population[,1]))
  print(result)
  ### run pca 
  wt_pca <- snpgdsPCA(gdgeno, snp.id=prunedsnp.id, 
          bayesian = TRUE, num.thread=10) 
  return(list(sample.id , wt_pca , result))
}

calculatepca(gdgeno)


plot_pca<- function(){
  pca<-calculatepca(gdgeno)
  wt_pca <-pca[[2]]
  sample<-pca[[1]]
  print(wt_pca)
  print(pca[[3]])
  strain <- as.vector(population[,2])
  # percentage of PC 
  pcomp.percent <- wt_pca$varprop*100
  print(pcomp.percent) 
  pcadf <- data.frame(wt_pca$sample.id,
                     Strain = factor(strain)[match(wt_pca$sample.id, sample)],
                     Eigenvector1 = wt_pca$eigenvect[,1],    # first eigenvector
                     Eigenvector2 = wt_pca$eigenvect[,2],    # second eigenvector
                     stringsAsFactors = FALSE)
  jpeg("pca.jpg", width = 500, height = 550)
  graph<-plot(pcadf$Eigenvector2, pcadf$Eigenvector1, col=as.integer(pcadf$Strain),  # get labels and colour strain groups
              xlab= paste("PC 2", round(pcomp.percent[2],3), "%", sep=" "),
              ylab= paste("PC 1",  round(pcomp.percent[1],3), "%" , sep=" "),  pch= "x")
          legend("topleft", legend=levels(pcadf$Strain), pch="x", col=1:nlevels(pcadf$Strain))
          title(main = "BCFTools", adj =0 )
          
  print(graph)
  dev.off()
  groups <- paste("PC", 1:6, "\n", format(pcomp.percent[1:5], digits=3), "%", sep="")
  png("pca_pairs_plot.png", width = 1000, height = 1100, res=150)
  pairs(wt_pca$eigenvect[,1:5], col=pcadf$Strain, labels=groups, cex.labels=2, cex=0.5, oma=c(3,2,5,13)) # set margin size with oma & get pc 1 to 5  
  legend(x=0.9,y=0.9, fill = unique(pcadf$Strain), legend = c(levels(pcadf$Strain)), cex = 1, xpd = NA)
  #callers<-title(main = "BCFTools", adj = 0, line=2) 
  mtext(side =3,adj=0, at=-0.03, line = 2 , text = "BCFTools", font=2, cex = 1.1)
  dev.off()
  
  #5.1 4.1 4.1 2.1 margin
  
  return(graph)
}
plot_pca()
# paste pc 1 to 4 as new lines
# format pc 1 to 3 percentage rounded by 2 
# no delimiter between pc 
# paste pc 1 to 4 as pair 
# assign color by population 
# label pairs with groups 
seqClose(gdgeno)
