######## Load libraries
library(data.table)
library(dplyr)


# set constants
verbose <- TRUE

dfile <- "destfile.zip"
folder <- "UCI HAR Dataset"


########## Check for the file
if(verbose) print("Checking for file....")
if(!file.exists(dfile))
{
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,dfile)

}

######## Check for the unzipped folder
if(verbose) print("Checking for unzipped folder....")
if(!file.exists(folder)) 
  {
   unzip(dfile, overwrite = TRUE)
}
  ######## Load the Files
if(verbose) print("Loading Test Files.....")
 xTestTable <- read.table(paste(folder,"/test/X_test.txt", sep = "" ))
 yTestTable <- read.table(paste(folder,"/test/y_test.txt", sep = "" ))
 subjectTestTable <- read.table(paste(folder,"/test/subject_test.txt", sep = "" ))

if(verbose) print("Loading Training Files....")
 xTrainTable <- read.table(paste(folder,"/train/X_train.txt", sep = "" ))
 yTrainTable <- read.table(paste(folder,"/train/y_train.txt", sep = "" ))
 subjectTrainTable <- read.table(paste(folder,"/train/subject_train.txt", sep = "" ))

##### Do I need root files? 
if(verbose) print("Loading Root files.....")
 activityTable <- read.table(paste(folder,"/activity_labels.txt", sep = "" ))
 featuresTable <- read.table(paste(folder,"/features.txt", sep = "" ))
 
if(verbose) print("Files Loaded")
 
####### bind the tables into one
if(verbose) print("Binding Tables.....")
xTable <- rbind(xTestTable,xTrainTable)
yTable <- rbind(yTestTable,yTrainTable)
subjectTable <- rbind(subjectTestTable, subjectTrainTable)

########### Move this
###########bigDataTable <- cbind(xTable, yTable, subjectTable)

##### Let's do this

###Extract the Data.....

if(verbose) print("Naming Columns.....")

setnames(yTable,"V1","ActivityCode")
setnames(subjectTable, "V1","User")

featureNames <- c("num", "function")
setnames(featuresTable,featureNames)

means <- grep("-(mean).*", as.character(featuresTable[,2]))
stds <- grep("-(std).*", as.character(featuresTable[,2]))
stats <- c(means,stds)

meansTableNames <- featuresTable[means,2]
stdsTableNames <-featuresTable[stds,2]
tableNames <- c(meansTableNames,stdsTableNames)


######Let's change some column names....

tableNames <- gsub("[-()]", "", tableNames)
tableNames <- sub("Acc", "Accelerometer", tableNames)
tableNames <- sub("Gyro", "Gyroscope", tableNames)
tableNames <- sub("std", ".STD.", tableNames)
tableNames <- sub("mean", ".Mean.", tableNames)
tableNames <- sub("Freq", "Frequency", tableNames)
tableNames <- sub("Mag", "Magnitude", tableNames)
tableNames <- sub("tBody", "TimeBody", tableNames)
tableNames <- sub("fBody", "FrequencyBody", tableNames)
tableNames <- sub("BodyBody", "Body", tableNames)

statsTable <- xTable[stats]
setnames(statsTable,tableNames)

######Bind that Table......

bigDataTable <- cbind(subjectTable,yTable, statsTable)

if(verbose) print("Big Data Table created.....")
 
if(verbose) print("Final Touches")

bigDataTable$ActivityCode <- factor(bigDataTable$ActivityCode, levels = activityTable[,1], labels = activityTable[,2])
bigDataTable$User <- as.factor(bigDataTable$User)

write.table(bigDataTable, "bigDataTable.txt", row.name=FALSE)

if(verbose) print("Group by Mean.....")

##### moving to dplyr functions. 
##### Figure out how to do this with data.table


summaryTable <- bigDataTable %>% group_by(User, ActivityCode) %>% summarise_all(funs(mean))

####summaryTable<- bigDataTable[,list(User, ActivityCode),by=group]

write.table(summaryTable, "summaryTable.txt", row.name=FALSE)



