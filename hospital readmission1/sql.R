library(RODBC)
library(RMySQL)

odbcConnect(,uid = "suneel12", pwd = "Suneel!2")
myconn=odbcDriverConnect(connection="Driver={SQL Server}; server=localhost;database=diabetes_train;trusted_connection=yes;")


con=dbConnect(RMySQL::MySQL(),
              dbname="statistics",
              host="localhost",port=3306,
              user="suneel2",
              password="Suneel!2")

devtools::install_github("r-dbi/odbc")
require(odbc)
require(ODB)
require(RODBC)


con <- dbConnect(odbc::odbc(), .connection_string = "Driver={SQL Server};")



library(RODBC)
dbhandle <- odbcDriverConnect('driver={SQL 
Server};server=suneel12;database=diabetes_train;trusted_connection=true')
res <- sqlQuery(dbhandle, 'select * from information_schema.tables')