# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")

#test CSS selector
test_CSS <- ContentScraper(
  Url = "https://www.repubblica.it",
  CssPatterns = ".body-text")



#uso Rcrawler per scaricare tutti gli HTML della homepage di Repubblica.it
Rcrawler (Website = "https://www.repubblica.it", #LINK DEL SITO DI PARTENZA
          Useragent= "Mozilla 3.11", #USER AGENT
          Obeyrobots = FALSE, #IF TRUE AUTOMATIC INSPECT AND OBEY ROBOTS.TXT
          RequestsDelay = 1, #RITARDO TRA OGNI ITERAZIONE
          MaxDepth = 1, #LIVELLO DELLO SCRAPING
          dataUrlfilter = "^https://www.repubblica.it", #ESCLUDI LINK DEGLI ARTICOLI A PAGAMENTO (REP.REPUBBLICA
          ManyPerPattern = TRUE, #NON FERMARTI AL PRIMO MATCHING DEL PATTERN
          DIR = "./data", #DOVE SALVARE IL FILE CON GLI HTML
          ExtractCSSPat = ".body-text", #SEGUI SOLO LINK CON QUESTO CSS PATTERN
          )

#inspect csv file
extracted_data <- read_csv("data/repubblica.it-181840/extracted_data.csv")
View(extracted_data)


list_DATA<-LoadHTMLFiles("data/repubblica.it-181840", type = "vector")
list_DATA

table <- tibble(
  text = list_DATA)

str(table)
str(table, 1)   # solo un livello di profondità
str(table[[2]]) # entra nel primo elemento della lista
str(DATA[[1]][[3]][1])

