
#The following packages have been used throughout this assignment:
library(tidyverse)
library(shiny)
library(shinythemes)
library(ggplot2)
library(shinyWidgets)
library(leaflet)
library(scales)

attach(kc_house_data)#Attaching variables

# Defining UI for the application 
shinyUI(navbarPage(theme = shinytheme("flatly"), 
                   title = "Housing sales in King County, Washington USA",
                   tabPanel("Prediction plot",
                            p("This tab shows the predicted vs. observed house prices in King County using different statistical methods. The predicted values are based on the best model (with the best predictors), which was selected using cross-validation."),
                            
                            sidebarPanel(sliderInput("price_input",
                                                     "Up to what price would you like to select the houses?",
                                                     min = 100000,
                                                     max = 7700000,
                                                     value = 500000,
                                                     step = 1000),
                                         
                                         #Making selection boxes for the different statistical methods
                                         checkboxInput("regInput", "Linear Regression", value = F, width = NULL),
                                         checkboxInput("poly_2_Input", "Polynomial ^2 Regression", value = F, width = NULL),
                                         checkboxInput("poly_3_Input", "Polynomial ^3 Regression", value = F, width = NULL),
                                         br()),
                            mainPanel(plotOutput("plot1"),
                                      tableOutput("modelres"))
                   ),
                   
                   tabPanel("Interactive map",
                            p("This is an interactive map showing the locations of the houses sold in King County, Washington USA. Click on the houses in the map to see more information."),
                            sidebarPanel(numericInput(inputId = "numberInput",
                                                      label = "Number of houses on the map:",
                                                      value = 10),
                                         varSelectInput("varInput", "For which variable do you want to see the top?", kc_house_data[,c("price", "sqft_living", "sqft_lot")]),
                                         radioButtons("orderInput", "Do you want the top highest or lowest values?",
                                                      choices = list("Highest" = 1, "Lowest" = 2), 
                                                      selected = 1)
                            ),
                            mainPanel(leafletOutput("mymap"))
                   )
))

