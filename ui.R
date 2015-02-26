
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


shinyUI(fluidPage(

  # Application title
  titlePanel("Relative abundance (%) of Sample"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    selectInput("SampleID", "Sample ID:", colnames(ya[[1]])[-(1:2)]),
    selectInput("TaxoLv", "Taxonomic rank:", lvn)
    ),
  
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot1"),
      plotOutput("distPlot2"),
      htmlOutput("gvis")
    )
  )
))
