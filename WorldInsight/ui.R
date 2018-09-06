source("ui_mainPage.R")

navbarPage("WorldInsight", id="nav",
           
           tabPanel("Start",
                    div(class="outer",
                        
                        tags$head(
                          includeCSS("../Data/mainpageStyles.css")
                        ),
                        
                        frontp()
                    )
           )
)