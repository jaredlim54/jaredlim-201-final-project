#load packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)
library(plotly)
library(knitr)
library(stringr)

#calling the dataset
video_game_sale_data <- read.csv("data/vgsales-12-4-2019.csv",
                                 stringsAsFactors = FALSE)

#make a line chart to show the Nintendo global sales, japan sales
#and north America sales over the years
nintendo_line_graph <- video_game_sale_data %>%
  group_by(Year) %>%
  filter(Publisher == "Nintendo") %>%
  summarise(
    global_sales = sum(Global_Sales, na.rm = TRUE),
    japan_sales = sum(JP_Sales, na.rm = TRUE),
    north_america_sales = sum(NA_Sales, na.rm = TRUE)) %>%
  gather("key", "value", global_sales, japan_sales, north_america_sales) %>%
  mutate(label = str_to_title(gsub("_", " ", key)))


#line graph
line_graph <- ggplot(data = nintendo_line_graph) +
  geom_point(mapping = aes(
    x = factor(Year),
    y = value, color = label, group = label,
    text = paste0(Year, "<br>", label, ": ", value)),
    size = .5) +
  geom_line(mapping = aes(
    x = factor(Year),
    y = value, color = label, group = label,
    text = paste0(Year, "<br>", label, ": ", value)),
    size = .5) +
  labs(title = "Nintendo Over the Years",
       x = "Year",
       y = "Value") +
  scale_color_discrete(name = "Sales", labels = c("Global Sales", "Japan Sales",
                                                  "North America Sales"))

final_nintendo_graph <- ggplotly(line_graph, tooltip = "text")