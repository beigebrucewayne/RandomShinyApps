library(shiny)
library(shinythemes)
library(plotly)
library(arules)
library(igraph)
library(arulesViz)

data.path  <- "./data.csv"
columns  <- c("order_id", "product_id")
topN  <- 10

get.txn  <- function(data.path, columns) {

	transactions.obj  <- read.transactions(
		file = data.path,
		format = "single",
		sep = ",",
		cols = columns,
		rm.duplicates = FALSE,
		quote = "",
		skip = 0,
		encoding = "unknown")

	return(transactions.obj)
}


get.rules  <- function(support, confidence, transactions) {

  parameters  <- list(
    support = support,
    confidence = confidence,
    minlen = 2,
    maxlen = 10,
    target = "rules")

  rules  <- apriori(transactions, parameter = parameters)

  return(rules)
}


find.rules  <- function(transactions, support, confidence) {

  all.rules  <- get.rules(support, confidence, transactions)

  rules.df  <- data.frame(rules = labels(all.rules), all.rules@quality)

  other.im  <- interestMeasure(all.rules, transactions = transactions)

  rules.df  <- cbind(rules.df, other.im[, c('conviction', 'leverage')])

  best.rules.df  <- head(rules.df[order(-rules.df$leverage),], topN)
  
  return(best.rules.df)
}


plot.graph  <- function(cross.sell.rules) {

  edges  <- unlist(lapply(cross.sell.rules['rules'], strsplit, split = '=>'))
  g  <- graph(edges = edges)

  return(g)
}


transactions.obj  <- get.txn(data.path, columns)


server  <- function(input, output) {

  cross.sell.rules  <- reactive({

    support  <- input$Support
    confidence  <- input$Confidence
    cross.sell.rules  <- find.rules(transactions.obj, support, confidence)
    cross.sell.rules$rules  <- as.character(cross.sell.rules$rules)

    return(cross.sell.rules)
  })

  gen.rules  <- reactive({
    support  <- input$Support
    confidence  <- input$Confidence
    gen.rules  <- get.rules(support, confidence, transactions.obj)

    return(gen.rules)
  })

  output$rulesTable  <- DT::renderDataTable({
    cross.sell.rules()
  })

  output$graphPlot  <- renderPlot({
    g  <- plot.graph(cross.sell.rules())
    plot(g)
  })

  output$explorePlot  <- renderPlot({
    plot(
      x = gen.rules(),
      method = NULL,
      measure = "support",
      shading = "lift",
      interactive = FALSE)
  })

}


ui  <- fluidPage(
  theme = shinytheme("yeti"),
  headerPanel(title = "Cross Selling Recommendations"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("Support", "Support Threshold", min = 0.01, max = 1.0, value = 0.01),
      sliderInput("Confidence", "Confidence Threshold", min = 0.05, max = 1.0, value = 0.05)
    ),
    mainPanel(
      tabsetPanel(
        id = "xsell",
        tabPanel('Rules', DT::dataTableOutput('rulesTable')),
        tabPanel('Explore', plotOutput('explorePlot')),
        tabPanel('Item Groups', plotOutput('graphPlot'))
      ) 
    )
  )
)


shinyApp(ui = ui, server = server)
