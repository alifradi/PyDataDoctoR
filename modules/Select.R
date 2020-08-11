SelectUI <- function(id,choices) {
  ns <- NS(id)
  tagList(
    selectInput(ns("sName"),label = 'Select by name',multiple = TRUE, choices = choices)
  )
}
SelectServer <- function(input, output, session) {
  # output$textGpeBy <- renderText({
  x<-''
  for (k in input$sName) {
    x<-paste(x,k,', ')
  }
  x<- substr(x,1,nchar(x)-2)
  txt <- paste("%>%", "\n  select(",x,")",sep = '')
  return(txt)
  # })
}