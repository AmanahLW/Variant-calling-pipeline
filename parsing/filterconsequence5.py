from collections import Counter
import csv
import sys
import pandas as pd
import numpy as np
import operator
from operator import itemgetter

bcf="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30nogvcfinfofieldextract.txt"
ont="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/analysis/ontologyeffect.csv"#../filtering/gatktest/allsamplesqual80vepinfofieldextract.txt

with open(ont, "r") as fn:
  terms={}
  for n in fn:
    (k,v1,v2)=n.split(",")
    terms[k]=[k,v1, int(v2)] # assign effect as key and effect,prority class, level to value

def find_priority(acceptlist):
   nondup= [*set(acceptlist)] # remove duplicates 
   length=len(nondup) 
   final = {}
   for i in nondup:
       final[terms[i][0]]=terms[i][2] #access the priority level using effect name as key and assign lvel as value to final dict
      # access effect name using effect name as key for terms
   return(max(final.items(),key = operator.itemgetter(0))[0]) # return key/effect with highest value 

def readvcf(vcf):
      effect=pd.read_csv(vcf, sep="\t", names=["EFFECT", "IMPACT"]) 
      effect["EFFECT"]=effect["EFFECT"].str.replace("&", " ")
      effect["EFFECT"]=effect["EFFECT"].str.split()
      e2=effect[effect["EFFECT"].map(len)>1] # find rows in effect column that has more tha oe element in list 
      t=find_priority(e2.iloc[0,0])
      singleef=effect[effect["EFFECT"].map(len)==1]
      e2["FINAL"]=e2.apply(lambda x: find_priority(x["EFFECT"]), axis=1)  # find most severe effect using find priority per row 
      singleef["EFFECT"]=singleef["EFFECT"].agg(lambda l: "".join(str(s) for s in l)) # join text by strinng 
      combined=singleef["EFFECT"].append(e2["FINAL"])
      
      freq=combined.value_counts().to_frame() # count differenent connsequence and convert to dataframe 
      print(freq)
      print(freq.dtypes)
      print(freq.columns)
      print(len(e2))
      print(len(singleef))
      
      freq.to_csv("/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesbcffilteredqual30valuecounts.txt", sep="\t", index=True, header=False)
      
      
      return(e2)
df=readvcf(bcf)
print(df)

  
