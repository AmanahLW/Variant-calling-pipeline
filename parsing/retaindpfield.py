


import re
import pandas as pd
import matplotlib.pyplot as plot
import seaborn as sb 

#variantgatk = "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/gatk/allsamples.tsv"
#variantbcf = "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/bcftools/merge_bcftoolsvariants.tsv"
#variantsstrelka =  "/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamples50samplessubset.vcf"

strelka="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesfilteredqual30samples.txt"  
dpstrelka="/data/scratch/bt211065/20220505_Researchproject/variant-calling-2022-main/snakemake/test/filtering/strelkatest/allsamplesstrelkafilteredqual30dpsumv2.txt" 
with open(dpstrelka, "a") as writeto:
  writeto.write("DP\n")
  with open(strelka, "r") as fn:
   #f.write("CHR \t POS \t QUAL \t DP" + "\n")
   records=[]
   for i,line in enumerate(fn):
     if i != 0:
      # header=line[:6]
       #header.extend(line[9:])
       line = re.split(r'\t|:', line)
      # chr_pos = line[0][:-3].split("\t")
     #chr_pos.extend(line[4::9])
       dp_samples= line[4::10] # 4tn index 
       dp_samplesint=(list(map(int, dp_samples)))
       dp=sum(dp_samplesint)
       writeto.write( str(dp) + "\n")
      # chr_pos=chr_pos[:6]
       #chr_pos.extend(dp_samples[1:])
       #records.append(chr_pos)
   
   #print(records)
 #  title=header[:6]  
  # title.extend(header[9:])
   #last_el=title[-1].strip()
   #print(last_el)
   
   #name=title[:8]
   #name.append(last_el)
   #print(name)
   #print(title)
   #print(title)
   #num= len(dp_samples)
   #header=["CHR", "POS", "QUAL"]
   #print(line)
   #samples=records[0][10:]
   #header.extend(records[0][10:])
   #print(records[0])
   
   #title=records[0][:5].extend(records[0][9:])
   
  # df = pd.DataFrame(records[1:], columns=name)
   # saving as tsv file
  # df.to_csv('strelkawithdp50samples.tsv', index= False , sep="\t")
#   print(df.iloc[:,3:])
#   df.AvgDP = df.AvgDP.round().astype(float)
#   #df['AvgDP'] = df['AvgDP'].apply(lambda num:round(num))
#   print(df['AvgDP'])
    #f_sort= df.sort_values(by=['AvgDP'],ascending=True)
#   sb.kdeplot(data=df['AvgDP'])
    
#   plot.savefig('AvgDP')
    #df.to_csv("cleaned_strelkaall.txt",sep = "\t", index=False)
   
   
   
   
   
   
   
paste ../filtering/strelkatest/allsamplesfilteredqual30qualscores.txt ../filtering/strelkatest/allsamplesstrelkafilteredqual30dpsumv2.txt | column -s '\t' -t > ../filtering/strelkatest/allsamplesfilteredqual30qualanddp.txt
[bt211065@frontend8 analysis]$ ^C
[bt211065@frontend8 analysis]$ tail ../filtering/strelkatest/allsamplesfilteredqual30qualanddp.txt

