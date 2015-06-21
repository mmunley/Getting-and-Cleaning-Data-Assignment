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
if(!file.exists(datadir)){
        print("unzipping data")
        unzip(file, list = FALSE, overwrite = TRUE)
        
}

## Merges training and test data to create one dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
X <- rbind(train, test)

train <- read.table("UCI HAR Dataset/train/subject_train.txt")
test <- read.table("UCI HAR Dataset/test/subject_test.txt")
Subj <- rbind(train, test)

train <- read.table("UCI HAR Dataset/train/y_train.txt")
test <- read.table("UCI HAR Dataset/test/y_test.txt")
Y <- rbind(train, test)

## Extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt")
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, mean.sd]
names(X) <- features[mean.sd, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

## Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[, 1] = activities[Y[, 1], 2]
names(Y) <- "activity"

## Appropriately labels the data set with descriptive variable names.

names(Subj) <- "subject"
cleaned <- cbind(Subj, Y, X)
write.table(cleaned, "merged_clean_data.txt")

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubjects <- unique(Subj)[, 1]
numSubject <- length(unique(Subj)[, 1])
numActiv <- length(activities[, 1])
numCols <- dim(cleaned)[2]
result <- cleaned[1:(numSubject*numActiv), ]

row <- 1
for (s in 1:numSubject){
        for (a in 1:numActiv) {
                result[row, 1] = uniqueSubjects[s]
                result[row, 2] = activities[a, 2]
                temp <- cleaned[cleaned$subject == s & cleaned$activity == activities[a, 2], ]
                result[row, 3:numCols] <- colMeans(temp[, 3:numCols])
                row <- row+1
        }
}

write.table(result, "dataset_with_averages.txt")