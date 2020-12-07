//ssc install winsor2

clear
cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/"
import delimited "Data/agregatedData_final.csv",stringcols(1) 

cd "/Users/guillaume/MyProjects/StataProjects/data_science/Project/stata"
drop v1
drop if instrument == "GOOG.OQ"
order date, first
//create id by company to create data panel
egen company_id = group(instrument)
encode date, gen(date1) 
gen log_volume = log(volume)
gen log_totalvolumeetf = log(totalvolumeetf)
gen log_companymarketcap = log(companymarketcap)
gen log_spreadbidAsk = log(spreadbidask)
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

winsor2 pe roe , suffix(_f) cuts(1 95)
save data_clean_w,replace
// generate data 
sort date1
by date1: gen yearid = _n
gen log_pef = log(pe_f)
sort company_id date1
by company_id: gen growth_pef = log_pef - log_pef[_n-1]
by company_id: gen growth_totalvolumeetf = log_totalvolumeetf - log_totalvolumeetf[_n-1]
by company_id: gen growth_spreadbidask = log_spreadbidAsk - log_spreadbidAsk[_n-1]


// Analysis of cluster k-means
bysort companyname: egen average_pe_f = mean(pe_f)
bysort companyname: egen average_roe_f = mean(roe_f)
bysort companyname: egen average_companymarketcap = mean(companymarketcap)

cluster k average_pe_f average_roe_f, k(7) name(clust_avg) s(kr(385617)) mea(abs) keepcen

cluster k pe_f roe_f , k(7) name(clust) s(kr(385617)) mea(abs) keepcen
cluster list clust

scatter average_pe_f average_roe_f
//descriptive stat
//collapse(mean) pe_f growthtotalnav_f,by(date1)
//sort date1
//gen pef = log(pe_f)
//twoway(scatter growthtotalnav_f pef)


preserve // preserve from collapse
// interessant pour voir les entreprises avec les plus haut PE
collapse(mean) pe_f growthtotalnav_f,by(company_id companyname)
scatter pe_f growthtotalnav_f,mlabel(companyname)||lfit pe_f growthtotalnav_f,mlabel(companyname)
sort pe_f
gen axis = _n
graph bar pe_f in 220/225, over(companyname) 
restore

preserve // preserve from collapse
// interessant pour voir les entreprises avec les plus haut PE
collapse(mean) pe_f roe_f,by(company_id companyname)
scatter pe_f roe_f,mlabel(companyname)||lfit pe_f roe_f,mlabel(companyname)
 
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

preserve
collapse(mean) average_pe_f average_roe_f average_companymarketcap,by(clust_avg)
//drop if date1 == 2006-01-04
graph matrix average_pe_f average_roe_f average_companymarketcap,mlabel(clust_avg)
twoway(scatter average_pe_f average_roe_f,mlabel(clust_avg))
restore

//global controls_w "roe_f log_volume returnsp500 spreadbidask log_companymarketcap log_totalvolumeetf"
//global controls_w "roe_f returnsp500 spreadbidask log_companymarketcap log_totalvolumeetf"
global controls_w "roe_f returnsp500 growth_spreadbidask growth_companymarketcap growth_totalvolumeetf"

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
xtreg growth_pef growthtotalnav##date1 $controls_w, fe
// regression without instrumental variable -> add clustering
eststo clear
eststo: xtreg growth_pef growthtotalnav
display e(r2)
estadd local fe "No"
estadd local controls "No"
eststo: xtreg growth_pef growthtotalnav $controls_w
display e(r2)
estadd local fe "No"
estadd local controls "Yes"
eststo: xtreg growth_pef growthtotalnav $controls_w, fe
display e(r2)
estadd local fe "Yes"
estadd local controls "Yes"
esttab using result_without_inst.tex, replace ar2 label title(Regression table without Instrumental Variable\label{tab1}) s(fe controls ar2 N, label("Fixed Effects"))
//Final regression

eststo clear
eststo:xtivreg2 growth_pef (growthtotalnav = issp500) $controls_w, fe
display e(F)
display e(r2_a)
vif, uncentered
estadd local fe "Yes"
estadd local clus "No"
estadd local Ftest e(F)
estadd local Ar2 e(r2_a)
eststo:xtivreg2 growth_pef (growthtotalnav = issp500) $controls_w, fe cluster(company_id)
display e(F)
display e(r2_a)
vif, uncentered
estadd local fe "Yes"
estadd local clus "Yes"
estadd local Ftest e(F)
estadd local Ar2 e(r2_a)
esttab using result_with_inst.tex,replace label title(Regression table with Intrumental Variable \label{tab1}) s(fe clus Ftest ar2 N, label("fixed effects Clustering"))

esttab using result.tex, label title(Regression table\label{tab1})
xtivreg growth_pef (growthtotalnav = issp500) $controls_w, re
xtivreg growth_pef (growthtotalnav = issp500) $controls_w, fe vce(cluster company_id)

ivreg growth_pef (growthtotalnav = issp500) $controls_w, robust

xi: xtivreg pe_f (growthtotalnav = issp500) $controls_w, robust

//plus de resultat
// à revoir ?? problème d'exogénéité
// voir pour enlever S&P 500
foreach value in $controls_w{
	xtreg issp500 `value', robust
}

eststo clear
eststo:xtivreg2 growthtotalnav issp500, fe
estadd local control "No" 
estadd local fe "Yes"
estadd local clus "No"
eststo:xtivreg2 growthtotalnav issp500 $controls_w, fe 
estadd local control "Yes" 
estadd local fe "Yes"
estadd local clus "No"
eststo:xtivreg2 growthtotalnav issp500 $controls_w, fe cluster(company_id)
estadd local control "Yes" 
estadd local fe "Yes"
estadd local clus "Yes"
esttab using relevant_inst.tex,replace ar2 label title(Regression table with Intrumental Variable \label{tab1}) s(control fe clus N, label("fixed effects Clustering"))


xtivreg2 growth_pef (growthtotalnav = issp500) $controls_w, fe cluster(company_id)
xtivreg2 growth_pef (growthtotalnav = issp500) $controls_w, fe cluster(date)
xtivreg2 growth_pef (growthtotalnav = issp500) $controls_w, fd cluster(company_id)


xtivreg pe_f (growthtotalnav = issp500) $controls_w, fe vce(cluster date1)
xi: xtivreg pe_f (growthtotalnav = issp500) $controls_w, re
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
xi: xtreg growth_pef interacNAV_SP $controls_w, fe
hausman fixed ., sigmamore
xtreg growth_pef interacNAV_SP $controls_w, re


// no stat significant
xtreg pe interacNAV_SP $controls, fe vce(cluster company_id)
xtreg pe_f interacNAV_SP $controls_w, fe vce(cluster company_id)
xtreg pe_f interacNAV_SP $controls_w, re vce(cluster company_id)
xtreg growth_pef interacNAV_SP $controls_w, re vce(cluster company_id)


