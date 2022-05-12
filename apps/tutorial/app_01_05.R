library(shiny)
library(ggplot2)
library(reactable)


datasets <- c("economics", "faithful", "seals")

ui <- fluidPage(
  shinythemes::themeSelector(),
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot"),
  reactableOutput("table")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot(
    {
      plot(dataset())
    },  res = 96,
    height = 300,
    width = 700)
  
  output$table <-  renderReactable(reactable(mtcars))
  
}

shinyApp(ui, server)


