clear all

* Setting directory
cd "/Users/manuellopez/Documents/GitHub/ECI"

* Importing in wide format
import delimited eci-wide

* Data wrangling
reshape long eci_rank eci gini incpp, i(country_name) j(year)
export delimited eci-long, replace
recode gini (0=.)
recode inc (0=.)
gen leci = ln(eci)*1000
gen lincpp = ln(inc)*1000

export delimited eci-long, replace

* Kuznets curve GINI & GDPpp
reg gini c.lincpp##c.lincpp eci
margins,at (lincpp=(7000 (500) 11000))
marginsplot, noci xlabel(7000 (500) 11000)
graph save "gdp.gph", replace

* Kuznets curve GINI & ECI
reg gini c.leci##c.leci
margins,at (leci=(0 (1000) 10000))
marginsplot, noci xlabel(0 (1000) 10000)
graph save "eci.gph", replace

* Combine the two exported graphs side by side
graph combine "gdp.gph" "eci.gph", cols(2) xcommon title("Comparison of Kuznets curves") name(combined, replace)
