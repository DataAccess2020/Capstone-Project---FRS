library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
library("stringr")


Rcrawler (Website = "https://www.repubblica.it", Useragent= "Mozilla 3.11",
          RequestsDelay = 2,
          MaxDepth = 1)

ListProjects()

list_DATA<-LoadHTMLFiles("repubblica.it-111649", type = "list")

article <- read_html("repubblica.it-111625") %>%
  html_nodes(".body-text > span")%>% 
  html_text()



tabella <- tibble(
  prova = vector_DATA
)
