clear all
cd "/Users/liran/Desktop/CRN/data"
filesearch *.dta,local(qq) 

local qq: subinstr local qq ".dta" "", all  //剔除掉后缀
foreach i of local qq{
use `i'.dta,clear
run "${project}/dofiles/`i'.do"
}

clear all
local myfilelist   : dir . files "*.dta"
foreach filename of local myfilelist {
  append using "`filename'"
}
tab DLAYPM42
tab AFRDPM42
