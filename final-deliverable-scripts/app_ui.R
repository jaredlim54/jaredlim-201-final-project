# app_ui.R
# data:
game_sales <- read.csv("vgsales-12-4-2019.csv", stringsAsFactors = FALSE)
nintendo_games <- game_sales %>%
  filter(Publisher == "Nintendo")

### Introduction Page ###


### First Chart ###
# This plot aims to answer the question of how genre and the total number of
# shipped copies are related. In other words, which genres are the most popular
# in terms of copies shipped/sold?
# Widgets:
# 1. Selecting genre (Multiple-choice input)
# Layout: bar chart

## Widget 1: Inputs ##
genre_unique <- unique(nintendo_games$Genre)

genre_check <- checkboxGroupInput(
  inputId = "genres",
  label = "Nintendo Genres:",
  choices = genre_unique,
  selected = genre_unique
)

### Second Chart##
# This plot aims to answer the question how genre and platform are
# related to the
# success of the
# product. In other words, does genre influence the number of sales a video game
# gets?
# Widgets:
# 1. Selecting genre (drop-down menu)
# 2. Selecting platform (multiple choice input)
# Layout: Scatter plot

# nintendo video games platform
nintendo_platform <- game_sales %>%
  filter(Publisher == "Nintendo") %>%
  group_by(Platform) %>%
  pull(Platform)

platform_unique <- unique(nintendo_platform)

## Widget 1: Selecting genre input (dropdown) ##
scatter_genre_pick <- selectInput(
  inputId = "scatter_genre_pick",
  label = "Select Genre",
  choices = genre_unique,
  selected = genre_unique[1],
  multiple = FALSE
)

## Widget 2: Selecting platform (multiple-choice input) ##

platform_check <- checkboxGroupInput(
  inputId = "platform_pick",
  label = "Check Platform",
  choices = platform_unique,
  selected = platform_unique
)


### Third Chart ###
# This plot answers the question on which regions were most successful for
# Nintendo.
games_by_country <- game_sales %>%
  filter(Publisher == "Nintendo") %>%
  select(Platform, Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
  gather("label", "value", Global_Sales, NA_Sales, JP_Sales, PAL_Sales) %>%
  group_by(label) %>%
  summarise(avg = mean(value, na.rm = TRUE), TSales = Platform)
sales_range <- range(games_by_country$avg)

# storing visualization in a tabpanel
visualization_1 <- tabPanel(
  "Nintendo Sales Data Bar Chart",
  h1("Overview of Nintendo sales by region"),
  p("This plot aims to answer the question on how each region compares
    in terms of Nintendo sales. The chart is specifically a bar
             chart, which allows for easy relative comparison of the different
             regions, with the height of each making size differences easier to
             observe."),
  p("In this graph the y-axis is representing the
             total average value for each different TSales, which is all added
             up. TSales on the other hand, is the label for the data that
             represents the Platform of each Nintendo Games Sold. In other
             words, TSales represent the  platforms, such as Xbox, the Wii,
             Gameboy, and many more. Note that PAL refers to Europe,
    NA refers to North America, and JP refers to Japan. The slider is
    adjustable to filter by a range of sales."),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "sales_count",
        label = "Sales Count Value Range by Country",
        min = round(sales_range[1], 2),
        max = round(sales_range[2], 2),
        value = round(sales_range, 2),
        step = 0.05
      )
    ),
    mainPanel(
      h1("Average Nintendo Sales Sold By Country Globally"),
      plotOutput(outputId = "gg_plot")
    )
  )
)



