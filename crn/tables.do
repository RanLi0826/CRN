cap mkdir "${project}/results"
cd "${project}/results"
use "${project}/clean_data/clean.dta",clear
svyset psu9621 [pw = poolwt], strata(stra9621) vce(linearized) singleunit(missing)

gen domain=(hf==1&age>=18&acceli42==1)

foreach num in 1 2 {
gen domain_agecat`num'=(agecat2==`num'&domain==1)
}

*tableS3
local comorbidities hypertension diabetes arthritis copd ascvd asthma anemia physical cancer smoke comor 

foreach var in agecat2 sex race poverty inscov insurance region edu `comorbidities'{
estpost svy , sub(domain):  tab `var', column ci percent nototal
estadd matrix ci_u=e(ub)
estadd matrix ci_l=e(lb)
est sto res_`var'_tol
}

foreach var in agecat2 sex race poverty inscov insurance region edu `comorbidities'{
estpost svy , sub(domain):  tab `var' crn, column ci percent nototal
estadd matrix ci_u=e(ub)
estadd matrix ci_l=e(lb)
est sto res_`var'
}


*weighted average
svy , sub(domain):  tab crn ,count ci format(%11.3g)
svy , sub(domain):  tab crn ,ci format(%11.3g)
svy , sub(domain):  tab delay_PM ,count ci format(%11.3g)
svy , sub(domain):  tab delay_PM ,ci format(%11.3g)
svy , sub(domain):  tab afford_PM ,count ci format(%11.3g)
svy , sub(domain):  tab afford_PM ,ci format(%11.3g)
tab crn if domain==1
tab crn if domain==1 & agecat2==1
tab delay_PM if domain==1 & agecat2==1
tab afford_PM if domain==1 & agecat2==1
svy , sub(domain_agecat1):  tab crn ,count ci format(%11.3g)
svy , sub(domain_agecat1):  tab crn ,ci format(%11.3g)
svy , sub(domain_agecat1):  tab afford_PM ,count ci format(%11.3g)
svy , sub(domain_agecat1):  tab afford_PM ,ci format(%11.3g)
svy , sub(domain_agecat1):  tab delay_PM ,count ci format(%11.3g)
svy , sub(domain_agecat1):  tab delay_PM ,ci format(%11.3g)
tab crn if domain==1 & agecat2==2
tab afford_PM if domain==1 & agecat2==2
tab delay_PM if domain==1 & agecat2==2
svy , sub(domain_agecat2):  tab crn ,count ci format(%11.3g)
svy , sub(domain_agecat2):  tab crn ,ci format(%11.3g)
svy , sub(domain_agecat2):  tab afford_PM ,count ci format(%11.3g)
svy , sub(domain_agecat2):  tab afford_PM ,ci format(%11.3g)
svy , sub(domain_agecat2):  tab delay_PM ,count ci format(%11.3g)
svy , sub(domain_agecat2):  tab delay_PM ,ci format(%11.3g)

*supplemental tableS3 
svy , sub(domain): mean age
svy , sub(domain): mean age, over(crn) coeflegend
test _b[c.age@0bn.crn]=_b[c.age@1.crn]
lincom _b[c.age@0bn.crn] - _b[c.age@1.crn]


*table1

local comorbidities hypertension diabetes arthritis copd ascvd asthma anemia physical cancer smoke comor 

