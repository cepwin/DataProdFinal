#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Create Exploratory Plot of Data"),
  sidebarLayout(
    sidebarPanel(
    selectInput("visData","Select Existing Data: ", 
                c("MT Cars" = "mtcars","EU Stock Markets"="EuStockMarkets")),
    selectInput("colA","Select data Column x: ",c()),
    selectInput("colB","Select data Column y: ",c()),
    selectInput("colC","Select data Column z: ",c()),
    selectInput("colD","Select data Column color: ",c()),
##    submitButton("Select data"), 
    actionButton("PlotDat","Plot the Data")
  ),
    mainPanel(
      h3("Linear Model Output"),
      verbatimTextOutput("text1"),
      h3("Exploratory Graph"),
      plotlyOutput("pPlot", height="500px")
    )
  )
))


