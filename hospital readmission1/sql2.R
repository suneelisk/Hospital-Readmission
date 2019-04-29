install.packages("RODBC")
install.packages("dplyr")
install.packages("ggplot2") 
library("RODBC")
library("dplyr")
library("ggplot2")


conn <- odbcDriverConnect('driver={SQL Server};server=localhost,port=suneel12;database=diabetes_train;trusted_connection=true')


library(Rodbc)

channel <- odbcConnect("statistic", uid="suneel12", pwd="Suneel!2")SQLServer



C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\statistics\\diabetes_train.ibd






library(odbc)
con <- dbConnect(odbc(),
                 Driver = "RMySQL::MySQL()",
                 Server = "localhost",
                 Database = "diabetes_train",
                 UID = "suneel12",
                 PWD = rstudioapi::askForPassword(prompt = "Suneel!2"),
                 Port = 3306)



