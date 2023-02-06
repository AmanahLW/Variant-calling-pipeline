import pandas as pd
import numpy as np
import re
import sys

samples=snakemake.input[0]
vcftofilter=snakemake.input[1]



# sample/strain /library
samplesandlibrary={}
with open(samples) as sf:
  for s in sf:
    if "library" not in s: 
      s=s.split()
      samplesandlibrary[s[0]]= s[2] ## extract sample and library 


with open(snakemake.output[0] , "a") as towrite:
  with open(vcftofilter,"r") as fn:
    for record in fn:
      if "##" in record:
        towrite.write(record)
      elif "CHROM" in record :
        towrite.write(record) 
        sample=record.split()[9:]
      else:
        var=re.compile('[0-9]+\|[1-9]+|[0-9]+/[1-9]+') 
        varindex=[ i  for i,item in enumerate(record.split()[9:]) if var.search(item[:3]) is not None]
        samplevariant = [sample[v] for v in varindex] # return samples using variant index
        libraries = [samplesandlibrary[l] for l in samplevariant] #return  libraries of variants 
        unique=set(libraries)
        if "-" in unique:
          towrite.write(record)
        elif len(unique) > 1:
          towrite.write(record)
        elif len(unique) == 1 and len(samplevariant) > 4:
          towrite.write(record)
