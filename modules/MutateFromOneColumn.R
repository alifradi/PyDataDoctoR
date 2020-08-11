SelectToMutateUI <- function(id,choices) {
  ns <- NS(id)
  tagList(
    selectInput(ns("ColOfMut"),label = 'Select column name',multiple = FALSE, choices = choices),
    selectInput(ns("AppMut"),label = 'Select function to apply',multiple = FALSE, choices = c('Min','Max','Mean','Median')),
    textInput(label = "New Column name", inputId = ns('NCName'),
              value = 'New_Column_name'
              #,value = paste('New',r,sep = '_')
    )
  )
}

SelectToMutateServer <- function(input, output, session) {
  x<-'%>% \n'
  if(input$AppMut == 'Min'){
    fun <- 'min('
  } else if(input$AppMut == 'Max'){
    fun <- 'max('
  } else if(input$AppMut == 'Mean'){
    fun <- 'mean('
  } else if(input$AppMut == 'Median'){
    fun <- 'median(' 
  }
  txt <- paste(x, 'mutate( ',input$NCName, ' = ', fun, input$ColOfMut,' ))')
  return(txt)
  
}