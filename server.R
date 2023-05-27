setwd("C:/Users/theaw/INFO201/a4-climate-change-nicolng")

library(tidyverse)
library(shiny)
library(plotly)

data <- read.csv("owid-co2-data.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  output$q1 <- renderText({
    latest_mean <- data %>% 
      filter(year == max(year)) %>%
      summarise(mean = mean(co2, na.rm = TRUE)) %>%
      pull(mean)
    q1 <- paste0("In the most recent year the data has, 2021, the average CO2 
                emissions from each country is ", round(latest_mean, 2), " million tonnes.")
   
  })
  
  output$q2 <- renderText({
    highest_co2_per_capita <- data %>% 
      filter(year == max(year)) %>%
      filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>%
      select(country, max = co2_per_capita)
    q2 <- paste0(highest_co2_per_capita$country, " has the highest CO2 per capita 
                 emissions with ", highest_co2_per_capita$max, " tonnes per person.")
    
  })
  
  output$q3 <- renderText({
    lowest_c <-  data %>% 
      filter(year == max(year)) %>%
      filter(consumption_co2 == min(consumption_co2, na.rm = TRUE)) %>%
      select(country, min = consumption_co2)
    q3 <- paste0(lowest_c$country, " has the lowest CO2 emission from consuption of ", 
                 lowest_c$min, " million tonnes.")
    
  })
  
  output$q4 <- renderText({
    highest_average <- data %>%
      group_by(country) %>%
      summarise(mean = mean(oil_co2, na.rm = TRUE)) %>%
      filter(country != "World" & country != "High-income countries") %>%
      filter(mean == max(mean, na.rm = TRUE))
    q4 <- paste0(highest_average$country, " has the highest average CO2 emissions from oil throughout the years. It released an average of ", 
                 highest_average$mean, " million tonnes.")
  })
  
  output$q5 <- renderText({
    highest_land_of_co2 <- data %>%
      filter(year == max(year)) %>%
      filter(country != "World" & country != "Upper-middle-income countries") %>%
      filter(land_use_change_co2 == max(land_use_change_co2, na.rm = TRUE))
    q5 <- paste0(highest_land_of_co2$country, " has the highest CO2 emission from land usage in the world. It releases ", 
                 highest_land_of_co2$land_use_change_co2, " million tonnes base on land usage.")
  })
  
  
  output$plot <- renderPlotly({
    filtered_data <- data %>%
      filter(country %in% input$country_select,
             year >= input$start,
             year <= input$end)
    data_plot <- ggplot(filtered_data) +
      geom_line(aes(x = year,
                    y = co2,
                    color = "red")) +
      ggtitle(paste0(input$country_select, "'s Carbon Emission Over The Years")) +
      xlab("Year") +
      ylab("CO2 emission (million tonnes)") +
      theme(legend.position = "none")
    return(ggplotly(data_plot))
  })
  
  
  
  output$info <- renderText({
    filtered_data <- data %>%
      filter(country %in% input$country_select,
             year >= input$start,
             year <= input$end)
    country_high <- filtered_data %>% 
      filter(co2 == max(co2))
    country_low <- filtered_data %>% 
      filter(co2 == min(co2, na.rm = TRUE))
    paste0("From ", input$start, " to ", input$end, ", ", input$country_select,
           " has an average of ", round(mean(co2), 2), " million tonnes per year. ", input$country_select,
           " highest year was ", country_high$year, " and emitted ", country_high$co2, " million tonnes ",
           " while the lowest emission was ", country_low$co2, " in ", country_low$year, ".")
    
  })
}

