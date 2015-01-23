## Load data.table library, so data tables can be used instead of data frames
library(data.table)

## Read the list of features into a vector (hence the [[1]]), drop line numbers
featureLabels   <- fread("features.txt", header = FALSE, drop = 1)[[1]]
## Generate a numeric vector of columns containing 'mean()' or 'std()'
labelsSelectedN <- c(grep('mean()', featureLabels, fixed = TRUE), 
                     grep('std()', featureLabels, fixed = TRUE)
                   )
## Sort that vector and throw out possible doubles
labelsSelectedN <- sort(unique(labelsSelectedN))
## Build the corresponding character-vector
labelsSelected  <- featureLabels[labelsSelectedN]

## Read the list of activities into a vector (hence the [[1]]), drop line numbers
activityLabels  <- fread("activity_labels.txt", header = FALSE, drop = 1)[[1]]
## Convert the activity labels to lowercase
activityLabels  <- tolower(activityLabels)

## Read list of training-data subjects, extract the only vector [[1]]
trainSubjects   <- fread("train/subject_train.txt", header = FALSE)[[1]]
## Read numeric list of training-data activities, extract the only vector [[1]]
trainActivityN  <- fread("train/y_train.txt", header = FALSE)[[1]]
## Read training data. Using fread for this data in data.table 1.9.4 crashes R
trainData       <- read.table("train/X_train.txt")
trainData       <- data.table(trainData)

## Read list of test-data subjects, extract the only vector [[1]]
testSubjects    <- fread("test/subject_test.txt", header = FALSE)[[1]]
## Read numeric list of test-data activities, extract the only vector [[1]]
testActivityN   <- fread("test/y_test.txt", header = FALSE)[[1]]
## Read test data. Using fread for this data in data.table 1.9.4 crashes R
testData        <- read.table("test/X_test.txt")
testData        <- data.table(testData)

## Extract the required columns from training-dataset
trainSelected   <- trainData[, labelsSelectedN, with = FALSE]
## Extract the required columns from test-dataset
testSelected    <- testData[, labelsSelectedN, with = FALSE]
## Merge them to get the working dataset
workData        <- rbindlist(list(trainSelected, testSelected))
## Merge the corresponding vectors of subjects
subjects        <- c(trainSubjects, testSubjects)
## Merge the corresponding numeric vectors of activities
activityN       <- c(trainActivityN, testActivityN)

## Clean up!
## Remove data that is not needed anymore
rm(testSelected)
rm(testData)
rm(testActivityN)
rm(testSubjects)
rm(trainSelected)
rm(trainData)
rm(trainActivityN)
rm(trainSubjects)
rm(featureLabels)

## Build a character-vector of activities
activity <- sapply(activityN, function(x) activityLabels[x])
## Merge vectors of subjects and activities into working dataset
workData <- cbind(subjects, activity, workData)
## Build a vector of column labels
labels   <-c("Subject", "Activity", labelsSelected)

## Clean up one more time!
rm(subjects)
rm(activityN)
rm(activity)
rm(activityLabels)
rm(labelsSelectedN)
rm(labelsSelected)

## Improve column labels
labels   <- sapply(labels, function(x) gsub("-mean()-X", ".X.mean", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-mean()-Y", ".Y.mean", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-mean()-Z", ".Z.mean", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-mean()", ".mean", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-std()-X", ".X.std", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-std()-Y", ".Y.std", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-std()-Z", ".Z.std", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("-std()", ".std", x, fixed = TRUE), USE.NAMES = FALSE)
labels   <- sapply(labels, function(x) gsub("BodyBody", "Body", x, fixed = TRUE), USE.NAMES = FALSE)
## Apply column names to working dataset
setnames(workData, labels)
## Reorder columns alphabetically, except for 'Subject' and 'Activity'
workData <- setcolorder(workData, 
                        c("Subject",
                          "Activity",
                          sort(labels[3:length(labels)])
                        )
                       )
## Extract reordered column labels
labels <- colnames(workData)

## Compile a table of average (== mean) data per subject and activity
meanData <- data.table(
                aggregate(subset(workData, ,3:68), 
                          list(workData$Subject, workData$Activity), 
                          mean
                )
            )
## Restore column names
setnames(meanData, labels)
## Rename activities to indicate they are now representing averages (means)
meanData$Activity <- paste(meanData$Activity, "mean", sep = ".")

## Finally write the tidy average dataset to disk
write.table(meanData, "tidy_data_mean.txt", row.name = FALSE)