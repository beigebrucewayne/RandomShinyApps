library(shiny)

shinyUI(
  fluidPage(
    tags$head(HTML(
      "<link href='http://fonts.googleapis.com/css?family=Jura' rel='stylesheet' type='text/css'")),
    h2("Custom HTML', style='font-family': 'Jura'; color: green; font-size: 64px;"),
    
    sidebarLayout(
      sidebarPanel(
        radioButtons('area', 'Service area'
          c('Armadillo', 'Baboon', 'Camel', 'Deer', 'Elephant'),
          selected = 'Armadillo')
      ),
      mainPanel(
        h3('Total posts'),
        HTML("<p>Cumulative <em>totals</em> over time</p>"),
        plotOutput('plotDisplay'),
        htmlOutput('outputLink')
      )
    )
))
