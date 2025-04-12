rename *, lower

* Define variables ------------------------------------------------------------
* hf status
gen hf_temp=(icd9codx=="428")
replace hf_temp=1 if cccodex=="108"
bys dupersid : egen hf=sum(hf_temp)
replace hf=1 if hf>1
tab hf,m 
label define status ///
	1 "HEART FAILURE" ///
    0 "other sample" ///
	
label values hf status
*Comorbidities:
*high blood pressure/hypertension:
gen hypertension_temp=1 if icd9codx=="401"
replace hypertension_temp=1 if cccodex=="98"
replace hypertension_temp=0 if hypertension_temp==.
bys dupersid : egen hypertension=sum(hypertension_temp)
replace hypertension=1 if hypertension>1
tab hypertension,m 


*diabetes
gen diabetes_temp =(icd9codx=="250") 
label var diabetes "Diabetes"
replace diabetes_temp=1 if cccodex=="49"
bys dupersid : egen diabetes=sum(diabetes_temp)
replace diabetes=1 if diabetes>1
tab diabetes,m 

*arthritis
gen arthritis_temp=(cccodex=="202"|cccodex=="203")
bys dupersid : egen arthritis=sum(arthritis_temp)
replace arthritis=1 if arthritis>1
tab arthritis,m 

*COPD
gen copd_temp=(cccodex=="127")
bys dupersid : egen copd=sum(copd_temp)
replace copd=1 if copd>1
tab copd,m 

*dyslipidemia
gen dyslipidemia_temp=(icd9codx=="272")
bys dupersid : egen dyslipidemia=sum(dyslipidemia_temp)
replace dyslipidemia=1 if dyslipidemia>1
tab dyslipidemia,m 

*ASCVD：angidx
gen ascvd_temp=(icd9codx=="410")
replace ascvd_temp=1 if icd9codx=="413"
replace ascvd_temp=1 if icd9codx=="414"
replace ascvd_temp=1 if icd9codx=="433"
replace ascvd_temp=1 if icd9codx=="434"
replace ascvd_temp=1 if icd9codx=="435"
replace ascvd_temp=1 if icd9codx=="436"
replace ascvd_temp=1 if icd9codx=="437"
replace ascvd_temp=1 if icd9codx=="440"
replace ascvd_temp=1 if icd9codx=="443"
bys dupersid : egen ascvd=sum(ascvd_temp)
replace ascvd=1 if ascvd>1
tab ascvd,m 

*asthma
gen asthma_temp=(icd9codx=="493")
replace asthma_temp=1 if cccodex=="128"
bys dupersid : egen asthma=sum(asthma_temp)
replace asthma=1 if asthma>1
tab asthma,m 

*hepatitis
gen hepatitis_temp=(icd9codx=="006")
replace hepatitis_temp=1 if icd9codx=="070"
bys dupersid : egen hepatitis=sum(hepatitis_temp)
replace hepatitis=1 if hepatitis>1
tab hepatitis,m 

*anemia
gen anemia_temp=(icd9codx=="280")
replace anemia_temp=1 if icd9codx=="285"
replace anemia_temp=1 if cccodex=="059"
bys dupersid : egen anemia=sum(anemia_temp)
replace anemia=1 if anemia>1
tab anemia,m 

*cancer 
gen cancer_temp=0 
replace cancer_temp=1 if cccodex=="011"|cccodex=="012"|cccodex=="013"|cccodex=="014"|cccodex=="015"|cccodex=="016"|cccodex=="017"|cccodex=="018"|cccodex=="019"|cccodex=="020"|cccodex=="021"|cccodex=="022"|cccodex=="023"|cccodex=="024"|cccodex=="025"|cccodex=="026"|cccodex=="027"|cccodex=="028"|cccodex=="029"|cccodex=="030"|cccodex=="031"|cccodex=="032"|cccodex=="033"|cccodex=="034"|cccodex=="035"|cccodex=="036"|cccodex=="037"|cccodex=="038"|cccodex=="039"|cccodex=="040"|cccodex=="041"|cccodex=="042"|cccodex=="043"
bys dupersid : egen cancer=sum(cancer_temp)
replace cancer=1 if cancer>1
tab cancer,m 


local comorbidities hf hypertension diabetes arthritis copd ascvd asthma hepatitis anemia cancer dyslipidemia 
keep dupersid `comorbidities' 
duplicates drop 
duplicates t dupersid, gen(t) 
tab t 
