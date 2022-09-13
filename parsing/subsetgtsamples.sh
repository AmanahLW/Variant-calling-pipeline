# get genotype column from VCF
cut -f -1,10-  

# remove text which is not genotype
perl -spi -e 's/:[^\s]+//g' 

# subsittite missing genotype with 0 
awk -F "\t" -v OFS="\t" '{ gsub("[.]/[.]", "0"); print $0}' 

# get first chrom and header
grep "CHROM\|^1\s" 
