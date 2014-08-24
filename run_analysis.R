## Project getting and cleaning data 
## Assgin url for downloading the zip file
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##  down load the zip file
download.file(url1,"UCI HAR Dataset.zip")
library(httr)
## load library (httr) and read into tables training and test data sets 
##  for x, y and subject from the respective text files
##  Also, read the features and activity-lables text files
datax_train <- read.table("./UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
datay_train <- read.table("./UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE)
datasub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)
datax_test <- read.table("./UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
datay_test <- read.table("./UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)
datasub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt",sep="",header=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
##  combine the subject, y and x data for training set by cbind
data_train <- cbind(datasub_train, datay_train, datax_train)
##  combine the subject, y and x data for test set by cbind
data_test <- cbind(datasub_test, datay_test, datax_test)
##  coombine the training and test set data by rbind to get the complete data set
data_all <- rbind(data_train, data_test)
##  assign the features (text) variable as character variable
##  create a charcter vector for subject and activity - which is not defined in the features text file 
##  Create the column head strings by concortenating C1 and C2 and 
##assin this as column names for the complete data set
c1<- as.character(features[,2])
c2 <- c("subject", "Activity")
columnhead <- c(c2,c1)
colnames(data_all) <- columnhead
##  break the compete data set into data1 (for labels) and 
##  data2 with only variables that include std and mean
data1 <- data_all[,1:2]
data2 <- data_all[grep("std|mean",colnames(data_all))]
##  reconstruct the reduced data set by combining Dat1 and Data 2
data3 <- cbind(data1,data2)
##  transform the variable names by removing unwanted characters 
##  so that they are more human readable
colnames(data3) <- gsub("-|\\()", "", colnames(data3))
##  Take the average of each variable for each subject and activity
##  30 subjects doing 6 activities -> 180 combinations
td1 <- aggregate(data3, by = list( data3$Activity,data3$subject), FUN = "mean")
##  this adds to undesirable columns in the front. Total # of columns are 83 instead of 81
##  Subset the data to get rid of the unwanted columns
td1 <- td1[,3:83]
## reassign the activity lables as human redable
td1$Activity[td1$Activity == "1"]<-"WALKING"
td1$Activity[td1$Activity == "2"]<-"WALKING_UPSTIRS"
td1$Activity[td1$Activity == "3"]<-"WALKING_DOWNSTIRS"
td1$Activity[td1$Activity == "4"]<-"SITTING"
td1$Activity[td1$Activity == "5"]<-"STANDING"
td1$Activity[td1$Activity == "6"]<-"LAYING"
##  This yields the desired tidy data set  
tidy_data <- td1
##  save the data table into a text file
file1 <-"C:/Users/Sridhar/Documents/tidy_data.txt" 
write.table(tidy_data, file = file1, sep="")


