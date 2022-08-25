install.packages("ggplot2")
install.packages("scales")
library("tidyverse")
library("scales")
library("ggplot2")
.libPaths()
#snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsampleschrfilteredqual80snpfreq.txt"
snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30snpfreq.txt"
#snptypecount<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual80snpfreq.txt"


#snpcountdf<-fread(snptypecount,sep="\t",nThread=10,header=TRUE)
plot_frq<-function(snpfrqdf){
  df<-read.delim(snpfrqdf, sep =  "\t")
  moddf<-df[!(df$SUM=="0"),]
  figure<- ggplot(moddf, aes(x=SUM))+
      geom_histogram(binwidth = 1, fill="#84FFFF", color="#84FFFF")+
      labs(x="Number of samples ", y = "Number of variants" , title= "BCFTools") +
      theme_classic() +
      scale_y_continuous(labels = comma) +
      theme(plot.title=element_text(hjust = 0, size = 20, face = "bold"), 
          text=element_text(size=20),
          axis.title=element_text(size=20)) +
      xlim(1, 53) 
    
  print(figure)
  #freq<-as.data.frame.matrix(table(moddf$SUM))
  #print(sd(freq[2]))
  return(table(moddf$SUM))
  #df<-plot_frq(snptypecount)
  #fig2<-plot_frq(f.name)
    
}
df<-plot_frq(snptypecount)

dev.off()