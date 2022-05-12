library(shiny)

ui <- fluidPage(
  actionButton("prev_narrative", "<"),
  actionButton("next_narrative", ">"),
  textOutput("narrative")
)

server <- function(input, output, session) {
  
  nro_fila <- reactiveVal(value=1)
  filas <- reactiveVal(value=10)
  
  observeEvent(input$next_narrative,{
    if (nro_fila() == filas()) {
      nro_fila(1)
    } else {
      nro_fila(nro_fila()+1)
    }
  })
  
  observeEvent(input$prev_narrative,{
    if (nro_fila() == 1) {
      nro_fila(filas())
    } else {
      nro_fila(nro_fila()-1)
    }
  })
  
  output$narrative <- renderText(nro_fila())
}

shinyApp(ui, server)


