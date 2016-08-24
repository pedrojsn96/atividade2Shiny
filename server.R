library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(dplyr)

#Observação:
#Esta usando X.U.FEFF.Curso, pois fiz uma leitura com enconding = "UTF-8"
# dados<- read.csv2(file = "data/baseGeral.csv", enconding = "UTF-8")

shinyServer(function(input, output) {
  
  #Select para Curso
  output$seletorCurso <- renderUI({
    cursos <- as.character(unique(dados$X.U.FEFF.Curso))
    selectInput("curso", "Escolha o Curso:", choices = (sort(cursos)))
  })
  #Select para o periodo a depender do curso escolhido
  output$seletorPeriodo <- renderUI({
    periodos <- filter(dados, X.U.FEFF.Curso == input$curso)
    selectInput("periodo", "Escolha o Periodo:", sort(as.character(unique(periodos$Período))))
  })
  #Select da disciplina a depender do curso e do periodo escolhido
  output$seletorDisciplina <- renderUI({
    disciplinas <- filter(dados,X.U.FEFF.Curso == input$curso, Período == input$periodo)
    selectInput("disciplina","Escolha a Disciplina:",as.character(unique(disciplinas$Nome.da.Disciplina)))
  })
  
  

})
