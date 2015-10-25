#
#   Course: Data Science / Getting and Cleaning Data
#   Title : Course Project
#
##########################################################################################################
# Instructions:
#
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.


###########################################################################################################


# set working directory - this should be the location of the raw data files
setwd()

library(plyr)
library(reshape2)
library(data.table)
library(dplyr)
library(reshape)     # order appears to be important for this library 

## Part 1 : Merges the training and the test sets to create one data set.

# Call in feature names to be used as col names
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# training dataset
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_train <- rename(subject_train, c(V1="Subject_ID"))

X_train <- data.frame(read.table("./UCI HAR Dataset/train/X_train.txt",col.names = features[,2]))
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")

# create training dataset
trainDF <- data.frame(cbind(subject_train,Y_train, X_train))

# create label indicating whether part of Training or Test dataset
trainDF$Partition <-"Train"

# test dataset
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_test <- rename(subject_test, c(V1="Subject_ID"))

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = features[,2])
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

# create training dataset
testDF <- data.frame(cbind(subject_test,Y_test, X_test))

# create label indicating whether part of Training or Test dataset
testDF$Partition <-"Test"

#create an Overall dataset consisting of Training and Test
OverallDF <- rbind(trainDF, testDF)

###################################################################################################
#
# Part 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# 
# Keep : Subject_ID and Activity
#

Keyvars <- OverallDF[,1:2]
MeanVars <- OverallDF[,grep("mean", colnames(OverallDF))]
StdVars <- OverallDF[,grep("std", colnames(OverallDF))]

MeanStdVars <- data.table(cbind(Keyvars,MeanVars,StdVars))

# 3.Uses descriptive activity names to name the activities in the data set

# attach Activity Labels to the dataset and reorder col
MeanStdVars_Act <- merge(MeanStdVars,activity_labels, by.x="V1", by.y="V1")
MeanStdVars_Act <- rename(MeanStdVars_Act, c(V2="Activity"))
MeanStdVars_Act %>% select(Subject_ID, Activity, tBodyAcc.mean...X:fBodyBodyGyroJerkMag.std..)

# 4.Appropriately labels the data set with descriptive variable names. 

names(MeanStdVars_Act) <- sub("[. ]", " ", names(MeanStdVars_Act))
names(MeanStdVars_Act) <- sub(" mean", "Mean", names(MeanStdVars_Act))
names(MeanStdVars_Act) <- sub(" std", "Std", names(MeanStdVars_Act))
names(MeanStdVars_Act) <- sub("[...]", "", names(MeanStdVars_Act))
names(MeanStdVars_Act) <- sub("[...]", "", names(MeanStdVars_Act))
names(MeanStdVars_Act) <- sub("[...]", "", names(MeanStdVars_Act))
names(MeanStdVars_Act)

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.

#TidyDF <- MeanStdVars[,lapply(.SD,mean),by=MeanStdVars$Subject_ID MeanStdVars$Activity]

X<- MeanStdVars_Act %>%
      group_by(Subject_ID, Activity) %>%
        summarise_each(funs(mean))

X$V1 <- NULL
write.table(X,"./CourseProject_Data.txt", row.names = FALSE)




