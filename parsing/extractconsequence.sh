# get info field
awk '{print $8}' ../filtering/gatktest/ allsamplesfilteredqual80v2noheader.vcf > ../filtering/gatktest/allsamplesqual80vepinfofield.txt


# get first predition
# get impact and consequence
awk -F ';CSQ=|[|],' '{print $2}' ../filtering/gatktest/allsamplesqual80vepinfofield.txt | awk -F '[|]|[|]' 
'{print $2 "\t" $3}' > ../filtering/gatktest/allsamplesqual80vepinfofieldextract.txt
