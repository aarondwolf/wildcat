* ==============================================================================
* examples.do
* Comprehensive Demonstration Suite for Wildcat Stata Scheme (scheme-wildcat)
* Generates 16 synchronized, diverse chart types matching R and Python themes
* ==============================================================================

version 16.0
set more off

* Resolve working directory so data/ and output_checks/ are found
cap which wildcat
if _rc != 0 {
    di as err "Wildcat scheme not found. Please run ssc install wildcat"
    error 198
}

* Ensure output and data directories exist
capture mkdir "output_checks"
capture mkdir "data"

* 1. Initialize scheme
set scheme wildcat

* Load auto benchmark dataset and save local copy
sysuse auto, clear
capture save "data/auto.dta", replace

* ------------------------------------------------------------------------------
* Plot 1: Scatter plot with linear fit and 95% confidence ribbon
* ------------------------------------------------------------------------------
twoway (lfitci mpg weight) ///
       (scatter mpg weight, pstyle(p1)), ///
       title("{bf:Automobile Weight vs. Fuel Efficiency}") ///
       subtitle("Linear fit with 95% confidence ribbon") ///
       xtitle("Vehicle Weight (lbs.)") ///
       ytitle("Mileage (mpg)") ///
       legend(order(2 "Linear Fit" 1 "95% CI" 3 "Automobiles") rows(1)) ///
       note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_scatter.png", as(png) width(2400) height(1500) replace

* ------------------------------------------------------------------------------
* Plot 2: Horizontal bar chart across repair categories
* Uses scheme-level bar_gap and bar_groupgap (no manual gap overrides in do-file)
* ------------------------------------------------------------------------------
preserve
drop if missing(rep78)
graph hbar (mean) mpg, over(rep78) asyvars ///
      title("{bf:Average Fuel Efficiency by Repair Record}") ///
      subtitle("Mean miles per gallon across 1978 repair ratings") ///
      ytitle("Mean Mileage (mpg)") ///
      legend(order(1 "Poor (1)" 2 "Fair (2)" 3 "Average (3)" 4 "Good (4)" 5 "Excellent (5)") rows(1)) ///
      note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_bar.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 3: Multi-panel faceted plot (by origin)
* Uses scheme bygraphstyle-nu for transparent headers and medlarge charcoal titles
* ------------------------------------------------------------------------------
twoway (scatter mpg weight if foreign == 0, pstyle(p1)) ///
       (scatter mpg weight if foreign == 1, pstyle(p2)), ///
       by(foreign, title("{bf:Mileage vs. Weight by Vehicle Origin}") ///
                   subtitle("Comparison of Domestic vs. Foreign automobiles") ///
                   note("Source: 1978 Automobile Data") ///
                   legend(off)) ///
       xtitle("Vehicle Weight (lbs.)") ///
       ytitle("Mileage (mpg)")

*graph export "output_checks/stata_facet.png", as(png) width(2400) height(1500) replace

* ------------------------------------------------------------------------------
* Plot 4: Box plot across repair records
* Uses scheme-level box_gap (75pct) to match R geom_boxplot width (0.55)
* ------------------------------------------------------------------------------
preserve
drop if missing(rep78)
graph box mpg, over(rep78) asyvars ///
      title("{bf:Fuel Efficiency Distribution by Repair Record}") ///
      subtitle("Distribution of miles per gallon across 1978 repair ratings") ///
      ytitle("Mileage (mpg)") ///
      legend(order(1 "Poor (1)" 2 "Fair (2)" 3 "Average (3)" 4 "Good (4)" 5 "Excellent (5)") rows(1)) ///
      note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_box.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 5: Multi-line time series plot (Industry Performance Trends)
* ------------------------------------------------------------------------------
preserve
clear
set obs 13
gen int year = 2009 + _n
gen double tech   = round(100 * exp(0.088 * (_n - 1)) + 1.8 * sin(_n * 0.9), 0.1)
gen double health = round(100 * exp(0.055 * (_n - 1)) + 1.2 * cos(_n * 0.9), 0.1)
gen double energy = round(100 * exp(0.032 * (_n - 1)) + 2.5 * sin(_n * 1.5), 0.1)
label var tech "Technology"
label var health "Healthcare"
label var energy "Energy"
save "data/trends.dta", replace

