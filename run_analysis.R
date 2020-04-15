library(dplyr)
library(tidyverse)

my_file <- "UCI HAR Dataset.zip"

if(!file.exists(my_file)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, my_file)
}
if(!file.exists("Final Project Data")) {
  unzip(my_file)
}


activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code Number", "Activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Number", "Function"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Code")
subject_training <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_training <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
y_training <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Code")

x_bound <- rbind(x_training, x_test)
y_bound <- rbind(y_training, y_test)
subject_bound <- rbind(subject_training, subject_test)
combinedData <- cbind(x_bound, y_bound, subject_bound)  

dataAverages <- combinedData %>% select(Subject, Code, contains("mean"), contains("std"))


names(dataAverages)[2] = "Activity"
names(dataAverages) <- gsub("Acc", "Accelometer", names(dataAverages))
names(dataAverages) <- gsub("BodyBody", "Body", names(dataAverages))
names(dataAverages) <- gsub("^f", "Frequency", names(dataAverages))
names(dataAverages) <- gsub("gravity", "Gravity", names(dataAverages))
names(dataAverages) <- gsub("Gyro", "Gyroscope", names(dataAverages))
names(dataAverages) <- gsub("Mag", "Magnitude", names(dataAverages))
names(dataAverages) <- gsub("mean()", "Mean", names(dataAverages))
names(dataAverages) <- gsub("-std", "Standard Deviation", names(dataAverages))
names(dataAverages) <- gsub("^t", "Time", names(dataAverages))


tidyData <- dataAverages %>%
  group_by(Subject, Activity) %>%
  summarize_all(mean)
write.table(tidyData, "Tidy Data.txt", row.name = FALSE)


