##########################################
##########################################
############ cleaning and spliting #######
##########################################
##########################################
##########################################

#cleaning and spliting original data
########################################

#---------------------------------
#Obtaining data for cleaning
#---------------------------------
mydata=read.csv("C:\\Users\\System2\\Desktop\\suneel\\project1\\hospital readmission\\diabetic_data_NA.csv",header=T,sep=",")
mydata=mydata[,-c(6,11,12)]
summary(mydata)
names(mydata)
head(mydata)
mydata$diag_1=as.numeric(mydata$diag_1)
mydata$diag_2=as.numeric(mydata$diag_2)
mydata$diag_3=as.numeric(mydata$diag_3)
str(mydata)


#---------------------------------
#Missing value imputation
#---------------------------------
library(data.table)
library(MASS)
library(missForest)
library(ROCR)
library(rpart)

set.seed(1)
impr_data= missForest(mydata,mtry=3,ntree=5)
full_data=impr_data$ximp
names(full_data)

full_data$Sgot.Aspartate.Aminotransferase.=round(full_data$Sgot.Aspartate.Aminotransferase.)
full_data$Alkphos.Alkaline.Phosphotase.=round(full_data$Alkphos.Alkaline.Phosphotase.)

#---------------------------------
#Exporting the cleaned data
#---------------------------------
write.csv(full_data,"C:\\Users\\System2\\Desktop\\suneel\\project1\\hospital readmission\\diabetic_cleaneddata.csv")
sum(is.na(full_data))
#---------------------------------
#Obtaining train and test data
#---------------------------------
set.seed(10)
train=sample(seq_len(nrow(full_data)),size=nrow(full_data)*0.7)
train_data=full_data[train,]
test_data=full_data[-train,]

nrow(train_data)
nrow(test_data)

#---------------------------------
#Exporting train and test data
#---------------------------------
write.csv(train_data,"C:\\Users\\user\\Desktop/liver/train_data.csv")
write.csv(test_data,"C:\\Users\\user\\Desktop/liver/test_data.csv")