twoway (line tech year, pstyle(p1)) ///
       (line health year, pstyle(p2)) ///
       (line energy year, pstyle(p3)), ///
       title("{bf:Industry Performance Trends (2010-2022)}") ///
       subtitle("Normalized cumulative sector growth index (Base = 100)") ///
       xtitle("Year") ///
       ytitle("Index Value (2010 = 100)") ///
       legend(order(1 "Technology" 2 "Healthcare" 3 "Energy") rows(1)) ///
       note("Source: Simulated Market Index Data")

*graph export "output_checks/stata_line.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 6: Kernel density distribution plot (Upper curve line layered on area)
* ------------------------------------------------------------------------------
twoway (kdensity mpg if foreign == 0, recast(area) color(nupurple%25) lwidth(none)) ///
       (kdensity mpg if foreign == 0, lcolor(nupurple) lwidth(medthick)) ///
       (kdensity mpg if foreign == 1, recast(area) color(nudarkorange%25) lwidth(none)) ///
       (kdensity mpg if foreign == 1, lcolor(nudarkorange) lwidth(medthick)), ///
       title("{bf:Fuel Efficiency Density by Origin}") ///
       subtitle("Kernel density estimates for domestic vs. foreign automobiles") ///
       xtitle("Mileage (mpg)") ///
       ytitle("Density") ///
       legend(order(1 "Domestic" 3 "Foreign") rows(1)) ///
       note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_density.png", as(png) width(2400) height(1500) replace

* ------------------------------------------------------------------------------
* Plot 7: Cleveland Dot Plot (graph dot)
* Tests dot styling, subtle gray leader dots, and clean borderless axis
* ------------------------------------------------------------------------------
preserve
drop if missing(rep78)
graph dot (mean) mpg, over(rep78) asyvars ///
      title("{bf:Mean Fuel Efficiency by Repair Record}") ///
      subtitle("Cleveland dot plot across repair ratings") ///
      ytitle("Miles per Gallon (mpg)") ///
      legend(order(1 "Poor (1)" 2 "Fair (2)" 3 "Average (3)" 4 "Good (4)" 5 "Excellent (5)") rows(1)) ///
      note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_dot.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 8: Lollipop / Stem Plot (twoway dropline)
* Tests vertical stem lines, baseline drop to zero, and solid circular heads
* ------------------------------------------------------------------------------
preserve
drop if missing(rep78)
collapse (mean) mpg, by(rep78)
summarize mpg
gen double diff = round(mpg - r(mean), 0.1)
save "data/lollipop.dta", replace

twoway (dropline diff rep78, msymbol(circle) pstyle(p1)), ///
       yline(0, lcolor(wc_axis) lpattern(dash) lwidth(thin)) ///
       title("{bf:Mileage Deviation by Repair Rating}") ///
       subtitle("Difference from overall mean repair rating efficiency") ///
       xtitle("Repair Record (1-5)") ///
       ytitle("Deviation from Mean (mpg)") ///
       xlabel(1(1)5) ///
       note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_lollipop.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 9: Coefficient / Forest Plot (twoway rcap + scatter)
* Tests horizontal error bar caps, linewidths, and dashed null zero line
* ------------------------------------------------------------------------------
preserve
clear
set obs 4
gen int id = _n
gen str24 parm = ""
replace parm = "Weight (lbs)" in 1
replace parm = "Displacement" in 2
replace parm = "Gear Ratio" in 3
replace parm = "Foreign Origin" in 4
gen double b = -0.005 in 1
replace b = -0.012 in 2
replace b = 1.450 in 3
replace b = 2.130 in 4
gen double min95 = b - 0.002 in 1
replace min95 = b - 0.006 in 2
replace min95 = b - 0.550 in 3
replace min95 = b - 0.720 in 4
gen double max95 = b + 0.002 in 1
replace max95 = b + 0.006 in 2
replace max95 = b + 0.550 in 3
replace max95 = b + 0.720 in 4
save "data/forest.dta", replace

twoway (rcap min95 max95 id, horizontal lcolor(nupurple) lwidth(medthick)) ///
       (scatter id b, pstyle(p1)), ///
       xline(0, lcolor(wc_axis) lpattern(dash) lwidth(thin)) ///
       ylabel(1 "Weight (lbs)" 2 "Displacement" 3 "Gear Ratio" 4 "Foreign Origin") ///
       title("{bf:Regression Coefficient Estimates (95% CI)}") ///
       subtitle("Marginal effects on vehicle fuel efficiency") ///
       xtitle("Estimated Coefficient") ///
       ytitle("Model Parameter") ///
       legend(off) ///
       note("Source: OLS Specification Estimates")

