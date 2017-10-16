library(dplyr)
library(ggplot2)
library(rgdal)
library(RColorBrewer)
library(shiny)

shinyServer(function(input, output) {
  load('gadf.Rdata')

  # reactive data
  passData  <- reactive({
    firstData  <- filter(gadf, date >= input$dateRange[1] & date <= input$dateRange[2]) 
    if (!is.null(input$domainShow)) {
      firstData  <- filter(firstData, networkDoamin %in% input$domainShow) 
    }
    return(firstData)
  })

  output$textDisplay  <- renderText({
    paste(
      length(seq.Date(input$dateRange[1], input$dateRange[2], by='days')),
      ' days are summarized. There were', sum(passData()$users),
      'users in this time period.'
    ) 
  })

  output$trend  <- renderPlot({
    groupByDate  <- group_by(passData(), YearMonth, networkDoamin) %>%
      summarize(
        meanSession = mean(sessionDuration, na.rm = TRUE),
        users = sum(users),
        newUsers = sum(newUsers),
        sessions = sum(sessions)
      )
  })
})
