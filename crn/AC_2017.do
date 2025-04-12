* -----------------------------------------------------------------------------
* Accessibility and quality of care: Access to Care, 2018
*
* Could Not Afford/Delay Getting Pmed For Cost in heart failure subsample
*  - Number/percent of people
*  - By poverty status
*
* Input file: MEPS HC-201: 2017 Full Year Consolidated Data File
* Input file: MEPS HC-199: 2018 Medical Conditions File

* -----------------------------------------------------------------------------

clear
set more off
cap mkdir "${project}/data"
cd "${project}/data"

/*download datafiles------------------------------------------------------------

copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h214/h214dta.zip" "h214dta.zip", replace
unzipfile "h214dta.zip", replace 
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h216/h216dta.zip" "h216dta.zip", replace
unzipfile "h216dta.zip", replace 
------------------------------------------------------------------------------*/

* MEPS HC-207: 2018 Medical Conditions File -----------------------------------
use "h199.dta", clear 
run "${project}/dofiles/MC.do"
tempfile MC_2017
tab t 
save "`MC_2017'"

* hf medications * 
use "h197a.dta",clear
global year 17x 
run "${project}/dofiles/PM.do"
tempfile PM_2017
save "`PM_2017'"

* MEPS HC-209: 2018 Full Year Consolidated Data File --------------------------
use h201, clear
rename *, lower
merge 1:1 dupersid using "`MC_2017'"
drop if _merge==2 
drop _merge 
merge 1:1 dupersid using "`PM_2017'"
drop if _merge==2 
foreach x in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central {
	replace use_`x'=0 if _merge==1 
	replace ex_`x'=0 if _merge==1 
}
drop _merge 
local comorbidities hf hypertension diabetes arthritis copd ckd ascvd asthma hepatitis anemia cancer 
foreach var in `comorbidities' {
replace `var'=0 if `var'==.
}
* Define variables ------------------------------------------------------------
* Could Not Afford Pmed Care-R4/2 
tab pmunab42,m
gen afford_PM = (pmunrs42 == 1|pmunrs42 ==2|pmunrs42 ==3)
* Delay Getting Pmed For Cost-R4/2
tab pmdlay42,m
gen delay_PM = (pmdlrs42 == 1|pmdlrs42 ==2|pmdlrs42 ==3)
* crn
gen crn = (afford_PM | delay_PM) /* afford or delay */
label var crn "Cost-Related Medication Nonadherence"
label define crn ///
	0 "No Cost-Related Nonadherence" ///
	1 "Cost-Related Nonadherence" 

label values crn crn
replace crn=. if pmunab42<0 | pmdlay42<0
tab crn,m

* age
gen age=agelast
list if age==.

gen agecat=1 if age>=18 & age<=39
replace agecat=2 if age>=40 & age<=64
replace agecat=3 if age>=65

label define agecat ///
	1 "18-39" ///
	2 "40-64" ///
	3 "65+" 

label values agecat agecat

*race
gen race=racethx
replace race=4 if race==5
label define race 1 "Hispanic" 2 "NH_white" 3 "NH_Black" 4 "Others"
label values race race
tab race,m 

*family income level
tab povcat17,m
gen poverty=1 if povcat17==1
replace poverty=2 if povcat17>=2&povcat17<=4
replace poverty=3 if povcat17>=5

label define poverty ///
	1 "less than 100%" /// of the poverty line
	2 "100% to less than 400%" ///
	3 "greater than or equal to 400%" 

label values poverty poverty

gen lowinc=(povcat17<=3)
*education level
tab hideg,m
gen edu=1 if hideg==1
replace edu=2 if hideg==2|hideg==3
replace edu=3 if hideg==4|hideg==5|hideg==6

label define edu ///
	1 "Less than high school" ///
	2 "high school/GED" ///
	3 "college or higher"
label values edu edu
tab edu,m 

*insurance 
label define ins 1 "Priv" 2 "Public" 3 "Unins"
label values inscov17 ins
rename inscov17 inscov
recode insurc17 7/8 = 7, generate(insurance)

label define insurance ///
	1 "<65, Any private"  ///
	2 "<65, Public only" ///
	3 "<65, Uninsured" ///
	4 "65+, Medicare only"  ///
	5 "65+, Medicare and private"  ///
	6 "65+, Medicare and other public" ///
	7 "65+, No medicare"

label values insurance insurance

*Census region
tab region17,m
rename region17 region
replace region=. if region<0
label define region ///
	1 "Northeast"  ///
	2 "Midwest" ///
	3 "South" ///
	4 "West" 

label values region region
*Comorbidities:
*high blood pressure/hypertension:
replace hypertension=1 if hibpdx==1

*diabetes
replace diabetes=1 if diabdx==1

*arithritis
replace arthritis=1 if arthdx==1

*COPD
replace copd=1 if chbron31==1

*asthma
replace asthma=1 if asthdx==1

*ascvd 
replace ascvd=1 if chddx==1|angidx==1| strkdx==1| midx==1

*insufficient physical activity
gen physical=1 if phyexe53==2
replace physical=0 if phyexe53==1
label var physical "insufficient physical activity"

*cancer 
replace cancer=1 if cancerdx==1

*smoke status
gen smoke=adsmok42 if adsmok42==1
replace smoke=0 if adsmok42==2
replace smoke=1 if oftsmk53==1|oftsmk53==2
replace smoke=0 if oftsmk53==3
label define smoke ///
	0 "never smoke" ///
	1 "smoke" 

label values smoke smoke

local Comorbidities hypertension diabetes arthritis copd ckd ascvd asthma hepatitis anemia physical cancer  dyslipidemia 

foreach var in `Comorbidities' {
label define `var' ///
	0 "no `var'" ///
	1 "`var'" 
label values `var' `var'
}

*OOP 
rename totslf17 totslf 
label var totslf "All Health Services & Out of Pocket"
rename obvslf17 obvslf 
label var obvslf "Total Office Based Visits & Out of Pocket"
rename optslf17 optslf 
label var optslf "Total Outpatient Visits & Out of Pocket"
rename ertslf17 ertslf 
label var ertslf "Total Emergency Room Visits & Out of Pocket"
rename iptslf17 iptslf 
label var iptslf "Total Inpatient Stays & Out of Pocket"
rename rxslf17 rxslf 
label var rxslf "Total Prescription Medicines & Out of Pocket"
rename hhaslf17 hhaslf 
label var hhaslf "Total Home Health Care & Out of Pocket"
foreach var in totslf obvslf optslf ertslf iptslf rxslf hhaslf{
replace `var'=`var'*525.276/475.322
}

*weight
rename perwt17f perwt 

keep crn dupersid perwt sex agecat age poverty race inscov insurance region hibpdx `Comorbidities' varstr varpsu edu smoke hideg hf afford_PM delay_PM lowinc panel acceli42 totslf obvslf optslf ertslf iptslf rxslf hhaslf use* ex* 
gen year=2017
merge m:m panel dupersid using h36u21, keepusing(psu9621 stra9621)
keep if _merge==3
drop _merge
save "${project}/clean_data/AC_2017.dta",replace 
