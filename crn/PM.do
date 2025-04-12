rename *,lower 
*SGLT-2 inhibitors
g sglt_rx=.
replace sglt_rx=rxsf$year if tc1==358 & tc1s1==99 & tc1s1_1==458
replace sglt_rx=rxsf$year if tc1==358 & tc1s1==99 & tc1s1_2==458
replace sglt_rx=rxsf$year if tc1==358 & tc1s2==99 & tc1s2_1==458 
replace sglt_rx=rxsf$year if tc1==358 & tc1s3==99 & tc1s3_1==458 
replace sglt_rx=rxsf$year if tc2==358 & tc2s1==99 & tc2s1_1==458 
replace sglt_rx=rxsf$year if tc2==358 & tc2s1==99 & tc2s1_2==458 
replace sglt_rx=rxsf$year if tc3==358 & tc3s1==99 & tc3s1_1==458
bys dupersid: egen use_sglt=count(sglt_rx)
replace use_sglt=1 if use_sglt>1 
bys dupersid: egen ex_sglt=sum(sglt_rx)

*beta-blockers
g beta_rx=.
replace beta_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_1==274
replace beta_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_2==274
replace beta_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s2_1==274 
replace beta_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s3_1==274 
replace beta_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_1==274 
replace beta_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_2==274 
replace beta_rx=rxsf$year if tc3==40 & tc3s1==47 & tc3s1_1==274

replace beta_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_1==275
replace beta_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_2==275
replace beta_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s2_1==275 
replace beta_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s3_1==275 
replace beta_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_1==275 
replace beta_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_2==275 
replace beta_rx=rxsf$year if tc3==40 & tc3s1==47 & tc3s1_1==275

bys dupersid: egen use_beta=count(beta_rx)
replace use_beta=1 if use_beta>1 
bys dupersid: egen ex_beta=sum(beta_rx)

*angiotensin receptor blockers and neprilysin inhibitors (ARNI)
g arni_rx=.
replace arni_rx=rxsf$year if tc1==40 & tc1s1==482 
replace arni_rx=rxsf$year if tc1==40 & tc1s2==482  
replace arni_rx=rxsf$year if tc1==40 & tc1s3==482  
replace arni_rx=rxsf$year if tc2==40 & tc2s1==482  
replace arni_rx=rxsf$year if tc2==40 & tc2s2==482  
replace arni_rx=rxsf$year if tc3==40 & tc3s1==482 

bys dupersid: egen use_arni=count(arni_rx)
replace use_arni=1 if use_arni>1 
bys dupersid: egen ex_arni=sum(arni_rx)

*ARB 
g arb_acei_rx=. 
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s1==56 
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s2==56  
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s3==56  
replace arb_acei_rx=rxsf$year if tc2==40 & tc2s1==56  
replace arb_acei_rx=rxsf$year if tc2==40 & tc2s2==56  
replace arb_acei_rx=rxsf$year if tc3==40 & tc3s1==56 
*ACEI
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s1==42 
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s2==42  
replace arb_acei_rx=rxsf$year if tc1==40 & tc1s3==42  
replace arb_acei_rx=rxsf$year if tc2==40 & tc2s1==42  
replace arb_acei_rx=rxsf$year if tc2==40 & tc2s2==42  
replace arb_acei_rx=rxsf$year if tc3==40 & tc3s1==42 

bys dupersid: egen use_arb_acei=count(arb_acei_rx)
replace use_arb_acei=1 if use_arb_acei>1 
bys dupersid: egen ex_arb_acei=sum(arb_acei_rx)

* categories * 
*cardiovascular agents
g cardiovascular_rx=.
replace cardiovascular_rx=rxsf$year if tc3==40 
replace cardiovascular_rx=rxsf$year if tc2==40  
replace cardiovascular_rx=rxsf$year if tc1==40 
bys dupersid: egen use_cardiovascular=count(cardiovascular_rx)
replace use_cardiovascular=1 if use_cardiovascular>1 
bys dupersid: egen ex_cardiovascular=sum(cardiovascular_rx)

*diuretics
g diuretics_rx=.
replace diuretics_rx=rxsf$year if tc3==40 & tc3s1==49 
replace diuretics_rx=rxsf$year if tc2==40 & tc2s1==49
replace diuretics_rx=rxsf$year if tc2==40 & tc2s2==49  
replace diuretics_rx=rxsf$year if tc1==40 & tc1s1==49
replace diuretics_rx=rxsf$year if tc1==40 & tc1s2==49
replace diuretics_rx=rxsf$year if tc1==40 & tc1s3==49
bys dupersid: egen use_diuretics=count(diuretics_rx)
replace use_diuretics=1 if use_diuretics>1 
bys dupersid: egen ex_diuretics=sum(diuretics_rx)

