library("ggplot2")


snptypecount<-"allsamplesbcftoolsfilteredqual30snptype.csv"

plot_snptype<-function(dfcounts){
  dfsnpcounts<-read.csv(dfcounts)
  colnames(dfsnpcounts)<-c("Type" , "Variant_Count")
  dfsnpcounts$Type <- as.factor( dfsnpcounts$Type)
  dfsnpcounts$Type <- factor( dfsnpcounts$Type, levels=c("Biallelic", "Triallelic", "Quadrallelic"))
  
  
  print(str(dfsnpcounts))
  png("snptype.png", width = 1100, height = 500, res=100)
  
  figure<-ggplot(data=dfsnpcounts, aes(x=Type, y=Variant_Count, fill=Type, colour=Type)) +
                 geom_bar(stat="identity", width = 0.5, position = position_dodge(0.2)) +
                 scale_y_continuous(labels = function(y) format(y,scientific = FALSE )) +
                 labs(x="SNP type", y="Number of SNPs identified", title = "BCFTools") +
                 theme_classic()+
                 theme(plot.title=element_text(hjust = 0, size = 20, face = "bold"), 
                       text=element_text(size=20),
                       axis.title=element_text(size=20),
                       legend.key.size = unit(4, 'mm'), 
                       legend.key.height = unit(2, 'cm'), 
                       legend.key.width = unit(2, 'cm'), 
                       legend.title = element_text(size=20, face="bold"), 
                       legend.text = element_text(size=20),
                       legend.spacing.x = unit(0.2, "cm")) 
              
  print(dfsnpcounts)
  print(figure)
  dev.off()
}


plot_snptype(snptypecount)

graph<-plot_snptype(snptypecount)  
print(graph)
dev.list()
dev.off(2)
dev.off()







