# set working direction
setwd("./desktop/r/test/34")

#reading tables

Xtest <- read.table("X_test.txt")
Ytest <- read.table("y_test.txt" )
SubjectTest <- read.table("subject_test.txt")

Xtrain <- read.table("X_train.txt")
Ytrain <- read.table("y_train.txt" )
SubjectTrain <- read.table("subject_train.txt")

Features <- read.table("features.txt") # to asign headers later
Features[,2 ] <- gsub("[-()]", "", Features[,2]) # annoying extra -() from function
Features[,2 ] <- gsub("mean", "Mean", Features[,2]) # make mean pop 
Features[,2 ] <- gsub("std", "Std", Features[,2]) # make standart deviation pop, more intuitive to read. Not adding full name, as would make header unnecesary long. 
Features[,2 ] <- gsub(",gravity", "Gravity", Features[,2]) # misterious comma & lowercase gravity
Activity_labels <- read.table("activity_labels.txt")

#asigning headers

colnames(Xtest) <- Features[,2]
colnames(Ytest) <- "ActivityID"
colnames(SubjectTest) <- "SubjectID"

colnames(Xtrain) <- Features[,2]
colnames(Ytrain) <- "ActivityID"
colnames(SubjectTrain) <- "SubjectID"

colnames(Activity_labels) <- c("ActivityID",'ActivityType')

#binding data together

test <- cbind(Xtest, Ytest, SubjectTest)
train <-cbind(Xtrain, Ytrain, SubjectTrain)
TestNTrain <- rbind(test, train)
TestNTrain2 <- merge(TestNTrain, Activity_labels, by = "ActivityID")

keep <- grepl("Subject|Activity|Mean|Std", colnames(TestNTrain2))
keep2 <- TestNTrain2[, keep]

# averages

total <- aggregate(.~SubjectID + ActivityID, keep2, FUN = mean)
total2 <- total[order(total$SubjectID, total$ActivityID), ]

# save 
write.table(total2, "tidy_data_set.txt", row.names = FALSE)