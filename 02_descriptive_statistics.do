*------------------------------------------------------------------------------*
*-----------------------------Andrew Sharma------------------------------------*
*--------------------------MSc Thesis - Do-File--------------------------------*
*------------------------------------------------------------------------------*

*==============================================================================*
*==========================DESCRIPTIVE STATISTICS==============================*
*==============================================================================*
*
*
* Date : March 2018
* Paper: MSc Thesis
*
* This file runs the main descriptive statistics for the dataset
* 	in addition to a subset of descriptive statistics.
*
* Output: \Tables\descriptive_stats.tex
*
* Variables: - Unique Person Identifier
*			 - Survey Year
*			 - Birth Year
*			 - Age
*			 - Sex
*			 - Leisure Time (Hobbies and other) - Weekday Hours
*			 - Working hours - Weekly
*			 - Working hours - Daily
*
*
*==============================================================================*
*==============================================================================*


*------------------------------------------------------------------------------*
*---------------------Verify Configuration File Execution----------------------*
*------------------------------------------------------------------------------*


if "${config}"!="1" do config


*------------------------------------------------------------------------------*
*-----------------Load sample data generated in 01_sample selection------------*
*------------------------------------------------------------------------------*


use "${tempDir}/final", clear


*------------------------------------------------------------------------------*
*---------------Generating and Exporting Descriptive Statistics Table----------*
*------------------------------------------------------------------------------*
*----------------------------Table 1 - Leisure Hours---------------------------*
*------------------------------------------------------------------------------*
*
*	FOR USE IN LaTeX, COMPILE A DOCUMENT CONTAINING:
*			
*			\documentclass[a4paper]{article}
*			\usepackage{booktabs}
*			\usepackage{dcolumn}
*			\usepackage{float}
*			\usepackage[skip=0.5\baselineskip]{caption}
*			\begin{document}
*			\setlength{\pdfpagewidth}{\paperwidth}
*			\setlength{\pdfpageheight}{\paperheight}
*			\pagestyle{empty}
*			\hoffset = -70pt
*			\captionsetup{justification=raggedright,singlelinecheck=false}
*
*	   		 	INSERT TABLE .TEX HERE
*
*			\end{document}
*
*
//Producing Descriptive Statistics//

local varlist leisure ///
			  wrkhrsday ///
			  syear ///
			  birthyr age sex ///


tabstat `varlist', s(mean sd min max) c(s) by(coh)


//Exporting Results to LaTeX//
estpost tabstat `varlist', s(mean sd min max n) c(s) by(coh)


esttab using "${texDir}/descriptive_stats.tex", ///
	cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max range") ///
	nonumber label title(Descriptive Statistics) ///
	replace booktabs


//Exporting Results to csv//
esttab using "${texDir}/descriptive_stats.csv", ///
	cells("mean(fmt(%9.2f)) sd(fmt(%9.2f)) min max") ///
	nonumber label title(Descriptive Statistics) ///
	replace

*------------------------------------------------------------------------------*
*---------------------------Generating Trend Table-----------------------------*
*------------------------------------------------------------------------------*


//Generating Trend Table (Sample Population)//
table ageint coh, row col

//Average Leisure per cohort//
table ageint coh, c(mean leisure) 



*______________________________________________________________________________*
*__________________Extensive Descriptive Statistics____________________________* 

//Average Leisure per cohort for male 
table ageint coh, c(mean leisure), if sex==1 

//Average Leisure per cohort for female 
table ageint coh, c(mean leisure), if sex==0

 
*bys sex: xtsum leisure age coh sex*


*------------------------------------------------------------------------------*
*------------------Figure 1 - Mean Leisure Time by Age & Cohort----------------*
*------------------------------------------------------------------------------*


//Generating mean values per age catgory and cohort//
gen leisure_mean=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum leisure if coh == `x' & ageint == `y' 
		replace leisure_mean = r(mean) if coh == `x' & ageint == `y'
	}
	}