*graph export "output_checks/stata_forest.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 10: Dumbbell / Paired Comparison Plot (twoway rspike + dual scatter)
* Tests horizontal paired connector bar and two-color series endpoints
* ------------------------------------------------------------------------------
preserve
clear
set obs 5
gen int id = _n
gen str15 cat = ""
replace cat = "Compact" in 1
replace cat = "Midsize" in 2
replace cat = "Full-size" in 3
replace cat = "SUV" in 4
replace cat = "Truck" in 5
gen double pre = 18.2 + _n * 2.1
gen double post = pre + 4.8
save "data/dumbbell.dta", replace

twoway (rspike pre post id, horizontal lcolor(wc_axis) lwidth(medthick)) ///
       (scatter id pre, pstyle(p1)) ///
       (scatter id post, pstyle(p2)), ///
       ylabel(1 "Compact" 2 "Midsize" 3 "Full-size" 4 "SUV" 5 "Truck") ///
       title("{bf:Fleet Upgrades: Baseline vs. Optimized}") ///
       subtitle("Fuel efficiency improvements across vehicle segments") ///
       xtitle("Miles per Gallon (mpg)") ///
       ytitle("Vehicle Class") ///
       legend(order(2 "Baseline" 3 "Optimized") rows(1)) ///
       note("Source: Engineering Simulation Data")

*graph export "output_checks/stata_dumbbell.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 11: Histogram with Continuous Density Overlay
* Tests discrete bin fill opacity and continuous curve overlay
* ------------------------------------------------------------------------------
twoway (histogram price, bin(12) color(nupurple%35) lcolor(nupurple%80)) ///
       (kdensity price, lcolor(nudarkorange) lwidth(medthick)), ///
       title("{bf:Automobile Price Distribution}") ///
       subtitle("Histogram bins with overlaid continuous kernel density estimate") ///
       xtitle("Price (USD)") ///
       ytitle("Density") ///
       legend(order(1 "Histogram (12 Bins)" 2 "Kernel Density") rows(1)) ///
       note("Source: 1978 Automobile Data")

* graph export "output_checks/stata_histogram.png", as(png) width(2400) height(1500) replace

* ------------------------------------------------------------------------------
* Plot 12: Bubble Chart with Weighted Markers ([w=...])
* Tests varying marker radius proportional to weight with transparency
* ------------------------------------------------------------------------------
twoway (scatter mpg weight [w=trunk] if foreign==0, msymbol(circle) mfcolor(nupurple%40) mlcolor(nupurple)) ///
       (scatter mpg weight [w=trunk] if foreign==1, msymbol(circle) mfcolor(nudarkorange%40) mlcolor(nudarkorange)), ///
       title("{bf:Vehicle Weight, Mileage, and Trunk Capacity}") ///
       subtitle("Weighted scatter with bubble area proportional to trunk volume (cu. ft.)") ///
       xtitle("Vehicle Weight (lbs.)") ///
       ytitle("Mileage (mpg)") ///
       legend(order(1 "Domestic" 2 "Foreign") rows(1)) ///
       note("Source: 1978 Automobile Data")

* graph export "output_checks/stata_bubble.png", as(png) width(2400) height(1500) replace

* ------------------------------------------------------------------------------
* Plot 13: Empirical Cumulative Distribution Function (ECDF)
* Tests step-like cumulative distribution function curves across two series
* ------------------------------------------------------------------------------
preserve
cumul mpg if foreign==0, gen(cdf_dom)
cumul mpg if foreign==1, gen(cdf_for)
twoway (line cdf_dom mpg if foreign==0, sort pstyle(p1)) ///
       (line cdf_for mpg if foreign==1, sort pstyle(p2)), ///
       title("{bf:Empirical Cumulative Distribution of Mileage}") ///
       subtitle("Cumulative probability comparison between domestic and foreign vehicles") ///
       xtitle("Mileage (mpg)") ///
       ytitle("Cumulative Probability (F(x))") ///
       ylabel(0(0.25)1) ///
       legend(order(1 "Domestic" 2 "Foreign") rows(1)) ///
       note("Source: 1978 Automobile Data")

