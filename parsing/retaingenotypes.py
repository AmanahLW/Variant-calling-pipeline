import pandas as pd
import sys
import re
import numpy as np

filename = sys.argv[1]   # accept 2nd arg in command line
def retaingenotype(gtubsetfile):
  records=[]
  chrlist=[]
  pattern= re.compile("gvcfgtchr([0-9]*|[a-z]*).txt") # find file pattern 
  chrnum=pattern.search(gtubsetfile).group(1) # accept chromosomal vcf with genotype subset and ./. noted as 0 
  genotypedf = pd.read_csv(gtubsetfile, header=0, sep="\t")
  spnames=list(genotypedf.columns)
  
  
  print(genotypedf)
  print(spnames)
  
  for i in spnames[1:]:
	  genotypedf[i] = np.where(genotypedf[i].str.match('[0-9]+/[1-9]+') , "1", genotypedf[i]) # match all gt except for 0/10 ad 0/0
	  genotypedf[i] = np.where(genotypedf[i].str.match('0/0'), "0" , genotypedf[i])  # match 0/0
	  genotypedf[i] = np.where(genotypedf[i].str.match('[0-9]+/[0-9]+') , "1", genotypedf[i]) # match geotypes [0-9]+/10

  
  genotypedf[spnames[1:]] = genotypedf[spnames[1:]].astype('int') # connvert to int from second column
  print(genotypedf)
  genotypedf['SUM']=genotypedf.iloc[:,1:].sum(axis=1) # sum 1 in each row and add sum 
  subsetgt=genotypedf[["CHROM", "SUM"]]
  
  subsetgt.to_csv("../filtering/bcftoolstest/allsamplesfilteredqual30chr"+ chrnum +"snpfrq3.txt", sep = "\t", header=True , index=False)
  return(subsetgt)
  
test=retaingenotype(filename)
print(test)
