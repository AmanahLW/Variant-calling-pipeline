install.packages("grid")

library("ggplot2")
library("scales")
library("cowplot")
library("gtable")
library("grid")
memory.limit(size=50000000000000000)
bcf<-"allsamplesbcffilteredqual30qualdpnomissqualvar.txt"
gatk<-"allsamplesgatkfilteredqual80v2qualdp.txt"
strelka<-"allsamplesstrelkafilteredqual30qualanddp.txt"
#strelka<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesfilteredqual30qualanddp.txt"
#bcf<- "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30qualdpnomissqualvar.txt"
#gatk<-"/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsamplesgatkfilteredqual80v2qualdp.txt"
############Find threshold for vcf strelka filter############
qualanddp <- read.delim(strelka, sep = "")
read_file<-function(filename){
  qualanddp <- read.delim(filename, sep = "\t") # change to non-whitespace for sep in strelka
  colnames(qualanddp)<-c("QUAL", "DP")
  qualanddp$QUAL<-as.numeric(as.character(qualanddp$QUAL))
  qualanddp$DP<-as.numeric(as.character(qualanddp$DP))
  return(qualanddp)

}  


stdf<-read_file(strelka)
qualst<-plotqual(stdf)
dpst<-plotdp(stdf)

bcfdf<-read_file(bcf)
qualbcf<-plotqual(bcfdf)
dpbcf<-plotdp(bcfdf)



gatkdf<-read_file(gatk)
qualgatk<-plotqual(gatkdf)
dpgatk<-plotdp(gatkdf)

jpeg("density plot.png", width = 1000, height = 1200)
plots<-plot_grid(qualst,dpst,qualbcf,dpbcf,qualgatk,dpgatk, 
         labels=c("a) Strelka2"," ", "b) BCFTools", " ", "c) GATK", " "),
         ncol=2, nrow=3 , align= "hv", label_size = 20 ,hjust=-0.7 , vjust= 0.2, rel_heights = c(10, 10)) +
        theme(plot.margin = unit(c(1,0.5,0.5,0.5), "cm"))  
# remove clips on top of graph
removeclips <- ggplot_gtable(ggplot_build(plots)) 
removeclips$layout$clip[removeclips$layout$name == "panel"] <- "off" 


grid.draw(removeclips)

dev.off()


#df<-sort_df(gatk)
plotqual<-function(df){
  qualdensity<-ggplot(df, aes(QUAL)) + 
                geom_density(fill= "#84FFFF", color="#84FFFF", na.rm = TRUE) +
                labs(x="QUAL (log10) ") +
                theme_classic() + 
                scale_x_continuous(trans = "log10" , 
                       labels = function(x) format(x,scientific = FALSE )) +
                theme( text=element_text(size=20),
                axis.title=element_text(size=20),
                plot.margin=margin(t=10))
 
                
  
  print(qualdensity)
  
}

plotdp<- function(df){
  dpdensity<-ggplot(df, aes(DP)) +
              geom_density(fill= "#84FFFF",color="#84FFFF", na.rm = TRUE ,bw=0.09 ) +
              labs(x="DP (log10) ") +
              theme(plot.title=element_text(hjust = 0.1),text=element_text(size=0.04)) +
              theme_classic()  +
              scale_x_continuous(trans = "log10" ,
                                 labels = function(x) format(x,scientific = FALSE )) + # include adjust geome density for bcftools
              theme( text=element_text(size=20),
              axis.title=element_text(size=20),
              plot.margin=margin(t=10))  
  print(dpdensity)
  
}

