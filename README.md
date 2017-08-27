# AssignmentDDP9_4
  
Coursera:   Data Science Specialization  
Course 9:   Developing Data Products  
Assignment: **Shiny App** published on shinyapp.io & **Reproducible Pitch** created with RStudio Presenter and published on Rpubs
  
This repository contains the R code, data and files for the Shiny app [AssignDDP94](https://mhunkeler.shinyapps.io/assignddp94/) and for the R Presentation [East Swiss: Forest Growth and Number of Plantations](http://www.rpubs.com/mhunkeler) published on Rpubs.
  
Swiss Federal Statistical Office Data [raw data](https://github.com/monika66/AssignmentDDP9_4/tree/rawdata) got pre-processed with R script **MergeSwissForestData.R** to data file **ForestData.csv**.  

[raw data](https://github.com/monika66/AssignmentDDP9_4/tree/rawdata) and pre-processing R script **MergeSwissForestData.R** are not needed in the Shiny app bundle but could be seen in the [rawdata branch](https://github.com/monika66/AssignmentDDP9_4/tree/rawdata) too.

**ForestData.csv** contains **Foreast Area Growth and Number of Plantations data** for the east Swiss Cantons:  
- Appenzell Innerrhoden, 
- Apenzell Ausserrhoden, 
- Glarus, Graubuenden / Grigioni / Grischun
- Schaffhausen, 
- St. Gallen
- Thurgau

Shiny app AssignDDP94 calculates based on **ForestData.csv** data and the choosen filter parameter **Canton, Type of Owner and Date Range** the  
- Total Forest Area growth [ha]  
- Productive Area growth [ha]  
- Total Number of Plantations   
and plots the  
- Forest Areas [ha]  
- Number of Plantations  
  
More details see **about.md** 
  

 
