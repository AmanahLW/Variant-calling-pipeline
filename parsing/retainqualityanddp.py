import pandas as pd
import re
#gatk="C:/Users/amana/Documents/Queen mary/Filtervariants/allsamplesfilteredqual80chr1noheader.txt"
#gatk="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsamplesfilteredqual80v2noheader.txt"
#bcf="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30nogvcfnoheader.txt"
#bcf= "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30nogvcfv3cleanednoheader.vcf"
bcf= "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30nogvcfnonomssingvarqualnoheader.txt"

with open(bcf, "r") as fn: # accept whole vcf
  records=[]
  pattern= re.compile("DP=([0-9]*);")
  #dp=pattern.search(filename).group(1)
  for i in fn:
    if "CHROM" in i:
      header=i
      header=header.split("\t") # get ref and alt
    else:
      i=i.split("\t")	
      qual=i[5]
      info=i[7]
      info=pattern.search(info).group(1) # serch for dp number in the info field 
      rec= qual.split() + info.split() # append depth to qual 
      records.append(rec)
  title=header[5].split()
  title.extend(header[7].split()) # output as qual and dp df
  df=pd.DataFrame(records, columns=title)
  
df.to_csv("/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30qualdpnomissqualvar.txt", 
sep = "\t", header=True , index=False )
