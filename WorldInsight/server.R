set.seed(100)

function(input, output, session) {
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4) 
  })
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if(is.null(event))
      return()
    
    isolate({
      showPopup(event$id, event$lat, event$lng, input$period, input$prodName, input$option)
    })
  })
  
  observe({
    periodSelected <- input$period
    prodName <- input$prodName
    options <- input$option
    print(is.character(options))
    
    mapData <- worldDataFiltered %>% filter(prodNm == input$prodName) %>% filter(period %in% input$period) %>% group_by(countryKor, lat, lng, numericCode) %>% summarise_(total = interp(~sum(var, na.rm = TRUE), var = as.name(options)))
    
    print(mapData)
    colorData <- mapData$total
    
    pal <- colorFactor("plasma", colorData)
    
    # bin은 분야별 색깔 범위를 지정하는 갯수
    pal <- colorBin("viridis", colorData, 5, pretty = FALSE)
    radius <- 300000
    
    # reflect to map
    leafletProxy("map", data = mapData) %>%
      clearShapes() %>%
      addCircles(~lng, ~lat, radius = radius, layerId = ~numericCode, stroke = FALSE, fillOpacity = 0.4, fillColor = pal(colorData)) %>% 
      addLegend("bottomleft", pal = pal, values = colorData, title = prodName, layerId = "colorLegend")
  })
  
  # Show a popup at the given location
  showPopup <- function(numericCodeInput, latInput, lngInput, periodInput, prodNmInput, optionInput) {
    
    selected <- worldDataFiltered %>% 
      filter(numericCode == numericCodeInput & period == periodInput & prodNm == prodNmInput) %>%
      mutate(exprtWgh = sum(exprtWgh), imprtWgh = sum(imprtWgh), exprtMny = sum(exprtMny),
             imprtMny = sum(imprtMny))
    
    print(selected)
    content <- as.character(tagList(
      tags$h4("나라 이름:", selected$countryKor),
      tags$strong("나라 이름 영문 표기 : ", selected$countryEng), tags$br(),
      sprintf("(USD 1,000) / TON"), tags$br(),
      tags$br(),
      sprintf("수출중량: %s", selected$exprtWgh, tags$br()),
      sprintf("수입중량: %s", as.integer(selected$imprtWgh)), tags$br(),
      sprintf("수출금액: %s", dollar(selected$exprtMny)),
      sprintf("수입금액: %s", dollar(selected$imprtMny))
    ))
    leafletProxy("map") %>% addPopups(lngInput, latInput, content, layerId = numericCodeInput)
  }
  
  ## Graph ##################
  
  observe({
    countryName_graph <- input$countryName_graph
    option_graph <- input$option_graph
    prodName_graph <- input$prodName_graph
    
    graph_y <- paste0(option_graph,"Total")
    graph_x = "period"
    
    output$yearlyCountryPlot <- renderPlot({
      
      # passsing variable in ggplot x,y data
      ggplot(data = sumCountryProductPerPeriod %>% filter(countryKor == countryName_graph & prodNm == prodName_graph), aes_string(x=graph_x, y=graph_y)) + geom_col()
      
    })
  })
  
  ## Variation #################
  
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(country$countryKor)
  )
  
  yearData <- reactive({
    df <- sumCountryPerPeriod %>%
      filter(period == input$year_variation) %>% 
      select(countryKor, imprtMnyTotal, exprtMnyTotal,
             imprtWghTotal, exprtWghTotal) %>%
      arrange(countryKor)
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Import Money vs Export Money, %s",
          input$year_variation),
        series = series
      )
    )
  })
  
  ## Surplus Graph ########
  output$surplustable <- DT::renderDataTable(DT::datatable({
    data <- worldDataFiltered %>% filter(countryKor == input$countryName_table & prodNm == input$prodName_table & ifSurplus == input$ifSurplus_table) %>% select(period, ifSurplus, prodNm, countryKor, countryEng, tradeBalance, exprtWgh, imprtWgh, exprtMny, imprtMny)
    data
  }))
  
  
  ## Top Nations #########
  
  observe({
    
    prodName_top <- input$prodName_top
    option_top <- input$option_top
    
    # get top 5 countries
    topnation <- worldDataFiltered %>% group_by(countryKor, prodNm) %>% filter(prodNm == prodName_top) %>% summarise_(total = interp(~sum(var, na.rm=TRUE), var = as.name(option_top)))
    
    topnation <- topnation %>% arrange(desc(topnation$total)) # arranging total in descending order
    topnation <- head(topnation,5)                            # get top 5
    topnation <- topnation$countryKor
    
    linedata <- worldDataFiltered %>% filter(countryKor %in% topnation & prodNm == prodName_top) %>% group_by(countryKor, countryEng, prodNm, period) %>% summarise_(total = interp(~sum(var, na.rm = TRUE), var = as.name(option_top)))
    
    output$topPlot <- renderPlot({
      ggplot(data = linedata, aes(x = period, y = total, group = countryEng, colour = countryEng)) + geom_line()
    })
  })
  
}