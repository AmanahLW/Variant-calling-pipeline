import pandas as pd
import sys
import re
import numpy as np
#allsamplesbcftoolsfilteredqual30nogvcfgtchr$n.txt
#allsamplesfilteredqual30nogvcfnonomssingvarqualnoheader.txt
filename = sys.argv[1]  
def retaingenotype(gtubsetfile):
  records=[]
  chrlist=[]
  pattern= re.compile("gvcfgtchr([0-9]*|[a-z]*).txt")
  chrnum=pattern.search(gtubsetfile).group(1)
  genotypedf = pd.read_csv(gtubsetfile, header=0, sep="\t")
  spnames=list(genotypedf.columns)
  #genotypedf = genotypedf.apply(pd.to_numeric, errors='coerce')
  #sampledflist=list(sampledf)
  gtdf=pd.DataFrame(columns=spnames)
  #print(gtdf)
  print(genotypedf)
  #for i in spnames[1:]:
  #genotypedf.apply(pd.to_numeric(error="ignore"))
  for i in spnames[1:]:
    genotypedf[i] = np.where(genotypedf[i].str.match('[0-9]+/[1-9]+') , "1", genotypedf[i])
    genotypedf[i] = np.where(genotypedf[i].str.match('0/0'), "0" , genotypedf[i])
  genotypedf[spnames[1:]] = genotypedf[spnames[1:]].astype('int')
  #genotypedf.iloc[:,1:].replace(0, np.nan , inplace=True) 
  #print(genotypedf)
  genotypedf['SUM']=genotypedf.iloc[:,1:].sum(axis=1)
  
  subsetgt=genotypedf[["CHROM", "SUM"]]
  
  subsetgt.to_csv("../filtering/bcftoolstest/allsamplesfilteredqual30chr"+ chrnum +"snpfrq.txt", sep = "\t", header=True , index=False)
  return(subsetgt)
  
test=retaingenotype(filename)
print(test)
