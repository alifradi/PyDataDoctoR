SummaryeUI <- function(id) {
  ns <- NS(id)
  tagList()
}

SummaryServer <- function(input, output, session) {
  x<-'%>% \n'
  txt <- paste(x, 'summary( )')
  return(txt)
}