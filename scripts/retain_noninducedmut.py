import pandas as pd
import numpy as np
import re
import sys

#samples="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/samples_half.tsv" 
samples=snakemake.input[0]
#bcftools/chr{chr}merge_bcftools.vcf.gz
#vcftofilter= "/data/scratch/bt211065/20220802_Researchproject/filteredmerge_bcftools.vcf"
vcftofilter=snakemake.input[1]

#filename = sys.argv[1]
#pattern= re.compile("qualchr([0-9]*|[a-z]*)allsamples")
#chrnum=pattern.search(filename).group(1)


# sample/strain /library
samplesandlibrary={}
with open(samples) as sf:
  for s in sf:
    if "library" not in s: 
      s=s.split()
      samplesandlibrary[s[0]]= s[2] ## extract sample and library 

#print(samplesandlibrary)

#with open("filtered_noninducedmuation" + chrnum + ".vcf" , "a") as towrite:

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
