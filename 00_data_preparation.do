*------------------------------------------------------------------------------*
*-----------------------------Andrew Sharma------------------------------------*
*--------------------------MSc Thesis - Do-File--------------------------------*
*------------------------------------------------------------------------------*

*==============================================================================*
*============================DATA PREPARATION==================================*
*==============================================================================*
* Date : March 2018
* Paper: MSc Thesis
*
* This program selects the relevant variables and merges the CNEF,
* 	person generated, person path, and person level databases
*
* Database used: soeplong, version 33.1
*
*	Files:				- pequiv.dta
*				 		- pl.dta
*				 		- ppfadl.dta
*				 		- pgen.dta
*
* Output: \temp\merge.dta
*
* Key Variables: - Person ID
*				 - Survey Year
*				 - Birth Year
*				 - Age (Yearly)
*				 - Age (10 Year Intervals)
*				 - Cohort (Yearly)
*				 - Cohort (10 Year Intervals)
*				 - Gender
*				 - Location in 1989
*				 - Migration Background
*				 - Selective Samples
*				 - Leisure Time (Hobbies & Other) - Weekday Hours
*				 - Effective Working Hours Per Week (Not Contractual)
*				 - Effective Working Hours Per Day (5 Day week - Not Contractual)
*
*
*==============================================================================*
*==============================================================================*

*------------------------------------------------------------------------------*
*---------------------Verify Configuration File Execution----------------------*
*------------------------------------------------------------------------------*


if "${config}"!="1" do config 


*------------------------------------------------------------------------------*
*----------------------------Variable Selection--------------------------------*
*------------------------------------------------------------------------------*


///////////////////////////Person-Level Variables///////////////////////////////
////////////////////////////////////////////////////////////////////////////////


//Introduce Data//
use syear pid					/// Survey Year, Person ID
	pli0051						/// Leisure Hours (Hobbies & Other) - Weekday
using "${data}/pl.dta", clear


*---------------------------Leisure Time (Discrete)----------------------------*


//Recoding Leisure Time//
gen leisure = pli0051
drop pli0051
recode leisure (-5/-1=.) (17/24=.)			//drop obs>17 as highly improbable


//Labelling Leisure Time//
lab var leisure "Weekday Hours: Leisure Activities and Hobbies"


//Save Data//
tempfile pl
save `pl', replace


//////////////////////Generated Variables on Person Level///////////////////////
////////////////////////////////////////////////////////////////////////////////


//Introduce Data//
use pid							/// Person ID
	syear						/// Survey Year
	pgtatzeit					/// Effective Working Hours Per Week (Not Contractual)
using "${data}/pgen.dta", clear


*----------------------Current Effective Working Hours-------------------------*


//Recoding Current Effective Working Hours (Weekly)//
gen wrkhrsweek=round(pgtatzeit)
recode wrkhrsweek (-2 = 0) (-3 = .) (-1 = .) (71/80 = .) //>70hours=.


//Labelling Effective Working Hours (Weekly)//
lab var wrkhrsweek "Current Effective Working Hours (Weekly)"
drop pgtatzeit


//Recoding Current Effective Working Hours (Daily)//
gen wrkhrsday=round(wrkhrsweek/5)


//Labelling Current Effective Working Hours (Daily)//
lab var wrkhrsday "Current Effective Working Hours (Daily)"


//Save Data//
tempfile pgen
save `pgen', replace


/////////////////////////////Person-Level Path Variables////////////////////////
////////////////////////////////////////////////////////////////////////////////


//Introduce Data//
use pid							/// Person ID
	syear						/// Survey Year
	sex							/// Gender
	gebjahr 					/// Birth Year
	loc1989						/// Location in 1989
	migback						/// Immigrant Status
	psample						/// Selective Samples
using "${data}/ppfadl.dta", clear


*----------------------------------Gender--------------------------------------*


//Recoding Gender: 0-Female 1-Male//
recode sex (-1 = .) (2 = 0)


//Labelling Gender: 0-Female 1-Male//
lab var sex "Sex: 0-Female 1-Male"
lab define sex1 0 "Female" 1 "Male"
lab values sex sex1


