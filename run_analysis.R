library(data.table)

featureLabels  <- fread("features.txt", header = FALSE, drop = c(1))[[1]]
activityLabels <- fread("activity_labels.txt", header = FALSE, drop = c(1))[[1]]

testSubjects   <- fread("test/subject_test.txt", header = FALSE)[[1]]
testActivity   <- fread("test/y_test.txt", header = FALSE)[[1]]
testData       <- read.table("test/X_test.txt")

testSelect <- c(grep("mean()", featureLabels), grep("std()", featureLabels))
testSelect <- sort(unique(testSelect))
