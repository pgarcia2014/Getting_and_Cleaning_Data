## DOWNLOAD AND UNZIP THE DATA
if (!file.exists("./CourseProject")) {dir.create("./CourseProject")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./CourseProject/ProjectData.zip")
dateDownloaded <- date()
unzip(zipfile = "./CourseProject/ProjectData.zip", exdir = "./CourseProject")

## READ THE DATA
# In accordance to README.txt file, the necessary data to build the data set is contained in the following files:
# - 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.
# - 'train/X_train.txt': Training set.
# - 'train/y_train.txt': Training labels.
# - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
# - 'test/X_test.txt': Test set.
# - 'test/y_test.txt': Test labels.
# - 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

# Step 01: Reading common data
FileName <- "./CourseProject/UCI HAR Dataset/activity_labels.txt"
common.activities <- read.table(file = FileName, header = FALSE)
FileName <- "./CourseProject/UCI HAR Dataset/features.txt"
common.features <- read.table(file = FileName, header = FALSE)

# Step 02: Reading training data
FileName <- "./CourseProject/UCI HAR Dataset/Train/y_train.txt"
train.ActivityData <- read.table(file = FileName, header = FALSE)
FileName <- "./CourseProject/UCI HAR Dataset/Train/subject_train.txt"
train.SubjectData <- read.table(file = FileName, header = FALSE)
FileName <- "./CourseProject/UCI HAR Dataset/Train/x_train.txt"
train.Data  <- read.table(FileName, header = FALSE)

# Step 03: Reading test data
FileName <- "./CourseProject/UCI HAR Dataset/test/y_test.txt"
test.ActivityData <- read.table(file = FileName, header = FALSE)
FileName <- "./CourseProject/UCI HAR Dataset/test/subject_test.txt"
test.SubjectData <- read.table(file = FileName, header = FALSE)
FileName <- "./CourseProject/UCI HAR Dataset/test/x_test.txt"
test.Data <- read.table(FileName, header = FALSE)

## MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.

# Step 01: Combine the data table by rows
merge.Activity <- rbind(test.ActivityData, train.ActivityData)
merge.Subject <- rbind(test.SubjectData, train.SubjectData)
merge.Data <- rbind(test.Data, train.Data )

# Step 02: Set names
names(merge.Activity) <- c("ActivityCode")
names(merge.Subject) <- c("Subject")
names(merge.Data) <- common.features$V2

# Step 03: Get the final data set
MergedData <- cbind(cbind(merge.Activity, merge.Subject), merge.Data)
head(MergedData)

## EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT. 
# Take all the features that include “mean()” or “std()” in their names.
# Must include "ActivityCode" and "Subject" in the subset of features. 

SelectedFeaturesNames <- common.features$V2[grep("mean\\(\\)|std\\(\\)", common.features$V2)]
SelectedFeaturesNames <- c("ActivityCode", "Subject", as.character(SelectedFeaturesNames))
CleanedData <- subset(MergedData, select = SelectedFeaturesNames)
head(CleanedData)

## USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
ActivityName <- as.character(common.activities[match(CleanedData$ActivityCode, common.activities$V1), 'V2'])
ActivityName <- as.factor(ActivityName)
CleanedData  <- cbind(ActivityName, CleanedData)
CleanedData$ActivityCode <- NULL
head(CleanedData, 40)

## APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.
# The data set contains data for activities, subject and features. 
# Activities and subject already have descriptive labels for variables and names. 
# For features, we still need to transform them in something more readable and understandable.
# From these two sources, features_info.txt and http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, you can deduce that
# t at the beginning of the labels refers to time
# f at the beginning of the labels refers to frequency
# Acc refers to Accelerometer
# Gyro refers to Gyroscope
# Mag refers to Magnitude

names(CleanedData) <- gsub("^t", "time", names(CleanedData))
names(CleanedData) <- gsub("^f", "frequency", names(CleanedData))
names(CleanedData) <- gsub("Acc", "Accelerometer", names(CleanedData))
names(CleanedData) <- gsub("Gyro", "Gyroscope", names(CleanedData))
names(CleanedData) <- gsub("Mag", "Magnitude", names(CleanedData))
# names(CleanedData)
write.table(CleanedData, file = "CleanedDataSet.txt",row.name=FALSE)

## FROM THE DATA SET IN STEP 4, CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.
library(plyr)
TidyData <- ddply(CleanedData,.(ActivityName, Subject),numcolwise(mean,na.rm = TRUE))
TidyData <- TidyData[order(TidyData$ActivityName,TidyData$Subject),]
write.table(TidyData, file = "TidyDataSet.txt",row.name=FALSE)




