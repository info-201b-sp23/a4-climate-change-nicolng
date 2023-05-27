library(tidyverse)
library(shiny)
library(plotly)

data <- read.csv("owid-co2-data.csv", stringsAsFactors = FALSE)


intro_tab <- tabPanel("Introduction",
             h1("A4 Data Applications (Climate Change)"),
             h3("Overview: Within this app, I'm interested in finding out how much carbon a country emitts. 
                You will be able to select your country of your choice, your beginning year, and your ending
                year to analyze the trend."),
             h3("This dataset was collected by \"Out World in Data\" but specifically from Hannah Ritchie, Max Roser, Edouard Mathieu, Bobbie Macdonald, and Pablo Rosado. 
                It is regularly updated and contains data on myriad of country's CO2 emissions, greenhouse gasses, energy mix, and other relevant metrics 
                 The data is utilized to help understand the one of the upcoming issues of the world, climate change.
                Especially with COP 26 Paris Agreement, climate is a big change currently. Some issues with this data is that it doesn't show how much the country
                is actively seeking to improve. It only shows their annual, per capita, cumulative, and consumption-based emissions. What if a country is actively improving
                their environment but it won't show on the charts. What if it is only one large corporation that is emitting all the carbon? Do other companies who are going 
                green but in the same country also take the blame? Having a very broad data does lead to some downsides and these are only just a few of the flaws in this
                data that we can properly assess. Implementing the amount of companies or the net worth of company can prove better information, or even ESG score can make this
                data better."),
             h2("In the most recent year, what is the global average co2 emission?"),
             textOutput("q1"),
             h2("Most recently, which country has the highest co2 per capita emission per capita?"),
             textOutput("q2"),
             h2("Which country has the lowest energy consumption per unit of GDP?"),
             textOutput("q3"),
             h2("Which country has the highest co2 emissions from oil?"),
             textOutput("q4"),
             h2("From land usage, which country has the highest CO2?"),
             textOutput("q5"),
             h3("In conclusion, Asia has been emitting the most amount of carbon recently. This is not surprising to use because commodities is a big part of China. At the
                same time, China is not active trying to go green. They are one of the few countries that did not agree to the Paris Agreement act.")
            )

viz_tab <- tabPanel("Interaction Visualization",
              h1("Annual total production-based emissions of carbon dioxide (CO₂)"),
              sidebarLayout(
                sidebarPanel(
                  # Starting year Selection
                  selectInput(inputId = "start",
                              label = "Please select your beginning year", 
                              choices = 1950:2021,
                              selected = "2015"),
                
                  # Ending year selection
                  selectInput(inputId = "end",
                              label = "Please select your ending year", 
                              choices = 1950:2021,
                              selected = "2021"),

                  # Choose what country they want to see
                  selectInput(inputId = "country_select",
                              label = "Select Country", 
                              choices = unique(data$country),
                              multiple = FALSE),
                ),
                mainPanel(
                  plotlyOutput("plot"),
                  textOutput("info")
                )
            )
        )
ui <- navbarPage(
           "Climate Change",
           intro_tab,
           viz_tab
      )
