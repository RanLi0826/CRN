clear
set more off
run "${project}/dofiles/AC_2012.do"
run "${project}/dofiles/AC_2013.do"
run "${project}/dofiles/AC_2014.do"
run "${project}/dofiles/AC_2015.do"
run "${project}/dofiles/AC_2016.do"
run "${project}/dofiles/AC_2017.do"
run "${project}/dofiles/AC_2018.do"
run "${project}/dofiles/AC_2019.do"
run "${project}/dofiles/AC_2020.do"
run "${project}/dofiles/AC_2021.do"
cap mkdir "${project}/clean_data"
cd "${project}/clean_data"
use AC_2012.dta,clear
append using AC_2013.dta 
append using AC_2014.dta 
append using AC_2015.dta 
append using AC_2016.dta 
append using AC_2017.dta 
append using AC_2018.dta 
append using AC_2019.dta 
append using AC_2020.dta 
append using AC_2021.dta

gen agecat2=1 if age>=18 & age<=64
replace agecat2=2 if age>=65

label define agecat2 ///
	1 "18-64" ///
	2 "65+" 

label values agecat2 agecat2

label define sex ///
	1 "male" ///
	2 "female" 

label values sex sex

label define year ///
	2012 "2012" ///
	2013 "2013" ///
	2014 "2014" ///
	2015 "2015" ///
	2016 "2016" ///
	2017 "2017" ///
	2018 "2018" ///
	2019 "2019" ///
	2020 "2020" ///
	2021 "2021" 

label values year year

gen edu2=1 if edu==1|edu==2
replace edu2=0 if edu==3
label define edu2 ///
	0 "higher than HS" ///
	1 "Less than high school education (including HS)" 

label values edu2 edu2 
local comor hypertension diabetes arthritis copd ascvd asthma anemia physical cancer
gen comorbidities=0
foreach var in `comor'{
replace comorbidities=comorbidities+`var'
}
gen comor=.
replace comor=1 if comorbidities==0|comorbidities==1
replace comor=2 if comorbidities>=2
label define comor ///
	1 "n=0or1" ///
	2 "n>=2" 
	
replace insurance =. if insurance==7

label values comor comor
gen poolwt=perwt/10
save clean.dta,replace 
