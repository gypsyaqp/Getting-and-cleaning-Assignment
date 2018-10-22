library(dplyr)
sub1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt",stringsAsFactors = FALSE, header = FALSE)
subjectrain<-tbl_df(sub1)#subject
subjectrain<-rename(subjectrain,subject=V1)
rm(sub1)

ytrain1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt",stringsAsFactors = FALSE, header = FALSE)
ytrain<-tbl_df(ytrain1)
ytrain<-rename(ytrain,activity=V1)
rm(ytrain1)

xtrain1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt",stringsAsFactors = FALSE, header = FALSE)
xtrain<-tbl_df(xtrain1)
rm(xtrain1)
#reading test files
sub1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt",stringsAsFactors = FALSE, header = FALSE)
subjectest<-tbl_df(sub1)#subject
subjectest<-rename(subjectest,subject=V1)
rm(sub1)

acti2<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt",stringsAsFactors = FALSE, header = FALSE)
ytest<-tbl_df(acti2)
ytest<-rename(ytest,activity=V1)
rm(acti2)

xtest1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt",stringsAsFactors = FALSE, header = FALSE)
xtest<-tbl_df(xtest1)
rm(xtest1)

feat1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\features.txt",stringsAsFactors = FALSE, header = FALSE)
feat<-tbl_df(feat1)
rm(feat1)

acti1<-read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt",stringsAsFactors = FALSE, header = FALSE)
acti<-tbl_df(acti1)
rm(acti1)

names(xtrain)<-feat$V2 #names to variables in xtrain data frame
names(xtest)<-feat$V2 #names to variables in xtest data frame

total1 = cbind(ytest, subjectest, xtest)

total = cbind(ytrain, subjectrain, xtrain)

totalf=rbind(total1,total) #merge two data sets
View(totalf)   # two data sets together

ff2<-totalf[,grep("activity|subject|mean()|std()",names(totalf))] #filter mean and std only
totalf1<-select(ff2,-grep("Freq",names(ff2)))# remove Freq

View(totalf1) # data set with mean and std variables only

totalend<-merge(totalf1,acti,by.x = "activity",by.y = "V1" , all.x = TRUE) #MERGES BASED IN v1 FOR BOTH DATA FRAMES

totalend<-totalend%>%select(V2,everything(),-activity)%>%rename(activity=V2) #order columns in the data set

View(totalend) #data set with activity labels

average<-aggregate(.~subject+activity,totalend, mean)#REFERENCE activity and subject the rest is the mean
average<-arrange(average,average$subject)# order average based on subject variable
View(average)  #average of variables

write.table(average, "average.txt", row.name=FALSE)# creates the second  data frame in the working directory