## Loads necessary libraries
library(httr)
library(data.table)

## download data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "UCIHAR.zip"
if(!file.exists(file)){
        print("adding file")
        download.file(url, file)
}

## unzip and create folders for data
datadir <- "UCI HAR Dataset"
resultdir <- "Results"
if(!file.exists(datadir)){
        print("unzipping data")
        unzip(file, list = FALSE, overwrite = TRUE)
        
}
if(!file.exists(resultdir)){
        print("Creating Result Folder")
        dir.create(resultDir)
}

## Merges training and test data to create one dataset
train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")
X <- rbind(train, test)

train <- read.table("train/subject_train.txt")
test <- read.table("test/subject_test.txt")
Subj <- rbind(train, test)

train <- read.table("train/y_train.txt")
test <- read.table("test/y_test.txt")
Y <- rbind(train, test)

## Extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, mean.sd]
names(X) <- features[mean.sd, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

## Uses descriptive activity names to name the activities in the data set
