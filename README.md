#   Course: Data Science / Getting and Cleaning Data
##   Title : Course Project : README.md file

### Steps taken to create final file from raw inputs
#### Setting up of R environment
1. Set the working directory using the setwd() command and ensure the raw data files are unzipped and located in the UCI HAR Dataset folder within the working directory.
        _(e.g working directory = “C:\\Users\\” with raw files located in the “C:\\Users\\ UCI HAR Dataset”)_
2. Install and load the required libraries:
a. plyr
b. reshape2
c. data.table
d. dplyr
e. reshape      
_Note: the order for the reshape library appears to be important as the rename function gave errors if this library was not the last to be loaded_ 
### Merge the training and the test sets to create one data set.
1. Read into R via the read.table() command 
a. feature.txt 
b. activity_labels.txt

and from the **train** folder within UCI HAR Dataset folder:

c. subject_train.txt – renaming the default column name to “Subject_ID” 
d. X_train.txt – using the feature.txt field names as the column names
e. Y_train.txt

and from the **test** folder within UCI HAR Dataset folder:

f. subject_train.txt – renaming the default column name to “Subject_ID” 
g. X_train.txt – using the feature.txt field names as the column names
h. Y_train.txt

2. Using cbind() 
a.  combine the objects created in (c,d,e) to create a data frame trainDF
b.  and similarly use the objects created in (f,g,h) to create a data frame testDF
3. Create an additional column on both dataframes which enables the data to be repartitioned into the training and test data frames after combining. In this script  the variable was named “Partition” and took the values “Train” or “Test”
4. Using rbind() append the testDF to the trainDF to create the overall data frame which will consist of all the data in the original train and test raw data files. 
### Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Keep  the Subject_ID and numerical activity field in an object call Keyvars. These are the identifier variables for all the observations in the dataset
2. Using the grep() function, select all columns which have the word “mean” somewhere in its name. Save in object MeanVars.
3. Do the same for the “std” and save in object StdVars
4. Combine the 3 objects into one dataframe using the cbind() function and call this object MeanStdVars. This dataset will contain the key variables alongside all columns which have, as part of its name, the words “mean” or “std”.
### Uses descriptive activity names to name the activities in the data set
Within the data frame created from the above step the activity field is currently numerical from 1 to 6. This step uses the merge() function to attach the Activity labels which were read into R alongside the other text files.
The field is renamed to Activity and then the dplyr syntax is used to reorder the columns so that the key variables are located at the right hand side of the data frame followed by the measurements. 
### Appropriately labels the data set with descriptive variable names. 
Using the substitute function, sub() on the column names of the data frame, extraneous characters are removed and the words “mean” and “std” are capitalised to aid in reading the columns whilst keeping the column names succinct.
### Creation of data set consisting of the average of each variable for each activity and each subject.
The final dataset was created using the dplyr package syntax which contains the averages of each of the selected measurements by Subject_ID and Activity. These were then written out into a .txt file using the write.table() function. 
##References
• Original_Experiment_README.txt file – this contains the background to the original experiment and the resulting measurements.
• Code_book.md file – information on all the variables both in the raw and final dataset.

