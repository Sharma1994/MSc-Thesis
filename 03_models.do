*------------------------------------------------------------------------------*
*-----------------------------Andrew Sharma------------------------------------*
*--------------------------MSc Thesis - Do-File--------------------------------*
*------------------------------------------------------------------------------*

*==============================================================================*
*==========================INFERENTIAL STATISTICS==============================*
*==============================================================================*
*
*
* Date : March 2018
* Paper: MSc Thesis
*
* This file estimates fixed effects models of the cleaned data
*
* Output: \Tables\models.tex
*
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
*----------------------Declare data to be Panel Data---------------------------*
*------------------------------------------------------------------------------*


xtset pid syear
set more off


*------------------------------------------------------------------------------*
*------------------------------Models 1 & 2------------------------------------*
*------------------------------------------------------------------------------*
*------------------------Random Effects GLS Model------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*-------------------------------Leisure Time-----------------------------------*
*------------------------------------------------------------------------------*


//Model 1: Leisure = Base Model (age^3, birth year)
eststo E1: xtreg leisure c.age##c.age##c.age c.birthyr, re


//Model 1: Predicted Values//
capt drop leisure_pred_01
predict leisure_pred_01 if e(sample)


//Model 1: Visualising Predicted Values//
graph twoway 	line leisure_pred_01 age if birthyr==1900, lpattern(solid) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1910, lpattern(solid) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1920, lpattern(solid) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_pred_01 age if birthyr==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line leisure_pred_01 age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1980, lpattern(solid) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ///
ylabel(0(0.2)3.6, labsize(vsmall) angle(0) grid) 	 			///	
xlabel(17 20(10)100, labsize(vsmall) grid) ///
xtitle("Age", size(vsmall)) ///
ytitle("Leisure Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) legend(off)

graph export "${figDir}/Figure_7.png", replace


*------------------------------------------------------------------------------*


//Model 2: Leisure = Model 1 + Gender + Employment Status//
eststo E1m: xtreg leisure c.age##c.age##c.age c.birthyr if sex==1, re


//Model 2: Predicted Values//
capt drop leisure_pred_male
predict leisure_pred_male if e(sample)

eststo E1f: xtreg leisure c.age##c.age##c.age c.birthyr if sex==0, re
capt drop leisure_pred_female
predict leisure_pred_female if e(sample)


//Model 2: Visualising Predicted Values//
graph twoway 	line leisure_pred_male age if birthyr==1900, lpattern(solid) lcolor(black) 			lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1910, lpattern(solid) lcolor(red)   			lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1920, lpattern(solid) lcolor(green) 			lwidth (medthin) sort ///
			||	line leisure_pred_male age if birthyr==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1950, lpattern(solid) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line leisure_pred_male age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1980, lpattern(solid) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==1990, lpattern(solid) lcolor(ltblue)   		lwidth (medthin) sort ///
			||  line leisure_pred_male age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
			||	line leisure_pred_female age if birthyr==1900, lpattern(dash) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1910, lpattern(dash) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1920, lpattern(dash) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_pred_female age if birthyr==1930, lpattern(dash) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1940, lpattern(dash) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1950, lpattern(dash) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line leisure_pred_female age if birthyr==1960, lpattern(dash) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1970, lpattern(dash) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1980, lpattern(dash) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==1990, lpattern(dash) lcolor(ltblue)   		lwidth (medthin) sort ///
			||  line leisure_pred_female age if birthyr==2000, lpattern(dash) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time By Gender", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ///
ylabel(0(0.2)3.6, labsize(vsmall) angle(0) grid) 	 ///	
xlabel(17 20(10)100, labsize(vsmall) grid) ///
xtitle("Age", size(vsmall)) ///
ytitle("Leisure Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(1 "Male") label(12 "Female") order(1 12))

graph export "${figDir}/Figure_8.png", replace


*------------------------------------------------------------------------------*
*------------------------------Models 3 & 4------------------------------------*
*------------------------------------------------------------------------------*
*------------------------Random Effects GLS Model------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*-------------------------------Work Hours-------------------------------------*
*------------------------------------------------------------------------------*


//Model 3: Work Hours = Base Model (age^2, birth year)//
eststo E3: xtreg wrkhrsday c.age##c.age c.birthyr, re


//Model 3: Predicted Values//
capt drop workhrs_pred_03
predict workhrs_pred_03 if e(sample)


//Model 3: Visualising Predicted Values//
graph twoway    line workhrs_pred_03 age if birthyr==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line workhrs_pred_03 age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1980, lpattern(solid) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Working Hours", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ///
ylabel(0(0.5)6.5, labsize(vsmall) angle(0) grid) 	 			///	
xlabel(17 20(10)80, labsize(vsmall) grid) ///
xtitle("Age", size(vsmall)) ///
ytitle("Work Hours (Weekday)", size(vsmall))	///
plotregion(color(white) fcolor(white) icolor(white)) legend(off)

graph export "${figDir}/Figure_9.png", replace


*------------------------------------------------------------------------------*


//Model 4: Work Hours//
eststo E4m: xtreg wrkhrsday c.age##c.age c.birthyr if birthyr>=1930 & sex==1, re


//Model 4: Predicted Values//
capt drop workhrs_pred_male
predict workhrs_pred_male if e(sample)

//Females//
eststo E4f: xtreg wrkhrsday c.age##c.age c.birthyr if birthyr>=1930 & sex==0, re

capt drop workhrs_pred_female
predict workhrs_pred_female if e(sample)


//Model 4: Visualising Predicted Values//
graph twoway    line workhrs_pred_male age if birthyr==1950, lpattern(solid) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line workhrs_pred_male age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1980, lpattern(solid) lcolor(black)  		lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1990, lpattern(solid) lcolor(ltblue)   		lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1950, lpattern(dash) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line workhrs_pred_female age if birthyr==1960, lpattern(dash) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1970, lpattern(dash) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1980, lpattern(dash) lcolor(black)  		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1990, lpattern(dash) lcolor(ltblue)   		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==2000, lpattern(dash) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Working Hours", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) ///
ylabel(0(0.5)9, labsize(vsmall) angle(0) grid) 	 			///
xlabel(17 20(5)70, labsize(vsmall) grid) ///
xtitle("Age", size(vsmall)) ///
ytitle("Work Hours (Weekday)", size(vsmall))	///
yscale(r(0 9)) ///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(4 "Male") label(11 "Female") order(4 11))

graph export "${figDir}/Figure_10.png", replace


*------------------------------------------------------------------------------*
*--------------------------Additional Graphics---------------------------------*
*------------------------------------------------------------------------------*

*-------------------------Leisure & Work Hours---------------------------------*
*------------------------------------------------------------------------------*

//Visualising Predicted Values//
graph twoway	line leisure_pred_01 age if birthyr==1900, lpattern(solid) lcolor(black) 		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1910, lpattern(solid) lcolor(red)   		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1920, lpattern(solid) lcolor(green) 		lwidth (medthin) sort ///
			||	line leisure_pred_01 age if birthyr==1930, lpattern(solid) lcolor(blue)   		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1940, lpattern(solid) lcolor(magenta)		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1950, lpattern(solid) lcolor(cranberry)	lwidth (medthin) sort ///
			||	line leisure_pred_01 age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1980, lpattern(solid) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==1990, lpattern(solid) lcolor(ltblue)   	lwidth (medthin) sort ///
			||  line leisure_pred_01 age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1940, lpattern(dash) lcolor(magenta)		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1950, lpattern(dash) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line workhrs_pred_03 age if birthyr==1960, lpattern(dash) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1970, lpattern(dash) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1980, lpattern(dash) lcolor(dknavy)  		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==1990, lpattern(dash) lcolor(black)   		lwidth (medthin) sort ///
			||  line workhrs_pred_03 age if birthyr==2000, lpattern(dash) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time & Working Hours", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) 								///
note("Source: SOEP V.33, release 2017", size(vsmall))											///
graphregion(color(white) fcolor(white) icolor(white)) yaxis(1 2) 				///
ylabel(0(0.5)6.5, labsize(vsmall) angle(0) grid axis(1))						///
ylabel(0(0.5)6.5, labsize(vsmall) angle(0) grid axis(2)) 						///	
xlabel(17 20(10)100, labsize(vsmall) grid) 										///
xtitle("Age", size(vsmall)) 													///
ytitle("Leisure Hours (Weekday)", size(vsmall) axis(1))							///
ytitle("Work Hours (Weekday)", size(vsmall) axis(2))							///
legend(label(1 "Leisure Time") label(17 "Working Hours") order(1 17))			///
plotregion(color(white) fcolor(white) icolor(white))							///
name("Figure_11", replace)

graph export "${figDir}/Figure_11.png", replace


*------------------------------------------------------------------------------*
*---------------------Leisure & Work Hours By Gender---------------------------*
*------------------------------------------------------------------------------*


//Visualising Predicted Values//
graph twoway 	line leisure_pred_male age if birthyr==1900, lpattern(solid) lcolor(black) 			lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1910, lpattern(solid) lcolor(red)   			lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1920, lpattern(solid) lcolor(green) 			lwidth (thin) sort ///
			||	line leisure_pred_male age if birthyr==1930, lpattern(solid) lcolor(blue)   		lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1940, lpattern(solid) lcolor(magenta)		lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1950, lpattern(solid) lcolor(cranberry)		lwidth (thin) sort ///
			||	line leisure_pred_male age if birthyr==1960, lpattern(solid) lcolor(gs8) 			lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1970, lpattern(solid) lcolor(dkorange)		lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1980, lpattern(solid) lcolor(dknavy)  		lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==1990, lpattern(solid) lcolor(ltblue)   		lwidth (thin) sort ///
			||  line leisure_pred_male age if birthyr==2000, lpattern(solid) lcolor(green)  		lwidth (thin) sort ///
///
			||	line leisure_pred_female age if birthyr==1900, lpattern(dash) lcolor(black) 			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1910, lpattern(dash) lcolor(red)   			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1920, lpattern(dash) lcolor(green) 			lwidth (thin) sort ///
			||	line leisure_pred_female age if birthyr==1930, lpattern(dash) lcolor(blue)   			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1940, lpattern(dash) lcolor(magenta)			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1950, lpattern(dash) lcolor(cranberry)			lwidth (thin) sort ///
			||	line leisure_pred_female age if birthyr==1960, lpattern(dash) lcolor(gs8) 				lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1970, lpattern(dash) lcolor(dkorange)			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1980, lpattern(dash) lcolor(dknavy)  			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==1990, lpattern(dash) lcolor(ltblue)   			lwidth (thin) sort ///
			||  line leisure_pred_female age if birthyr==2000, lpattern(dash) lcolor(green)  			lwidth (thin) sort ///
///
			||  line workhrs_pred_male age if birthyr==1950, lpattern(shortdash) lcolor(cranberry)			lwidth (medthin) sort ///
			||	line workhrs_pred_male age if birthyr==1960, lpattern(shortdash) lcolor(gs8) 				lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1970, lpattern(shortdash) lcolor(dkorange)			lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1980, lpattern(shortdash) lcolor(black)  			lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==1990, lpattern(shortdash) lcolor(ltblue)  		 	lwidth (medthin) sort ///
			||  line workhrs_pred_male age if birthyr==2000, lpattern(shortdash) lcolor(green)  			lwidth (medthin) sort ///
///			
			||  line workhrs_pred_female age if birthyr==1950, lpattern(longdash) lcolor(cranberry)		lwidth (medthin) sort ///
			||	line workhrs_pred_female age if birthyr==1960, lpattern(longdash) lcolor(gs8) 			lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1970, lpattern(longdash) lcolor(dkorange)		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1980, lpattern(longdash) lcolor(black)  		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==1990, lpattern(longdash) lcolor(ltblue)   		lwidth (medthin) sort ///
			||  line workhrs_pred_female age if birthyr==2000, lpattern(longdash) lcolor(green)  		lwidth (medthin) sort ///
title("Age and Cohort Effects on Leisure Time and Working Hours by Gender", size(small))	///
subtitle("West Germany 1984-2016", size(vsmall)) ///
note("Source: SOEP V.33, release 2017", size(vsmall)) ///
graphregion(color(white) fcolor(white) icolor(white)) yaxis(1 2) ///
xlabel(17 20(10)100, labsize(vsmall) grid) ///
ylabel(0(0.5)9, labsize(vsmall) angle(0) grid axis(1))		///
ylabel(0(0.5)9, labsize(vsmall) angle(0) grid axis(2))	///
xtitle("Age", size(vsmall)) ///
ytitle("Leisure Hours (Weekday)", size(vsmall) axis(1))	///
ytitle("Work Hours (Weekday)", size(vsmall) axis(2)) ///
plotregion(color(white) fcolor(white) icolor(white)) ///
legend(label(1 "Male Leisure Time (per Day)") label(12 "Female Leisure Time (per Day)") ///
label(26 "Male Work Hours (per Day)") label(32 "Female Work Hours (per Day)") ///
order(1 12 26 32) size(vsmall)) name("Figure_12", replace)

graph export "${figDir}/Figure_12.png", replace


*------------------------------------------------------------------------------*
*-----------------Generating & Exporting Model Comparison Table----------------*
*------------------------------------------------------------------------------*
*
*	FOR USE IN LaTeX, COMPILE A DOCUMENT CONTAINING:
*			\documentclass[a4paper,10pt]{article}
*			\usepackage{booktabs}
*			\usepackage{dcolumn}
*			\usepackage{caption}
*			\usepackage{amsmath}
*			\setlength{\pdfpagewidth}{\paperwidth}
*			\setlength{\pdfpageheight}{\paperheight}
*			\begin{document}
*			\pagestyle{empty}
*			\hoffset = 0pt
*			\captionsetup{justification=raggedright,singlelinecheck=false}
*	   		 INSERT TABLE .TEX HERE
*			\end{document}


quietly eststo M1: xtreg leisure c.age##c.age##c.age i.coh if sex==0, re
quietly eststo M2: xtreg leisure c.age##c.age##c.age i.coh if sex==1, re

estout M1 M2, cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* 0.05 ** 0.01 *** 0.001)				 ///
	stats(r2_o N, fmt(3 0) label(R-Squared N)) 					 ///
	mlabels("Female" "Male") 	 ///
	note("Source: SOEP V.33, release 2017: Standard errors in parentheses") ///
	nobaselevels
	
esttab M1 M2 using "${texDir}/models1.tex", 		 ///
	b(3) se(3) not starlevels(* 0.5 ** 0.01 *** 0.001) 	 ///
	stats(r2_o N, fmt(3 0) label(R-Squared N)) 					 ///
	nogaps nodepvars nonumbers compress booktabs 		 ///
	label title(Leisure Model) 						 ///
	mlabels("Female" "Male") 	 ///
	note("Source: SOEP V.33, release 2017: Standard errors in parentheses") ///
	nobaselevels replace
	
quietly eststo M3: xtreg wrkhrsday c.age##c.age i.coh if sex==0, re
quietly eststo M4: xtreg wrkhrsday c.age##c.age i.coh if sex==1, re

estout M3 M4, cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* 0.05 ** 0.01 *** 0.001)				 ///
	stats(r2_o N, fmt(3 0) label(R-Squared N)) 					 ///
	mlabels("Female" "Male") 	 ///
	note("Source: SOEP V.33, release 2017: Standard errors in parentheses") ///
	nobaselevels
	