*graph export "output_checks/stata_ecdf.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 14: Stacked Area Composition Chart
* Tests multi-series stacked area polygons with borderless boundaries
* ------------------------------------------------------------------------------
preserve
clear
set obs 10
gen int year = 2013 + _n
gen double s1 = 45 - _n * 1.5
gen double s2 = 30 + _n * 0.8
gen double s3 = 25 + _n * 0.7
gen double c1 = s1
gen double c2 = s1 + s2
gen double c3 = 100
save "data/area.dta", replace

twoway (area c3 year, color(nubrightblue%60) lwidth(none)) ///
       (area c2 year, color(nudarkorange%60) lwidth(none)) ///
       (area c1 year, color(nupurple%60) lwidth(none)), ///
       title("{bf:Energy Portfolio Composition (2014-2023)}") ///
       subtitle("Relative percentage share of energy production sources") ///
       xtitle("Year") ///
       ytitle("Share of Generation (%)") ///
       ylabel(0(20)100) ///
       legend(order(3 "Conventional" 2 "Solar & Wind" 1 "Hydroelectric") rows(1)) ///
       note("Source: Simulated Energy Grid Accounts")

*graph export "output_checks/stata_area.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 15: Uncertainty Fan Chart / Nested Confidence Bands (twoway rarea)
* Tests multi-tier confidence intervals (80% and 95%) around central forecast
* ------------------------------------------------------------------------------
preserve
clear
set obs 11
gen int year = 2020 + _n - 1
gen double t = _n - 1
gen double fc = 100 * exp(0.06 * t)
gen double lo80 = fc - 3.5 * sqrt(t)
gen double hi80 = fc + 3.5 * sqrt(t)
gen double lo95 = fc - 6.2 * sqrt(t)
gen double hi95 = fc + 6.2 * sqrt(t)
save "data/ribbon.dta", replace

twoway (rarea lo95 hi95 year, color(nupurple%15) lwidth(none)) ///
       (rarea lo80 hi80 year, color(nupurple%30) lwidth(none)) ///
       (line fc year, lcolor(nupurple) lwidth(medthick)), ///
       title("{bf:Economic Output Projection with Confidence Bands}") ///
       subtitle("Baseline forecast with nested 80% and 95% uncertainty intervals") ///
       xtitle("Forecast Horizon (Year)") ///
       ytitle("Index Value (2020 = 100)") ///
       legend(order(3 "Point Forecast" 2 "80% Interval" 1 "95% Interval") rows(1)) ///
       note("Source: Macroeconomic Forecasting Model")

*graph export "output_checks/stata_ribbon.png", as(png) width(2400) height(1500) replace
restore

* ------------------------------------------------------------------------------
* Plot 16: Bi-Directional / Tornado Bar Chart
* Tests positive and negative variances straddling a central zero line
* ------------------------------------------------------------------------------
preserve
clear
set obs 6
gen int id = _n
gen str15 metric = ""
replace metric = "Q1 Sales" in 1
replace metric = "Q2 Margin" in 2
replace metric = "Q3 Volume" in 3
replace metric = "Q4 Growth" in 4
replace metric = "FY EBITDA" in 5
replace metric = "FCF Yield" in 6
gen double pos = (10 + _n * 3.5) * (mod(_n, 2) == 1)
gen double neg = (-8 - _n * 2.8) * (mod(_n, 2) == 0)
save "data/pyramid.dta", replace

twoway (bar pos id, horizontal barwidth(0.58) pstyle(p1)) ///
       (bar neg id, horizontal barwidth(0.58) pstyle(p2)), ///
       yscale(reverse) ///
       xline(0, lcolor(wc_axis) lpattern(solid) lwidth(thin)) ///
       ylabel(1 "Q1 Sales" 2 "Q2 Margin" 3 "Q3 Volume" 4 "Q4 Growth" 5 "FY EBITDA" 6 "FCF Yield") ///
       title("{bf:Quarterly Performance Variances vs. Budget}") ///
       subtitle("Percentage variance across operational and financial metrics") ///
       xtitle("Variance from Budget (%)") ///
       ytitle("Performance Metric") ///
       legend(order(1 "Favorable (Surplus)" 2 "Unfavorable (Deficit)") rows(1)) ///
       note("Source: Financial Planning & Analysis Report")

*graph export "output_checks/stata_pyramid.png", as(png) width(2400) height(1500) replace
restore

di as res "All 16 Stata example plots exported successfully to /output_checks/."
