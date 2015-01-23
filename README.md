# README for "run_analysis.R"
## Course project for the "Getting and Cleaning Data" course on Coursera

The library 'data.table' is needed for 'fread()' and to work with data tables.

The working directory should be set to the root of the 'UCI HAR Dataset'
directory. The script reads the files 'features.txt' and 'activity_labels.txt' 
from the working directory, 'subject_train.txt', 'y_train.txt' and 'X_train.txt'
from the 'train'-subdirectory, and 'subject_test.txt', 'y_test.txt' and 
'X_test.txt' from the 'test'-subdirectory.

The list of feature-names is read into *featureLabels*. The numbers of the
feature-names containing 'mean()' or 'std()' are collected in the numeric
vector *labelsSelectedN*. The corresponding character vector is *labelsSelected*.

The names of activities are read into *activityLabels* and converted to 
lowercase to improve readability. The index of each activity corresponds to its
number used in *activityN*.

The id-numbers of the subjects (1-30) on which the measurements were performed
are read into *trainSubjects* and *testSubjects*, for training-data and
test-data respectively.

The numeric values of each activity (1-6) for which the measurements were 
performed are read into *trainActivityN* and *testActivityN*, for training-data
and test-data respectively.

The tables of measurements corresponding to the labels in *featureLabels* are
read into *trainData* and *testData*, for training-data
and test-data respectively.

To work on smaller datasets the columns corresponding to *labelsSelectedN*, which
are the ones we are interested in, are copied to *trainSelected* and
*testSelected*, for training-data and test-data respectively.

Now the training-data and test-data are merged. The merged data tables go into
*workData*, the merged numeric list of subjects goes into *subjects* and the 
numeric list of activities goes into *activityN*.

First cleanup. Delete data that is no longer needed.

Now create a character vector of activities, *activity*, by taking the activity
name from *activityLabels* corresponding to the number in *activityN*.

Add *subjects* and *activity* as the first and second columns of *workData*.

The character vector *labels* now holds the names of the columns, including
"Subject" and "Activity". The other column names are the ones given
by *featureLabels*.

Second cleanup. Unneeded data is deleted.

Before we name the columns in the working dataset the given names are beautified
a bit by removing parts of the names illegal in R and double uses of 'Body'.
Now the *labels* vector is applied as names for the columns in *workData*.

The columns in *workData*, except for "Subject" and "Activity" are ordered in
alphabetic order. Thus each column containing a mean is follow by its standard
deviation. 

The tidy dataset as requested by step 4 in the course project is now stored
in *workData*.

For step 5 we take the mean of all mesurements for each subject and activity and
store them in *meanData*. This data is ordered by activity and subordered by
subject. Since we have 30 subjects with 6 activities it contains 180 rows.

Now the column names of the working data are applied to the mean data because
"Subject" and "Activity" got lost in the previous step.

We append '.mean' to each activity-name to indicate that is a mean over several 
measurements of that activity. 

Now the average data is written to the file 'tidy_data_mean.txt' as requested by
the instructions. Step 5 completed!

Read the table with:
library(data.table)
tidyData <- fread("tidy_data_mean.txt")