esttab M3 M4 using "${texDir}/models2.tex", 		 ///
	b(3) se(3) not starlevels(* 0.5 ** 0.01 *** 0.001) 	 ///
	stats(r2_o N, fmt(3 0) label(R-Squared N)) 					 ///
	nogaps nodepvars nonumbers compress booktabs 		 ///
	label title(Working Hours Model) 						 ///
	mlabels("Female" "Male") 	 ///
	note("Source: SOEP V.33, release 2017: Standard errors in parentheses") ///
	nobaselevels replace
	
*------------------------------------------------------------------------------*
*--------------------------Post-Estimation Tests-------------------------------*
*------------------------------------------------------------------------------*


//Hausman Test for Fixed Effects vs Random Effects//
quietly xtreg leisure c.age##c.age##c.age i.sex i.coh, fe
est store fixed
quietly xtreg leisure c.age##c.age##c.age i.sex i.coh, re
est store random
hausman fixed random


//Breusch-Pagan LM test for random effects versus OLS//
quietly xtreg leisure c.age##c.age##c.age i.sex i.coh, re
xttest0 			// Prob > chibar2 =   0.0000
					// Reject null hypothesis - heteroskedasticity


//Recovering Individual-Specific Effects//
quietly xtreg leisure c.age##c.age##c.age i.sex i.coh, fe
predict alphafehat, u
sum alphafehat


*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
