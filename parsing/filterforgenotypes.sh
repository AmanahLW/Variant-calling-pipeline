#!/usr/bin/env bash
#$ -cwd
#$ -pe smp 1
#$ -l h_rt=3:0:0
#$ -l h_vmem=1G
#$ -o run_filterchrforgt.o
#$ -e run_filterchrforgt.e






declare -a chr=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25"  "K\|^M")


#get chr and header
for n in "${chr[@]}"
do
 grep  "CHROM\|^$n\s" "../filtering/bcftoolstest/allsamfilteredqual30nogvcfgenotypesub.txt" > "../filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30nogvcfgtchr$n.txt"
done



