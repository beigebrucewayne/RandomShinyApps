library(shiny)

shinyUI(
  fluidPage(
    titlePanel('Goog Analytics'),
    
    sidebarLayout(
      sidebarPanel(
        dateRangeInput(inputid = 'dateRange', label = 'Date range', start = '2017-10-01'),
        checkboxGroupInput(
          inputId = 'domainShow',
          label = 'Show NHS and other domain (defaults to all)?',
          choices = list('NHS users' = 'nhs.uk', 'Other' = 'Other'),
          selected = c('nhs.uk', 'Other')
        ),
        hr(),
        radioButtons(
          inputId = 'Output required',
          choices = list('Average session' = 'meanSession',
                         'Users' = 'users',
                         'Sessions' = 'sessions')),
      ),
      mainPanel(
        tabsetPanel( # set up tabbed output
          tabPanel('Summary', textOutput('textDisplay')
          ),
          tabPanel('Trend', plotOutput('trend')
          ),
          tabPanel('Map', plotOutput('qqplotMap'))
          )
        )
      )
    )
  )
