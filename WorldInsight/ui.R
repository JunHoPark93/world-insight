library(leaflet)
source("ui_mainPage.R")

navbarPage("Superzip", id="nav",
           
           tabPanel("Start",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeCSS("../Data/mainpageStyles.css"),
                          includeScript("gomap.js")
                        ),
                        frontp())
           ),
           
           tabPanel("World map",
                    div(class="outer",
                        leafletOutput("map", width="100%", height="100%"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, 
                                      bottom = "auto",width = 330, height = "auto",
                                      
                                      h2("World Map (세계지도)"),
                                      
                                      selectInput("period", "연도", periodGlobal, selected = "2000"),
                                      selectInput("prodName", "품목", prodName, selected = "살아 있는 동물"), 
                                      selectInput("option", "옵션", option, selected = "imprtMny")))
                              
           ), # end of tab Panel (World Map)
           
           tabPanel("Yearly Country Graph",
                    fluidPage(    
                      
                      # Give the page a title
                      titlePanel("Product by Region"),
                      
                      # Generate a row with a sidebar
                      sidebarLayout(      
                        
                        # Define the sidebar with one input
                        sidebarPanel(
                          selectInput("countryName_graph", "지역:", 
                                      country$countryKor, selected = "가나"),
                          selectInput("prodName_graph", "품목명", prodName, selected = "살아 있는 동물"),
                          selectInput("option_graph", "옵션" , option, selected = "imprtMny"),
                          hr()
                        ),
                        
                        # Create a spot for the barplot
                        mainPanel(
                          plotOutput("yearlyCountryPlot")  
                        )))
          ) # end of tab panel (Yearly Countr Graph)
                        
                      
)