//Figure 1 - Average Leisure Time (Age category & Cohort)//
graph twoway 	line leisure_mean age if coh==1900, lpattern(solid) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1910, lpattern(solid) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1920, lpattern(solid) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_mean age if coh==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line leisure_mean age if coh==1960, lpattern(solid) lcolor(gs8) 		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1970, lpattern(solid) lcolor(dkorange)	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1980, lpattern(solid) lcolor(dknavy)  	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ylabel(0(0.2)4.2, labsize(vsmall) angle(0) grid) 	 			///	
xlabel(20(10)90, labsize(vsmall) grid) xtitle("Age", size(vsmall)) ytitle("Leisure Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) legend(off)
graph export "${figDir}/Figure_1.png", replace


*------------------------------------------------------------------------------*
*-----------------------Figure 2 - Leisure Hours By Gender---------------------*
*------------------------------------------------------------------------------*


gen leisure_male=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum leisure if coh == `x' & ageint == `y' & sex == 1
		replace leisure_male = r(mean) if coh == `x' & ageint == `y' & sex == 1
	}
	}
	

gen leisure_female=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum leisure if coh == `x' & ageint == `y' & sex == 0
		replace leisure_female = r(mean) if coh == `x' & ageint == `y' & sex == 0
	}
	}
	

//Figure 2 - Average Leisure Time  -  Gender//
graph twoway 	line leisure_male age if coh==1900, lpattern(solid) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_male age if coh==1910, lpattern(solid) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_male age if coh==1920, lpattern(solid) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_male age if coh==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_male age if coh==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_male age if coh==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line leisure_male age if coh==1960, lpattern(solid) lcolor(gs8) 		lwidth (medthin) sort ///
			||  line leisure_male age if coh==1970, lpattern(solid) lcolor(dkorange)	lwidth (medthin) sort ///
			||  line leisure_male age if coh==1980, lpattern(solid) lcolor(dknavy)  	lwidth (medthin) sort ///
			||  line leisure_male age if coh==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_male age if coh==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
			||	line leisure_female age if coh==1900, lpattern(dash) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_female age if coh==1910, lpattern(dash) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_female age if coh==1920, lpattern(dash) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_female age if coh==1930, lpattern(dash) lcolor(blue)   	lwidth (medthin) sort ///
			||  line leisure_female age if coh==1940, lpattern(dash) lcolor(magenta)	lwidth (medthin) sort ///
			||  line leisure_female age if coh==1950, lpattern(dash) lcolor(cranberry) 	lwidth (medthin) sort ///
			||	line leisure_female age if coh==1960, lpattern(dash) lcolor(gs8) 		lwidth (medthin) sort ///
			||  line leisure_female age if coh==1970, lpattern(dash) lcolor(dkorange)	lwidth (medthin) sort ///
			||  line leisure_female age if coh==1980, lpattern(dash) lcolor(dknavy)  	lwidth (medthin) sort ///
			||  line leisure_female age if coh==1990, lpattern(dash) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_female age if coh==2000, lpattern(dash) lcolor(green)  	lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time By Gender", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ylabel(0(0.2)5, labsize(vsmall) angle(0) grid) 	 			///	
xlabel(20(10)90, labsize(vsmall) grid) xtitle("Age", size(vsmall)) ytitle("Leisure Hours (Weekday)", size(vsmall)) ///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(1 "Male") label(12 "Female") order(1 12)) ///
name("Figure_2", replace)
graph export "${figDir}/Figure_2.png", replace


*------------------------------------------------------------------------------*
*---------------------Figure 3 - Leisure Hrs vs Working Hrs--------------------*
*------------------------------------------------------------------------------*


gen wrkhrsday_mean=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum wrkhrsday if coh == `x' & ageint == `y' 
		replace wrkhrsday_mean = r(mean) if coh == `x' & ageint == `y'
	}
	}


