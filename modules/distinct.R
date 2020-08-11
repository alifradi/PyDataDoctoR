distinctUI <- function(id) {
  ns <- NS(id)
  tagList()
}
distinctServer <- function(input, output, session) {
  x<-'%>% \n'
  txt <- paste(x, 'distinct(  )')
  return(txt)
}