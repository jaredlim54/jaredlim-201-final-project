## Aggregated Table

rm(list = ls())

game_sales <- read.csv("data/vgsales-12-4-2019.csv",
  stringsAsFactors = FALSE
)


# loading libraries
library(dplyr)

## Actual table:
# sort by:
#   - only games published by nintendo
#   - sort (ascending) by games with the most copies sold
#   - omit sales and other irrelevant information

aggregated_data <- game_sales %>%
  filter(Publisher == "Nintendo") %>%
  select(-c(
    Global_Sales, NA_Sales, PAL_Sales, JP_Sales, Other_Sales,
    basename, Developer, VGChartz_Score, url, status, Vgchartzscore,
    img_url, Last_Update, Publisher
  )) %>%
  arrange(-Total_Shipped) %>%
  group_by(Genre)
