SummarizeUI <- function(id,choices) {
  ns <- NS(id)
  tagList(
    selectInput(ns("ColOfSummary"),label = 'Select column name',multiple = FALSE, choices = choices),
    selectInput(ns("AppSummary"),label = 'Select function to apply',multiple = FALSE,
                choices = c('Min','Max','Mean','Median')),
  )
}
SummarizeServer <- function(input, output, session) {
  x<-'%>% \n'
  if(input$AppSummary == 'Min'){
    fun <- 'min('
  } else if(input$AppSummary == 'Max'){
    fun <- 'max('
  } else if(input$AppSummary == 'Mean'){
    fun <- 'mean('
  } else if(input$AppSummary == 'Median'){
    fun <- 'median(' 
  }
  txt <- paste(x, 'summarise( ',input$AppSummary,'_',input$ColOfSummary, ' = ', fun, input$ColOfSummary,' ))')
  return(txt)
}