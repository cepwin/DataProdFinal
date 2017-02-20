# Define server logic required to draw a histogram



library(shiny)
library(shinyjs)
library(plotly)

newdata<-data.frame()
 g<-plot_ly(mtcars, x= ~mpg, y = ~cyl, z = ~disp, type = "scatter3d", color = ~hp)

shinyServer(function(input, output,session) {
  
  #This method handles filling the list of datasets
  #Only data of the type data.frame that have at least 4 columns are incorporated
  getDataSets<-function() {
    ds<-data(package="datasets")
    res<-ds$results
    dsNames<-res[,3]
    choise<-c()
    dataLst<-list()
    for(i in 1:length(dsNames)) {
      wd<-strsplit(dsNames[[i]]," ")[[1]]
      dsNames[[i]]<-wd[1]
      assign("xo", get(wd[1]))
      if("data.frame" %in% class(xo)){
        if(ncol(xo) >= 4) {
          choise<-c(choise,wd[1])
          dataLst[[wd[1]]]<-xo
        }
      } else {
        if("ts" %in% class(xo)){
          xoDF <- as.data.frame(xo)
          if(ncol(xoDF) >= 4) {
            choise<-c(choise,wd[1])
            dataLst[[wd[1]]]<-xoDF
          }
        }
      }
    }
    updateSelectInput(session, "visData",
                      choices = choise)
    dataLst
  }
  
  dataLst <- getDataSets()
    
   ##Reactive method takes selected dataset and calculates the lm 
  ## which is then displayed.
   plotdata<- reactive({
     shinyjs::hideElement("pPlot")
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
    x<-lm(newdata[,1] ~., data = newdata)
     x
    })
   ##End of reactive method
   


  output$text1 <- renderPrint({
    summary(plotdata())
  })
  
  outtext <-eventReactive(input$PlotDat,
            { 

              datasel2 <- input$visData
              newdata2<-dataLst[[datasel2]]
              xval<-input$colA
              yval<-input$colB
              zval<-input$colC
              cval<-input$colD
              tinydf<-cbind(newdata2[[xval]],newdata2[[yval]],newdata2[[zval]],newdata2[[cval]])
              g<-plot_ly(newdata2, x= ~newdata2[[xval]], y = ~newdata2[[yval]], z = ~newdata2[[zval]],  
                         marker = list(color = ~newdata2[[cval]],text=cval,showscale=TRUE))%>% 
                add_markers() %>%
                layout(scene = list(xaxis = list(title = xval),
                                    yaxis = list(title = yval),
                                    zaxis = list(title = zval)),
                       annotations = list(           
                         x = 1.07,
                         y = 1.03,
                          text = cval,
                         xref = 'paper',
                         yref = 'paper',
                         showarrow = FALSE
                            ))
              shinyjs::showElement("pPlot")
              g

        })
 
 
 output$pPlot <- renderPlotly({
 outtext()
 })
 
})