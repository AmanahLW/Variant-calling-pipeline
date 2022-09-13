
cut -f -1,10-  

perl -spi -e 's/:[^\s]+//g' 

awk -F "\t" -v OFS="\t" '{ gsub("[.]/[.]", "0"); print $0}' 


grep "CHROM\|^1\s" 
