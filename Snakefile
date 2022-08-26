CHUNKSIZE=7000000*4 # 7 million reads per chunk
GENOME="/data/SBBS-BuschLab/genomes/GRCz11/GRCz11.fa"

import pandas
import re

samples = pandas.read_table("samples_half.tsv").set_index("sample", drop=False)


units = pandas.read_table("units.tsv").set_index(["sample"], drop=False)
region = list(range(1,26))
region.append('other')



rule all:
    input:
       expand("{sample}/{sample}_bcftools.g.vcf.gz",sample=samples['sample']),
       expand("{sample}/{sample}_bcftools.g.vcf.gz.tbi",sample=samples['sample']),
       expand("{sample}/strelka.S1.vcf.gz", sample=samples['sample']),
       expand("{sample}/{sample}gatk.g.vcf.gz", sample=samples['sample']),
       expand("{sample}/{sample}gatk.g.vcf.gz.tbi", sample=samples['sample'])
      

      
rule download_merge_fastq:
    priority: 1
    output:
        fq1=temp("{sample}/1.fastq"),
        fq2=temp("{sample}/2.fastq")
    log:
        "{sample}/download_merge_fastq.log"
    params:
        fqs=lambda wildcards: " ".join(units.loc[[wildcards.sample]][["urls", "md5s"]].aggregate(":".join, axis=1).values)
    resources:
        runtime=240,
	      file=3,
        mem=10
    shell:
        "scripts/download_merge_fastq.sh {output.fq1} {output.fq2} '{params.fqs}' &> {log}"

checkpoint split_fastq:
    priority: 2
    input:
        fq1="{sample}/1.fastq",
        fq2="{sample}/2.fastq"
    output:
        directory("{sample}/chunks")
    log:
        "{sample}/split_fastq.log"
    params:
        chunksize=CHUNKSIZE
    shell:
        "(mkdir {wildcards.sample}/chunks; "
        "split --suffix-length=3 --additional-suffix=.fastq --numeric-suffixes --lines={params.chunksize} {input.fq1} {wildcards.sample}/chunks/1.; "
        "split --suffix-length=3 --additional-suffix=.fastq --numeric-suffixes --lines={params.chunksize} {input.fq2} {wildcards.sample}/chunks/2.) "
        "&> {log}"

rule bwa_aln_1:
    priority: 3
    envmodules:
        "BWA/0.7.17"
    input:
        "{sample}/chunks/1.{chunk}.fastq"
    output:
        temp("{sample}/chunks/1.{chunk}.sai")
    resources:
        mem=3,
        runtime=240,
        file=3
    params:
        genome=GENOME
    shell:
       "bwa aln  {params.genome} {input} > {output}  "
    

rule bwa_aln_2:
    priority: 3
    envmodules:
        "BWA/0.7.17"
    input:
        "{sample}/chunks/2.{chunk}.fastq"
    output:
        temp("{sample}/chunks/2.{chunk}.sai")
    resources:
        mem=3,
        runtime=240,
        file=3
    params:
        genome=GENOME
    shell:
        "bwa aln  {params.genome} {input} > {output} "
        

rule bwa_sampe:
    priority: 4
    envmodules:
        "BWA/0.7.17",
        "samtools/1.15.1"
    input:
        fq1="{sample}/chunks/1.{chunk}.fastq",
        fq2="{sample}/chunks/2.{chunk}.fastq",
        sai1="{sample}/chunks/1.{chunk}.sai",
        sai2="{sample}/chunks/2.{chunk}.sai"
    output:
        temp("{sample}/chunks/{chunk}.bam")
    resources:
        mem=5
    params:
        genome=GENOME
    shell:
        "(bwa sampe {params[0]} {input.sai1} {input.sai2} {input.fq1} {input.fq2} "
        "| samtools view -bT {params.genome} -o {output} -)  "

def get_chunks(wildcards):
    checkpoint_output = checkpoints.split_fastq.get(**wildcards).output[0]
    return expand("{sample}/chunks/{chunk}.bam", sample=wildcards.sample, chunk=glob_wildcards(os.path.join(checkpoint_output, "1.{chunk}.fastq")).chunk)

