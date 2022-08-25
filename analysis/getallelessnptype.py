import re 
import pandas as pd 


#gatk="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsamplesqual80vepchr9.txt"
#gatk="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/gatktest/allsamplesfilteredqual80noheader.txt"
bcf="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesfilteredqual30nogvcfnonomssingvarqualnoheader.txt"

def retain_alleles(filename):
  with open(filename, "r") as fn:
    record=[]
    for i in fn:
      if "CHROM" not in i:
        type_alleles=i.split("\t")[3:5]
        allelestr="".join(type_alleles)
        record.append(type_alleles)  
    df=pd.DataFrame(record,columns=["REF","ALT"])
    bibool = (df['REF'].str.len() == 1) & (df['ALT'].str.len() == 1)
    bi= df.loc[bibool]
    numbi=len(bi.index)
    tribool = (df['REF'].str.len() == 1) & (df['ALT'].str.len() == 3) & df["ALT"].str.contains('[ATCG],[ATCG]', regex=True)
    tri= df.loc[tribool] 
    numtri=len(tri.index) 
    quadbool = (df['REF'].str.len() == 1) & (df['ALT'].str.len() == 5) & df["ALT"].str.contains('[ATCG],[ATCG],[ATCG]', regex=True)
    quad=df.loc[quadbool]
    numquad=len(quad.index)
    
    count_types=[numbi,numtri,numquad]
    type_names=["Biallelic", "Triallelic", "Quadrallelic"]
    
    snp= {"SNP type":  type_names,
            "Variant count of each SNP type": count_types}
    snpdf=pd.DataFrame(snp)
    snpdf.to_csv( "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30snptype.csv", header=list(snpdf.columns), index=None, sep=',')
            
    return(snpdf)

    
test=retain_alleles(bcf)
print(test)
	#print(records)
	#alleles=header[3:5]

	#samples=header[9:]
	#last_sample=samples[-1][:-1]
	#samples[-1]=last_sample
	#alleles.extend(samples)

	#df=pd.DataFrame(records, columns=alleles)
	#df.to_csv("allsamplesfilteredqual80chr1noheaderrefaltgt.txt", sep = "\t", header=True , index=False )
