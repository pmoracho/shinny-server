library(dplyr)
library(ggplot2)
library(forcats)
library(vroom)
library(shiny)
library(ggelegant)

if (!exists("injuries")) {
  app_root <- "./apps/tutorial"
  data_path <-file.path(app_root, "neiss")

  injuries <- vroom::vroom(file.path(data_path, "injuries.tsv.gz"))
  products <- vroom::vroom(file.path(data_path, "products.tsv"))
  population <- vroom::vroom(file.path(data_path, "population.tsv"))
  
}

ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count"))),
    column(2, numericInput("n", "Observations:", 5, min = 1, max = 10))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(1, actionButton("prev_narrative", "<")),
    column(1, actionButton("next_narrative", ">")),
    column(10, textOutput("narrative"))
  )
)

#<< count_top
count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_infreq(fct_lump({{ var }}, n = n))) %>%
    #mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}
#>>

server <- function(input, output, session) {
  
  selected <- reactive(injuries %>% 
                         filter(prod_code == input$code))

  nro_fila <- reactiveVal(value=1)
  filas <- reactive(nrow(selected()))
  
  observeEvent(input$code, {nro_fila(1)})
  
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
  
  output$narrative <- renderText(selected()$narrative[nro_fila()])
  
  #<< tables
  output$diag <- renderTable(count_top(selected(), diag, input$n), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, input$n), width = "100%")
  output$location <- renderTable(count_top(selected(), location, input$n), width = "100%")
  #>>

  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        geom_smooth(se = FALSE) +
        labs(y = "Estimated number of injuries") +
        theme_elegante_std(base_family =  "Ubuntu Condensed")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        geom_smooth(se = FALSE) +
        labs(y = "Injuries per 10,000 people") +
        theme_elegante_std(base_family =  "Ubuntu Condensed")
    }
  }, res = 96)
}

shinyApp(ui, server)