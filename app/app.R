# Section Imports ------------------------------
library(shiny)
# ----  1. User interface  ----
  ui <- fluidPage(
    uiOutput('tb')

)

# ----  2. Server  ----
  
server <- function(input, output) {
# ----  2.1 Set Tab Panels  ----
output$tb <- renderUI({
  tabsetPanel(
    #  2.1.1 Environment Tab  ----
    tabPanel("Environment"
      
    ),
    #  2.1.2 Plots and discovery  ----
    tabPanel("Data lab"
      
    ),
    #  2.1.3 Data wrangling  ----
    tabPanel("Viewer"
      
    ),
    #  2.1.4 History  ----
    tabPanel("History"
             
    ),
    #  2.1.5 Execute script  ----
    tabPanel("Execute script"
             
    )
    
  )
})

# ----  2.2 Reactive values  ----
MiniJob <- reactiveVal(value = "")
DataSets <- reactiveValues()

}
shinyApp(ui = ui, server = server)