rule merge_chunks:
    priority: 5
    envmodules:
      "samtools/1.15.1" 
    input:
      get_chunks
    output:
      temp("{sample}/{sample}.bam")
    shell:
      "samtools merge -o {output} {input} &&  "
      "rm -rf {wildcards.sample}/chunks  &&  "
      "rm -f {wildcards.sample}/1.fastq {wildcards.sample}/2.fastq "
      
rule sort_readname:
    priority:6
    envmodules:
      "samtools/1.15.1"
    input:
      "{sample}/{sample}.bam"
    output:
      temp("{sample}/{sample}_sorted.bam")
    resources:
      runtime=240,
      mem=60
    shell:
      "samtools sort -m {resources.mem}G -n {input} -O BAM -o {output} "
    
rule fixmate:
    priority:7
    envmodules:
      "samtools/1.15.1",
      "biobambam2/2.0.146"
    input:
      "{sample}/{sample}_sorted.bam"
    output:
      temp("{sample}/{sample}_nodups.bam")
    resources:
      runtime=240
    shell:
      "samtools fixmate {input} - | bammarkduplicates O={output}"

rule sort_coords:
    priority:8
    envmodules:
      "samtools/1.15.1"
    input:
      "{sample}/{sample}_nodups.bam"
    output:
      temp("{sample}/{sample}_sortcoords.bam")
    resources:
      mem=19,
      cpus=2,
      runtime=240
    shell:
      "samtools sort -m {resources.mem}G --threads {resources.cpus} -o {output} {input} "
    


rule addread_group:
    priority:9
    envmodules:
      "samtools/1.15.1",
      "GATK/4.2.6.0"
    input:
      "{sample}/{sample}_sortcoords.bam"
    output:
      addrg=temp("{sample}/{sample}_addreadgroups.bam"),
      rg=temp("{sample}/{sample}_addreadgroups.bam.bai")
    shell:
      "  gatk  AddOrReplaceReadGroups -I {input} -O {output.addrg} -LB {wildcards.sample} "
      " -PL {wildcards.sample} -PU {wildcards.sample} -SM {wildcards.sample} --VALIDATION_STRINGENCY SILENT ; "
      "samtools index {wildcards.sample}/{wildcards.sample}_addreadgroups.bam  "
        

rule bcftools_call:
    priority:10
    envmodules:
      "bcftools/1.15.1",
      "htslib/1.15.1"
    input:
      bam="{sample}/{sample}_addreadgroups.bam",
      bai="{sample}/{sample}_addreadgroups.bam.bai",
      ref=GENOME
    output:
      vcf="{sample}/{sample}_bcftools.g.vcf.gz",
      index="{sample}/{sample}_bcftools.g.vcf.gz.tbi"
    log:
      "{sample}/bcftools.log"
    resources:
      runtime=240,
      cpus=3
    shell:
      "bcftools mpileup --gvcf 10,20  -f {input.ref} {input.bam} |  "
      "bcftools call --threads {resources.cpus}   -m  -Oz -o {output.vcf} &> {log} ;  "
      "tabix {wildcards.sample}/{wildcards.sample}_bcftools.g.vcf.gz  "
    

rule strelka:
    priority:11
    envmodules:
      "Strelka2/2.9.10"
    input:
      bam="{sample}/{sample}_addreadgroups.bam",
      bai="{sample}/{sample}_addreadgroups.bam.bai",
      ref=GENOME
    output:
      vcf="{sample}/strelka.S1.vcf.gz"
    resources:
      runtime=240,
      mem=4,
      cpus=10,
      file=10
    shell:
      "strelka-wrapper configureStrelkaGermlineWorkflow.py --bam={input.bam} "
      "--referenceFasta={input.ref} --runDir={wildcards.sample}  --exome ; "
      "strelka-wrapper {wildcards.sample}/runWorkflow.py -m local --quiet  -j {resources.cpus} -g {resources.mem} ; "
      "less {wildcards.sample}/results/variants/genome.S1.vcf.gz > {output.vcf} ; " 
      "rm -r -f {wildcards.sample}/workspace {wildcards.sample}/results ; "
      "rm {wildcards.sample}/workflow*  {wildcards.sample}/runWorkflow* "
  
  
     
