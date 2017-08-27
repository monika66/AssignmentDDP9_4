# Assignment DDP94
# Author: Monika Hunkeler, 24 of August 2017
#
# This is the user interface definition of the Shiny web application 'AssignDDP94'.
ForestData <- read.csv("ForestData.csv", header = TRUE, sep = ",", quote = "\"")

shinyUI(navbarPage("Shiny AssignDDP94",
                   tabPanel("Plot",
                            headerPanel("East Switzerland: Forest and Plantation Growth"),
                            sidebarPanel(
                              h4("Please choose input:"),
                              selectInput("canton", "Canton", choices=unique(ForestData$Canton)),
                              selectInput("ownerType", "Type of Owner", choices=unique(ForestData$TypeofOwner)),
                              dateRangeInput("dateRange", label = 'Date Range', start = "1975-01-01" , end = "2016-12-31", format = "yyyy", startview = 'year', min = "1975-01-01", max="2016-12-31")
                            ),
                            mainPanel(
                              plotOutput("swissForestPlot"),
                              p("Total Forest area growth [ha]:"),
                              verbatimTextOutput("Total"),
                              p("Productive Forest area growth [ha]:"),
                              verbatimTextOutput("Productive"),
                              plotOutput("swissPlantationPlot"),
                              p("Development of Total Number of Plantations:"),
                              verbatimTextOutput("Plantations")
                            )),
                   tabPanel("Table", verbatimTextOutput("FilterText"), DT::dataTableOutput("table")),                 
                   tabPanel("About", uiOutput("aboutFile"))
                  ))
