## Summary Information

# video game sales - vgsales-12-4-2019.csv

rm(list = ls())

game_sales <- read.csv("data/vgsales-12-4-2019.csv", stringsAsFactors = FALSE)

# loading libraries
library(dplyr)

## Basic summary information:

# For each numeric column I want to get:
#   - min value
#   - max value
#   - mean
#   - sum of the column
# For non-numeric (genre, name):
#   - number of unique values
#   - sample values (if there are no duplicates)
#   - most common value (mode) only if there are duplicates in the column

# Removing NA values from game_sales

# get mode function I found online which gets the mode of a vector
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

get_col_info <- function(col_name, df) {
  values <- df %>% pull(col_name)

  if (is.numeric(values)) {
    info <- list(
      min_value = min(values, na.rm = TRUE),
      max_value = max(values, na.rm = TRUE),
      mean = mean(values, na.rm = TRUE),
      sum = sum(values, na.rm = TRUE)
    )
  } else if (anyDuplicated(values) > 1) {
    info <- list(
      n_values = length(unique(values)),
      mode = getmode(values)
    )
  } else {
    info <- list(
      n_values = length(unique(values)),
      sample_values = sample(unique(values), 5)
    )
  }
  return(info)
}

summary_info <- function(df) {
  col_names <- colnames(df)
  return(as.list(sapply(col_names, get_col_info, df)))
}

games_summary <- summary_info(game_sales)

# Nintendo summary:
# This is basically the same as the summary information above but it only
# includes data from Nintendo games. The data will then just be the normal
# game_sales data but it excludes non-Nintendo published sources.

nintendo_games <- game_sales %>%
  filter(Publisher == "Nintendo")

nintendo_summary <- summary_info(nintendo_games)
