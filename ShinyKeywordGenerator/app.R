library(advertools)
library(tidyverse)
library(DT)
library(shiny)
library(shinydashboard)

ui  <- dashboardPage(
  skin = 'black',

  dashboardHeader(title = 'Keyword Vomitter 🤢'),

  dashboardSidebar(
  
    textInput('queries', label = h5('Search Queries'), width = '100%', value = 'nhl, nba, nfl')),

  dashboardBody(

    DT::dataTableOutput('data')

  )
)


server  <- function(input, output) {

  output$data  <- DT::renderDataTable({
  
    keywords  <- data.frame(broad = input$queries)
    keywords$modified  <- kw_modified_broad(keywords$broad)
    keywords$phrase  <- kw_phrase(keywords$broad)
    keywords$exact  <- kw_exact(keywords$phrase)
    keywords$negative  <- kw_negative(keywords$exact)

    DT::datatable(
    
    )
  })
}


shinyApp(ui, server)
