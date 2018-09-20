library(leaflet)
source("ui_mainPage.R")

navbarPage("WorldInsight", id="nav",
           
           tabPanel("Start",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeCSS("mainpageStyles.css"),
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
          ), # end of tab panel (Yearly Countr Graph)
          
          tabPanel("Money Variation",
                   googleChartsInit(),
                   
                   # Use the Google webfont "Source Sans Pro"
                   tags$link(
                     href=paste0("http://fonts.googleapis.com/css?",
                                 "family=Source+Sans+Pro:300,600,300italic"),
                     rel="stylesheet", type="text/css"),
                   tags$style(type="text/css",
                              "body {font-family: 'Source Sans Pro'}"
                   ),
                   
                   h2("MoneyFlow Chart"),
                   
                   googleBubbleChart("chart",
                                     width="100%", height = "475px",
                                     
                                     options = list(
                                       fontName = "Source Sans Pro",
                                       fontSize = 13,
                                       # Set axis labels and ranges
                                       hAxis = list(
                                         title = "Import Money Total ($USD)",
                                         viewWindow = xlim
                                       ),
                                       vAxis = list(
                                         title = "Export Money Total (years)",
                                         viewWindow = ylim
                                       ),
                                       # The default padding is a little too spaced out
                                       chartArea = list(
                                         top = 50, left = 75,
                                         height = "75%", width = "75%"
                                       ),
                                       # Allow pan/zoom
                                       explorer = list(),
                                       # Set bubble visual props
                                       bubble = list(
                                         opacity = 0.4, stroke = "none",
                                         # Hide bubble label
                                         textStyle = list(
                                           color = "none"
                                         )
                                       ),
                                       # Set fonts
                                       titleTextStyle = list(
                                         fontSize = 16
                                       ),
                                       tooltip = list(
                                         textStyle = list(
                                           fontSize = 12
                                         )
                                       )
                                     )
                   ),
                   fluidRow(
                     shiny::column(4, offset = 4,
                                   sliderInput("year_variation", "Year",
                                               2000, 2018,
                                               value = 2000, animate = TRUE)
                     )
                   )
          ), # end of tab panel (Money Variation)
          
          tabPanel("Surplus Table",
                   fluidPage(
                     titlePanel("Surplus DataTable"),
                     
                     # Create a new Row in the UI for selectInputs
                     fluidRow(
                       selectInput("countryName_table",
                                   "나라 이름:",
                                   country$countryKor,
                                   selected = "가나"
                       ),
                       
                       selectInput("prodName_table",
                                   "품목명:",
                                   prodName,
                                   selected = "살아 있는 동물"
                       ),
                       
                       selectInput("ifSurplus_table",
                                   "무역수지:",
                                   c("적자", "흑자"),
                                   selected = "적자")
                     ),
                     # Create a new row for the table.
                     fluidRow(
                       DT::dataTableOutput("surplustable")
                     )
                   )
                   
          ), # end of tabPanel (Surplus Table)
          
          
          tabPanel("Top Countries",
                   fluidPage (    
                     titlePanel("Top Nations"),
                     
                     sidebarLayout(      
                       sidebarPanel(
                         selectInput("prodName_top", "품목명", choices = prodName),
                         selectInput("option_top", "옵션" , option, selected = "imprtMny"),
                         hr()
                       ),

                       mainPanel(
                         plotOutput("topPlot"))))
          ), # end of tabPanel (Top Countries)
          
          
          tabPanel("Top10 Product",
                   fluidPage(
                     titlePanel("Top10 Trade"),

                     fluidRow(
                       selectInput("period_topTrade", "기간", periodGlobal, selected = '2010'),
                       selectInput("option_topTrade", "옵션", optionMoney, selected = "imprtMny")
                     ),
                     
                     fluidRow(
                       DT::dataTableOutput("topCountriesTable")))
                   
          ) # end of tabPanel (Top10 Product)
)








