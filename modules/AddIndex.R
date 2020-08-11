AddIndexServer <- function(input, output, session,nrowData) {
  txt <- paste("%>%", "\n  cbind( Index = c(1:",nrowData,"))",sep = '')
  return(txt)
}

AddIndexUI <- function(id) {
  ns <- NS(id)
  tagList()
}