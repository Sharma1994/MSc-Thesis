*------------------------------------------------------------------------------*
*-----------------------------Andrew Sharma------------------------------------*
*--------------------------MSc Thesis - Do-File--------------------------------*
*------------------------------------------------------------------------------*

*==============================================================================*
*=============================CONFIGURATION====================================*
*==============================================================================*
* Date : March 2018
* Paper: MSc Thesis
*
* This program configures the global and local directories
*	for the accompanying files.
*
*
*==============================================================================*
*==============================================================================*

*------------------------------------------------------------------------------*
*--------------------------Configuration File----------------------------------*
*------------------------------------------------------------------------------*


clear
clear matrix		// Clear Any Previous Results/Data
capt log close _all // Close Log Files


*------------------------------------------------------------------------------*
*--------------------------Setting Directories---------------------------------*
*------------------------------------------------------------------------------*


//Set Current Working Directory//
global workingDir "D:\SET_WORKING_DIRECTORY\"


//Set Data Directory//
global data "D:\SET_DATA_DDIRECTORY\"


global tempDir 		= "${workingDir}/temp"		// Temp File Dir.
global adoDir		= "${workingDir}/Do_Files"	// Do File Dir.
global texDir		= "${workingDir}/Tables"	// Latex Table Dir.
global figDir		= "${workingDir}/Figures"	// Figure Dir.
cd "$workingDir" 			// change to working directory
adopath + "$adoDir" 		// extend the ado-file search path
capt mkdir "$tempDir" 		// create directory for temporary files (if not there)
capt mkdir "$Do_Files"		// create Do-File directory (if not there)
capt mkdir "$Tables"		// create Table directory (if not there)
capt mkdir "$Figures"		// create Figures Directory (if not there)


*------------------------------------------------------------------------------*
*--------------------------Stata-Specific Preferences--------------------------*
*------------------------------------------------------------------------------*


set more off		// Turn off 'tap to scroll'
set varabbrev off	// Turn off variable abbreviations
global config = 1	// Flag for executed config
*ssc install estout  // Install estout package for table production/exporting


*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