foreach num in 1 2 {
foreach crncat in afford_PM delay_PM crn { 
foreach var in sex race poverty inscov insurance region edu `comorbidities'{
estpost svy , sub(domain_agecat`num'):  tab `var' `crncat', row ci percent nototal
estadd matrix ci_u=e(ub)
estadd matrix ci_l=e(lb)
est sto res_`crncat'_`var'`num'
}
}
}
*results
*tableS3
cap erase tableS3.rtf
local comorbidities hypertension diabetes arthritis copd ascvd asthma anemia physical cancer  smoke edu comor
foreach var in agecat sex race poverty inscov insurance region `comorbidities'{
esttab res_`var'_tol res_`var' using "tableS3.rtf",b(2) ci nostar onecell scalars(p_Pear) sfmt(4) unstack nonotes label nomtitle nonumbers append
}

*table1
cap erase "table1.rtf" 
local comorbidities hypertension diabetes arthritis copd ascvd asthma anemia physical cancer smoke edu comor
foreach var in sex race poverty inscov insurance region `comorbidities'{
esttab res_crn_`var'1 res_afford_PM_`var'1 res_delay_PM_`var'1 res_crn_`var'2 res_afford_PM_`var'2 res_delay_PM_`var'2 using "table1.rtf",b(2) ci nostar nonotes label mtitle nonumbers unstack sfmt(fmt[%20.2f]) append
} 

* Figure1 * 
cd "${project}/figs"
use "${project}/clean_data/clean.dta",clear
svyset psu9621 [pw = poolwt], strata(stra9621) vce(linearized) singleunit(missing)
gen domain=(hf==1&age>=18&acceli42==1)
foreach num in 1 2 {
gen domain_`num'=(domain==1&agecat2==`num')
}
set scheme s1color, perm
foreach var in crn afford_PM delay_PM { 
svy, sub(domain): proportion `var',over(year) percent
cap drop coef_`var'
gen coef_`var'=.
forvalues x=2012(1)2021 {
replace coef_`var'=_b[1.`var'@`x'.year]*100 if year==`x'

}
}
keep coef_crn coef_afford_PM coef_delay_PM year
duplicates drop 
tw (con coef_crn coef_afford_PM coef_delay_PM year ), ytitle("Prevalence of CRN, %") xtitle(Year) /// 
legend(label(1 "overall") label(2 "didn't get") label(3 "delay")) ///
xlabel (2012(1)2021) name(con,replace) 

*********
*Figure2*
*********
cap mkdir "${project}/results"
cd "${project}/results"
use "${project}/clean_data/clean.dta",clear
svyset psu9621 [pw = poolwt], strata(stra9621) vce(linearized) singleunit(missing)

gen domain=(hf==1&age>=18&acceli42==1)

foreach num in 1 2 {
gen domain_agecat`num'=(agecat2==`num'&domain==1)
}

label var use_sglt "SGLT2 inhibitors"
label var use_beta "Beta blockers"
label var use_arni "ARNIs"
label var use_arb_acei "ACEI or ARB"
label var use_cardiovascular "Cardiovascular Agents"
label var use_antihypertensive "Antihypertensive Agents"
label var use_diuretics "Diuretics"
label var use_antidiabetic "Antidiabetic Agents"
label var use_antihyperlipidemic "Antihyperlipidemic Agents"
label var use_central "Central Nervous System"
label var use_coagulation "Coagulation Modifier"
label var use_others "Others"

svy , sub(domain_agecat1): mean use_sglt use_beta use_arni use_arb_acei use_cardiovascular use_antihypertensive use_diuretics use_antidiabetic use_antihyperlipidemic use_central use_coagulation use_others if crn==0
est sto figure3_agecat1_crn0

svy , sub(domain_agecat1): mean use_sglt use_beta use_arni use_arb_acei use_cardiovascular use_antihypertensive use_diuretics use_antidiabetic use_antihyperlipidemic use_central use_coagulation use_others if crn==1

est sto figure3_agecat1_crn1

svy , sub(domain_agecat2): mean use_sglt use_beta use_arni use_arb_acei use_cardiovascular use_antihypertensive use_diuretics use_antidiabetic use_antihyperlipidemic use_central use_coagulation use_others if crn==0
est sto figure3_agecat2_crn0

svy , sub(domain_agecat2): mean use_sglt use_beta use_arni use_arb_acei use_cardiovascular use_antihypertensive use_diuretics use_antidiabetic use_antihyperlipidemic use_central use_coagulation use_others if crn==1

