Getting-and-Cleaning-Data
=========================
This is the assignment for the getting and cleaning data course on Coursera.

This file describes how run_analysis.R script works.

First, unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  rename the folder that contained those unziped files (e.g., assignment), put the run_analysis.R script into this folder.

Second, Open RStudio and change working dir to this folder (e.g., C:\Desktop\assignment)

Third, use source("run_analysis.R") command in RStudio.
    ##Alternatively, open the run_analysis.R file, select lines to run.

Finally, two output files are generated in the folder:
  cleanData.txt (8150 KB), which is the merged cleaned data  
  cleandata_means.txt (220 KB), which is data set required for submit
