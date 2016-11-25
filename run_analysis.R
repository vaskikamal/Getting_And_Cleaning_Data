library(reshape2)

# read data into data frames
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurement files
featureNames <- read.table("UCI HAR Dataset/features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
cumulated <- rbind(train, test)
meanstdcols <- grepl("mean\\(\\)", names(cumulated)) | grepl("std\\(\\)", names(cumulated))

meanstdcols[1:2] <- TRUE
cumulated <- cumulated[, meanstdcols]
cumulated$activity <- factor(cumulated$activity, labels=c("Walking",
                                                      "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
melted <- melt(cumulated, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

write.csv(tidy, "tidy.csv", row.names=FALSE)
write.table(tidy, file = "tidy_data.txt")