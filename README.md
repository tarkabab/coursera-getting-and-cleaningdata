
Coursera: Getting and Cleaning Data Course Project
==================================================

Task:
-----
You should create one R script called run_analysis.R that does the following.  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

The initial datasets were:  
  features_filename <- "UCI HAR Dataset/features.txt"  
  activitylabels_filename <- "UCI HAR Dataset/activity_labels.txt"  

  testset_filename <- "UCI HAR Dataset/test/X_test.txt"  
  testsetactivities_filename <- "UCI HAR Dataset/test/y_test.txt"  
  testsetsubjects_filename <- "UCI HAR Dataset/test/subject_test.txt"  
  trainset_filename <- "UCI HAR Dataset/train/X_train.txt"  
  trainsetactivities_filename <- "UCI HAR Dataset/train/y_train.txt"  
  trainsetsubjects_filename <- "UCI HAR Dataset/train/subject_train.txt"  


### Step 1. Merges the training and the test sets to create one data set.

First load all the initial datasets, and make some basic consistency checks.

We concetanete the test and train datasets with rbind.  
Remark: rbind works if the number of columns in the two datasest are the same,
 and there are no duplicates in the column names.

### Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

The features_info.txt describes the data in the test and train sets.  
The inportant bit here is the feature vector names:

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

and the estimate names:

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

The full list can be found in the features.txt file provided.  
The column names of the test and train sets are in the second column of this table.

We are interested in only in the mean and std deviation of measurements.  
We can filter the column names with grep("mean()|std()", which give us 66 results.  
That is exactly the number if we combine the feature vector names (the one with XYZ counts 3) with the estimate names (8*3+9)*2 = 66.  
We create a logical vector with the help of the grep, and
use the logical vector to extract the columns we are interested in.

### 3. Uses descriptive activity names to name the activities in the data set

Before we add columns to the merged dataset, its easier to add the names of the columns with the help of the logical vector now. After that, if we add descriptive names to the new columns, we are basically done with step 4.

The activities for the train and test sets are in the  y_train.txt and y_test.txt files respectively.  
The activity labels are in the activity_labels.txt.

We combine the train and test sets with rbind first, than we add the resulting set as a new column ("activity_id") to the originally merged dataset.  
To complete the task, based on the new column and the activity names in activity_labels.txt, with the help of the match R command, we add another column containing the activity names ("activity")

### 4. Appropriately labels the data set with descriptive variable names.

We did this step in Step 3.
 
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

We add a new testsubject column to our dataset. (after we first rbind-ed the train and test subject data)  
We use aggregate to do the groupping and the avarage calculation on the originally extracted 66 columns.  
As a last step, we save the dataset to the file "averageBySubjectAndActivity.txt".
