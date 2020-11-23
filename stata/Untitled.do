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


xtset company_id date1 

//test regression

//do regression for each company -> usefull for som ebig company like FB or NFLX
xi: regress pe growthtotalnav i.company_id 

xtreg pe roe volume growthtotalnav
xtreg pe roe volume growthtotalnav, fe
xtreg pe roe volume growthtotalnav, re
