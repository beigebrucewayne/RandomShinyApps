library(shiny)
library(ggplot2)

# load data -> strings as strings
PO  <- read.csv('PO.csv', stringsAsFactors = FALSE)

# create new var to hold area and will with blanks
PO$Area  <- NA

# find posts that match service codes and label them
# with correct names
PO$Area[grep('RHARY', PO$HealthServices, ignore.case=TRUE)]  <- 'Armadillo'
PO$Area[grep('RHAAR', PO$HealthServices, ignore.case=TRUE)]  <- 'Baboon'
PO$Area[grep('RHANN-inpatient', PO$HealthServices, ignore.case=TRUE)]  <- 'Camel'
PO$Area[grep('rha20-25101', PO$HealthServices, ignore.case=TRUE)]  <- 'Deer'
PO$Area[grep('rha20-29202', PO$HealthServices, ignore.case=TRUE)]  <- 'Elephant'

# create postings variabel to add together for cum sum
PO$ToAdd  <- 1

# remove all missing values for Area
PO  <- PO[!is.na(PO$Area),]

# API returns data in reverse chronological order - reverse it
PO  <- PO[nrow(PO):1,]

# produce cumulative sum column
PO$Sum  <- ave(PO$ToAdd, PO$Area, FUN = cumsum)

# produce date column form data column in spreadsheet
PO$Date  <- as.Date(substr(PO$dtSubmitted, 1, 10), format='%Y-%m-%d')
