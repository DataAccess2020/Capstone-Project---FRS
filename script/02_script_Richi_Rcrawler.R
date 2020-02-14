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
url_list_normalized

#pulisco l'elenco tenendo solo i link che iniziano con "https://www.repubblica.it"
url_list_cleaned <- str_subset(url_list_normalized,"^https://www.repubblica.it")
url_list_cleaned

#faccio lo stesso con xpath

#collect all link
link_xpath <- ContentScraper(Url = "https://www.repubblica.it", 
                             XpathPatterns = "//*/a/@href" ,
                             ManyPerPattern = TRUE)
#ispeziono l'elenco dei link
link_xpath[[1]]

#creo una lista con tutti i link
url_list_xpath <- c(link_xpath[[1]])
url_list_xpath


#pulisco l'elenco tenendo solo i link che iniziano con "https://www.repubblica.it"
url_list_xpath_cleaned <- str_subset(url_list_xpath,"^https://www.repubblica.it")
url_list_xpath_cleaned

#confronto le due liste

control_list <- tibble(
  link_css = url_list_cleaned,
  links_xpath = url_list_xpath_cleaned
)

control_list

#extract text
text_by_contentscraper<-ContentScraper(Url = url_list_xpath_cleaned, CssPatterns = ".middle-img h1 , .summary , .body-text > span",
                     PatternsName = "text", ManyPerPattern = TRUE)                  

text_by_contentscraper

#creo una tabella con tutti i link ed il testo
tabella_link_repubblica <- tibble(
  elenco_link = url_list_cleaned,
  text = text_by_contentscraper)

tabella_link_repubblica