est sto figure3_agecat2_crn1

  * identify @at * 
coefplot (figure3_agecat1_crn0,recast(bar) barwidt(0.3) noci mlabpos(3) ) (figure3_agecat1_crn1,recast(bar) barwidt(0.3) noci mlabpos(3) ),bylabel("<65 years") || ///
(figure3_agecat2_crn0,recast(bar) barwidt(0.3) noci mlabpos(3) mlabel(@at)) (figure3_agecat2_crn1,recast(bar) barwidt(0.3) noci mlabpos(3) mlabel(@at)),bylabel("≥65 years") ///
headings(use_sglt = "{bf:guideline-recommended medications}"                     ///
use_cardiovascular = "{bf: }")

  * figure3 * 
coefplot (figure3_agecat1_crn0,recast(bar) barwidt(0.3) noci mlabpos(3) ) (figure3_agecat1_crn1,recast(bar) barwidt(0.3) noci mlabpos(3) ),bylabel("<65 years")   || ///
(figure3_agecat2_crn0,recast(bar) barwidt(0.3) noci mlabpos(3) ///
mlabel(cond(@at>7.8&@at<8.2&@by==2,"*",cond(@at<2.2&@by==1,"*",cond(@at>11.8&@at<13.2&@by==2,"*",""))))) ///
(figure3_agecat2_crn1,recast(bar) barwidt(0.3) noci mlabpos(3) ///
mlabel(cond(@at>7.8&@at<8.2&@by==2,"*",cond(@at<2.2&@by==1,"*",cond(@at>11.8&@at<13.2&@by==2,"*","")))) ),bylabel("≥65 years") tit(cond(@by==1,"Panel B",cond(@by==1,"Panel A",""))) ///
legend(lab(1 "without CRN") lab(2 "with CRN")) ///
headings(use_sglt = "{bf:Guideline-recommended}"                     ///
use_cardiovascular = "{bf: }") ///
xlab(0.5 "50%" 1 "100%") xtit("Utilization rate, %",placement(5.5))

*********
*Figure3*
*********
cap mkdir "${project}/results"
cd "${project}/results"
use "${project}/clean_data/clean.dta",clear
svyset psu9621 [pw = poolwt], strata(stra9621) vce(linearized) singleunit(missing)

gen domain=(hf==1&age>=18&acceli42==1)

foreach num in 1 2 {
gen domain_agecat`num'=(agecat2==`num'&domain==1)
}
* OOP expenditure: users only * 
foreach var in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central coagulation others total {
g ex_user_`var'=ex_`var'
replace ex_user_`var'=. if use_`var'==0
g domain_`var'_age1=(use_`var'==1 & agecat2==1 & domain==1)
g domain_`var'_age2=(use_`var'==1 & agecat2==2 & domain==1)
}