*--------------------------------Birth Year------------------------------------*


//Recoding Birth Year//
recode gebjahr (-1=.), gen(birthyr)
drop gebjahr


//Labelling Birth Year//
lab var birthyr "Year of Birth"


*------------------------------Location in 1989--------------------------------*


//Recoding Location in 1989//
recode loc1989 (-2=4) (-1=5)


//Labelling Location in 1989//
label drop loc1989
lab var loc1989 "Location in 1989"
lab define loc1989   1 "East Germany (DDR)" ///
					 2 "West Germany (FRG)" ///
					 3 "Abroad" ///
					 4 "Not Applicable" ///
					 5 "No Answer"
lab values loc1989 loc1989


*-----------------------------Migration Background-----------------------------*


//Labelling Migration Background//
lab drop migback
lab var migback "Migration Background"
lab define migback 1 "No Migration Background" ///
				   2 "Direct Migration Background" ///
				   3 "Indirect Migration Background"
lab values migback migback


*-------------------------------Selective Samples------------------------------*


//Labelling Selective Samples//
lab drop psample
lab var psample "Sample Type"
lab define psample 1 "A 1984 Initial Sample (West)" ///
				   2 "B 1984 Migration (until 1983, West)" ///
				   3 "C 1990 Initial Sample (East)" ///
				   4 "D 1994/5 Migration (1984-1994, West)" ///
				   5 "E 1998 Refreshment" ///
				   6 "F 2000 Refreshment" ///
				   7 "G 2002 High Income" ///
				   8 "H 2006 Refreshment" ///
				   9 "I 2009 Innovation Sample" ///
				  10 "J 2011 Refreshment" ///
				  11 "K 2012 Refreshment" ///
				  12 "L1 2010 Birth Cohort (2007-2010)" ///
				  13 "L2 2010 Family Type (Low-Income, Single-Parent, Large Families)" ///
				  14 "L3 2011 Family Type (Single-Parent, Large Families)" ///
				  15 "M1 2013 Migration (1995-2011)" ///
				  16 "M2 2015 Migration (2009-2013)" ///
				  17 "M3 2016 Refugee (2013-2015)" ///
				  18 "M4 2016 Refugee/family (2013-2015)"
lab values psample psample


//Save Data//
tempfile ppfadl
save `ppfadl', replace


*------------------------------------------------------------------------------*
*------------------------------Merge All Data----------------------------------*
*------------------------------------------------------------------------------*


////////////////////////////Load Person Level File//////////////////////////////


use `pl', clear


////////////////////////////Merge Person-Level Path File/////////////////////////


merge 1:1 pid syear using `ppfadl', keep (1 3) nogen


/////////////////////////Merge Generated Person-Level File//////////////////////


merge 1:1 pid syear using `pgen', keep (1 3) nogen


*------------------------------------------------------------------------------*
*------------------------Labelling PID and Survey Year-------------------------*
*------------------------------------------------------------------------------*


lab var pid "Unique Person Identifier"
lab var syear "Survey Year"


*------------------------------------------------------------------------------*
*-----------------------------Generated variables------------------------------*
*------------------------------------------------------------------------------*


///////////////////////////////////Age//////////////////////////////////////////


//Generating Age Variable//
gen age = syear - birthyr


//Labelling Age Variable//
lab var age "Age"


//Generating Age (10 Year Interval) Variable//
egen ageint = cut(age), at(17,20(10)100)


//Labelling Age (10 Year Interval) Variable//
lab var ageint "Age (Categorised)"


			   

//////////////////////////////////Cohort////////////////////////////////////////


//Generating Cohort (10 Year Interval) Variable//
egen coh = cut(birthyr), at (1900(10)2000)


//Labelling Cohort (10 Year Interval) Variable//
lab var coh "Birth Cohort (10 Year Intervals)"


*------------------------------------------------------------------------------*
*-------------------------------Data Overview----------------------------------*
*------------------------------------------------------------------------------*


count 							// 619,718 Before Sample Selection


*------------------------------------------------------------------------------*
*--------------------------------Save Data-------------------------------------*
*------------------------------------------------------------------------------*


save "${tempDir}/merge.dta", replace


*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
