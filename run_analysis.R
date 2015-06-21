## download data
library(httr)
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

