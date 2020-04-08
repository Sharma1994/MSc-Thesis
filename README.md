# MSc-Thesis
Project Document and Stata code for MSc Thesis


# This project uses data from the German Socio-economic Panel (2017):
How to access data:
Current EUI members can access German SOEP data as follows:

1. Complete the Library's Micro Data Registration Form (selecting 'G-SOEP' from the dropdown menu)

2. The Library sends a DIW 'addendum' form as an email attachment to the data requestor

3. The form is signed, dated and returned to econlibrary@eui.eu for counter-signature

4. The Library sends the form to DIW, Berlin

5. Following registration, are given access to the restricted server and provided with a password.

Please read, and abide by, the terms and conditions of use for licensed data resources.


# Directories
Set your Working Directory and Data Directory in the config do-file


# Master File
When executed, this master file runs each specific step in the analysis
in the correct order.


The files for this project is divided into the following steps:

1. Configuration
  
      config.do

2. Data Preparation:

      00_data_preparation.do
      
      01_sample_selection.do
	
3. Data Analysis:

      02_descriptive_statistics.do
      
      03_models.do


n.b. config file defines global paths which must be
run before executing any other do-file.

Replace 'do' command with 'run' to execute with suppressed output

# Leisure_Time.stpr

This file cotains the Stata project file, consisting of all the do-files within the project.

# Additional packages:

The config do-file will automatically install Stata's *estout* package, a generic program for making a table from one or more estimation results.

This project also uses LaTeX for table output. LaTeX code has been included in the comments.
