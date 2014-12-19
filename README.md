# Getting and Cleaning Data Course Project

## This file describes how run_analysis.R script works.

* First, make sure the run_analysis.R script is in the current working directory.
* Second, use source("run_analysis.R") command in RStudio.
* Third, two output files are generated in the current working directory:
  * CleanedDataSet.txt: it contains a data frame with 10299*68 dimension.
  * TidyDataSet.txt: it contains a data frame with 180*68 dimension.
* Finally, use ds <- read.table("TidyDataSet.txt") command in RStudio to read the file. 