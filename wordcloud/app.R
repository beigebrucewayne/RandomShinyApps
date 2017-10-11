library(wordcloud)
library(tidyverse)
library(tidytext)
library(janeaustenr)
library(shinythemes)
library(shiny)

ui  <- fluidPage(
  theme = shinytheme('darkly'),
  titlePanel('Wordcloud Web App'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('ngramCount', '# of Grams', min = 1, max = 5, value = 2),
      hr(),
      sliderInput('cloudCount', '# of Words', min = 50, max = 400, value = 100)
    ),
    mainPanel(
      plotOutput('wordcloud') 
    )
  )
)

server  <- function(input, output) {
  ngrams  <- reactive({
    input$ngramCount
  })
  output$wordcloud  <- renderPlot({
    austen_books() %>%
      select(text) %>%
      unnest_tokens(ngram, text, token="ngrams", n=ngrams()) %>%
      count(ngram) %>%
      with(wordcloud(ngram, n, max.words=input$cloudCount, rot.per=.2, colors=c("#b4b3b3", "#969696", "#484848", "#8dc7d3")))
  })
}

shinyApp(ui, server)
