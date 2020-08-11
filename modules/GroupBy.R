GroupBytUI <- function(id,choices) {
  ns <- NS(id)
  tagList(
    selectInput(ns("gpe"),label = 'Group By',multiple = TRUE, choices = choices)
  )
}
GroupByServer <- function(input, output, session) {
  x<-''
  for (k in input$gpe) {
    x<-paste(x,k,', ')
  }
  x<- substr(x,1,nchar(x)-2)
  txt <- paste("%>%", "\n  group_by(",x,")",sep = '')
  return(txt)
  
}