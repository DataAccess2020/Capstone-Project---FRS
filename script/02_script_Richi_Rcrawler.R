library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
library("stringr")


#estraggo tutti i link contenuti sulla homepage di repubblica
#ottengo una lista di 3 elementi: informazioni sull'operazione, link interni, link esterni.
repubblica_link<-LinkExtractor(url="https://www.repubblica.it/")

#ispeziono l'elenco dei link interni
repubblica_link[["InternalLinks"]]

#creo una tabella con tutti i link
tabella_link_repubblica <- tibble(
  elenco_link = repubblica_link[["InternalLinks"]]
)

#con questa tabella è possibile "pulire" i link per estrarre solo gli articoli che ci interessano