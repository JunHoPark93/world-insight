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
                        leafletOutput("map", width="100%", height="100%")
                        
                        
                    )
           )
                        
                      
)