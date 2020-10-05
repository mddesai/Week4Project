#set and check working directory
setwd("D:/Academics/Coursera/DataScienceCourse/Week4Project/project/UCI_HAR_Dataset")
getwd()

#load libraries
library(dplyr)

#reading train data
XTrain = read.table("./train/X_train.txt")
YTrain = read.table("./train/Y_train.txt")
SubTrain = read.table("./train/subject_train.txt")

#reading test data
XTest = read.table("./test/X_test.txt")
YTest = read.table("./test/Y_test.txt")
SubTest = read.table("./test/subject_test.txt")

#reading features and activity labels
features = read.table("./features.txt")
activity_labels = read.table ("./activity_labels.txt")

#merging datasets
XTotal = rbind(XTrain, XTest)
YTotal = rbind(YTrain, YTest)
SubTotal = rbind(SubTrain, SubTest)

#extracting measurements for mean and std dev
SelectFeatures = features[grep(".*mean\\(\\)|std\\(\\)", features[,2]), ]
XTotal = XTotal[, SelectFeatures[,1]]

#descriptive activity names
colnames(YTotal) = "activity"
YTotal$activitylabel = factor(YTotal$activity, labels = as.character(activity_labels[,2]))
activitylabel = YTotal[,-1]

#appropriate labels and descriptive var names
colnames(XTotal) = features[SelectFeatures[,1],2]

#creating tidy data with average of each var for each activity and each subject
colnames(SubTotal) = "subject"
total = cbind(XTotal, activitylabel, SubTotal)
total_mean = total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)