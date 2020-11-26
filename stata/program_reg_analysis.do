//ssc install winsor2

clear
cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/"
import delimited "Data/agregatedData_final.csv",stringcols(1) 

cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/stata"
drop v1

order date, first
//create id by company to create data panel
egen company_id = group(instrument)
encode date, gen(date1) 
gen log_volume = log(volume)
gen log_totalvolumeetf = log(totalvolumeetf)
gen log_companymarketcap = log(companymarketcap)
//drop if date1 < 2013-01-01

duplicates report company_id date1
duplicates list company_id date1
duplicates tag company_id date1, gen(isdup)
//browse if isdup

drop if isdup 
gen interacNAV_SP = issp500*growthtotalnav
xtset company_id date1 


//global controls "roe volume returnsp500 spreadbidask companymarketcap totalvolumeetf"
global controls "roe returnsp500 spreadbidask companymarketcap totalvolumeetf"


save data_clean,replace

winsor2 pe roe growthtotalnav, suffix(_f) cuts(1 95)

// Analysis of cluster k-means
bysort companyname: egen average_pe_f = mean(pe_f)
bysort companyname: egen average_roe_f = mean(roe_f)
bysort companyname: egen average_companymarketcap = mean(companymarketcap)

cluster k pe_f roe_f companymarketcap , k(7) name(clust) s(kr(385617)) mea(abs) keepcen
cluster list clust
table clust

//descriptive stat
//collapse(mean) pe_f growthtotalnav_f,by(date1)
//sort date1
//gen pef = log(pe_f)
//twoway(scatter growthtotalnav_f pef)
sort date1
by date1: gen yearid = _n
gen log_pef = log(pe_f)
sort company_id date1
by company_id: gen growth_pef = log_pef - log_pef[_n-1]
preserve // preserve from collapse
// interessant pour voir les entreprises avec les plus haut PE
collapse(mean) pe_f growthtotalnav_f,by(company_id companyname)
scatter pe_f growthtotalnav_f,mlabel(companyname)||lfit pe_f growthtotalnav_f,mlabel(companyname)
sort pe_f
gen axis = _n
graph bar pe_f in 220/225, over(companyname) 
restore
preserve
collapse(mean) pe_f pe,by(date1)
//drop if date1 == 2006-01-04
twoway(lfit pe_f date1,mlabel(date1))
restore

preserve
collapse(mean) pe_f roe_f companymarketcap,by(clust)
//drop if date1 == 2006-01-04
graph matrix pe_f roe_f companymarketcap,mlabel(clust)
twoway(scatter pe_f roe_f,mlabel(clust))
restore

global controls_w "roe_f log_volume returnsp500 spreadbidask log_companymarketcap log_totalvolumeetf"
global controls_w "roe_f returnsp500 spreadbidask log_companymarketcap log_totalvolumeetf"

hist growthtotalnav
hist roe_f
summarize pe growthtotalnav $controls, detail

corr pe growthtotalnav $controls

kdensity spreadbidask
collin pe growthtotalnav $controls //ok for collinearity

extremes pe growthtotalnav $controls 

drop if company_id == 157

twoway histogram pe, bin(10) freq 
//test regression

//do regression for each company -> usefull for som ebig company like FB or NFLX
xi: regress pe growthtotalnav i.company_id 

// without control
xtreg pe interacNAV_SP 

xtivreg pe_f (growthtotalnav = issp500) $controls_w, fe
xtivreg log_pef (growthtotalnav = issp500) $controls_w, fe
ivreg pe_f (growthtotalnav = issp500) $controls_w, robust
// with control
xtreg pe_f interacNAV_SP $controls

//Fixed-effect regression
xtreg pe interacNAV_SP $controls, fe

xtreg pe_f c.growthtotalnav##issp500 $controls_w, fe
xtreg growth_pef c.growthtotalnav##issp500 $controls_w, fe
keep if issp500 == 1
xtreg pe_f interacNAV_SP $controls_w, fe
estimates store fixed

//Random-effect regression
xtreg pe interacNAV_SP $controls, re // constant change
xtreg pe_f interacNAV_SP $controls_w, re
xtreg log_pef interacNAV_SP $controls_w, re
hausman fixed ., sigmamore


// no stat significant
xtreg pe interacNAV_SP $controls, fe vce(cluster company_id)
xtreg pe_f interacNAV_SP $controls_w, fe vce(cluster company_id)
xtreg pe_f interacNAV_SP $controls_w, re vce(cluster company_id)
xtreg growth_pef interacNAV_SP $controls_w, re vce(cluster company_id)


