# loading libaries
library(modeest)
library(dplyr)
library(knitr)
library(ggplot2)
library(plotly)
library(leaflet)
library(tidyr)
library(viridis)
library(hrbrthemes)
# calling the Nintendo games sales data set
video_game_sales_data <- read.csv("data/vgsales-12-4-2019.csv",
  stringsAsFactors = FALSE
)
# creating a bar graph for the data set to show the averaged amount of per
# million Nintendo sales for Global sales, Japan sales, PAL (Europe and Oceania)
# sales, and North America sales over the years
games_by_country <- video_game_sales_data %>%
  select(Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
  gather("label", "value", Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
  group_by(label) %>%
  summarise(avg = mean(value, na.rm = TRUE))
#country games bar graph that shows average sales sold per region
country_games_bar_graph <- ggplot(games_by_country, aes(
  fill = label, y = avg,
  x = label
)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_viridis(discrete = T, option = "E") +
  ggtitle("Average Sales Sold in Each Region") +
  theme_ipsum() +
  theme(legend.position = "none") +
  xlab("")
