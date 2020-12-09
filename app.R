# Section Imports ------------------------------
source('imports/LibRaries.R')
source('imports/LibMod.R')
source('imports/FeatureSelection.R')
source('imports/CollectData.R')
# ----  1. User interface  ----
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
    #  1.1 Sidebar Panel  ----
        fileInput('fileIn', 'Upload your RDS File here'),
        textInput(label = "Data Name",inputId = 'DN',value = 'NewData'),
        uiOutput('datasetnames'),
        actionButton("Get", label = 'Import')
      ),
    #  1.2 MainPanel  ----
      mainPanel(verticalLayout(
        #  1.2.1 Pannels
           uiOutput('tb')
      )
        ))
  )

# ----  2. Server  ----
options(shiny.maxRequestSize = 1000*1024^2)
server <- function(input, output,session) {
# ----  2.1 Set Tab Panels  ----
output$tb <- renderUI({
  tabsetPanel(
    #  2.1.1 Environment Tab  ----
    tabPanel("Environment",
      # tableOutput("tabEnv")
      box(dataTableOutput('tableViewer'),style = "height:700px; overflow-y: scroll;
                                                    width:890px; overflow-x: scroll;")
    ),
    #  2.1.2 Plots and discovery  ----
    tabPanel("Data lab",
      radioButtons(label = "Experiment Controls", inputId = 'ExpCtrl',choices = c('Start a new experiement',
                                                                                 'Choose operations',
                                                                                 'End the job')),
      actionButton('Flush Code', inputId = 'MJRes'),
      actionButton('Apply', inputId = 'Apply'),
      actionButton('Save to job directory', inputId = 'toDirect'),
      uiOutput('SelecByRadio'),
      uiOutput('SelectedUIPanel'),
    #  Mini Job code  ----

      splitLayout(textInput(label = 'State output name', inputId = 'MinJobCodeVar', value = stri_rand_strings(1, 10))
        ,verbatimTextOutput('minJOB'))
      
    ),
    #  2.1.3 Data wrangling  ----
    tabPanel("Viewer"
      
    ),
    #  2.1.4 History  ----
    tabPanel("History",
            verbatimTextOutput('JOB') 
    ),
    #  2.1.5 Execute script  ----
    tabPanel("Execute script",
             actionButton(label = "Evaluate", inputId = 'EvCode'),
             textInput(label = 'Type your R script down here',inputId = 'scrEval',value = as.character("1+2")),
             verbatimTextOutput('resSrc')
             
    )
  )
})
    #  2.1.6 Radio selected controls  ----
    output$SelecByRadio <- renderUI({
    if(input$ExpCtrl=='Choose operations'){
    return(
      OpSelectUI('testOptionSelector',c('Group By','Select','Apply function on one single Column',
                                  'Summarize by function','Summary','Unique rows','Add Index'))
    )
  } else if(input$ExpCtrl=='Start a new experiement'){
    }
})
    #  2.1.7 Build miniJob with selected operators  ----
    observeEvent(input$Apply, {
      
      if(is.null(input$fileIn) | input$Get == 0){return()} else{
        data <- as.data.frame(eval(parse(text = paste(sep = '','DataSets$',input$ETL))))
      }
      
      if(callModule(OpSelectServer,'testOptionSelector')=='Group By'){
         MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(GroupByServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Select'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(SelectServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Apply function on one single Column'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(SelectToMutateServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Summarize by function'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(SummarizeServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Summary'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(SummaryServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Unique rows'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(distinctServer,"line1"))
      }else if(callModule(OpSelectServer,'testOptionSelector')=='Add Index'){
        MiniJobCode$foo <- paste( MiniJobCode$foo, callModule(AddIndexServer,"line1",nrow(data)))
      }
    })

    #  2.1.8 Generate operators UI part  ----
    output$SelectedUIPanel <- renderUI({
      if(!is.null(input$ETL)){
        if(is.null(input$fileIn) | input$Get == 0){return()} else{
          data <- eval(parse(text = paste(sep = '','DataSets$',input$ETL)))
          as.data.frame(data) }
          choices <- names(data)
        if(callModule(OpSelectServer,'testOptionSelector')=='Group By'){
          return(GroupBytUI('line1',choices))
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Select'){
          SelectUI('line1',choices)
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Apply function on one single Column'){
          SelectToMutateUI("line1",choices)
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Summarize by function'){
          SummarizeUI("line1",choices)
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Summary'){
          SummaryeUI("line1")
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Unique rows'){
          distinctUI("line1")
        }else if(callModule(OpSelectServer,'testOptionSelector')=='Add Index'){
          AddIndexUI("line1")
        }else{
          return()
        }
      }
    })
    
    
# ----  2.2 Reactive values  ----
code <- reactiveVal(value = "")
DataSets <- reactiveValues()
MiniJobCode <- reactiveValues('foo' = "")
JobCode <- reactiveValues('foo' = "")

    #  2.2.1 default naming for data  ----
    observe({x<-input$Get
  updateTextInput(session, "DN", value = paste('Data_',x,sep = ''))
})
# ----  2.3 Import data into environment and show it ----
        observeEvent(input$Get, {
          DataSets$dList <- c(isolate(DataSets$dList), as.data.frame(readRDS(input$fileIn$datapath)))
          eval(parse(text =paste(
          'DataSets$',input$DN,'<- c(isolate(DataSets$',input$DN,'), as.data.frame(readRDS(input$fileIn$datapath)))'
          ,sep = '')))
        })
        output$tableViewer <- renderDT({
          if(is.null(input$fileIn) | input$Get == 0){return()} else{
          data <- eval(parse(text = paste(sep = '','DataSets$',input$ETL)))
          datatable(as.data.frame(data),filter = "top",options = list(
            pageLength = 5
          ))
         }
        })
        output$datasetnames <- renderUI({
          choices = names(DataSets)[names(DataSets)!='dList']
          selectInput(label = 'Data to load from Application environment',inputId = 'ETL',choices = choices)
        })
# ----  2.5 Code the mini job  ----
        observeEvent(input$ExpCtrl, {
          if(input$Get > 0 & input$ExpCtrl == 'Start a new experiement')
           {MiniJobCode$foo <- paste(MiniJobCode$foo,input$MinJobCodeVar ,' <- ', input$ETL, sep = '')}
        })
        observeEvent(input$MJRes, {
          MiniJobCode$foo <- ""
        })
        output$minJOB <- renderText({
          MiniJobCode$foo
        })
    #  2.6 Code the Job  ----
        observeEvent(input$toDirect, {
          JobCode$foo <- paste(JobCode$foo, MiniJobCode$foo, sep = '\n')
        })
        output$JOB <- renderText({
          JobCode$foo
        })
    #  2.7 Execute code  ----
        
        
        observeEvent(input$EvCode, {
          out = eval(parse(text = input$scrEval))
          output$resSrc<- renderText({
            return(out)
          })
        })
# ----  End  ----
}
shinyApp(ui = ui, server = server)
