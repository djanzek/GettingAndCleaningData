fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "dataset.zip", mode="wb")
unzip("dataset.zip")
list.files()
wd <- getwd()
setwd("./UCI HAR Dataset")
list.files()
list.dirs()

collumn_labels_raw <- readLines("features.txt")
collumn_labels_table <- read.table("features.txt", header=FALSE)
collumn_numbers1 <- grep("mean\\(\\)", collumn_labels_raw)
collumn_numbers2 <- grep("std\\(\\)", collumn_labels_raw)
collumn_numbers <- sort(union(collumn_numbers1, collumn_numbers2))
collumn_labels <- collumn_labels_table$V2[collumn_numbers]
rm(collumn_labels_table, collumn_numbers1, collumn_numbers2)

data_train <- read.table("./train/X_train.txt", header=FALSE)
data_train <- data_train[ , collumn_numbers]
colnames(data_train) <- collumn_labels

data_train_rownames <- read.table("./train/y_train.txt", header=FALSE)
data_train_subject <- read.table("./train/subject_train.txt", header=FALSE)
data_train$subject <- data_train_subject$V1
rm(data_train_subject)
data_train$activity <- data_train_rownames$V1
rm(data_train_rownames)

data_test <- read.table("./test/X_test.txt", header=FALSE)
data_test <- data_test[ , collumn_numbers]
colnames(data_test) <- collumn_labels

data_test_rownames <- read.table("./test/y_test.txt", header=FALSE)
data_test_subject <- read.table("./test/subject_test.txt", header=FALSE)
data_test$subject <- data_test_subject$V1
rm(data_test_subject)
data_test$activity <- data_test_rownames$V1
rm(data_test_rownames)

row.names(data_test) <- 7353:10299

data <- rbind(data_train, data_test)
rm(data_test, data_train, collumn_labels, collumn_labels_raw, collumn_numbers)
data$activity <- factor(data$activity, labels=c("WALKING", "WALKING_UPSTAIRS", 
      "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"), order=TRUE)
head(data)

install.packages("reshape2")
library(reshape2)
data_melt <- melt(data, id.vars=c("subject", "activity"))
head(data_melt)
result <- dcast(data_melt, subject + activity ~ variable, mean)
head(result)

rm(data, data_melt)
setwd(wd)
write.csv(result, "TidyDataset.csv", quote=FALSE, row.names=FALSE)
