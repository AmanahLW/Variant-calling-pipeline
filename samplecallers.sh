find */ -name strelka.S1.vcf.gz | sed 'p;s/.gz/ /g' | xargs -n2 mv
find */ | grep _bcftools.g.vcf.gz$ | sed -e 's/_bcftools.g.vcf.gz$//' > samples-bcftools.tsv
find */ | grep strelka.S1.vcf$ | sed -e 's/strelka.S1.vcf$//' > samples-strelka.tsv 
find */ | grep gatk.g.vcf.gz$ | sed -e 's/gatk.g.vcf.gz$//' > samples-gatk.tsv
