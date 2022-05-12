library(shiny)

today <- Sys.Date()
ui <- fluidPage(
  textInput("name", "What's your name?", placeholder = "Ingrese su nombre"),
  #sliderInput("fecha", "When should we deliver?", value = today + 3, min = today, max = today + 10),
  sliderInput("numero", "Ingrese el rango", value=50, step=5, min = 0, max = 100),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

shinyApp(ui, server)