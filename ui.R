library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(dplyr)
library(DT)
library(xlsx)

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
      column(
        width=6,
        valueBoxOutput("SatisfatorioBox", width = 6),
        valueBoxOutput("InsatisfatorioBox",width = 6),
         box(
           width= 12, title = "Representação Gráfica",status = "primary",solidHeader = TRUE ,collapsible = TRUE
             )
        ),
      column(
        width = 6,
        box(
          width = 12, title = "Variavéis",status = "primary",solidHeader = TRUE ,collapsible = TRUE,
          dataTableOutput("tabelaVariaveis")
        ),
        box(
          width=12,title = "Alunos",status = "primary",solidHeader = TRUE ,collapsible = TRUE,
          dataTableOutput("tabelaAluno")
        )
      )
    )
  )
)