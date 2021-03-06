library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(xlsx)
library(plotly)

#Observação:
#Esta usando X.U.FEFF.Curso, pois fiz uma leitura com encoding = "UTF-8"
# dados<- read.csv2(file = "data/baseGeral.csv", encoding = "UTF-8")
# dicionarioDados <- read.xlsx("data/DicionarioDados.xlsx",1, encoding = 'UTF-8')

dados<- read.csv2(file = "data/baseGeral.csv", encoding = "UTF-8")
dicionarioDados <- read.xlsx("data/DicionarioDados.xlsx",1, encoding = 'UTF-8')
dicionarioDados1 <- read.xlsx("data/DicionarioDados.xlsx",2, encoding = 'UTF-8')
#Uniao das duas abas do arquivo excel
dicionario <- merge(dicionarioDados, dicionarioDados1, all = T,sort = T)

#Lista de Variveis
listaVariaveis <- data.frame(dicionario[,c("Variável","Descrição.sobre.as.variáveis")])

shinyServer(function(input, output) {
  
  #Select para Curso
  output$seletorCurso <- renderUI({
    cursos <- as.character(unique(dados$Curso))
    selectInput("curso", "Escolha o Curso:", choices = (sort(cursos)))
  })
  #Select para o periodo a depender do curso escolhido
  output$seletorPeriodo <- renderUI({
    periodos <- filter(dados, Curso == input$curso)
    showPeriodo <- sort(as.character(unique(periodos$Período)))
    names(showPeriodo)<- paste(showPeriodo,"º Periodo")
    selectInput("periodo", "Escolha o Periodo:", showPeriodo)
  })
  #Select da disciplina a depender do curso e do periodo escolhido
  output$seletorDisciplina <- renderUI({
    disciplinas <- filter(dados,Curso == input$curso, Período == input$periodo)
    selectInput("disciplina","Escolha a Disciplina:",as.character(unique(disciplinas$Nome.da.Disciplina)))
  })
  
  ## InfoBoxes
  ##Base de acordo com os parametros escolhidos
  baseFiltrada <- reactive({
    filter(dados,Curso == input$curso, Período == input$periodo, Nome.da.Disciplina == input$disciplina)
  }) 
  #Cria um tabela agrupando DESEMPENHO_BINARIO em 0 e 1
  variavelClasse <- reactive({
    table(baseFiltrada()$DESEMPENHO_BINARIO)
  })
  #Retorna a % Satisfatoria
  variavelSatisfatoria <- reactive({
    if(is.na(variavelClasse()[1])){
      0
    }else{
      round((variavelClasse()[1]/count(baseFiltrada()))*100,2) 
    }
  })
  #Retorna a % Insatisfatoria
  variavelInsatisfatoria <- reactive({
    if(is.na(variavelClasse()[2])){
      0
    }else{
      round((variavelClasse()[2]/count(baseFiltrada()))*100,2) 
    }
  })
  output$SatisfatorioBox <- renderValueBox({
    valueBox(
      paste0(variavelSatisfatoria(),"%"),"Satisfatório", icon = icon("thumbs-o-up "),
      color = "green", width = 4
    )
  })
  output$InsatisfatorioBox <- renderValueBox({
    valueBox(
      paste0(variavelInsatisfatoria(),"%"),"Insatisfatório", icon = icon("thumbs-o-down "),
      color = "red", width = 4
    )
  })
  #Linha selecionada
  rowSelect <- reactive({
    input$tabelaVariaveis_rows_selected
  })
  
  #Retorna tabela de alunos
  output$tabelaAluno <- renderDataTable({
    #transformar em um dataframe nome do aluno, freq e desempenho binario
    variaveis <- as.character(listaVariaveis$Variável)
    varSelected <- variaveis[rowSelect()]
    df <- data.frame(baseFiltrada()[,c("Nome.do.Aluno",varSelected,"DESEMPENHO_BINARIO")])
    df$DESEMPENHO_BINARIO[df$DESEMPENHO_BINARIO == 0] <- "Satisfatório"
    df$DESEMPENHO_BINARIO[df$DESEMPENHO_BINARIO == 1] <- "Insatisfatório"
    colnames(df) <- c("Nome","Freq","Situação")
    DT::datatable(
      df,rownames = FALSE,options = list(paging = FALSE,searching = FALSE, 
                                         info = FALSE, scrollY = '300px'),
                                    class = "compact"
    )
  })
  
  #Retorna tabela de variaveis
  output$tabelaVariaveis <- renderDataTable({
    colnames(listaVariaveis) <- c("Variável","Descrição")
    DT::datatable(
      listaVariaveis,rownames = FALSE, options = list(paging = FALSE, searching = FALSE,
                                          info = FALSE, scrollY = '300px'),class = "compact",
                      selection = list(target = 'row',mode="single",selected=c(1))
    )
  })
  
  #Retorna o Grafico
  output$showGrafico <- plotly::renderPlotly({
    variaveis <- as.character(listaVariaveis$Variável)
    varSelected <- variaveis[rowSelect()]
    freq <- baseFiltrada()[,varSelected]
    df <- baseFiltrada()
    df$DESEMPENHO_BINARIO[df$DESEMPENHO_BINARIO == 0] <- "Satisfatório"
    df$DESEMPENHO_BINARIO[df$DESEMPENHO_BINARIO == 1] <- "Insatisfatório"
    p <- plot_ly(df, x = ID.do.Aluno, y = freq, text = paste(paste("Nome:", Nome.do.Aluno),paste("Freq:",freq),paste("Situação:", DESEMPENHO_BINARIO), sep = "<br>")
                 ,mode = "markers", color = freq ,name = varSelected)
    ##bla
    p <-layout(title = varSelected,xaxis=list(title=""),yaxis=list(title=""))
    p
    
      })

})
