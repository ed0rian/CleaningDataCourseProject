library(data.table)

featureLabels   <- fread("features.txt", header = FALSE, drop = c(1))[[1]]
labelsSelectedN <- c(grep("mean()", featureLabels, fixed = TRUE), 
                     grep("std()", featureLabels, fixed = TRUE)
                   )
labelsSelectedN <- sort(unique(labelsSelectedN))
labelsSelected  <- featureLabels[labelsSelectedN]

activityLabels  <- fread("activity_labels.txt", header = FALSE, drop = c(1))[[1]]

trainSubjects   <- fread("train/subject_train.txt", header = FALSE)[[1]]
trainActivityN  <- fread("train/y_train.txt", header = FALSE)[[1]]
trainData       <- read.table("train/X_train.txt")
trainData       <- data.table(trainData)

testSubjects    <- fread("test/subject_test.txt", header = FALSE)[[1]]
testActivityN   <- fread("test/y_test.txt", header = FALSE)[[1]]
testData        <- read.table("test/X_test.txt")
testData        <- data.table(testData)

trainSelected   <- trainData[, labelsSelectedN, with = FALSE]
testSelected    <- testData[, labelsSelectedN, with = FALSE]
workData        <- rbindlist(list(trainSelected, testSelected))
subjects        <- c(trainSubjects, testSubjects)
activityN       <- c(trainActivityN, testActivityN)

rm(testSelected)
rm(testData)
rm(testActivityN)
rm(testSubjects)
rm(trainSelected)
rm(trainData)
rm(trainActivityN)
rm(trainSubjects)
rm(featureLabels)

returnActivity <- function(x) {
    activityLabels[x]
}
activity <- sapply(activityN, returnActivity)
labels   <-c(labelsSelected, "Activity", "Subject")
workData <- cbind(workData, activity, subjects)

setnames(workData, labels)
