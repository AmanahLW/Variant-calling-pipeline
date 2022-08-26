install.packages("ggplot2")
install.packages("scales")
library("tidyverse")
library("scales")
library("ggplot2")
.libPaths()

options(scipen = 999) # remove sci noation
snptypecount="allsamplesfilteredqual30snpfreqv5.txt"
plot_frq<-function(snpfrqdf){
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

