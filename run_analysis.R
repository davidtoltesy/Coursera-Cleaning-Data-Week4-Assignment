## Week 4 Cleaning and Getting Data Assignment - David Töltésy

## Load libraries
library(data.table)
library(dplyr)

## Setting the Work Directory
setwd("/Users/davidtoltesy/Documents/GitHub/CleaningDataAssignment/")

## Read features.txt
features_data <- read.table("./data/features.txt") 

## Read activity_labesl.txt
activity_labels_data <- read.table("./data/activity_labels.txt", header = FALSE) 

## Read training diretory (Activity)
subject_train_data <- read.table("./data/train/subject_train.txt", header = FALSE)
x_train_data       <- read.table("./data/train/X_train.txt", header = FALSE)
y_train_data       <- read.table("./data/train/Y_train.txt", header = FALSE) 

## Read test directory (Features)
subject_test_data <- read.table("./data/test/subject_test.txt", header = FALSE)
x_test_data       <- read.table("./data/test/X_test.txt", header = FALSE)
y_test_data       <- read.table("./data/test/Y_test.txt", header = FALSE)

## Merge datasets (Activity + Features)
subject_total    <- rbind(subject_train_data, subject_test_data)
activity_total   <- rbind(x_train_data, x_test_data)
features_total   <- rbind(y_train_data, y_test_data)

## Clean measurement
select_features <-  features_data[grep(".*mean\\(\\)|std\\(\\)", features_data[,2], ignore.case = FALSE),]
activity_total  <- activity_total[,select_features[,1]]

## Column naming
colnames(activity_total) <-select_features[,2]
colnames(features_total) <- "activity"
colnames(subject_total)  <- "subject"

## Merge datasets
final_data <- cbind(subject_total, activity_total, features_total)

## Factorizing
final_data$activity <- factor(final_data$activity, levels = activity_labels_data[,1], labels = activity_labels_data[,2]) 
final_data$subject  <- as.factor(final_data$subject) 

## Create tidy dataset 
tidydata <- final_data %>% group_by(activity, subject) %>% summarize_all(funs(mean))

## Export tidy dataset
write.table(tidydata, file = "tidydata.txt", row.names = FALSE, col.names = TRUE)

## Hallelujah!
