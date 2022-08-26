install.packages("ggplot2")
install.packages("scales")
library("tidyverse")
library("scales")
library("ggplot2")
.libPaths()
#snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsampleschrfilteredqual80snpfreq.txt"
#snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30snpfreq.txt"
#snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual80snpfreq.txt"
#snptypecount<-"allsamplesfilteredqual30snpfreqv3.txt"
options(scipen = 999)
#snptypecount="allsampleschrfilteredqual80snpfreq.txt"
snptypecount="allsamplesfilteredqual30snpfreqv5.txt"
plot_frq<-function(snpfrqdf){
  df<-read.delim(snpfrqdf, sep =  "\t" ,header = TRUE)
  moddf<-df[!(df$SUM=="0"),]
 # png("snpfrqgatk.png" , height = 1000, width=1000)
  figure<- ggplot(moddf, aes(x=SUM))+
      geom_histogram(binwidth = 1, fill="#84FFFF", color="#84FFFF")+ 
      labs(x="Number of samples ", y = "Number of variants" , title= "BCFTools") +
      theme_classic() +
      theme(plot.title=element_text(hjust = 0, size = 20, face = "bold"), 
          text=element_text(size=20),
          axis.title=element_text(size=20))
      xlim(1, 52) 
 # dev.off()  
  #print(figure)
  #print(table(df$SUM))
  
  snp<-hist(moddf$SUM, breaks=52)
  hist(moddf$SUM, breaks=52 , xlab = "Number of samples" , 
  ylab="Number of variants" , main=NULL , col = "lightblue" , lty="blank" , ylim = c(0,4000000) , xlim = c(1,52))
  title("BCFTools", adj=0)
  
  nonlogcount<-snp$counts
  print(nonlogcount)
  print(sd(nonlogcount))
  print(mean(nonlogcount))
  return(sd(as.vector(table(df$SUM))))
  
  
    
}
df5<-plot_frq(snptypecount)
#1745271356 Jul 13 21:36 allsamplesfilteredqual30nogvcf.vcf.gz