//Figure 3 - Average Leisure Time & Working Hours//
graph twoway 	line leisure_mean age if coh==1900, lpattern(solid) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1910, lpattern(solid) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1920, lpattern(solid) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_mean age if coh==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line leisure_mean age if coh==1960, lpattern(solid) lcolor(gs8) 		lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1970, lpattern(solid) lcolor(dkorange)	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1980, lpattern(solid) lcolor(dknavy)  	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_mean age if coh==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
			||	line wrkhrsday_mean age if coh==1900, lpattern(dash) lcolor(black) 		lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1910, lpattern(dash) lcolor(red)   		lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1920, lpattern(dash) lcolor(green) 		lwidth (medthin) sort ///
			||	line wrkhrsday_mean age if coh==1930, lpattern(dash) lcolor(blue)   	lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1940, lpattern(dash) lcolor(magenta)	lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1950, lpattern(dash) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line wrkhrsday_mean age if coh==1960, lpattern(dash) lcolor(gs8) 		lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1970, lpattern(dash) lcolor(dkorange)	lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1980, lpattern(dash) lcolor(dknavy)  	lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==1990, lpattern(dash) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line wrkhrsday_mean age if coh==2000, lpattern(dash) lcolor(green)  	lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time and Working Hours", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) yaxis(2) ///
xlabel(20(10)90, labsize(vsmall) grid) ///
ylabel(0(0.5)7, labsize(vsmall) angle(0) grid)		///
ylabel(0(0.5)7, labsize(vsmall) angle(0) grid axis(2))	///
xtitle("Age", size(vsmall)) ///
ytitle("Leisure Hours (Weekday)", size(vsmall))	///
ytitle("Working Hours (Weekday)", size(vsmall) axis(2)) ///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(1 "Leisure Time") label(12 "Working Hours") order(1 12)) ///
name("Figure_3", replace)
graph export "${figDir}/Figure_3.png", replace


*------------------------------------------------------------------------------*
*---------------Figure 4 - Leisure Hrs vs Working Hrs by Gender----------------*
*------------------------------------------------------------------------------*


gen wrkhrsday_male=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum wrkhrsday if coh == `x' & ageint == `y' & sex == 1
		replace wrkhrsday_male = r(mean) if coh == `x' & ageint == `y' & sex == 1
	}
	}
	

gen wrkhrsday_female=.

quietly forvalues x = 1900(10)2000 {
	foreach y of numlist 17(3)20 20(10)100 {
		sum wrkhrsday if coh == `x' & ageint == `y' & sex == 0
		replace wrkhrsday_female = r(mean) if coh == `x' & ageint == `y' & sex == 0
	}
	}
	
	
//Figure 4 - Average Leisure Time & Working Hours by Gender//
graph twoway 	line leisure_male age if coh==1900, lpattern(solid) lcolor(black) 				lwidth (medium) sort ///
			||  line leisure_male age if coh==1910, lpattern(solid) lcolor(red)   				lwidth (medium) sort ///
			||  line leisure_male age if coh==1920, lpattern(solid) lcolor(green) 				lwidth (medium) sort ///
			||	line leisure_male age if coh==1930, lpattern(solid) lcolor(blue)   				lwidth (medium) sort ///
			||  line leisure_male age if coh==1940, lpattern(solid) lcolor(magenta)				lwidth (medium) sort ///
			||  line leisure_male age if coh==1950, lpattern(solid) lcolor(cranberry)			lwidth (medium) sort ///
			||	line leisure_male age if coh==1960, lpattern(solid) lcolor(gs8) 				lwidth (medium) sort ///
			||  line leisure_male age if coh==1970, lpattern(solid) lcolor(dkorange)			lwidth (medium) sort ///
			||  line leisure_male age if coh==1980, lpattern(solid) lcolor(dknavy)  			lwidth (medium) sort ///
			||  line leisure_male age if coh==1990, lpattern(solid) lcolor(ltblue)   			lwidth (medium) sort ///
			||  line leisure_male age if coh==2000, lpattern(solid) lcolor(green)  				lwidth (medium) sort ///
