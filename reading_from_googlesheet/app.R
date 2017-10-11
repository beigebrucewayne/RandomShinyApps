library(googlesheets)
library(tidyverse)
library(ggthemes)
library(shinythemes)
library(DT)


ui  <- fluidPage(
  theme = shinytheme('simplex'),

  titlePanel('AdWords Dashboard'),

  sidebarLayout(

    sidebarPanel(
      selectInput('ws', 'Worksheet', choices = c('DailyCosts', 'MonthlyOverview', 'DailySEMData', 'SEMDataOverview'))),

    mainPanel(
      DT::dataTableOutput('contents')  
    )
  )
)


server  <- function(input, output) {

  # authorize access to googlesheets
  gs_auth()

  # grab googlesheets object via URL
  gs_data  <- gs_url('https://docs.google.com/spreadsheets/d/187bilrHYjG4wEd-07GXZ4Z6YJkILQfaEJbGfZno3PDo/edit?usp=sharing')

  # grab user selected worksheet
  worksheet  <- reactive({
    input$ws
  })

  # render datatable
  output$contents  <- DT::renderDataTable({

    # read data from googlesheets
    data  <- gs_read(gs_data, ws = worksheet())

    # render datatable object + settings
    DT::datatable(data,
      class = 'strive hover compact order-column',
      extensions = 'Buttons',
      options = list(
        dom = 'Bfrip',
        buttons = c('excel', 'pdf', 'print'),
        pageLength = 50),
      filter = 'top')
  })
}


shinyApp(ui, server)
