# app.R file

## Reactive Bar Charts ##
# a bar chart of the sales of Nintendo games by genre. It may have a multiple
# choice thing for the users to select, with that technically being a widget.
# Widgets should allow for:
# 1. user to select multiple genres of games

# Scatter plot

rm(list = ls())

# loading libraries
library(ggplot2)
library(dplyr)
library(shiny)
library(plotly)
library(tidyr)
library(leaflet)
library(knitr)
library(stringr)




# source ui
source("app_ui.R")
source("app_server.R")

# run shiny app

shinyApp(ui = ui, server = server)
