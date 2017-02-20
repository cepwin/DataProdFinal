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
  titlePanel("Explore the Data Set"),
  sidebarLayout(
    sidebarPanel(
    selectInput("visData","Select Existing Data: ", 
                c("MT Cars" = "mtcars")),
    selectInput("colA","Select data Column x: ",c()),
    selectInput("colB","Select data Column y: ",c()),
    selectInput("colC","Select data Column z: ",c()),
    selectInput("colD","Select data Column color: ",c()),
##    submitButton("Select data"), 
    actionButton("PlotDat","Plot the Data")
  ),
    mainPanel(
      tabsetPanel(
        tabPanel("Output",
        h3("Linear Model Output"),
        verbatimTextOutput("text1"),
        h3("Exploratory Graph"),
        plotlyOutput("pPlot", height="500px")
        ),
        tabPanel("Instructions",
           h3("Description"),
             p("The purpose of this application is to allow one to perform some very basic analysis of the data sets provided."),
            h3("Use"),
            p("To use the app do the following"),
            tags$li("Select one of the existing data set.  This will set off the reactive method that wll calculate the linear model and fill the column fields."),
           tags$li("Select the x, y and z axis as well as an additional column 'color.' The data points color will be based on the value of this column."),
            tags$li("Click on 'Plot the Data' and this will create a plotly plot (called 'Exploratory Graph') based on the x, y, z and color values selected earlier.")
          ) 
         )
      )
    )
  )
)


