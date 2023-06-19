library(shiny)
library(mongolite)
library(plotly)
library(shinythemes)

# Connect to Mongo Data Base
mongo_conn <- mongo(collection = "test", url = "mongodb+srv://mikimartins:w87gYRgtOyQftcvW@cluster0.cmbdr1m.mongodb.net/?retryWrites=true&w=majority")
# Define the UI
ui <- fluidPage(
  theme = shinytheme("slate"),
  titlePanel("Lista de clientes"),
  navbarPage(
    "",
    id = "navtabs",
    tabPanel("Formulario",
             div(
               class = "container",
               style = "margin-top: 30px;",
               fluidRow(
                 column(
                   width = 6,
                   offset = 3,
                   div(
                     class = "card",
                     div(
                       class = "card-body",
                       h5("User Information"),
                       br(),
                       textInput("name", "Name:"),
                       textInput("email", "Email:"),
                       textInput("phone", "Phone Number:"),
                       selectInput("status", "Status:", choices = c("Pending", "Approved", "Client")),
                       selectInput("region", "Region:", choices = c(
                         "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", 
                         "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", 
                         "SP", "SE", "TO"
                       )),
                       numericInput("salary", "Salary:", value = 0),
                       actionButton("submit", "Submit")
                     )
                   )
                 )
               )
             )
    ),
    tabPanel("Lista", tableOutput("formData")),
    tabPanel("Graficos",
             fluidRow(
               column(6, plotlyOutput("funnelChart")),
               column(6, plotlyOutput("pieChart"))
             ),
             fluidRow(
               column(12, plotlyOutput("histogram"))
             )
    )
  )
)

# Define the server
server <- function(input, output, session) {
  # Create reactive values to store form data
  formData <- reactiveValues(time = Sys.time())
  
  # Save the form data to MongoDB
  observeEvent(input$submit, {
    data <- data.frame(
      Name = input$name,
      Email = input$email,
      Phone = input$phone,
      Status = input$status,
      Region = input$region,
      Salary = input$salary,
      Time = formData$time
    )
    
    # Insert the data into the MongoDB collection
    mongo_conn$insert(data)
  })
  
  # Fetch the form data from MongoDB
  output$formData <- renderTable({
    req(mongo_conn$find())
  })
  
  
  # Create a funnel chart based on the Status column
  
  # Create a funnel chart based on the Status column
  output$funnelChart <- renderPlotly({
    req(mongo_conn$find())
    data <- mongo_conn$find()
    
    if (nrow(data) > 0) {
      # Prepare data for funnel chart
      funnel_data <- table(data$Status)
      
      funnel_labels <- c("Pending", "Approved", "Client")
      funnel_values <- funnel_data[funnel_labels]
      
      plot_ly(
        x = funnel_values,
        y = funnel_labels,
        type = "funnel",
        textinfo = "value+percent previous"
      ) %>%
        layout(
          plot_bgcolor = "transparent",
          paper_bgcolor = "transparent",
          yaxis = list(categoryarray = funnel_labels)
        )
    } else {
      # Display a message if no data is available
      plot_ly(
        type = "scatter",
        mode = "text",
        x = 0.5,
        y = 0.5,
        text = "No data available",
        textfont = list(color = "black", size = 20),
        hoverinfo = "none"
      ) %>%
        layout(
          plot_bgcolor = "transparent",
          paper_bgcolor = "transparent",
          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
        )
    }
  })
  
  
  
  
  
  
  
  # Create a pie chart based on the Region column
  output$pieChart <- renderPlotly({
    req(mongo_conn$find())
    pie_data <- table(mongo_conn$find()$Region)
    plot_ly(
      labels = names(pie_data),
      values = pie_data,
      type = "pie"
    ) %>%
      layout(
        plot_bgcolor = "transparent",
        paper_bgcolor = "transparent"
      )
  })
  
  # Create a histogram to count the number of registrations by time
  output$histogram <- renderPlotly({
    req(mongo_conn$find())
    time_data <- as.POSIXct(mongo_conn$find()$Time)
    hist_data <- data.frame(Time = time_data)
    plot_ly(hist_data, x = ~Time, type = "histogram") %>%
      layout(
        plot_bgcolor = "transparent",
        paper_bgcolor = "transparent"
      )
  })
  
  # Update the active tab based on the selected tab
  observeEvent(input$navtabs, {
    updateTabsetPanel(session, "navtabs", selected = input$navtabs)
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
