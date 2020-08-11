# Section Imports ------------------------------
library(shiny)
library(DT)
library(shinydashboard)
source('imports/LibRaries.R')
source('imports/LibMod.R')
source('imports/FeatureSelection.R')
source('imports/CollectData.R')
# ----  1. User interface  ----
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        fileInput('fileIn', 'Upload your  Excel File here'),
        textInput(label = "Data Name",inputId = 'DN',value = 'ali'),
        uiOutput('datasetnames'),
        actionButton("Get", label = 'Get')
      ),
      mainPanel(verticalLayout(
        uiOutput('tb')
        # verbatimTextOutput('minJob')
      )
        ))
  )

# ----  2. Server  ----
  
server <- function(input, output) {
# ----  2.1 Set Tab Panels  ----
output$tb <- renderUI({
  tabsetPanel(
    #  2.1.1 Environment Tab  ----
    tabPanel("Environment",
      # tableOutput("tabEnv")
      box(dataTableOutput('tableViewer'),style = "height:500px; overflow-y: scroll;
                                                    width:890px; overflow-x: scroll;")
    ),
    #  2.1.2 Plots and discovery  ----
    tabPanel("Data lab"
      
    ),
    #  2.1.3 Data wrangling  ----
    tabPanel("Viewer"
      
    ),
    #  2.1.4 History  ----
    tabPanel("History"
             
    ),
    #  2.1.5 Execute script  ----
    tabPanel("Execute script"
             
    )
  )
})
# ----  2.2 Reactive values  ----
code <- reactiveVal(value = "")
DataSets <- reactiveValues()
# ----  2.3 Import data  ----
observeEvent(input$Get, {
  code(paste(code(), paste(input$DN ,'<- readRDS(input$fileIn$datapath))','\n')))
  DataSets$dList <- c(isolate(DataSets$dList), as.data.frame(readRDS(input$fileIn$datapath)))
  eval(parse(text =paste(
    'DataSets$',input$DN,'<- c(isolate(DataSets$',input$DN,'), as.data.frame(readRDS(input$fileIn$datapath)))'
    ,sep = '') 
  ))
})
output$tableViewer <- renderDataTable({
  if(is.null(input$fileIn) | input$Get == 0){return()} else{
    data <- eval(parse(text = paste(sep = '','DataSets$',input$ETL)))
    as.data.frame(data) 
  }
})
# output$minJob <- renderText({
#   code()
# })
output$datasetnames <- renderUI({
  choices = names(DataSets)[names(DataSets)!='dList']
  selectInput(label = 'Data to load from Application environment',inputId = 'ETL',choices = choices)
})
# ----  2.4 Get Objects into environment  ----
# output$tabEnv <- renderTable({
#   DFN = names(DataSets)[names(DataSets)!='dList']
#   Nrow <- c()
#   Ncol <- c()
#   p=1
#   for (k in DFN) {
#     eval(parse(text = paste(sep = '','data <- as.data.frame(DataSets$',k,')')))
#     append(Nrow, nrow(data), after = 1)  
#     append(Ncol, ncol(data), after = 1)
#   }
#   
#   as.data.frame(DataSets = DFN, Rows = Nrow, Columns = Ncol)
# })

}
shinyApp(ui = ui, server = server)
