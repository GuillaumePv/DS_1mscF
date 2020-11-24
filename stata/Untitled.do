clear
cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/"
import delimited "Data/agregatedData_final.csv",stringcols(1) 

cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/stata"
drop v1

order date, first
//create id by company to create data panel
egen company_id = group(instrument)
encode date, gen(date1) 

duplicates report company_id date1
duplicates list company_id date1
duplicates tag company_id date1, gen(isdup)
//browse if isdup

drop if isdup 
gen interacAUM_SP = issp500*growthtotalnav

global controls "roe volume returnsp500 spreadbidask companymarketcap totalvolumeetf"

summarize pe growthtotalnav $controls, detail

corr pe growthtotalnav $controls

kdensity spreadbidask
collin pe growthtotalnav $controls //ok for collinearity

extremes pe growthtotalnav $controls 

drop if company_id == 157
xtset company_id date1 
twoway histogram pe, bin(10) freq 
//test regression

//do regression for each company -> usefull for som ebig company like FB or NFLX
xi: regress pe growthtotalnav i.company_id 

// without control
xtreg pe interacAUM_SP 

xtivreg pe (growthtotalnav = issp500)
// with control
xtreg pe interacAUM_SP $controls

//bonne regression
xtreg pe interacAUM_SP $controls, fe

set max_memory 120000
xtreg pe interacAUM_SP i.date1 $controls, fe
xtreg pe interacAUM_SP $controls, fe vce(cluster company_id)
xtreg pe roe volume growthtotalnav, fe
xtreg pe roe volume growthtotalnav, re
