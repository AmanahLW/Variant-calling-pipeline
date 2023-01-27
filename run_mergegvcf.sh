#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=240:0:0
#$ -l h_vmem=5G
#$ -o run_mergegvcf.o
#$ -e run_mergegvcf.e

module purge
module load Snakemake/7.7.0
module load pandas/1.4.2



snakemake   --use-envmodules  --profile gridengine   --snakefile Mergegvcf
