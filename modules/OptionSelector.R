OpSelectUI <- function(id,choices) {
  ns <- NS(id)
  tagList(
    selectInput(ns("OpSel"),label = 'Select operator',multiple = FALSE, choices = choices)
  )
}
OpSelectServer <- function(input, output, session) {
  return(
    as.character(input$OpSel)
  )
}