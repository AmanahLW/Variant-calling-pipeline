#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 8
#$ -l h_rt=1:0:0
#$ -l h_vmem=4G
#$ -o run_mergechrsnpfrq.o
#$ -e run_mergechrsnpfrq.e


head -n 1 ../filtering/bcftoolstest/allsamplesfilteredqual30chr1snpfrq3.txt  > ../filtering/bcftoolstest/allsamplesfilteredqual30snpfreqv5.txt
declare -a chr=("1" "2" "3"  "4" "5"  "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "contigs")

for i in "${chr[@]}"
do
   tail -n+2  "../filtering/bcftoolstest/allsamplesfilteredqual30chr${i}snpfrq3.txt"   >>  "../filtering/bcftoolstest/allsamplesfilteredqual30snpfreqv5.txt"

done

