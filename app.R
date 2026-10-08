# app.R
# Financial Inclusion in Uganda: interactive dashboard
# Data: World Bank Global Findex 2025

library(shiny)
library(bslib)
library(tidyverse)

# Load and prepare Uganda data
uganda <- read_csv("app_data/uganda_findex.csv", show_col_types = FALSE)

group_choices <- c(
  "Overall" = "all",
  "Gender" = "gender",
  "Age" = "age_cat",
  "Education" = "education",
  "Income" = "income",
  "Location (2024 only)" = "urbanicity",
  "Labor force" = "laborforce"
)

metric_choices <- c(
  "Any account" = "account_t_d",
  "Mobile money account" = "mobileaccount_t_d"
)

ui <- page_sidebar(
  title = "Financial Inclusion in Uganda",
  theme = bs_theme(bootswatch = "flatly"),
  sidebar = sidebar(
    selectInput("category", "Compare by:", choices = group_choices),
    selectInput("metric", "Measure:", choices = metric_choices),
    helpText("Share of adults (15+). Source: World Bank Global Findex 2025.")
  ),
  card(
    card_header("Trend over time"),
    plotOutput("trend_plot", height = "400px")
  ),
  card(
    card_header("Data"),
    tableOutput("data_table")
  )
)

server <- function(input, output, session) {

  chosen <- reactive({
    uganda %>%
      filter(group == input$category) %>%
      transmute(year, group2, share = .data[[input$metric]]) %>%
      filter(!is.na(share))
  })

  output$trend_plot <- renderPlot({
    ggplot(chosen(), aes(x = year, y = share, colour = group2)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3) +
      scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
      scale_x_continuous(breaks = c(2011, 2014, 2017, 2021, 2024)) +
      labs(x = NULL, y = NULL, colour = NULL) +
      theme_minimal(base_size = 15) +
      theme(legend.position = "bottom")
  })

  output$data_table <- renderTable({
    chosen() %>%
      mutate(year = as.character(year),
             share = scales::percent(share, accuracy = 0.1)) %>%
      rename(Year = year, Group = group2, Share = share)
  })
}

shinyApp(ui, server)