foreach var in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central coagulation others total {
svy , sub(domain_`var'_age1): mean ex_`var' if crn==0
est sto `var'_a1_c0
}

foreach var in beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central coagulation others total {
svy , sub(domain_`var'_age1): mean ex_`var' if crn==1
est sto `var'_a1_c1
}

foreach var in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central coagulation others total {
svy , sub(domain_`var'_age2): mean ex_`var' if crn==0
est sto `var'_a2_c0
}

foreach var in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central coagulation others total {
svy , sub(domain_`var'_age2): mean ex_`var' if crn==1
est sto `var'_a2_c1
}

label var ex_sglt "SGLT2 inhibitors"
label var ex_beta "Beta blockers"
label var ex_arni "ARNIs"
label var ex_arb_acei "ACEI or ARB"
label var ex_cardiovascular "Cardiovascular Agents"
label var ex_antihypertensive "Antihypertensive Agents"
label var ex_diuretics "Diuretics"
label var ex_antidiabetic "Antidiabetic Agents"
label var ex_antihyperlipidemic "Antihyperlipidemic Agents"
label var ex_central "Central Nervous System"
label var ex_coagulation "Coagulation Modifier"
label var ex_others "Others"
label var ex_others "Total"

coefplot (sglt_a1_c0 beta_a1_c0 arni_a1_c0 arb_acei_a1_c0 cardiovascular_a1_c0 antihypertensive_a1_c0 diuretics_a1_c0 antidiabetic_a1_c0 antihyperlipidemic_a1_c0 central_a1_c0 coagulation_a1_c0 others_a1_c0 total_a1_c0,recast(bar) barwidt(0.3) noci mlabpos(3) ) ///
(*_a1_c1,recast(bar) barwidt(0.3) noci mlabpos(3) ),bylabel("<65 years") || ///
(*_a2_c0,recast(bar) barwidt(0.3) noci mlabpos(3) mlabel(cond(@at>10.8&@at<11.2&@by==1,"*",cond(@at>3.8&@at<4.2&@by==2,"*",cond(@at>12.8&@at<13.2&@by==1,"*",""))))) ///
(*_a2_c1,recast(bar) barwidt(0.3) noci mlabpos(3) mlabel(cond(@at>10.8&@at<11.2&@by==1,"*",cond(@at>3.8&@at<4.2&@by==2,"*",cond(@at>12.8&@at<13.2&@by==1,"*",""))))) ,bylabel("≥65 years") ///
tit(cond(@by==1,"Panel B",cond(@by==1,"Panel A",""))) ///
legend(lab(1 "without CRN") lab(2 "with CRN")) ///
headings(ex_sglt = "{bf:Guideline-recommended}" ///
ex_cardiovascular = "{bf: }") ///
 xtit("Out-of-pocket expenditure per user, $",placement(5.5))

* Figure S2
use "${project}/clean_data/clean.dta",clear
svyset psu9621 [pw = poolwt], strata(stra9621) vce(linearized) singleunit(missing)
gen domain=(hf==1&age>=18&acceli42==1)
set scheme s1color, perm
svy,sub(domain): logistic crn ib2.agecat2 i.sex ib2.race ib3.edu i.lowinc ib2.inscov ib1.comor 
mat b = e(b) 
mat list b
mat cov = e(V) 
mat list cov 
g b = .
g se = .
forv i = 1/19 {
replace b = b[1,`i'] if _n==`i'
replace se = sqrt(cov[`i',`i']) if _n==`i'
}
g lb=b-(invttail(e(df_r),0.025)*se)
g ub=b+invttail(e(df_r),0.025)*se 
keep b lb ub
drop if b==.
drop if b==0 
drop if _n==12 

g variable="" 
replace variable="age<65 y (vs. ≥65 y)" if _n==1 
replace variable="Female (vs. Male)" if _n==2
replace variable="Hispanic" if _n==3
replace variable="Black" if _n==4
replace variable="Others" if _n==5
replace variable="less than HS" if _n==6
replace variable="HS or GED" if _n==7
replace variable="Low-income (vs. Mid/High-income)" if _n==8
replace variable="Private" if _n==9
replace variable="Uninsured" if _n==10
replace variable="≥2 (vs. 0 or 1)" if _n==11

cap g cat="" 
replace cat="Demographics" if _n==1|_n==2 
replace cat="Race (vs. White)" if _n>=3 & _n<=5
replace cat="SES" if _n==8 
replace cat="Education (vs. ≥college)" if _n>=6 & _n<=7 
replace cat="Insurance (vs. Public)" if _n>=9 & _n<=10 
replace cat="Comorbidities" if _n==11

cap g order=. 
replace order=_n 
replace order=_n+1 if _n>=6 
replace order=6 if _n==8

metan b lb ub,eform nowt nooverall nobox nosubgroup label(namevar=variable) labtitle("") by(cat) xtick(0.1(0.1)1 2(1)10) effect(Odds Ratio) title("Risk-adjusted Odds Ratio", pos(6) size(medium small)) xlab(0.1 0.2 0.4 0.6 0.8 1 2 4 6 8 10) sortby(order)
