# video game genre for scatter plot
video_game_sale_genre <- nintendo_games %>%
  filter(!is.na(Genre)) %>%
  filter(Publisher == "Nintendo")

server <- function(input, output) {
  # Bar chart
  output$bar_chart <- renderPlotly({
    plot_data <- nintendo_games %>%
      group_by(Genre) %>%
      filter(!is.na(Genre)) %>%
      filter(Genre %in% input$genres)

    # Bar chart
    plot1 <- plot_ly(
      data = plot_data,
      x = ~Genre,
      y = ~Total_Shipped,
      type = "bar",
      color = ~Genre, colors = "Set3",
      text = ~Name
    ) %>%
      layout(
        title = "Shipped Nintendo copies by genre",
        xaxis = list(title = "Genre"),
        yaxis = list(title = "Total Shipped copies (in millions)")
      )
    return(plot1)
  })
  # scatter plot
  output$scatter_plot <- renderPlotly({
    plot_data <- video_game_sale_genre %>%
      filter(Genre %in% input$scatter_genre_pick) %>%
      filter(Platform %in% input$platform_pick)
    plot2 <- plot_ly(
      data = plot_data,
      x = ~Year,
      y = ~Global_Sales,
      type = "scatter",
      mode = "markers",
      color = ~Genre, colors = "Set3",
      text = ~Name
    ) %>%
      layout(
        title = "Nintendo Global Sales Scatter Plot",
        xaxis = list(
          title = "Years"
        ),
        yaxis = list(
          title = "Global Sales"
        )
      )
    return(plot2)
  })
  # region plot
  output$gg_plot <- renderPlot({
    games_by_country <- game_sales %>%
      filter(Publisher == "Nintendo") %>%
      select(Platform, Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
      gather("label", "value", Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
      group_by(label) %>%
      summarise(avg = mean(value, na.rm = TRUE), TSales = Platform) %>%
      filter(
        avg <= input$sales_count[2],
        avg >= input$sales_count[1]
      )
    plot3 <- ggplot(
      data = games_by_country
    ) +
      geom_col(mapping = aes(y = avg, x = label, color = TSales)) +
      ggtitle("Average Nintendo Sales Sold Vs Global Countries") +
      xlab("Countries") +
      ylab("Average Value of Nintendo Sales Sold")
    return(plot3)
  })
}
