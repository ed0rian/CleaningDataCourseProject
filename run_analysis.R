library(data.table)

featureLabels   <- fread("features.txt", header = FALSE, drop = c(1))[[1]]
labelsSelectedN <- c(grep("mean()", featureLabels), grep("std()", featureLabels))
labelsSelectedN <- sort(unique(labelsSelectedN))
labelsSelected  <- featureLabels[labelsSelectedN]

activityLabels  <- fread("activity_labels.txt", header = FALSE, drop = c(1))[[1]]

trainSubjects   <- fread("train/subject_train.txt", header = FALSE)[[1]]
trainActivity   <- fread("train/y_train.txt", header = FALSE)[[1]]
trainData       <- read.table("train/X_train.txt")
trainData       <- data.table(trainData)

testSubjects    <- fread("test/subject_test.txt", header = FALSE)[[1]]
testActivity    <- fread("test/y_test.txt", header = FALSE)[[1]]
testData        <- read.table("test/X_test.txt")
testData        <- data.table(testData)

trainSelected   <- trainData[, labelsSelectedN, with = FALSE]
testSelected    <- testData[, labelsSelectedN, with = FALSE]
workData        <- rbindlist(list(trainSelected, testSelected))
subjects        <- c(trainSubjects, testSubjects)
activity        <- c(trainActivity, testActivity)

rm(testSelected)
rm(testData)
rm(testActivity)
rm(testSubjects)
rm(trainSelected)
rm(trainData)
rm(trainActivity)
rm(trainSubjects)
rm(featureLabels)

