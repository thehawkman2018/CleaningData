---
title: "CodeBook.md"
author: "Eric"
date: "9/20/2020"
output: html_document
---


# Course Project
  The goal of this project is to consolidate the URI HAR Dataset from the University of California-Irvine. This data set contains data collected from acceleromoters from Samsung Galaxy Smartphones.

# Data
 * There are 8 main files from the dataset used:  x_train.txt, x_test.txt, y_train.txt, y_test.txt, subject_train.txt, subject_test.txt, features.txt and activity_labels.txt.
 * The data is divided into a standard training and data set configuration. The features.txt file corresponds with the x_ files and the activity_labels corresponds to the y_ files.
 * The training and test files, _train and _test respectively, will be merged.
 
# Project
 The project is described as such:
 You should create one R script called run_analysis.R that does the following.

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each      measurement.
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names.
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 6. Code used in run_analysis.r uses the data.table and dplyr libraries.
 
# Output
 Using the run_analysis.R file the output are two datasets:
 
 * BigDataTable.txt is a the result of merging the datasets. It contains 10299 records and 68 variables.
 * The dataset variables include the user, the activity they were engaged in and the 66 variables of mean and standard deviations.
 * tidyTable.txt contains a summary of the BigDataTable.txt dataset