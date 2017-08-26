---
title: "East Swiss Forest Growth and Plantations"
subtitle: "Data Science Specialization - Data Product Developing"
author: "Monika Hunkeler" 
date: "24 August 2017"
output:
  html_document: default
  pdf_document: default
---
  
  
  
## 1. About Shiny app 'AssignDDP94' 

### 1.1 East Swiss Forest Growth and Number of Plantations Data
The application [AssignDDP94](https://mhunkeler.shinyapps.io/assignddp94/) is based on [Swiss Federal Statistical Office Data](https://www.pxweb.bfs.admin.ch/default.aspx?px_language=en) about [Forest area in Switzerland, in hectare](https://www.pxweb.bfs.admin.ch/Selection.aspx?px_language=en&px_db=px-x-0703010000_101&px_tableid=px-x-0703010000_101\px-x-0703010000_101.px&px_type=PX) and [Number of plantations in Swiss forest](https://www.pxweb.bfs.admin.ch/Selection.aspx?px_language=en&px_db=px-x-0703030000_112&px_tableid=px-x-0703030000_112\px-x-0703030000_112.px&px_type=PX).
  
The East Swiss forest data were collected from 1975 until 1986 and contains informations about the east cantons:  
**Appenzell Innerrhoden, Apenzell Ausserrhoden, Glarus, Graubünden / Grigioni / Grischun, Schaffhausen, St. Gallen and Thurgau**.
  
### 1.2 Navbar Tab 'Plot': Widget Input Data
The input widget at the upper left corner of the tab 'Plot' creates a filter for the east forest data. Chooseable input filter parameters are:  
**Canton**, **Type of Owner** and **Date Range**.
  
  
 ![Fig. 1](Widget.JPG) 

  
### 1.3 Navbar Tab 'Plot': Plots
Based on the input parameter choice displays the Navbar tab "Plot" two interactive plots:  
- **Plot Forests of Canton** shows the total area and the productive area of forest in hectar [ha] based on canton, type of forest owner and date range.  
  
 ![Fig. 2](plot1.JPG) 
  
  
- **Plot Plantations of Canton** shows the total number of plantations and the number of Hardwood (deciduous) and Softwood (conifers) plantations based on  
canton, type of forest owner and date range.  
  
 ![Fig. 3](plot2.JPG) 
  
  
### 1.4 Navbar Tab 'Table'
Based on the input parameter choice the Navbar tab "Table" will display the choosen filter and the filtered data table. As addition there is a search function available for the filtered data table.

The table structure has 9 columns:  
- **Year**: Date range from 1975 until 1986  
- **Canton**: Appenzell Innerrhoden, Apenzell Ausserrhoden, Glarus, Graubünden / Grigioni / Grischun, Schaffhausen, St. Gallen and Thurgau.  
- **TypeofOwner**: Forest owner Types are *Type of owners - Total*, *Private forest* and *Public forest*. For Public Forest exists subtypes of owners called *Federal forest*, *Cantonal forest*, *Municipality forest*, *Bourgeois forest* and *Other public forest*. Note this Public Forest subtypes contains Forest Area data no Plantation data.  
- **NrofOwners**: Number of forest Owners.    
- **TotalArea**: Total forest area in hectar [ha]  
- **Productive Area**: Productive forest area in hectar [ha]  
- **Hardwood**: Number of Hardwood (deciduous) plantations  
- **Softwood**: Number of Softwood (conifers) plantations  
- **Total Species**: Number of Hardwood (deciduous) and Softwood (conifers) plantations    
   
  
 ![Fig. 4](table.JPG) 


## 2. Further informations: R Code, Data and Files

There is a reproducible and executable Presentation [Swiss Forest Growth and Number of Plantations, AssignDDP94](http://rpubs.com/mhunkeler) published on Rpubs. 
  
In case you like to install the Shiny app by yourself, all R code, data and markdown files are available on github <https://github.com/monika66/AssignmentDDP9_4> 


### 2.1 Data
The [raw data](https://github.com/monika66/AssignmentDDP9_4/rawdata) where extracted, merged and mutated with the R script "MergeSwissForestData.R". 
  
```
# Load, subset, merge and mutate the two Swiss Forest Data Files for "Forest area in Switzerland, in hectare" and
# "Number of plantations in Swiss forest". 
# Write dataset ForestData.csv used for Shiny App AssignDDP94
setwd('YourPath/AssignDDP94')
library(plyr)
library(tidyr)
# Read raw data and write joined data
ForestData <- read.csv("./rawdata/px-x-0703010000_101.csv", header = FALSE, sep = ";", quote = "\"")
FDrows <- nrow(ForestData)
ForestData <- subset(ForestData[3:FDrows, ])
ForestData <- subset(ForestData[which(ForestData$V2 == "Switzerland"), ])
PlantingData <- read.csv("./rawdata/px-x-0703030000_112.csv", header = FALSE, sep = ";", quote = "\"")
PDrows <- nrow(PlantingData)
PlantingData <- subset(PlantingData[3:PDrows, ])
PlantingData <- subset(PlantingData[which(PlantingData$V2 == "Switzerland"), ])
ForestData <- join(ForestData, PlantingData, by = c("V1", "V2", "V3",  "V4"), type = "left", match = "all")
names(ForestData)[8] <- "WoodSpecies"
names(ForestData)[9] <- "NrofPlantations"
ForestData <- spread(ForestData, WoodSpecies, NrofPlantations)
ForestData <- ForestData[ , c(1, 3:10)]
names(ForestData) <- c("Year", "Canton", "TypeofOwner", "NrofOwners", "TotalArea", "ProductiveArea", "Hardwood", "Softwood", "TotalSpecies")
write.csv(ForestData, file = "./ForestData.csv", row.names = FALSE)
```

The Shiny app "AssignDDP94" uses the processed data ["ForestData.csv"](https://github.com/monika66/AssignmentDDP9_4/) as: 
  
data.frame with 2352 obs. of  9 variables
  
 $ Year          : Factor w/ 44 levels  
 $ Canton        : Factor w/ 9 levels  
 $ TypeofOwner   : Factor w/ 10 levels  
 $ NrofOwners    : Factor w/ 877 levels  
 $ TotalArea     : Factor w/ 2191 levels  
 $ ProductiveArea: Factor w/ 2224 levels  
 $ Hardwood      : Factor w/ 4193 levels  
 $ Softwood      : Factor w/ 4193 levels  
 $ TotalSpecies  : Factor w/ 4193 levels  
  
### 2.3 Code ui.R  

```
# This is the user interface definition of the Shiny web application 'AssignDDP94'.
ForestData <- read.csv("ForestData.csv", header = TRUE, sep = ",", quote = "\"")  

shinyUI(navbarPage("Navbar",
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
                              plotOutput("swissPlantationPlot")
                            )),
                   tabPanel("Table", verbatimTextOutput("FilterText"), DT::dataTableOutput("table")),                 
                   tabPanel("About", uiOutput("aboutFile"))
                  ))
```
  
  
### 2.3 Code server.R
  
```
# This is the server logic of the Shiny web application 'AssignDDP94'.   
library(shiny)  
library(ggplot2)  
library(lubridate)  
library(markdown)  
library(DT)  
ForestData <- read.csv("ForestData.csv", header = TRUE, sep = ",", quote = "\"")  

shinyServer(function(input, output, session) {
    # Swiss Forest Growth Plot  
    output$swissForestPlot <- renderPlot({
      ForestData <- ForestData[(ForestData$Year>=(year(input$dateRange)[1]) & ForestData$Year<=(year(input$dateRange)[2])) , ]
      ggplot(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType), ]) + geom_point(aes(Year,ProductiveArea), color = "blue") + geom_point(aes(Year, TotalArea), color = "red") + xlab("Year") + ylab("Forest Area [ha]") + ggtitle(paste("Forests of Canton:", input$canton), paste(input$ownerType, ", Total Area (blue) and Productive Area (green)"))
    })
    
    # Swiss Plantations Growth Plot
    output$swissPlantationPlot <- renderPlot({
      ForestData <- ForestData[(ForestData$Year>=(year(input$dateRange)[1]) & ForestData$Year<=(year(input$dateRange)[2])) , ]
      ggplot(ForestData[which(ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType), ]) + geom_point(aes(Year,Hardwood), color = "red")  + geom_point(aes(Year, Softwood), color = "green") + geom_point(aes(Year, TotalSpecies), color = "black") + xlab("Year") + ylab("Number of Plantations") + ggtitle(paste("Plantations of Canton:", input$canton), paste(input$ownerType, ", Hardwood (red), Softwood (green) and Wood Species total (black) "))
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
      data <- ForestData[ForestData$Canton==input$canton & ForestData$TypeofOwner == input$ownerType,  ]
      data <- data[(data$Year>=(year(input$dateRange)[1]) & data$Year<=(year(input$dateRange)[2])), ]
    }))
    
    output$aboutFile <- renderUI({
      file <- includeMarkdown("about.md")
    })
  })  
``` 
  
    
## 3. Assignment DDP 9.4
Coursera:         Data Science Specialization   
Course 9:         Developing Data Product 
Assignment 9.4:   Shiny App, shinyapps.io server, Markdown, R Packages, R Presenter, Github, Rpubs  
   
   
### 3.1 ToDo-List
**Shiny Application deployed on Rstudio's servers:**  
The application must include the following:  
- Some form of input (widget: textbox, radio button, checkbox, ...)  
- Some operation on the ui input in sever.R  
- Some reactive output displayed as a result of server calculations  
- The documentation should be at the Shiny website itself.   
- Codes server.R and ui.R code shared on github  
  
**Reproducible Presentation using RStudio Presenter:**  
- Created a web page using Rstudio Presenter    
- 5 pages (inclusive title slide)  
- Hosted on Rpubs  
- Contains embedded R code that gets run when slidifying the document  
  
  
### 3.2 Review criterias 
**Shiny Application** 
- Was there enough documentation on the shiny site for a user to get started using the application?  
- Did the application run as described in the documentation?  
- Was there some form of widget input (slider, textbox, radio buttons, checkbox, ...) in either ui.R or a custom web page?  
- Did server.R perform some calculations on the input in server.R?  
- Was the server calculation displayed in the html page?  
  
**Reproducible Presentation** 
- Was the presentation completed in slidify or R Presenter?  
- Was it 5 pages?  
- Did it contain an R expression that got evaluated and displayed?  
- Was it hosted on github or Rpubs?  
- Was the server calculation displayed in the html page?  
