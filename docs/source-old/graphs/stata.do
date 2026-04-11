*ssc install schemepack, replace
sysuse auto, clear
local wcprimary "78 42 132"

twoway 	(scatter mpg weight, mcolor("`wcprimary'")), ///
		scheme(gg_tableau)
		
graph export "plot-stata.pdf", replace