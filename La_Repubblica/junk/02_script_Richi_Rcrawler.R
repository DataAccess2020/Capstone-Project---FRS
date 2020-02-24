# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")


#estraggo tutti i link contenuti sulla homepage di repubblica
#ottengo una lista di 3 elementi: informazioni sull'operazione, link interni, link esterni.
repubblica_link<-LinkExtractor(url="https://www.repubblica.it/",
                               Useragent = "Mozilla 3.11")

#ispeziono l'elenco dei link interni
repubblica_link[["InternalLinks"]]

#creo una lista con tutti i link
url_list <- c(repubblica_link[["InternalLinks"]])
url_list #controllo i link

#normalizzo l'elenco dei link
url_list_normalized <- LinkNormalization(url_list,"https://www.repubblica.it/" )


#pulisco l'elenco tenendo solo i link che iniziano con "https://www.repubblica.it"
url_list_cleaned <- str_subset(url_list_normalized,"^https://www.repubblica.it")



#extract text
text_by_contentscraper<-ContentScraper(Url = url_list_cleaned, CssPatterns = ".body-text",
                     PatternsName = "text", ManyPerPattern = TRUE) 



#creo una tabella con tutti i link ed il testo
tabella_link_repubblica <- tibble(
  elenco_link = url_list_cleaned,
  text = text_by_contentscraper)

tabella_link_repubblica
