library(shiny)

shinyServer(function(input, output) {
  output$textDisplay  <- renderText({
    paste0("Title:" input$comment,
      "'. There are ", nchar(input$comment),
      " characters in this."
    ) 
  })

  output$plotDisplay  <- renderPlot({
    par(bg = '#ecf1ef')
    plot(poly(1:100, as.numeric(input$graph)), type = "1", ylab = "y", xlab = "x")
  })
})
