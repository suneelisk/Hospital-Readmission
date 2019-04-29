library(caTools)
library(nnet)
library(dplyr)
mydata=read.csv("F:\\suneel\\suneel\\hospital readmission1\\diabetic_cleaneddata.csv",header=TRUE,sep=",")
head(mydata)
train_data=read.csv("F:\\suneel\\suneel\\hospital readmission1\\train.csv",header=TRUE,sep=",")
test_data=read.csv("F:\\suneel\\suneel\\hospital readmission1\\test.csv",header=TRUE,sep=",")
str(train_data)

train_data$readmitted=ifelse(train_data$readmitted=="<30","1",
                             ifelse(train_data$readmitted==">30","2","3"))
#test_data$readmitted=ifelse(test_data$readmitted=="<30","1",
         #                    ifelse(test_data$readmitted==">30","2","3"))

train_data$readmitted=as.factor(train_data$readmitted)
#test_data$readmitted=as.factor(test_data$readmitted)
str(train_data)
str(test_data)

(l <- sapply(train_data, function(x) is.factor(x)))
m=train_data[,l]
ifelse(n <- sapply(m, function(x) length(levels(x))) == 1, "DROP", "NODROP")
names(train_data)

train_data=train_data[,-c(37,38)]
model=multinom(readmitted~.,data=train_data)
summary(model)

observed=train_data$readmitted


pred_class=predict(model,test_data,type="class")
pred=predict(model,test_data,type="prob")
head(pred)
data_pred=cbind(test_data,pred)
head(data_pred)
mean(data_pred$"1")
mean(data_pred$"2")
mean(data_pred$"3")
#write.csv(data_pred,"data_pred.csv")


save(model,file = "modelmultinom.rda")
