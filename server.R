# Assignment DDP94
# Author: Monika Hunkeler, 24 of August 2017
#
# This is the server logic of the Shiny web application 'AssignDDP94'. 
#
# Load libraries and data
library(shiny)
library(ggplot2)
library(lubridate)
library(markdown)
library(DT)

ForestData <- read.csv("ForestData.csv", header = TRUE, sep = ",", quote = "\"")

shinyServer(function(input, output, session) {

    # Calculate for given input filter development of total forest area in [ha] 
    output$Total  <- renderText({
      TotalDiff <- as.character(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[2])), 5] - ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[1])), 5])
    })
    
    #Calculate for given input filter development of productive area in [ha]
    output$Productive  <- renderText({
      ProductiveDiff <- as.character(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[2])), 6] - ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[1])), 6])
    })
    
    # Swiss Forest Growth Plot
    output$swissForestPlot <- renderPlot({
      ForestData <- ForestData[(ForestData$Year>=(year(input$dateRange)[1]) & ForestData$Year<=(year(input$dateRange)[2])) , ]
      ggplot(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType), ]) + geom_point(aes(Year,ProductiveArea), color = "green") + geom_point(aes(Year, TotalArea), color = "blue") + xlab("Year") + ylab("Forest Area [ha]") + ggtitle(paste("Forests of Canton:", input$canton), paste(input$ownerType, ", Total Area (blue) and Productive Area (green)"))
    })
    
    # Swiss Plantations Growth Plot
    output$swissPlantationPlot <- renderPlot({
      ForestData <- ForestData[(ForestData$Year>=(year(input$dateRange)[1]) & ForestData$Year<=(year(input$dateRange)[2])) , ]
      ggplot(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType), ]) + geom_point(aes(Year,Hardwood), color = "red")  + geom_point(aes(Year, Softwood), color = "green") + geom_point(aes(Year, TotalSpecies), color = "black") + xlab("Year") + ylab("Number of Plantations") + ggtitle(paste("Plantations of Canton:", input$canton), paste(input$ownerType, ", Hardwood (red), Softwood (green) and Wood Species total (black) "))
      })
    
    # Calculate for given input filter development of Total Number of Plantations 
    output$Plantations  <- renderText({
      PlantationsDiff <- as.character(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[2])), 7] - ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType & ForestData$Year==(year(input$dateRange)[1])), 7])
    })
    
    
    # Table Filter Parameters
    output$FilterText  <- renderText({
      FilterText <- paste("Filter: Canton is", input$canton)
      FilterText <- paste(FilterText, paste(", Type of Owner is", input$ownerType))
      FilterText <- paste(FilterText, paste(", Date Range is", 
                                            paste(as.character(year(input$dateRange)), collapse = " to ")
      ))
    })
    
    # Table shows filtered Data
    output$table <- DT::renderDataTable(DT::datatable({
      ForestData <- read.csv("ForestData.csv", header = TRUE, sep = ",", quote = "\"")
      data <- ForestData[ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType,  ]
      data <- data[(data$Year>=(year(input$dateRange)[1]) & data$Year<=(year(input$dateRange)[2])), ]
    }))
    
    output$aboutFile <- renderUI({
      file <- includeMarkdown("about.md")
    })
  })