ui <- fluidPage(
  includeCSS("style.css"),

  tabsetPanel(
    ## Introduction Page ##
    tabPanel(
      "Introduction Page",
      h1("A Closer Look at Nintendo's Success"),
      h4("By: Asigiah Aly, Brian Thien Ho, Jared Lim, Harlette Tanduyan"),
      img(src = "https://images.nintendolife.com/
                 3c515f4f48403/switch-games.original.jpg", class = "center"),
      h2("Summary"),
      p("As our generation grew up in the ever-evolving industry of video
             games, we are now intrigued by its impact beyond shaping our
             childhood interests. Exploring the importance of Nintendo and the
             aspect it provides gives up a sense of knowledge of the how
             Nintendo, a company that shaped so much of our lives, has been able
             to constantly improve and adapt to fufill the needs of many. When
             observing specific aspects, we have found the important factors
             that Nintendo has obtained to gain popularity all over the world.
             Nintendo is also a leading producer of video games worldwide,
             where they have cultivated incredibly popular series known across
             pop culture, such as the Super Mario series and the Legend of
             Zelda. This motivated us for our final
             project, where we continued to specifically explore the capital
             behind Nintendo. We investigate this by its most and least
             successful games, its leading genres,and its top customers in terms
             of countriesfrom data we derived from a", a(
        href = "https://www.kaggle.com/gregorut/videogamesales",
        "2019 study of video game sales."
      )),
      h2("Our Questions"),
      p("Moreover, the main questions we aim to answer in this project is:
               Are all Nintendo game genres equal, or are more popular than
               others? What were the products with the most and least sales? Is
               it correlated by the games' genre or platform? Lastly, what are
               the differences and similarities of Nintendo game sales in
               different regions? In other words, were certain regions
        more successful for Nintendo than others?"),
    ),

    ## First Chart ##
    # which genres are most popular in terms of copies sold?

    tabPanel(
      "Shipped Nintendo copies by Genre",
      h1("Overview of Nintendo Copies Shipped by Genre"),
      p("This plot aims to answer the question on which Nintendo genres
                 are most popular, in terms of total number of copies shipped.
                 Each Nintendo game is classified by a genre, so the number of
                 copies sold for each genre is a sum of all games' copies sold
                 by genre. We found that a bar graph was best to display this
        information because it is easy for readers to tell which genres have
        more copies sold than others. It's easy to establish whether
        one genre dominates or not based on the visual height of the bar."),
      p("The x-axis displays the genre, while the y-axis displays
                 how many total copies were shipped. Hovering over the bar
                 reveals which particular game in that genre adds to
                 the total number of copies shipped. From the select genre(s),
                 you can checkbox which genres to display."),
      sidebarLayout(
        sidebarPanel(
          h5("Select Genre(s)"),
          genre_check
        ),
        mainPanel(
          plotlyOutput("bar_chart")
        )
      )
    ),

    tabPanel(
      "Scatter Plot of Sales vs. Platform & Genre",
      sidebarLayout(
        sidebarPanel(
          scatter_genre_pick,
          platform_check
        ),
        mainPanel(
          h1("Overview of Nintendo Products by Global Sales"),
          p("This scatter plot shows the Nintendo games that
          sold the highest and lowest amount in Global Sales
          throughout the years. Our focus for the video
          games global sales is particularly only on
          Nintendo gaming platforms and the genre of the
          video game. The checkbox filters the Nintendo
          platforms.
          The drop down menu bar provides a list of genres
          to choose from. We chose a scatter plot because it gives an overall
            trend about the relationship between the global sales
            and video games as time progressed. It's also easy to filter
            through multiple variables through a scatterplot in this way."),
          p("The X-axis is the year of the game's release, while the Y-axis
          is the Global Sales in millions.
          Hovering over the scatter plot reveals the
          name of the game, the year the game was released,
          and the Global Sale for that game."),
          plotlyOutput("scatter_plot")
        )
      )
    ),
    visualization_1,

    ## Conclusion Page on one "Key Takeaways" Page ##
    # Conclusion table
    # Conclusion page 1: Are all genres of Nintendo games equal, or are
    # some more popular than others?
    # Page 2: Were there any patterns between genre, platform, and sales?
    # Page 3: Were certain regions more successful for Nintendo than others?

    tabPanel(
      "Key Takeaways",
      fluidRow(
        h1("CONCLUSIONS"),
        p("Here, we summarize our findings from the data we visualized and
          from examining that data. To restate, our initial questions in
          the introduction were if some Nintendo game genres were more
          popular than others, if sales were influenced by the games' genre
          and platform, and if certain regions have more sales than others."),
        tableOutput("conclusion_table"),
        h2("Are all genres of Nintendo games equal? Or are some
                  more popular than others?"),
        h6("Overall Patterns"),
        p("Overall, there were some Nintendo genres that were more
                popular than others."),
        p("One clear and notable pattern found through the bar chart was
                that the platform, RPG, and Sports genres have the most overall
                shipped copies. On the other hand, Nintendo's not as popular
                genres in copies sold are the strategy, action,
                and party genres. In fact, the platform genre has over 400
                million shipped copies combined, the role-playing genre has over
                300 million old, and the sports genre has about 200 million
                copies sold. On the other hand, the strategy genre has about 17
                million copies sold, the party genre has just over 20 million,
                and the action genre has slightly more than the party genre at
                over 20 million copies sold. This moreover indicates the pattern
                of Nintendo's most popular games being largely platform games
                and role-playing games, while it is not as famed its action or
                strategy games. Looking closer, this chart also skews heavily
                towards console largely because of Nintendo's most popular game
                series, the Super Mario series, as if one hovers over the
                platform genre, much of it is populated by Super Mario games.
                Similarly, the RPG genre is dominated by Pokemon games."),
        h6("Broader Implications"),
        p("This chart moreover shows that Nintendo's most successful
                genres are largely platform games. It kind of boxes in
                Nintendo's reputation as a successful producer of console games
                without much room to expand in other genres such as strategy or
                action games. Even though there are hugely popular releases in
                other genres, namely the Breath of the Wild in the
                action-adventure genre, Nintendo's overall more known publicly
                as the dominant competitor in platform games. Also, many
                of the popular platform games, such as Super Mario Bros,
                New Super Mario Bros, and Super Mario World were published
                well over 10 years ago, which indicate that Nintendo's newer
                games in other genres are not nearly as popular yet in terms of
                total copies shipped as their newest games, such as the Breath
                of the Wild, at least as of 2019."),
        h2("What was the Product with the Most and Least Sales? Were
                  there any Patterns?"),
        h6("Overall Patterns"),
        p("Generally, the products with the most and least
                              sales are dependent on the genre in which it was
                              released in. When interacting and manipulating
                              the scatter plot, we noticed that sales were the
                              strongest in the early 2000s - 2010. However,
                              not every genre had their leading game within that
                              time frame. For example, the video game with the
                              max global sales in the sports genre was Major
                              League Baseball Featuring Ken Griffey Jr.
                              Released in 1988, it sold over 790,000 global
                              Nintendo copies. On the lower end of the sports
                              genre, The lowest global sale in the sports genre
                              was Calcio Bit. Released in 2006 with 30,000
                              global Nintendo copies sold."),
        h6("Broader Implications"),
        p("In connection to a broader implication, we can state
                                that the most successful games aren't always
                                going to be
                                the most recent and updated. Looking at this
                                aspect can help video game developers
                                gain a wider perspective on popularity trends
                    in their creation process."),
        h2("How does each Region compare in terms of Product Sales?"),
        h6("Overall Patterns"),
        p("With exploring the question of, \"How does each
             region compare in terms of product sales?\", it branched into other
             questions, such as, \"Which region had the highest number of sales
             sold?\". The bar chart we created helped answer this question
             this by ranking the regions with the highest sales sold in
             millions.
             The key in reading this chart is being able to absorb the meaning
             of each information within the different heights of the bars.
             The higher the bars in each region, means the larger amount of
             sales of games that were  sold. Another key is knowing what each
             axis means and what each
             label represents.  This can be an explaination for why the
             y-axis values are in the hundreds, as it is counting the total
             TSales per country. This also explains why the slider value is not
             correspondant to each slide value, as the slider is representing
             the average value for each countries sales, and not corresponding
             to the TSales. So, the x-axis is effected by the widget, as for the
             desinated average sales sold for the specific country, the data
             will shift. This plot also reveals key insights. When observing the
             map, it shows that a large fraction of the global sales is from
             North America, as North America's values are the closest to the
             values of Global Sales. To add on, the chart shows that the PAL and
             Japan Sales are quite lower in sales sold, than compared to North
             America. This moreover indicates that despite Nintendo being from
             Japan, the data overall shows that North America plays a large role
             in Nintendo's sales. Europe is still less than that of North
             America, indicating that there might be more consumption of video
             games in North America than both Japan and Europe. The pattern seen
             is that countries, such as North America, who have larger TSales,
             as in different platform and console sales, tend to have larger
             average sales sold total as well. With more interest in a multitude
             of platforms, it can lead to differences in amount of sales sold."
          ),
        h6("Broader Implications"),
        p("Overall, the arguably most competitive region for Nintendo remains to
        be in North America. With the knowledge that North America is the
        primary region of income for Nintendo, Nintendo games have to be
        tailored to not just its Japanese audience at home, but also to North
        America, and to a lesser extent European audiences. This means that
        Nintendo must also pool effort into understanding the North American
        player base and where their interests are to remain competitive as a
        video game maker in the region. Moving forward, we can predict that this
        trend to continue, where Nintendo puts a great deal of effort into
        understanding a North American player base to better market its own
        video games and compete with North American video game companies.")
      )
    )
  )
)
