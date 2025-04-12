rename *, lower

* Define variables ------------------------------------------------------------
* hf status
gen hf_temp=(icd10cdx=="I50")
bys dupersid : egen hf=sum(hf_temp)
replace hf=1 if hf>1
tab hf,m 
label define status ///
	1 "HEART FAILURE" ///
    0 "other sample" ///
	
label values hf status
*Comorbidities:
*high blood pressure/hypertension:
gen hypertension_temp=1 if icd10cdx=="I10"
replace hypertension_temp=1 if ccsr1x=="CIR007"
replace hypertension_temp=0 if hypertension_temp==.
bys dupersid : egen hypertension=sum(hypertension_temp)
replace hypertension=1 if hypertension>1
tab hypertension,m 


*diabetes
gen diabetes_temp =(icd10cdx=="E11") 
label var diabetes "Diabetes"
replace diabetes_temp=1 if icd10cdx=="E10"|icd10cdx=="E12"|icd10cdx=="E13"|icd10cdx=="E14"
replace diabetes_temp=1 if ccsr1x=="END002"
replace diabetes_temp=1 if ccsr1x=="END003"
replace diabetes_temp=1 if ccsr2x=="END005"
bys dupersid : egen diabetes=sum(diabetes_temp)
replace diabetes=1 if diabetes>1
tab diabetes,m 

*arthritis
gen arthritis_temp=(icd10cdx=="M16")
replace arthritis_temp=1 if icd10cdx=="M17"
replace arthritis_temp=1 if icd10cdx=="M19"
replace arthritis_temp=1 if icd10cdx=="M06"
replace arthritis_temp=1 if ccsr1x=="MUS003"
replace arthritis_temp=1 if ccsr1x=="MUS006"
bys dupersid : egen arthritis=sum(arthritis_temp)
replace arthritis=1 if arthritis>1
tab arthritis,m 

*COPD
gen copd_temp=(icd10cdx=="J42")
replace copd_temp=1 if icd10cdx=="J43"
replace copd_temp=1 if icd10cdx=="J44"
replace copd_temp=1 if ccsr1x=="RSP008"
bys dupersid : egen copd=sum(copd_temp)
replace copd=1 if copd>1
tab copd,m 

*CKD
gen ckd_temp=(icd10cdx=="N18")
replace ckd_temp=1 if ccsr1x=="GEN003"
bys dupersid : egen ckd=sum(ckd_temp)
replace ckd=1 if ckd>1
tab ckd,m 

*dyslipidemia
gen dyslipidemia_temp=(icd10cdx=="E78")
bys dupersid : egen dyslipidemia=sum(dyslipidemia_temp)
replace dyslipidemia=1 if dyslipidemia>1
tab dyslipidemia,m 

*ASCVD：angidx
gen ascvd_temp=(icd10cdx=="I20")
replace ascvd_temp=1 if icd10cdx=="I21"
replace ascvd_temp=1 if icd10cdx=="I25"
replace ascvd_temp=1 if icd10cdx=="I63"
replace ascvd_temp=1 if icd10cdx=="G45"
replace ascvd_temp=1 if icd10cdx=="I70"
replace ascvd_temp=1 if icd10cdx=="I73"
replace ascvd_temp=1 if icd10cdx=="I79"
bys dupersid : egen ascvd=sum(ascvd_temp)
replace ascvd=1 if ascvd>1
tab ascvd,m 

*asthma
gen asthma_temp=(icd10cdx=="J45")
replace asthma_temp=1 if ccsr1x=="RSP009"
bys dupersid : egen asthma=sum(asthma_temp)
replace asthma=1 if asthma>1
tab asthma,m 

*hepatitis
gen hepatitis_temp=(icd10cdx=="B19")
replace hepatitis_temp=1 if ccsr1x=="INF007"
bys dupersid : egen hepatitis=sum(hepatitis_temp)
replace hepatitis=1 if hepatitis>1
tab hepatitis,m 

*anemia
gen anemia_temp=(icd10cdx=="D64")
replace anemia_temp=1 if icd10cdx=="D50"
replace anemia_temp=1 if ccsr1x=="BLD001"
replace anemia_temp=1 if ccsr1x=="BLD003"
bys dupersid : egen anemia=sum(anemia_temp)
replace anemia=1 if anemia>1
tab anemia,m 

*cancer 
gen cancer_temp=0 
replace cancer_temp=1 if icd10cdx=="C34"|icd10cdx=="C53"|icd10cdx=="C55"|icd10cdx=="C56"|icd10cdx=="C61"|icd10cdx=="C64"|icd10cdx=="C71"|icd10cdx=="C76"|icd10cdx=="C80"|icd10cdx=="C85"|icd10cdx=="C95"
bys dupersid : egen cancer=sum(cancer_temp)
replace cancer=1 if cancer>1
tab cancer,m 

*obesity
gen obesity_temp=(icd10cdx=="E66")
replace obesity_temp=1 if ccsr1x=="END009"
bys dupersid : egen obesity=sum(obesity_temp)
replace obesity=1 if obesity>1
tab obesity,m 

local comorbidities hf hypertension diabetes arthritis copd ckd ascvd asthma hepatitis anemia cancer obesity dyslipidemia 
keep dupersid `comorbidities' 
duplicates drop 
duplicates t dupersid, gen(t) 
tab t 
