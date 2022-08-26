
cut -f -1,10-  ../filtering/gatktest/allsamplesfilteredqual80v2noheader.txt > ../filtering/gatktest/allsamplesfilteredqual80v2noheadergenotype.txt

perl -spi -e 's/:[^\s]+//g' ../filtering/gatktest/allsamplesfilteredqual80v2noheadergenotype.txt

 awk -F "\t" -v OFS="\t" '{ gsub("[.]/[.]", "0"); print $0}' ../filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30nogvcfgenotype.txt >  ../filtering/bcftoolstest/allsamplesbcftoolsfilteredqual30nogvcfgenotypecleanedmissinggt.txt


 grep "CHROM\|^1\s" ../filtering/gatktest/allsamplesfilteredqual80v2noheadergenotype.txt > ../filtering/gatktest/allsamplesfilteredchr1gt.txt