*antidiabetic agents
g antidiabetic_rx=.
replace antidiabetic_rx=rxsf$year if tc1==358 & tc1s1==99 
replace antidiabetic_rx=rxsf$year if tc1==358 & tc1s2==99  
replace antidiabetic_rx=rxsf$year if tc1==358 & tc1s3==99  
replace antidiabetic_rx=rxsf$year if tc2==358 & tc2s1==99  
replace antidiabetic_rx=rxsf$year if tc2==358 & tc2s2==99  
replace antidiabetic_rx=rxsf$year if tc3==358 & tc3s1==99 
bys dupersid: egen use_antidiabetic=count(antidiabetic_rx)
replace use_antidiabetic=1 if use_antidiabetic>1 
bys dupersid: egen ex_antidiabetic=sum(antidiabetic_rx)

*antihyperlipidemic agents
g antihyperlipidemic_rx=.
replace antihyperlipidemic_rx=rxsf$year if tc1==358 & tc1s1==19 
replace antihyperlipidemic_rx=rxsf$year if tc1==358 & tc1s2==19  
replace antihyperlipidemic_rx=rxsf$year if tc1==358 & tc1s3==19  
replace antihyperlipidemic_rx=rxsf$year if tc2==358 & tc2s1==19  
replace antihyperlipidemic_rx=rxsf$year if tc2==358 & tc2s2==19  
replace antihyperlipidemic_rx=rxsf$year if tc3==358 & tc3s1==19 
bys dupersid: egen use_antihyperlipidemic=count(antihyperlipidemic_rx)
replace use_antihyperlipidemic=1 if use_antihyperlipidemic>1 
bys dupersid: egen ex_antihyperlipidemic=sum(antihyperlipidemic_rx)

*central nervous system agents
g central_rx=.
replace central_rx=rxsf$year if tc3==57  
replace central_rx=rxsf$year if tc2==57   
replace central_rx=rxsf$year if tc1==57 
bys dupersid: egen use_central=count(central_rx)
replace use_central=1 if use_central>1 
bys dupersid: egen ex_central=sum(central_rx)

*antihypertensive
g antihypertensive_rx=. 
**beta-blockers
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_1==274
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_2==274
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s2_1==274 
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s3_1==274 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_1==274 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_2==274 
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==47 & tc3s1_1==274

replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_1==275
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==47 & tc1s1_2==275
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s2_1==275 
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==47 & tc1s3_1==275 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_1==275 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==47 & tc2s1_2==275 
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==47 & tc3s1_1==275

**ACEI
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==42 
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==42  
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s3==42  
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==42  
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s2==42  
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==42 

**ARB
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==56 
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==56  
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s3==56  
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==56  
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s2==56  
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==56 

**calcium channel blockers
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==48  
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==48   
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s3==48   
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==48   
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s2==48   
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==48  

**diuretics
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==49 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==49
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s2==49  
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==49
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==49
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s3==49

**ANTIHYPERTENSIVE COMBINATIONS
replace antihypertensive_rx=rxsf$year if tc3==40 & tc3s1==55 
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s1==55
replace antihypertensive_rx=rxsf$year if tc2==40 & tc2s2==55  
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s1==55
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s2==55
replace antihypertensive_rx=rxsf$year if tc1==40 & tc1s3==55
bys dupersid: egen use_antihypertensive=count(antihypertensive_rx)
replace use_antihypertensive=1 if use_antihypertensive>1 
bys dupersid: egen ex_antihypertensive=sum(antihypertensive_rx)

*Coagulation modifier
g coagulation_rx=. 
replace coagulation_rx=rxsf$year if tc1==81
replace coagulation_rx=rxsf$year if tc2==81
replace coagulation_rx=rxsf$year if tc3==81
bys dupersid: egen use_coagulation=count(coagulation_rx)
replace use_coagulation=1 if use_coagulation>1 
bys dupersid: egen ex_coagulation=sum(coagulation_rx)

*others
gen others_rx=. 
replace others_rx=rxsf$year if sglt_rx==. & beta_rx==. & arni_rx==. & arb_acei_rx==. & cardiovascular_rx==. & diuretics_rx==. & antidiabetic_rx==. & antihyperlipidemic_rx==. & central_rx==. & antihypertensive_rx==. & coagulation_rx==.
bys dupersid: egen use_others=count(others_rx)
replace use_others=1 if use_others>1 
bys dupersid: egen ex_others=sum(others_rx)

*others
gen total_rx=rxsf$year 
bys dupersid: egen use_total=count(total_rx)
replace use_total=1 if use_total>1 
bys dupersid: egen ex_total=sum(total_rx)

keep ex_* use_* dupersid

duplicates drop 

duplicates t dupersid,gen(z)
tab z 
drop z 

foreach x in sglt beta arni arb_acei antihypertensive cardiovascular diuretics antidiabetic antihyperlipidemic central {
	label var use_`x' "whether use `x' or not" 
	label var ex_`x' "how much oop spent,neveruse=0"
}
