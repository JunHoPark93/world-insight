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
 
  
  
  
}