require(markdown)
library(shiny)

#
# Server 
#
server <- function(input, output) {
  
  # Directory where log files of shiny applications are stored
  shinyLogDir <- "/var/log/shiny-server/"
  
    
  #
  # List all files in a data frame
  #
  output$text <- renderTable({
    as.data.frame(list.files(shinyLogDir,full.names = T))
  })
    
  
  #
  # Display select box with available shiny applications
  #
  output$selectApplication <- renderUI({
    files <- list.files(shinyLogDir,full.names = F)
    appsAvailable <- unique(gsub("(.?)-shiny-.*", "\\1", files))
    selectInput(inputId = "appSelected",label = "Shiny Application :", choices=appsAvailable)
  })
  
  #
  # Display select box with available logs for the application choosen
  #
  output$selectLog <- renderUI({
    if(is.null(input$appSelected))
      return()
    
    files <- list.files(shinyLogDir,paste0(input$appSelected,".*"),full.names = F)
    selectInput(inputId = "logFileSelected",label = "log file :", choices=files)
  })
  
  
  #
  # Display content of log files
  #
  output$log <- renderTable({
    
    if(is.null(input$logFileSelected))
      return()
    
    fileText <- paste(readLines(paste0(shinyLogDir, input$logFileSelected)), collapse = "\n")
    fileText
  })
  
  
  #
  # List available R packages
  #
  output$pck <- renderTable({
    installed.packages()
  })
}


#
# UI
#
listLogFilesTab <- tabPanel("Liste des logs",tableOutput(outputId = "text"))
packagesTab <- tabPanel("Listes des packages",tableOutput("pck"))
logFileTab <- tabPanel(title = " Visu. Log.",
                        sidebarPanel(htmlOutput("selectApplication"),htmlOutput("selectLog")),
                        mainPanel(verbatimTextOutput(outputId = "log"))
                       )

ui <- fluidPage(
    navbarPage(title = "Shiny Server information",
               logFileTab,
               listLogFilesTab,
               packagesTab
    )
  )


shinyApp(ui,server)

