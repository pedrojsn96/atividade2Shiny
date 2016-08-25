library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(dplyr)
library(DT)

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
  dashboardBody(
    fluidRow(
      column(width=12,
             valueBoxOutput("SatisfatorioBox", width = 4),
             valueBoxOutput("InsatisfatorioBox",width = 4),
             box(
               title = "Variavéis",status = "primary",width = 4,solidHeader = TRUE ,collapsible = TRUE
               
             )),
      column(width=12,
             box(
               title = "Representação Gráfica",status = "primary",width=8,solidHeader = TRUE ,collapsible = TRUE
               
             ),
             box(
               title = "Alunos",status = "primary",width = 4,solidHeader = TRUE ,collapsible = TRUE,
               dataTableOutput("tabelaAluno")
               
               
             ))
      
    )
  )
)