rule gatk_caller: 
    priority: 12
    envmodules:
      "GATK/4.2.6.0"
    input: 
      ref=GENOME,
      bam="{sample}/{sample}_addreadgroups.bam",
      bai="{sample}/{sample}_addreadgroups.bam.bai",
      intervals="intervals/{region}.list" 
    output:
      temp("{sample}/gatkchr_{region}.g.vcf.gz")
    resources:
      mem=5,
      runtime=240,
      file=2
    shell:
      " gatk HaplotypeCaller -R {input.ref} -I {input.bam} -O {output} "
      " -L {input.intervals} -VS SILENT -ERC GVCF --QUIET --create-output-variant-index false "
      
rule merge_gvcf:  
    priority: 13  
    envmodules:
      "GATK/4.2.6.0"
    input:
      chr1="{sample}/gatkchr_1.g.vcf.gz", 
      chr2="{sample}/gatkchr_2.g.vcf.gz", 
      chr3="{sample}/gatkchr_3.g.vcf.gz", 
      chr4="{sample}/gatkchr_4.g.vcf.gz", 
      chr5="{sample}/gatkchr_5.g.vcf.gz", 
      chr6="{sample}/gatkchr_6.g.vcf.gz", 
      chr7="{sample}/gatkchr_7.g.vcf.gz", 
      chr8="{sample}/gatkchr_8.g.vcf.gz", 
      chr9="{sample}/gatkchr_9.g.vcf.gz", 
      chr10="{sample}/gatkchr_10.g.vcf.gz", 
      chr11="{sample}/gatkchr_11.g.vcf.gz", 
      chr12="{sample}/gatkchr_12.g.vcf.gz", 
      chr13="{sample}/gatkchr_13.g.vcf.gz", 
      chr14="{sample}/gatkchr_14.g.vcf.gz", 
      chr15="{sample}/gatkchr_15.g.vcf.gz", 
      chr16="{sample}/gatkchr_16.g.vcf.gz", 
      chr17="{sample}/gatkchr_17.g.vcf.gz", 
      chr18="{sample}/gatkchr_18.g.vcf.gz",
      chr19="{sample}/gatkchr_19.g.vcf.gz", 
      chr20="{sample}/gatkchr_20.g.vcf.gz", 
      chr21="{sample}/gatkchr_21.g.vcf.gz", 
      chr22="{sample}/gatkchr_22.g.vcf.gz", 
      chr23="{sample}/gatkchr_23.g.vcf.gz", 
      chr24="{sample}/gatkchr_24.g.vcf.gz", 
      chr25="{sample}/gatkchr_25.g.vcf.gz", 
      other="{sample}/gatkchr_other.g.vcf.gz"
    output: 
      vcf="{sample}/{sample}gatk.g.vcf.gz",
      index="{sample}/{sample}gatk.g.vcf.gz.tbi"
    resources:
      runtime=240,
      cpus=10
    log:
      "{sample}/gatkmerge.log"
    shell:
      "gatk MergeVcfs -I {input.chr1} -I {input.chr2} -I {input.chr3} -I {input.chr4} -I {input.chr5} -I {input.chr6} "
      "-I {input.chr7} -I {input.chr8} -I {input.chr9} -I {input.chr10} -I {input.chr11} -I {input.chr12} -I {input.chr13} " 
      "-I {input.chr14} -I {input.chr15} -I {input.chr16} -I {input.chr17} -I {input.chr18} -I {input.chr19} -I {input.chr20} "
      "-I {input.chr21} -I {input.chr22} -I {input.chr23} -I {input.chr24} -I {input.chr25} -I {input.other} "
      "-O {output.vcf} --VALIDATION_STRINGENCY SILENT --QUIET &> {log} ;"
      "rm {wildcards.sample}/gatkchr_* "
