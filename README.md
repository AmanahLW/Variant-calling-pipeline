# Variant-calling-pipeline
A reproducible snakemake workflow for identifying strain specific variants in Danio Rerio (Zebrafish). Variants called would be uploaded to European Variation Archive, https://www.ebi.ac.uk/ena/browser/home . This workflow requires two Snakefiles and a bash script to generate variant caller specific text files containing a list of samples. The list of samples is the input for the second Snakefile. The pipline is ran on a High Performance Cluster (HPC) by connection to a SunGrid Engine config file. Jobs statuses are controlled through status.sh. 

Dependencies: Snakemake 7.7.0 Pandas 1.4.2 BWA/0.7.17 samtools/1.15.1 biobambam2/2.0.146 bcftools/1.15.1 htslib/1.15.1 GATK/4.2.6.0 Strelka2/2.9.10 gvcfgenotyper/2019.02.26

Execution: snakemake --use-envmodules --profile gridengine --snakefile Snakefile
snakemake --use-envmodules --profile gridengine --snakefile Mergegvcfv3
bash samplecallers.sh

Supervisors: Ian Sealy and Elisabeth Busch-Nentwich
