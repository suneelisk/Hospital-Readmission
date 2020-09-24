library(shiny)
library(shinydashboard)
library(plyr)
library(randomForest)
library(DT)
library(nnet)
library(dplyr)
library(shinyWidgets)

Logged = FALSE
my_username <- "patient"
my_password <- "readmission"


########################################################################################################################################################################

ui <- dashboardPage(skin='green',
                    
                    dashboardHeader(title="Prediction Hospital Readmission",titleWidth = 400,dropdownMenu(type="messages",
                                                                                                                  messageItem(from="ISKISK",message="WELCOME TO KSSS ANALYTICS"))
                                    
                    ),
                   # setBackgroundImage(src = "images.jpg"),
                    
                    
                    
                    
                    dashboardSidebar(
                      fileInput("file","Upload a Data",accept=c('csv','comma-seperated-values','.csv')),
                      downloadButton("downloadData", "Download"),
                      actionButton("myuser","Logout",icon=icon("user")),br(),
                      tags$div(class = "header", checked = NA,
                               tags$tbody("Need Help ?"),br(),
                               tags$a(href = "###", "Contact Us...")
                      )
                    ),
                    dashboardBody(
                      fluidRow(fluidPage(theme="bootstrap.min.css",
                                         
                                         tabBox ( width = 2000, height = 5500,
                                                  
                                                  
                                                  
                                                  tabPanel("Output", p("The aim of this application is to Predict will patient readmitted or not...",
                                                                       style="font-family:'Berlin sans FB Demi';font-size:12pt"),
                                                           box( width = 100,
                                                                title = "will patient to be readmitted ? ",status = "primary", solidHeader = TRUE,collapsible = TRUE,
                                                                dataTableOutput("y_cap"))), 
                                                  
                                                  
                                                  tabPanel("Patient likely to be readmitted within a month",
                                                           box( width = 20,
                                                                title = "Patient likely to be readmitted within a month",status = "success", solidHeader = TRUE,collapsible = TRUE,
                                                                dataTableOutput("rrr"))), 
                                                  
                                                  
                                                  tabPanel("Patient not likely to be readmitted within a month", 
                                                           box( width = 20,
                                                                title = "Patient not likely to be readmitted within a month",status = "danger", solidHeader = TRUE,collapsible = TRUE,
                                                                dataTableOutput("yyy")))
                                         )
                      )),verbatimTextOutput("dataInfo")
                    )
)
########################################################################################################################################################################       
set.seed(100000)
load("modelmultinom.rda")


server = function(input, output,session) {
  
  values <- reactiveValues(authenticated = FALSE)
  
  # Return the UI for a modal dialog with data selection input. If 'failed' 
  # is TRUE, then display a message that the previous value was invalid.
  dataModal <- function(failed = FALSE) {
    modalDialog(title = "Welcome to SDDDS...",
                textInput("username", "Username:"),
                passwordInput("password", "Password:"),
                footer = tagList(
                  #modalButton("Cancel"),
                  actionButton("ok", "OK")
                )
    )
  }
  
  # Show modal when button is clicked.  
  # This `observe` is suspended only whith right user credential
  
  obs1 <- observe({
    showModal(dataModal())
  })
  
  # When OK button is pressed, attempt to authenticate. If successful,
  # remove the modal. 
  
  obs2 <- observe({
    req(input$ok)
    isolate({
      Username <- input$username
      Password <- input$password
    })
    Id.username <- which(my_username == Username)
    Id.password <- which(my_password == Password)
    if (length(Id.username) > 0 & length(Id.password) > 0) {
      if (Id.username == Id.password) {
        Logged <<- TRUE
        values$authenticated <- TRUE
        obs1$suspend()
        removeModal()
        
      } else {
        values$authenticated <- FALSE
      }     
    } 
  })
  
  
  
  
  dataModal2 <- function(failed = FALSE) {
    modalDialog(fade = FALSE,title = tagList(h3("Thank You !!")),footer = NULL,
                tags$div(class = "header", checked = NA,
                         tags$h4("Visit us for more..."),
                         tags$a(href = "dhdkj", "hfhfh")
                )
    )
  }
  
  
  obs4 <- observe({
    if(Logged <<- TRUE)
      req(input$myuser)
    showModal(dataModal2())
  })
  
  ###########################################################################   
  
  output$dataInfo <- renderPrint({
    
    out <-reactive({
      file1 <- input$file
      if(is.null(file1)) {return(NULL)}
      data <- read.csv(file1$datapath,header=TRUE)
      withProgress(message='Loading table',value=30,{
        n<-10
        
        for(i in 1:n){
          incProgress(1/n,detail=paste("Doing Part", i, "out of", n))
          Sys.sleep(0.1)
        }
      })
      #data=data[,-c(1,2,3,7,8,9,10,16,17,26,27,29,30,,32,33,34,35,38)]
      pred_class=predict(model,data,type="class")
      test_predicted=ifelse(pred_class==1,"Patient readmitted with in a month",ifelse(pred_class==2,"Patient readmitted after a month","Not Admitted"))
      data.frame(data[1],test_predicted)
      
      
    })
    
    output$y_cap <- DT::renderDataTable(
      out(),options=list(scrollX=TRUE)
    ) 
    
    output$rrr <- renderDataTable({
      datatable(subset(out(),out()$test_predicted=="Patient readmitted with in a month"),options=list(scrollX=TRUE))
    }) 
    
    
    output$yyy <- renderDataTable({
      subset(out(),out()$test_predicted=="Patient readmitted after a month")
    },options=list(scrollX=TRUE)) 
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("final_table_output", ".csv", sep = "")
      },
      content = function(file) {
        write.csv(out(), file, row.names = FALSE)
      }
    )
    ############################################################################################################################################################ 
    
  })
  
}

############################################################################################################################################################

shinyApp(ui,server)

