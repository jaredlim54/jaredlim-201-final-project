# calling the Video Games Sales data
game_sales <- read.csv("data/vgsales-12-4-2019.csv", stringsAsFactors = FALSE)

# subsetting the VGS data to target just Nintendo
# and the top ten rank
new_game_sales <- subset(game_sales, Publisher == "Nintendo")
top_ten <- subset(new_game_sales, Rank <= 10)

# creating a data frame to combine
# the names of the top ten in correlation
# to its number of global sales
df <- data.frame(
  name = c(
    "Wii Sports", "Super Mario Bros.", "Mario Kart Wii", "Wii Sports Resort",
    "Pokemon Red/Pokemon Blue", "Tetris",
    "New Super Mario Bros.",
    "Wii Play", "New Super Mario Bros. Wii",
    "Duck Hunt"
  ),
  globalsales = c(
    82.74, 40.24, 35.82, 33.00,
    31.37, 30.26, 30.01,
    29.02, 28.62, 28.31
  )
)

# loading package for data visualization
library(ggplot2)

# creating a dot plot to visualize
# the top ten Nintendo games globally sold
top_ten_globally <- ggplot(df, aes(x = name, y = globalsales)) +
  geom_point(col = "tomato2", size = 3) +
  geom_segment(aes(
    x = name,
    xend = name,
    y = min(globalsales),
    yend = max(globalsales)
  ),
  linetype = "dashed",
  size = 0.1
  ) +
  labs(
    title = "Top 10 Nintendo Games Vs. Global Sales",
    subtitle = "Dot Plot",
    caption = "source: vgsales.csv"
  ) +
  coord_flip()
