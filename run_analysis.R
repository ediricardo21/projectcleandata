library(dplyr)
# Reading data ------------------------------------------------------------

#Assigning a dataset to names
names <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/features.txt")
names <- names$V2

#Reading dataset 1 
datatest <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/test/X_test.txt")
testy <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/test/y_test.txt")
testsubject <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/test/subject_test.txt")

#Assigning names to  dataset 1 and selecting
datatest <- datatest %>% mutate(Activity=testy$V1,subject=testsubject$V1) %>% select(c(Activity,subject,1:563))
colnames(datatest) <- c("Activity","Subject",names)


#Reading dataset 2

datatrain <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/train/x_train.txt")
trainy <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/train/y_train.txt")
trainsubject <- read.table("C:/Users/ediri/Desktop/Curso R/Johns Hopkins University/Cleanning Data/projectcleandata/UCI HAR Dataset/train/subject_train.txt")

#Assigning names to  dataset 2 and selecting
datatrain <- datatrain %>% mutate(Activity=trainy$V1,subject=trainsubject$V1) %>% select(c(Activity,subject,1:563))
colnames(datatrain) <- c("Activity","Subject",names)
 #Merging datasets

mergedata <- rbind(datatest,datatrain)
colnames(mergedata) <- c("Activity","Subject",names)


# Extracting correct values from  merge data ------------------------------------------------------

mergedata <- mergedata %>% select(Activity,Subject,contains("-mean")|contains("-st"))
mergedata$Activity <- factor(mergedata$Activity)
mergedata$Subject <- as.factor(mergedata$Subject)
#Assigning levels
levels(mergedata$Activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")



# Casting -----------------------------------------------------------------

library(reshape2)
#Formating
tidy <- melt(mergedata, id = c("Subject", "Activity"))
tidy$variable <-  gsub("-mean"," Mean",tidy$variable)
tidy$variable <-  gsub("[-()]"," ",tidy$variable)
tidy$variable <-  gsub("std","Std",tidy$variable)

colnames(tidy) <- c("Subject","Activity","Variable","Value")

#Create final tidydataset

tidydata <- dcast(tidy,Subject+Activity~ Variable,mean,value.var = "Value")
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)

