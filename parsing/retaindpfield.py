


import re
import pandas as pd



#variantgatk = "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/gatk/allsamples.tsv"
#variantbcf = "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/bcftools/merge_bcftoolsvariants.tsv"
#variantsstrelka =  "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamples50samplessubset.vcf"

strelka="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesfilteredqual30samples.txt"  
dpstrelka="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesstrelkafilteredqual30dpsumv2.txt" 
with open(dpstrelka, "a") as writeto: 
  writeto.write("DP\n") # write in first line dp to empty file
  with open(strelka, "r") as fn: # accept only sample fields
   records=[]
   for i,line in enumerate(fn):
     if i != 0: # start writin to file after first line
      # header=line[:6]
       #header.extend(line[9:]) 
       line = re.split(r'\t|:', line) # split into list at tabs between samples and coluns inbetween fields in each sample
       dp_samples= line[4::10] # start at 4tn index for depth   and jump every 10th element for next depth read 
       dp_samplesint=(list(map(int, dp_samples)))  
       dp=sum(dp_samplesint) # find sum of depth for each sample
       writeto.write( str(dp) + "\n") 
 
