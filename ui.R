library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(dplyr)

dashboardPage(
  dashboardHeader(title = "Atv Complementar"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Parametros",tabName = "Parametros", icon = icon("dashboard"))
          ),
          uiOutput("seletorCurso"),
          uiOutput("seletorPeriodo"),
          uiOutput("seletorDisciplina")
    
  ),
  dashboardBody()
)