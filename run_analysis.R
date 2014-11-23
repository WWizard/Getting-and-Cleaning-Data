# Step1. Merges the training and the test sets to create one data set.

#Read the train data
trainData <- read.table("./train/X_train.txt")
dim(trainData) # 7352*561
head(trainData) #V1-V561

trainLabel <- read.table("./train/y_train.txt")
table(trainLabel)

trainSubject <- read.table("./train/subject_train.txt")

#Read the test data
testData <- read.table("./test/X_test.txt")
dim(testData) # 2947*561
head(testData)

testLabel <- read.table("./test/y_test.txt") 
table(testLabel) #V1-V561
 
testSubject <- read.table("./test/subject_test.txt")

#Merge data
MergeData <- rbind(trainData, testData)
dim(MergeData) # 10299*561
MergeLabel <- rbind(trainLabel, testLabel)
dim(MergeLabel) # 10299*1
MergeSubject <- rbind(trainSubject, testSubject)
dim(MergeSubject) # 10299*1

# Step2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./features.txt")
dim(features)  # 561*2
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(meanStdIndices) # 66
MergeData <- MergeData[, meanStdIndices]
dim(MergeData) # 10299*66
names(MergeData) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # remove "()"
names(MergeData) <- gsub("mean", "Mean", names(MergeData)) # capitalize M
names(MergeData) <- gsub("std", "Std", names(MergeData)) # capitalize S
names(MergeData) <- gsub("-", "", names(MergeData)) # remove "-" in column names 

# Step3. Uses descriptive activity names to name the activities in the data set.

activity <- read.table("./activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabel <- activity[MergeLabel[, 1], 2]
MergeLabel[, 1] <- activityLabel
names(MergeLabel) <- "activity"

# Step4. Appropriately labels the data set with descriptive activity names.

names(MergeSubject) <- "subject"
cleanData <- cbind(MergeSubject, MergeLabel, MergeData)
dim(cleanData) # 10299*68
write.table(cleanData, "cleanData.txt") # write out the 1st dataset

# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

subjectLen <- length(table(MergeSubject)) # 30
activityLen <- dim(activity)[1] # 6
columnLen <- dim(cleanData)[2] #68
result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleanData)
row <- 1
for(i in 1:subjectLen) {
    for(j in 1:activityLen) {
        result[row, 1] <- sort(unique(MergeSubject)[, 1])[i]
        result[row, 2] <- activity[j, 2]
        bool1 <- i == cleanData$subject
        bool2 <- activity[j, 2] == cleanData$activity
        result[row, 3:columnLen] <- colMeans(cleanData[bool1&bool2, 3:columnLen])
        row <- row + 1
    }
}
head(result)
write.table(result, "cleandata_means.txt") # write out the 2nd dataset

