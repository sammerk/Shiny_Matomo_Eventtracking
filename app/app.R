library(shiny)

ui <- fluidPage(
  tags$head(HTML("<script>
  var _paq = window._paq = window._paq || [];
  
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u='https://shinyapp.matomo.cloud/';
    _paq.push(['setTrackerUrl', u+'matomo.php']);
    _paq.push(['setSiteId', '1']);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.async=true; g.src='https://cdn.matomo.cloud/shinyapp.matomo.cloud/matomo.js'; s.parentNode.insertBefore(g,s);
  })();
</script>")),
  
  
  tags$script(HTML(
    "$(document).on('shiny:inputchanged', function(event) {
       if (event.name === 'bins' || event.name === 'col') {
         _paq.push(['trackEvent', 'input',
           'updates', event.name, event.value]);
       }
     });"
  )),
  
  # -- Application UI
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Number of bins:",
                  min = 1, max = 50, value = 30),
      selectInput("col", "Barplot Color",
                  c("blue", "grey", "purple", "orange"), selected = "grey")
    ),
    
    mainPanel(
      h1(textOutput("user")),
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output, session) {
  
  output$user <- renderText({
    paste0("Hello ", session$user,
           "! This app is tracked by Matomo")
  })
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = input$col, border = 'white')
    
  })
  
}

shinyApp(ui = ui, server = server)