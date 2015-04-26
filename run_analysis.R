run_analysis<-function(){
  ##--The required files are in a subdirectory of the current working directory
  ##--We move the current working directory to the UCI HAR Dataset folder
  
  old_dir<-getwd()
  setwd("Getting and Cleaning Data/Project/UCI HAR Dataset/")
  
  #--STEP 1: Read test files
  #-- This is straightforward reading in the files into objects using read.table
  
  ##--Read the training data
  data_test <- read.table("test/X_test.txt") # 2947x561
  
  ##--Read the training labels
  label_test <- read.table("test/y_test.txt") # 2947x1
  
  ##--Read the training subjects
  subject_test <- read.table("test/subject_test.txt") # 2947x1
  
  #--STEP 2 Read training files
  
  ##--Read the training data
  data_train <- read.table("train/X_train.txt") # 7352x561
  
  ##--Read the training labels
  label_train <- read.table("train/y_train.txt") # 7352x1
  
  ##--Read the training subjects
  subject_train <- read.table("train/subject_train.txt") #7352x1
  
  #-STEP 2: Merge the corresponding training and test data
  #--Using rbind() to merge the datasets
  
  ##--Merge data objects
  data <- rbind(data_test,data_train) # 10299x561
  
  ##--Merge label objects
  labels <- rbind(label_test,label_train) #10299x1
  
  ##--Merge subject objects
  subjects <- rbind(subject_test,subject_train) #10299x1
  
  #-STEP 3: Extract columns with Mean and Standard Deviation
  features <- read.table("features.txt") #561x2
  
  ##--On viewing the featues table we observe features corresponding to each column of the "data" table 
  
  ##--Select columns of data object by extracting Mean and Standard Deviation using grep()
  data <- data[,grep(pattern="(mean|std)\\(\\)",features$V2)] #10299x66
  ##--giving pattern as "mean" would result in addition of meanFreq too
  
  #-STEP 4: Rename columns of all objects to recognizable names
  
  ##-- Rename columns of "data"
  names(data)<-features[grep(pattern="(mean|std)\\(\\)",features$V2),2] 
  
  ##--Rename rows and columns of "labels" using activity labels
  activity <- read.table("activity_labels.txt")
  labels[,1] <- activity[labels[,1],2] # Replacing numbers with recognizable labels
  names(labels)<-"Activity.Performed"
  
  ##--Rename column name of "subjects"
  names(subjects)<-"Subject"
  
  #-STEP 5: Merge datasets into one dataset
  ##--Since all datasets have same number of rows(10299), we use cbind()
  final_data<-cbind(subjects,labels,data) #10299x68
  
  #-STEP 6: Create another tidy dataset with means of activities for each subject
  ##--using split() and applying colMeans() using by() was tedious therefore used ddply of plyr package
  require(plyr)
  avg_tidy_data <- ddply(final_data,.(Subject, Activity.Performed),function(x){colMeans(x[, 3:68])})
  ##--ddply is much more adept at recursive splitting and applying functions and then returning data frame
  
  ##-STEP 7: Save independent tidy dataset
  write.table(avg_tidy_data,"Avg_Tidy_Data.txt",row.names=FALSE) #180x68
  
  message("File successfully saved!!!")
  
  ##--return to old working directory
  setwd(old_dir)
  
}