##Download zip from URL provided and place in files directory (windows platform)
if(!file.exists("./files")){dir.create("./files")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(fileUrl, destfile=paste("files", destfile, sep="/"))
## unzip files and set date of download
unzip(paste("files", destfile, sep="/"), exdir="files")
data_dir <- setdiff(dir("files"), destfile)
dateDownloaded <- date()
## display the dateDownloaded
dateDownloaded

## create a the training directory
training_dir <- paste("files", data_dir, "train", sep="/")
## read the training subject table, add a oolumn name and create a dataframe
training_subject_df <- read.table(paste(training_dir, "subject_train.txt", sep="/"), col.names="subject")
## check the head of the dataframe
head(training_subject_df)

## get the labels, change the 2 column names and create a dataframe
labels_df <- read.table(paste("files", data_dir, "activity_labels.txt", sep="/"), col.names=c("labelcode", "label"))
## check the head of the dataframe
head(labels_df)

## get the features, change the 2 column names and create a dataframe
features_df <- read.table(paste("files", data_dir, "features.txt", sep="/"), col.names=c("featurecode", "feature"))
## check the head of the dataframe
head(features_df)

## desired feature indices (mean and std)
desiredFeatureIndices <- grep("mean\\(|std\\(", features_df[,2])  
## check the head for 10 matches
head(desiredFeatureIndices, 10)

## get the x_training values, use the feature names if names are not present
training_data_df <- read.table(paste(training_dir, "X_train.txt", sep="/"), col.names=features_df[,2], check.names=FALSE)
## check the head for 1 row of the dataframe
head(training_data_df, 1)

## filter the training_data_df using the indices
training_data_df <- training_data_df[,desiredFeatureIndices]
## check the head for 1 row of the dataframe
head(training_data_df, 1)

training_labels_df <- read.table(paste(training_dir, "Y_train.txt", sep="/"), col.names="labelcode")
## check the head for 1 row of the dataframe
head(training_labels_df, 1)

## bind the dataframes together
bound_training_df <- cbind(training_labels_df, training_subject_df, training_data_df)
## check the head for 1 row of the dataframe
head(bound_training_df, 1)

## Repeat these steps for the test files ..

## Now, set up the testing files:
## create a the testing directory
testing_dir <- paste("files", data_dir, "test", sep="/")
## read the testing subject table, add a oolumn name and create a dataframe
testing_subject_df <- read.table(paste(testing_dir, "subject_test.txt", sep="/"), col.names="subject")
## check the head of the dataframe
head(testing_subject_df)

## get the x_testing values, use the feature names if names are not present
testing_data_df <- read.table(paste(testing_dir, "X_test.txt", sep="/"), col.names=features_df[,2], check.names=FALSE)
## check the head for 1 row of the dataframe
head(testing_data_df, 1)

## filter the testing_data_df using the indices
testing_data_df <- testing_data_df[,desiredFeatureIndices]
## check the head for 1 row of the dataframe
head(testing_data_df, 1)

## get the y_testing values, use the label name (labelcode)
testing_labels_df <- read.table(paste(testing_dir, "Y_test.txt", sep="/"), col.names="labelcode")
## check the head for 1 row of the dataframe
head(testing_labels_df, 1)

## bind the dataframes together
bound_testing_df <- cbind(testing_labels_df, testing_subject_df, testing_data_df)
## check the head for 1 row of the dataframe
head(bound_testing_df, 1)

## Merge the 70% training dataset to the 30% testing dataset:
merged_df <- rbind(bound_training_df, bound_testing_df)
## check the head for 1 row of the merged dataset
head(merged_df, 1)

## Replace the label codes
replaced_labels_df <- merge(labels_df, merged_df, by.x="labelcode", by.y="labelcode")
## remove label
r_labels_df <- replaced_labels_df[,-1]
## check the head for 1 row of the replaced label and merged dataset
head(r_labels_df, 1)

## Reshape the dataset with reshape2 package:
library(reshape2)
molten <- melt(r_labels_df, id=c("label", "subject"))
head(molten)

## Now, let's make the tidy dataset with mean for each variable
tidy_dataset <- dcast(molten, label + subject ~ variable, mean)
head(tidy_dataset)

## Write the tidy_dataset
write.table(tidy_dataset, file="tidy.txt", quote=FALSE, row.names=FALSE, sep="\t")

## write the codeBook
write.table(paste("* ", names(tidy_dataset), sep=""), file="CodeBook.md", quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")



  