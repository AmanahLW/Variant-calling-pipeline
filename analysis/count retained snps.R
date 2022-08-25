########Count nonfiltered #######
strelkaprivate<-22222056
gatkprivate <-3287013
bcfprivate <-4586541
bcfgatk <-1783468
bcfstrelka<-12909879
gatkstrelka<-3072007
all<-17086178


strelka<-55290120
gatk<-25228666
bcf<-36366066    

#########countfilteres ####

#filtered1 
strelkafilterdpriavte1<-3995775 
gatkfilteredprivate1<-5736487
bcffilteredprivate1<-2373029
bcfgatkfiltered1<-1507408
bcfstrelkafiltered1<-1637979
gatkstrelkafiltered1<-3872554
allfiltered1<-14112217

filtered1<-c(strelkafilterdpriavte1,gatkfilteredprivate1,
               bcffilteredprivate1,bcfgatkfiltered1,bcfstrelkafiltered1,gatkstrelkafiltered1,allfiltered1)
unfiltered1<-c(strelkaprivate,gatkprivate,bcfprivate,bcfgatk,bcfstrelka,gatkstrelka,all)

isecthresholds1<-data.frame(filtered1, unfiltered1)
rownames(isecthresholds1)<-c("strelkaprivate","gatkprivate", "bcfprivate", "bcfgatkfiltered1",
                             "bcfstrelkafiltered1", "gatkstrelkafiltered1" , "all" )

colnames(isecthresholds1)<-c("filtered", "unfilterd")

print(isecthresholds1)

bcfqual30<-19630633
gatkqual20<-25228666 #no change
strelkaqual20<-23618525



retainedstrelka<-(strelkaqual20/strelka)*100
retainedgatk<-(gatkqual20/gatk)*100
retainedbcf<-(bcfqual30/bcf)*100
#> retainedstrelka
#[1] 42.71744
#> retainedgatk
#[1] 100
#> retainedbcf
#[1] 53.98063

              #bcf     #gatk    #strelka
filtered<-c(19630633, 25228666, 23618525 )
nonfiltered<-c(36366066 , 25228666, 55290120)
retained<-c((bcfqual30/bcf)*100, (gatkqual20/gatk)*100 ,(strelkaqual20/strelka)*100)

threshold1<-data.frame(filtered, nonfiltered,retained)

rownames(threshold1)<-c("bcf" , "gatk", "strelka")

print(threshold1)




#filtered2
strelkaprivate10<-10336558
gatkprivatequal30<- 5547870 
bcftoolspriavtequal40<-2044674
bcfgatkfilterd2<-725532
bcfstrelkafiltered2<-1094425
strelkagatkfiltered2<-7111018
allfiltered2<-11844246

bcfqual40<-15708877
gatkqual30<-25228666
strelka10<-30386247

retainedstrelkaqual10<-(strelka10/strelka)*100
retainedgatkqual30<-(gatkqual30/gatk)*100
retainedbcfqual40<-(bcfqual40/bcf)*100
#> retainedstrelkaqual20
#[1] 54.95782
#> retainedgatkqual30
#[1] 100
#> retainedbcfqual40
#[1] 43.19653
#
#


filtered2<-c(strelkaprivate10,gatkprivatequal30,bcftoolspriavtequal40,bcfgatkfilterd2,bcfstrelkafiltered2,strelkagatkfiltered2,allfiltered2)
unfiltered2<-c(strelkaprivate,gatkprivate,bcfprivate,bcfgatk,bcfstrelka,gatkstrelka,all)

isecthreshol2<-data.frame(unfiltered2, filtered2)

rownames(isecthreshol2)<-c("strelkaprivate","gatkprivate","bcftoolspriavte","bcfgatkfilterd2","bcfstrelkafiltered2","strelkagatkfiltered2","allfiltered2")
colnames(isecthreshol2)<-c("unfilterd", "filtered")

print(isecthreshol2)

#bcf     gatk      strelka

filtered<-c(15708877, 25228666,30386247 )
nonfiltered<-c(36366066 , 25228666, 55290120)
retained<-c((bcfqual40/bcf)*100, (gatkqual30/gatk)*100 ,(strelka10/strelka)*100)

threshold2<-data.frame(filtered, nonfiltered,retained)

rownames(threshold2)<-c("bcf" , "gatk", "strelka")

print(threshold2)


