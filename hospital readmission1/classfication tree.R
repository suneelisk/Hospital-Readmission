library(caTools)
library(rpart)
library(rpart.plot)
library(dplyr)
mydata=read.csv("F:\\suneel\\suneel\\hospital readmission1\\diabetic_cleaneddata.csv",header=TRUE,sep=",")
head(mydata)
train_data=read.csv("F:\\suneel\\suneel\\hospital readmission1\\train.csv",header=TRUE,sep=",")
test_data=read.csv("F:\\suneel\\suneel\\hospital readmission1\\test.csv",header=TRUE,sep=",")
str(train_data)


train_data$readmitted=ifelse(train_data$readmitted=="<30","lessthanthirty",
                             ifelse(train_data$readmitted==">30","greaterthanthirty","NO"))
test_data$readmitted=ifelse(test_data$readmitted=="<30","lessthanthirty",
                            ifelse(test_data$readmitted==">30","greaterthanthirty","NO"))

train_data$readmitted=as.factor(train_data$readmitted)
test_data$readmitted=as.factor(test_data$readmitted)
str(train_data)
str(test_data)

model=rpart(readmitted~.,data=train_data,method="class",cp=0.01099)
summary(model)
rpart.plot(model,extra=104)

pred=predict(model,test_data,type="prob")

head(pred)

data_pred=cbind(test_data,pred)
head(data_pred)
mean(data_pred$lessthanthirty)
mean(data_pred$greaterthanthirty)
mean(data_pred$NO)


save(model,file="model.rda")
