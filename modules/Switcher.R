SwitcherServer <- function(input, 
                           output, 
                           session, 
                           #dataset, 
                           Operator) {
  df <- mtcars
  Operator <- reactive({Operator})
  choices <- names(df)
  code <- reactiveVal('')
  output$OperatorUI <- renderUI({
    if(Operator=='Group By'){
      return(GroupBytUI('line1',choices))
    }
    if(Operator=='Select'){
      SelectUI('line1',choices)
    }
  })
  code <- reactive({
    if(Operator=='Group By'){
      return(
        code(paste(code(), callModule(GroupByServer,"line1")))
      )
    }
    if(Operator=='Select'){
      return(
        code(paste(code(), callModule(SelectServer,"line1")))
      )
    }
  })
  
}

SwitcherUI <- function(id,choices) {
  uiOutput('OperatorUI')
}