#####filtered 3
strelkaprivatefilterdqual5<-14457140
gatkprivatefilteredqual40<-3807963
bcftoolsprviatefilteredqual20<-2698641
bcfgatkfiltered3<-1683022
bcfstrelkafiltered3<-2604503
gatkstrelkafiltered3<-3505193
allfiltered3<-15611378


bcffiltered3qual20<-22597544
gatkfiltereded3qual40<-24607556
strelkafiltered3qual5<-36178214

filtered3<-c(strelkaprivatefilterdqual5,gatkprivatefilteredqual40,bcftoolsprviatefilteredqual20,bcfgatkfiltered3,bcfstrelkafiltered3,gatkstrelkafiltered3,allfiltered3)
unfiltered3<-c(strelkaprivate,gatkprivate,bcfprivate,bcfgatk,bcfstrelka,gatkstrelka,all)

isecthreshold3<-data.frame(unfiltered3, filtered3)
rownames(isecthreshold3)<-c("strelkaprivate","gatkprivate","bcftoolsprviatefiltered","bcfgatkfilterd3","bcfstrelkafiltered3","strelkagatkfiltered3","allfiltered3")
colnames(isecthreshold3)<-c("unfilterd", "filtered")

print(isecthreshold3)
#bcf     gatk      strelka

filtered<-c(22597544, 24607556,36178214 )
nonfiltered<-c(36366066 , 25228666, 55290120)
retained<-c((bcffiltered3qual20/bcf)*100, (gatkfiltereded3qual40/gatk)*100 ,(strelkafiltered3qual5/strelka)*100)

threshold3<-data.frame(filtered, nonfiltered,retained)

rownames(threshold3)<-c("bcf" , "gatk", "strelka")

print(threshold3)


####filtered 4

gatkfiltereded4qual50<-23639080
(gatkfiltereded4qual50/gatk)*100
#93.69929
####filtered 5

gatkfiltereded5qual60<-22976448
(gatkfiltereded5qual60/gatk)*100
#91.07278

gatkfiltereded6qual70<-22190067 # keep this and test isec 
(gatkfiltereded6qual70/gatk)*100
#87.95577

gatkfiltereded7qual80<-20793267 


(gatkfiltereded7qual80/gatk)*100
#82.41921

####filtered 6
strelkafilteredqual30<-20956557
(strelkafilteredqual30/strelka) * 100
#37.9029% retained

#####dataframe for each caller

count<-c(bcfqual30,bcfqual40,bcffiltered3qual20)
percent<-c((bcfqual30/bcf)*100 ,(bcfqual40/bcf)*100, (bcffiltered3qual20/bcf)*100)

bcfdf<-data.frame(count,percent)
colnames(bcfdf)<-c("count","retained%")
rownames(bcfdf)<-c("30", "40","20")
#KEEP BCF AT QUAL 30 THRESHOLD

countst<-c(strelkaqual20,strelka10,strelkafiltered3qual5)
percentst<-c((strelkaqual20/strelka)*100,(strelka10/strelka)*100,(strelkafiltered3qual5/strelka)*100)
strelkadf<-data.frame(countst,percentst)
colnames(strelkadf)<-c("count","retained%")
rownames(strelkadf)<-c("20", "10","5")########keep qual threshold 20 or 10 qual as count close to gatk



##final isec
strelkafilterdprivatequal10 <-9791295
gatkfilteredpriavtequal70<-3201258
bcftoolsfilleredpriavtequal20<-3039660
bcfgatkfiltered<-1707282
bcfstrelkafiltered<-3313425
gatkstrelkafiltered<-2744350
allfiletred<-14537177

##final isec 

strelkaprivatequal30filtered<-3215008
gatkprivatequal80filtered<-4088265
bcftoolsprivatequal30filtered<-1069360
bcf30gatk80filtered<-1607040
bcf30strelka30filtered<-2643587
strelka30gatk80filtered<-2504998
allfiltered<-12592964



#[bt211065@frontend8 gatktest]$ grep -v "##" allsamplesfilteredqual80v2.vcf | wc -l
#20793267

filteredisec<-c(strelkafilteredqual30,bcfqual30,gatkfiltereded7qual80)
unfilteredisec<-c(strelka, bcf, gatk)
percentisec<-c((strelkafilteredqual30/strelka)*100,(bcfqual30/bcf)*100,(gatkfiltereded7qual80/gatk)*100)
isecthreshold4<-data.frame(filteredisec,unfilteredisec, percentisec)
rownames(isecthreshold4)<-c("strelka","bcf" ,"gtak")
colnames(isecthreshold4)<-c("filtered", "unfiltered", "percent")







