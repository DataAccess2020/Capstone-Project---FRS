# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")

#test CSS selector
test_CSS <- ContentScraper(
  Url = "https://www.repubblica.it",
  CssPatterns =c(".Articolo , .entry-subtitle a , .entry-title a"))



#uso Rcrawler per scaricare tutti gli HTML della homepage di Repubblica.it
Rcrawler (Website = "https://www.repubblica.it", #LINK DEL SITO DI PARTENZA
          Useragent= "Mozilla 3.11", #USER AGENT
          Obeyrobots = TRUE, #AUTOMSTIC CONTROL AND RESPECT ROBOTS.TXT
          RequestsDelay = 1, #RITARDO TRA OGNI ITERAZIONE
          MaxDepth = 1, #LIVELLO DELLO SCRAPING
          dataUrlfilter = "^https://www.repubblica.it", #ESCLUDI LINK DEGLI ARTICOLI A PAGAMENTO (REP.REPUBBLICA)
          ManyPerPattern = TRUE, #NON FERMARTI AL PRIMO MATCHING DEL PATTERN
          DIR = "./data", #DOVE SALVARE IL FILE CON GLI HTML
          ExtractCSSPat = c(".body-text > span , strong , .summary , .middle-img h1",".Articolo , .entry-subtitle a , .entry-title a"), #SEGUI SOLO LINK CON QUESTO CSS PATTERN
          PatternsNames = c("articolo", "link") #A COSA SI REFERISCE IL PATTERN CSS
          )

#inspect csv file
extracted_data <- read_csv("data/repubblica.it-132052/extracted_data.csv")
View(extracted_data)


list_DATA<-LoadHTMLFiles("data/repubblica.it-132305", type = "list")

