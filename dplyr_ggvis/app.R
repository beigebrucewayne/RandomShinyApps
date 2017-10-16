library(dplyr)
library(shiny)
library(ggvis)

groupByDate  <- filter(gadf, networkDomain %in% topThree$networkDomain) %>%
  group_by(YearMonth, networkDomain) %>%
  summarize(
    meanSession = mean(sessionDuration, na.rm = TRUE),
    users = sum(users),
    newUsers = sum(newUsers),
    sessions = sum(sessions))

ui  <- fluidPage(
  inputPanel(
    checkboxInput('smooth', label = 'Add smoother?', value = FALSE))
)

server  <- function(input, output) {
  renderPlot({
    thePlot  <- qqplot(groupByDate, aes(x = Date, y = meanSession, group = networkDomain, color = networkDomain)) +
      geom_line() + ylim(0, max(groupByDate$meanSession))

    if (input$smooth) {
      thePlot  <- thePlot + geom_smooth() 
    }
    print(thePlot)
  })
}
