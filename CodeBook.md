Bruce R.
2/4/2020

# Study Design

This project takes data already collected and processed. The data is from a  
accelerometer and gyroscope of Samsung Phones. (See the README.md file for more information).

Here we restrict our analysis to only measurements that are means or standard deviations
of measurements. These are features with "mean()" or "std()" in their name. Note, there are
features that have "Mean" in their name but I chose not to include them because they
did not seem to be means calculated from measurements, as evidenced by the lack of corresponding 
standard deviation calculation.

# Code Book
The first step is to import the data. The data we want is the processed data. This data
is broken up into two sets, *test* and *train* located in two folders with corresponding names.
We import the data from the X, Y, and subject data from each folder. We then combine each 
to get X, Y, and subject data for the combined train and test data.

We then load the *feature.txt* which contains the column names for the X data set so we 
can add that to the X data. Now we only take the columns that have "mean()" or "std()" in 
their name.  Now we tidy up the names by removing parentheses, capitalize mean and std for 
"camelCase" readability, and finally replace abbreviations with full words.

We next read in the activity labels and recode Y so that it shows the name and not the 
number for the activity.

We can then combine the three data frames to get the final full data set.

There are 68 variables in this data set and 10299 observations. The data set is tidy 
since each row represents one observation: a subject (column 1) doing one activity (column 2). 
All other columns (3 through 68) are variables for the mean or standard deviation of a 
particular measurement from the sensors. 

The first variable is *subject* which stands for an individual that participated in the original 
study. There were 30 subjects, numbered 1 through 30.

The second variable is *activity* which is the activity the subject was doing when the 
data was collected. There are 6 activities: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
"SITTING", "STANDING", and "LAYING".

The rest of the data are derived from the following measurements:

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

These are processed data from the accelerometer and gyroscope measurements. For 
variables that have XYZ in their name, there are separate 
measurements for X, Y, and Z.  Variables 
that start with "t" (time) are measured in seconds. Variables that start with "f" (for freqency) 
are measured in hertz. Finally, the mean and standard deviations are recorded
for all of these which gives the 66 quantitative variables. 

Now that we have the data we want and the data is tidy and we can produce the 
summary table. Here we calculate the average for each 
of the means and standard deviations for each subject in each activity. Therefore, there are 
180 rows since each of the 30 subjects were recorded in 6 activities. 

The code to process the data is in the file "run_analysis.R". The script can be run if it
is in a folder that also contains the folder *UCI HAR Dataset*, from the zip file available here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Upon completion it will write a file named "summary_data.txt" which contains the tidy
data set of summaries. 

