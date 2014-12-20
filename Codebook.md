# Getting and Cleaning Data
## Course project codebook

The run_analysis.R script performs the following tasks:

* Checks if the CourseProject folder exists under the work directory. If not, creates the folder.
* Downloads the data for the project 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and saves it as ProjectData.zip under the CourseProject folder.
* Unzips the zipped file.
* Reads the unzipped data.
  * activity_labels.txt is stored in common.activities
	* features.txt is stored in common.features
	* Train/y_train.txt is stored in train.ActivityData
	* Train/subject_train.txt is stored in train.SubjectData
	* Train/x_train.txt is stored in train.Data
	* test/y_test.txt is stored in test.ActivityData
	* test/subject_test.txt is stored in test.SubjectData
	* test/x_test.txt is stored in test.Data
* Merges the training and test data
  * Combines the training and test activity data by rows using the rbind function and the result is stored in merge.Activity
	* Combines the training and test subject data by rows using the rbind function and the result is stored in merge.Subject
	* Combines the training and test data by rows using the rbind function and the result is stored in merge.Data
	* Sets the names of the columns. 
		* "ActivityCode" for activity column
		* "Subject" for subject column.
		* Data contains 561 columns. The names for each of them can be found in common.features (common.features$V2)
	* Combines the merge.Activity, merge.Subject and merge.Data by columns using the cbind function and the result is stored in MergedData.
* Extracts only the measurements on the mean and standard deviation for each measurement
  * Takes all the features that include "mean()" or "std()" in their names. The script uses the data stored in common.features$V2 and the grep function. The result is stored in SelectedFeaturesNames.
	* "ActivityCode" and "Subject" are added to SelectedFeaturesNames.
	* The script creates a new set from the data stored in MergedData using the SelectedFeaturesNames and the subset function. The result is stored in CleanedData
* Replaces the activity codes by the activity names
  * Compares CleanedData$ActivityCode and common.activities$V1 using the match function and retrieves the names stored in common.activities$V2. The result is stored in ActivityName
	* Factorizes ActivityName
	* Combines ActivityName and CleanedData by columns using cbind function
	* Removes ActivityCode from CleanedData
* Appropriately labels the data set with descriptive variable names
  * Some names in CleanedData contain abbreviations that are difficult to understand. The script puts the right words instead of the abbreviations. It uses the names and gsub functions.
	* Saves the CleanedData set in a text file named "CleanedDataSet.txt"
* Creates the tidy data set
  * Uses the library "plyr"
	* Calculates the average of each variable for each activity and each subject by using the ddply function. Stores the result in TidyData
	* Sorts the data stored in TidyData by activity and subject using the order function.
	* Saves the TidyData set in a text file named "TidyDataSet.txt"	

