library("ggplot2")
library("stringr")

effect_count<-"allsamplesbcffilteredqual30valuecounts.txt"
ont_terms<-"ontologyeffect.csv"
ploteffect<-function(effects,ont){
  effectcounts=read.delim(effects, sep="\t", header=FALSE)
  ontology=read.csv(ont, header=FALSE)
  terms<-ontology[,1]
  colnames(effectcounts)<- c("Consequence", "Counts")
  terms_rec <- terms[terms %in% effectcounts$Consequence] # check which values are in ont dataset
  
  effectcounts$Consequence<-as.factor(effectcounts$Consequence) # change to factor
  effectcounts$Consequence<-factor(effectcounts$Consequence, levels = terms_rec) # assign each effect as levels according to format of ont data 
  
  png("effectcount.png", width = 1000, height = 1000, res=100)
  
  fig<-ggplot(effectcounts, aes(x=`Consequence`, y=Counts, 
                                fill=`Consequence`, colour=`Consequence`)) +
              geom_bar(stat="identity", width = 0.5, position = position_dodge(0.2)) +
              labs(x="Effect", y = "Number of annotated variants", title= "BCFTools") +
              theme_classic() +
              theme(legend.key.size = unit(5, 'mm') , legend.text = element_text(size=10),
              legend.title = element_text(size=15 , face = "bold") , 
              axis.text.x = element_text(angle =90, vjust = 0.5 , hjust = 1 , size = 15),
              axis.text.y = element_text(size=15),
              legend.background = element_rect(linetype = "solid") ,
              plot.title = element_text(size = 15, face="bold"),
              axis.title = element_text(size = 15)) +
              scale_y_continuous(labels = function(y) format(y,scientific = FALSE )) +
              ylab("Counts (log10)") +
              guides(fill=guide_legend(ncol =1), color=guide_legend(ncol =1)) # make legend a sigle column
  print(fig)  
  dev.off()            
  print(sum(effectcounts$Counts))
 
  return(effectcounts)
}

conseq<-ploteffect(effect_count,ont_terms)  


