# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")

#uso Rcrawler per scaricare tutti gli HTML della homepage di Repubblica.it
Rcrawler (Website = "https://www.repubblica.it",
          Useragent= "Mozilla 3.11",
          RequestsDelay = 1,
          MaxDepth = 1,
          dataUrlfilter = "^https://www.repubblica.it",
          ManyPerPattern= TRUE,
          DIR = "./data"
          )

ListProjects()

list_DATA<-LoadHTMLFiles("data/repubblica.it-131816", type = "list")

article <- read_html("repubblica.it-111625") %>%
  html_nodes(".body-text > span")%>% 
  html_text()



tabella <- tibble(
  prova = vector_DATA
)
