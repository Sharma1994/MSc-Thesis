*------------------------------------------------------------------------------*
*-----------------------------Andrew Sharma------------------------------------*
*--------------------------MSc Thesis - Do-File--------------------------------*
*------------------------------------------------------------------------------*

*==============================================================================*
*=============================SAMPLE SELECTION=================================*
*==============================================================================*
* Date : March 2018
* Paper: MSc Thesis
*
* This program selects the relevant sample ready for analysis and deals with
*	missing values
*
* Data Used: - merge.dta
*
* Output: - \temp\final.dta
*
* Exclusions:
*
*	- Exclude Survey Year 1990 (Question not asked)
*	- Exclude Persons Below the Age of 17
*	- Exclude Immigrants
*	- Exclude East Germany
*	- Exclude Migrant and East Germany Oversamples
*	- Exclude Missings
*
*	
*==============================================================================*
*==============================================================================*

*------------------------------------------------------------------------------*
*---------------------Verify Configuration File Execution----------------------*
*------------------------------------------------------------------------------*


if "${config}"!="1" do config


*------------------------------------------------------------------------------*
*---------------Load Merged Data Created in 00_data_preparation.do-------------*
*------------------------------------------------------------------------------*


use "${tempDir}/merge", clear


*------------------------------------------------------------------------------*
*------------------------Dropping Survey Year 19990----------------------------*
*------------------------------------------------------------------------------*


drop if syear==1990		//Question not asked to West Germans


*------------------------------------------------------------------------------*
*-------------------------Setting Age Range (18-99)----------------------------*
*------------------------------------------------------------------------------*


recode age (0/16=.) (100/110=.)


*------------------------------------------------------------------------------*
*--------------------------Excluding Immigrants--------------------------------*
*------------------------------------------------------------------------------*


recode migback (2 3=.)


*------------------------------------------------------------------------------*
*--------------------------Excluding East Germany------------------------------*
*------------------------------------------------------------------------------*


recode loc1989 (1 3=.) (2=1) (4=2) (5=3)
label drop loc1989
label define loc1989 1 "West Germany" 2 "Not Applicable" 3 "No Answer"
label values loc1989 loc1989


*------------------------------------------------------------------------------*
*-------------------------Excluding Selective Samples--------------------------*
*------------------------------------------------------------------------------*


recode psample (2 3 4 15 16 17 18=.)		///
			   (5=2) (6=3) (7=4) (8=5)		///
			   (9=6) (10=7) (11=8) (12=9)	///
			   (13=10) (14=11) 
label drop psample
label define psample ///
			 1 "A 1984 Initial Sample (West)" 2 "E 1998 Refreshment" ///
			 3 "F 2000 Refreshment" 4 "G 2002 High Income" ///
			 5 "H 2006 Refreshment" 6 "I 2009 Innovation Sample" ///
			 7 "J 2011 Refreshment" 8 "K 2012 Refreshment"		 ///
			 9 "L1 2010 Birth Cohort (2007-2010)"				 ///
			10 "L2 2010 Family Type (Low-Income, Single parent, Large Families" ///
			11 "L3 2011 Family Type (Single-Parents, Large Families"
label values psample psample


*------------------------------------------------------------------------------*
*------------------------------Drop Missings-----------------------------------*
*------------------------------------------------------------------------------*


local missvar pid syear ///
			  birthyr coh age ageint sex ///
			  leisure ///
			  migback loc1989 psample ///
			  wrkhrsday wrkhrsweek
			  
misstable sum `missvar'
		  sum `missvar'
		  
gen missings =missing(pid, syear, ///
					  birthyr, coh, age, ageint, sex, ///
					  leisure, ///
					  migback, loc1989, psample, ///
					  wrkhrsday, wrkhrsweek)

label variable missings "Missing Data"
tab missings
drop if missings==1

sum `missvar'

//297,280 total observations omitted//
//42,564 distinct observation omitted//



*------------------------------------------------------------------------------*
*-------------------------------Data Overview----------------------------------*
*------------------------------------------------------------------------------*


distinct pid 							//N_total=308,466---N_distinct=41,998//


*------------------------------------------------------------------------------*
*--------------------------------Save Data-------------------------------------*
*------------------------------------------------------------------------------*


save "${tempDir}/final", replace


*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
