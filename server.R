# Define server logic required to draw a histogram



library(shiny)
library(plotly)

newdata<-data.frame()

shinyServer(function(input, output,session) {
   dataLst <- list()
   dataLst[["mtcars"]] <-mtcars
   dataLst[["EuStockMarkets"]] <- EuStockMarkets
  # choise<-c("a","b")
  # g<-  plot_ly(mtcars, x= ~mpg, y = ~cyl, z = ~disp, type = "scatter3d", color = ~hp)

   plotdata<- reactive({
     datasel <- input$visData
     data2<-dataLst[[datasel]]
    if(class(data2) == "data.frame") {
      newdata<-data2
     } else {
     newdata<-as.data.frame(data2)
    }
    choise<-names(newdata)
    updateSelectInput(session, "colA",
                      choices = choise)
    updateSelectInput(session, "colB",
                      choices = choise)
    updateSelectInput(session, "colC",
                      choices = choise)
    updateSelectInput(session, "colD",
                      choices = choise)
    
    datasel
    })
   

  output$text1 <- renderText({
    plotdata()
  })
  
  outtext <-eventReactive(input$PlotDat,
            { 
              datasel <- input$visData
              data2<-dataLst[[datasel]]
              if(class(data2) == "data.frame") {
                newdata<-data2
              } else {
                newdata<-as.data.frame(data2)
              }
              
              g<-plot_ly(newdata, x= ~newdata[[input$colA]], y = ~newdata[[input$colB]], z = ~newdata[[input$colC]],  color = ~newdata[[input$colD]]) %>% 
                add_markers() %>%
                layout(scene = list(xaxis = list(title = input$colA),
                                    yaxis = list(title = input$colB),
                                    zaxis = list(title = input$colC)))
              
              g
        })
 
 
 output$pPlot <- renderPlotly({
 outtext()
 })
 
})