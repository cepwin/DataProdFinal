# Define server logic required to draw a histogram



library(shiny)
library(shinyjs)
library(plotly)

newdata<-data.frame()
 g<-plot_ly(mtcars, x= ~mpg, y = ~cyl, z = ~disp, type = "scatter3d", color = ~hp)

shinyServer(function(input, output,session) {
   dataLst <- list()
   dataLst[["mtcars"]] <-mtcars
   dataLst[["EuStockMarkets"]] <- EuStockMarkets
   dataLst[["CO2"]] <- CO2
   dataLst[["WWWusage"]] <- WWWusage
   dataLst[["ChickWeight"]] <- ChickWeight
   dataLst[["OrchardSprays"]] <-OrchardSprays
   dataLst[["USPersonalExpenditure"]] <- USPersonalExpenditure
   dataLst[["UCBAdmissions"]] <- UCBAdmissions 
   dataLst[["airquality"]] <- airquality
   dataLst[["UKgas"]] <- UKgas
   
   ##Reactive method
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
              data2<-dataLst[[datasel2]]
              if(class(data2) == "data.frame") {
                newdata2<-data2
              } else {
                newdata2<-as.data.frame(data2)
              }
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