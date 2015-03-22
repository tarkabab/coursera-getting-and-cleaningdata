run_analyzis <- function() {
  
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 
# Good luck!
  
  features_filename <- "UCI HAR Dataset/features.txt"
  activitylabels_filename <- "UCI HAR Dataset/activity_labels.txt"

  testset_filename <- "UCI HAR Dataset/test/X_test.txt"
  testsetactivities_filename <- "UCI HAR Dataset/test/y_test.txt"
  testsetsubjects_filename <- "UCI HAR Dataset/test/subject_test.txt"
  trainset_filename <- "UCI HAR Dataset/train/X_train.txt"
  trainsetactivities_filename <- "UCI HAR Dataset/train/y_train.txt"
  trainsetsubjects_filename <- "UCI HAR Dataset/train/subject_train.txt"
  
  #
  # helper functions
  #
  
  # load
  load <- function(dataname, filename, columnnames=NULL) {
    print(paste("load", dataname, "from: ", filename))
    if(is.null(columnnames)) {
      data <- read.table(filename)
    }
    else {
      data <- read.table(filename, col.names = columnnames)
    }
    if(nrow(data)==0) {
      stop("error, could not load", dataname)
    }
    return(data)
  }
  
  
  #
  # Load initial datasets
  #
  print("Loading initial dataset...")

  # load features
  features <- load("features", features_filename, c("feature_id","feature_name"))
  # load activity labels
  activitylabels <- load("activity labels", activitylabels_filename, c("activity_id","activity_name"))

  # load trainset
  trainset <- load("trainset", trainset_filename)
  # load testset
  testset <- load("testset", testset_filename)
  # load activities of trainset
  trainsetactivities <- load("train set activities", trainsetactivities_filename, "activity_id")
  # load activities of testset
  testsetactivities <- load("test set activities", testsetactivities_filename, "activity_id")
  # load subjects of trainset
  trainsetsubjects <- load("train set subjects", trainsetsubjects_filename, "subject_id")
  # load subjects of testset
  testsetsubjects <- load("test set subjects", testsetsubjects_filename, "subject_id")

  print("done")  
  
  
  #
  # Consistency checks
  #
  print(paste("Number of NAs in the trainset: ", sum(is.na(trainset))))
  print(paste("Number of NAs in the testset:", sum(is.na(testset))))
  if(nrow(features) != ncol(trainset)) {
    stop("inconsistent data: number of features in trainset (", length(names(trainset)), ")\n",
         "                   number of features in features (", nrow(features), ")")
  }
  if(nrow(features) != ncol(testset)) {
    stop("inconsistent data: number of features in testset (", length(names(testset)), ")\n",
         "                   number of features in features (", nrow(features), ")")
  }
  if(nrow(trainset) != nrow(trainsetactivities)) {
    stop("inconsistent data: number of rows in trainset (", nrow(trainset), ")",
         "                   number of rows in trainset activities (", nrow(trainsetactivities), ")")
  }
  if(nrow(testset) != nrow(testsetactivities)) {
    stop("inconsistent data: number of rows in testset (", nrow(testset), ")",
         "                   number of rows in testset activities (", nrow(testsetactivities), ")")
  }
  if(nrow(trainset) != nrow(trainsetsubjects)) {
    stop("inconsistent data: number of rows in trainset (", nrow(trainset), ")",
         "                   number of rows in trainset subjects (", nrow(trainsetsubjects), ")")
  }
  if(nrow(testset) != nrow(testsetsubjects)) {
    stop("inconsistent data: number of rows in testset (", nrow(testset), ")",
         "                   number of rows in testset subjects (", nrow(testsetsubjects), ")")
  }
  
  #
  # 1. Merges the training and the test sets to create one data set.
  #
  completeset <- rbind(testset,trainset)
  

  #
  # 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  # 
  # tBodyAcc-XYZ
  # tGravityAcc-XYZ
  # tBodyAccJerk-XYZ
  # tBodyGyro-XYZ
  # tBodyGyroJerk-XYZ
  # tBodyAccMag
  # tGravityAccMag
  # tBodyAccJerkMag
  # tBodyGyroMag
  # tBodyGyroJerkMag
  # fBodyAcc-XYZ
  # fBodyAccJerk-XYZ
  # fBodyGyro-XYZ
  # fBodyAccMag
  # fBodyAccJerkMag
  # fBodyGyroMag
  # fBodyGyroJerkMag
  # 
  # mean(): Mean value
  # std(): Standard deviation

  # create logical vector on measures of interests
  print("create logical vector on measures of interests")
  meanAndStdIndexes <- features[grep("mean\\(\\)|std\\(\\)", features$feature_name), "feature_id"]
  print("done")
  # extract columns based on logical vector
  print("extract columns based on logical vector")
  extracted <- completeset[, meanAndStdIndexes]
  print("done")
  
  
  #
  # 3. Uses descriptive activity names to name the activities in the data set
  #
  
  # work ahead: set names of extracted columns with the help of the logical index
  print("set names of extracted columns")
  names(extracted) <- features[meanAndStdIndexes,"feature_name"]
  print("done")
  # add activity_id column to the extracted dataset
  print("add activity_id column")
  extracted$activity_id <- rbind(testsetactivities, trainsetactivities)[,"activity_id"]
  print("done")
  # map activity names to new activity column
  print("map activity names to activity_id")
  extracted$activity = activitylabels[ match(extracted$activity_id, activitylabels$activity_id) , "activity_name"]
  print("done")
  
  
  #
  # 4. Appropriately labels the data set with descriptive variable names. 
  # done in step 3
  
  
  #
  # 5. From the data set in step 4, creates a second, independent tidy data set
  #    with the average of each variable for each activity and each subject.
  
  # add subject column to extracted set
  print("add subject column")
  extracted$subjects <- rbind(testsetsubjects, trainsetsubjects)[,"subject_id"]
  print("done")
  # group by subject and activity, and calculate avarage
  print("group by subject and activity, and calculate avarage")
  averageBySubjectAndActivity <- aggregate(extracted[,1:66], list(Subject = extracted$subjects, Activity = extracted$activity), mean)
  print("done")
  # write result to txt file
  print("write result to txt file: 'averageBySubjectAndActivity.txt'")
  write.table(averageBySubjectAndActivity, "averageBySubjectAndActivity.txt", row.names = FALSE)
  print("done")
  
}