///
			||	line leisure_female age if coh==1900, lpattern(dash) lcolor(black) 				lwidth (medthick) sort ///
			||  line leisure_female age if coh==1910, lpattern(dash) lcolor(red)   				lwidth (medthick) sort ///
			||  line leisure_female age if coh==1920, lpattern(dash) lcolor(green) 				lwidth (medthick) sort ///
			||	line leisure_female age if coh==1930, lpattern(dash) lcolor(blue)   			lwidth (medthin) sort ///
			||  line leisure_female age if coh==1940, lpattern(dash) lcolor(magenta)			lwidth (medthin) sort ///
			||  line leisure_female age if coh==1950, lpattern(dash) lcolor(cranberry)			lwidth (medthin) sort ///
			||	line leisure_female age if coh==1960, lpattern(dash) lcolor(gs8) 				lwidth (medthin) sort ///
			||  line leisure_female age if coh==1970, lpattern(dash) lcolor(dkorange)			lwidth (medthin) sort ///
			||  line leisure_female age if coh==1980, lpattern(dash) lcolor(dknavy)  			lwidth (medthin) sort ///
			||  line leisure_female age if coh==1990, lpattern(dash) lcolor(ltblue)   			lwidth (medthin) sort ///
			||  line leisure_female age if coh==2000, lpattern(dash) lcolor(green)  			lwidth (medthin) sort ///
graphregion(color(white) fcolor(white) icolor(white)) ///
xlabel(17 20(10)100, labsize(vsmall) grid) ///
ylabel(0(0.5)5.5, labsize(vsmall) angle(0) grid)		///
xtitle("Age", size(vsmall)) ///
ytitle("Leisure Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(1 "Male Leisure Time (per Day)") label(12 "Female Leisure Time (per Day)") ///
order(1 12)) name("Figure_4_1", replace) nodraw


graph twoway	line wrkhrsday_male age if coh==1940, lpattern(solid) lcolor(magenta)			lwidth (medium) sort ///
			||  line wrkhrsday_male age if coh==1950, lpattern(solid) lcolor(cranberry)			lwidth (medium) sort ///
			||	line wrkhrsday_male age if coh==1960, lpattern(solid) lcolor(gs8) 				lwidth (medium) sort ///
			||  line wrkhrsday_male age if coh==1970, lpattern(solid) lcolor(dkorange)			lwidth (medium) sort ///
			||  line wrkhrsday_male age if coh==1980, lpattern(solid) lcolor(black)  			lwidth (medium) sort ///
			||  line wrkhrsday_male age if coh==1990, lpattern(solid) lcolor(ltblue)   			lwidth (medium) sort ///
			||  line wrkhrsday_male age if coh==2000, lpattern(solid) lcolor(green)  			lwidth (medium) sort ///
///
			||  line wrkhrsday_female age if coh==1940, lpattern(dash_dot) lcolor(magenta)		lwidth (medium) sort ///
			||  line wrkhrsday_female age if coh==1950, lpattern(dash_dot) lcolor(cranberry)	lwidth (medium) sort ///
			||	line wrkhrsday_female age if coh==1960, lpattern(dash_dot) lcolor(gs8) 			lwidth (medium) sort ///
			||  line wrkhrsday_female age if coh==1970, lpattern(dash_dot) lcolor(dkorange)		lwidth (medium) sort ///
			||  line wrkhrsday_female age if coh==1980, lpattern(dash_dot) lcolor(black)  		lwidth (medium) sort ///
			||  line wrkhrsday_female age if coh==1990, lpattern(dash_dot) lcolor(ltblue)   	lwidth (medium) sort ///
			||  line wrkhrsday_female age if coh==2000, lpattern(dash_dot) lcolor(green)  		lwidth (medium) sort ///
graphregion(color(white) fcolor(white) icolor(white)) ///
xlabel(17 20(5)100, labsize(vsmall) grid) ///
ylabel(0(0.5)8.5, labsize(vsmall) angle(0) grid)		///
xtitle("Age", size(vsmall)) ///
ytitle("Working Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(5 "Male Work Hours (per Day)") label(12 "Female Work Hours (per Day)") ///
order(5 12)) name("Figure_4_2", replace) nodraw


graph combine Figure_4_1 Figure_4_2, cols(1) scheme(sj) imargin(zero) ///
title("Age and Cohort Effects on Leisure Time & Working Hours, By Gender", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
altshrink name("Figure_4", replace)


graph export "${figDir}/Figure_4.png", replace


*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
