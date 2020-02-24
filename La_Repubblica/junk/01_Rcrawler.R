##scrape "coronvirus" articles and test sentyment##

setwd("C:/Users/Riccardo/Desktop/prova Rcrawler")
here::here()

Rcrawler (Website = "https://www.repubblica.it", #LINK DEL SITO DI PARTENZA
          Useragent= "Mozilla 3.11", #USER AGENT
          Obeyrobots = FALSE, #IF TRUE AUTOMATIC INSPECT AND OBEY ROBOTS.TXT
          RequestsDelay = 1, #RITARDO TRA OGNI ITERAZIONE
          MaxDepth = 2, #LIVELLO DELLO SCRAPING
          ManyPerPattern = TRUE, #NON FERMARTI AL PRIMO MATCHING DEL PATTERN
          DIR = "./data", #DOVE SALVARE IL FILE CON GLI HTML
          KeywordsFilter= c("coronavirus"),
          KeywordsAccuracy = 99,
          )

link_list <- INDEX$Url

HTML <- LoadHTMLFiles("data/repubblica.it-230214", type = "vector")


tabella <- tibble(
  text = HTML)

testo <- ContentScraper(HTmlText = tabella,
                        CssPatterns = c(".middle-img h1", ".summary" , ".body-text > span"),
                        ManyPerPattern = TRUE,
               astext = TRUE, asDataFrame = FALSE)



 