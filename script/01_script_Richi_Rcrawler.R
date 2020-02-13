# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")

#test CSS selector
test_CSS <- ContentScraper(
  Url = "https://www.repubblica.it",
  CssPatterns =c(".Articolo , .entry-subtitle a , .entry-title a"))
#collect all link with xpath
link_xpath <- ContentScraper(Url = "https://www.repubblica.it", 
                      XpathPatterns = "//*/a/@href" ,
                      ManyPerPattern = TRUE)


#uso Rcrawler per scaricare tutti gli HTML della homepage di Repubblica.it
Rcrawler (Website = "https://www.repubblica.it", #LINK DEL SITO DI PARTENZA
          Useragent= "Mozilla 3.11", #USER AGENT
          RequestsDelay = 1, #RITARDO TRA OGNI ITERAZIONE
          MaxDepth = 1, #LIVELLO DELLO SCRAPING
          dataUrlfilter = "^https://www.repubblica.it", #ESCLUDI LINK DEGLI ARTICOLI A PAGAMENTO
          ManyPerPattern = TRUE, #NON FERMARTI AL PRIMO MATCHING DEL PATTERN
          DIR = "./data", #DOVE SALVARE IL FILE CON GLI HTML
          ExtractCSSPat = ".Articolo , .entry-subtitle a , .entry-title a", #SEGUI SOLO LINK CON QUESTO CSS PATTERN
          PatternsNames = "articolo" #A COSA SI REFERISCE IL PATTERN CSS
          )

ListProjects()

list_DATA<-LoadHTMLFiles("data/repubblica.it-131816", type = "vector")

article <- read_html(list_DATA) %>%
  html_nodes(".body-text > span")%>% 
  html_text()

tabella <- tibble (
  prova = article,
  link = )