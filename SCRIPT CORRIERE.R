library("RCurl")
library("tidyverse")
library("rvest")
library("string")


#PART ONE -------------- 

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.corriere.it//?ref=RHHD-L")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("https://www.corriere.it//robots.txt")


##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("Ilcorrieredellasera.html")) 


# PART TWO -----------


#selecting the links of the articles

links <- read_html(here::here("Ilcorrieredellasera.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links

#selecting only the links of corriere 

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

#creating a dataset with the links

datlinksC <- tibble(
  links = CORRIERELinks
)
dat


datlinks$tema <- 1

datlinks1 <- mutate(
  datlinks, 
  tema = recode(links,
                #POLITICA
                "https://www.corriere.it/politica/" = "POLITICA",
                "https://www.corriere.it/elezioni/" = "POLITICA",
                "https://www.corriere.it/elezioni/risultati-regionali-2020" = "POLITICA",
                "https://www.corriere.it/elezioni-2019/"= "POLITICA",
                "https://www.corriere.it/elezioni-2019/europee-risultati/italia.shtml"= "POLITICA",
                "https://www.corriere.it/elezioni-2019/risultati-regionali/" = "POLITICA",
                "https://www.corriere.it/elezioni-2019/risultati-comunali/capoluoghi-di-provincia/" = "POLITICA",
                "https://www.corriere.it/elezioni-2018/" = "POLITICA",
                "https://www.corriere.it/politica/elezioni-regionali-sicilia-2017/" = "POLITICA",
                "https://www.corriere.it/referendum-autonomia-lombardia-e-veneto/" = "POLITICA",
                "https://www.corriere.it/amministrative-2017/elezioni-comunali-giugno.shtml" = "POLITICA",
                "https://www.corriere.it/politica/primarie_pd/"= "POLITICA",
                "https://www.corriere.it/la-crisi-di-governo/" = "POLITICA",
                "https://www.corriere.it/amministrative-2016/elezioni-comunali-giugno.shtml/"= "POLITICA",
                
                #CRONACA
                "https://www.corriere.it/cronache/" = "CRONACA", 
                "https://www.corriere.it/speciale/interni/2018/ponte-morandi-genova-video-crollo-foto-vittime-atlantia-autostrade-ultime-notizie/"= "CRONACA",
                "https://www.corriere.it/cronache/harry-meghan-markle-matrimonio/"= "CRONACA", 
                "https://www.corriere.it/cronache/speciali/2013/vajont/"= "CRONACA", 
                "https://www.corriere.it/reportages/cronache/2016/migranti-morti-mediterraneo/" = "CRONACA",
                  
                #ESTERI
                "https://www.corriere.it/esteri/" = "ESTERI",
                "https://www.corriere.it/elezioni-europee/100giorni/" = "ESTERI",
                "https://www.corriere.it/esteri/elezioni-spagna-2019/risultati-voto/" = "ESTERI",
                "https://www.corriere.it/esteri/elezioni-usa-midterm-2018/" = "ESTERI",
                "https://www.corriere.it/esteri/elezioni-germania-2017/" = "ESTERI",
                "https://www.corriere.it/esteri/elezioni-regno-unito-2017/" = "ESTERI",
                "https://www.corriere.it/esteri/presidenziali-francia/" = "ESTERI",
                "https://www.corriere.it/elezioni-presidenziali-usa-2016/" = "ESTERI",
                
                #ECONOMIA
                "https://www.corriere.it/economia/" = "ECONOMIA",
                "https://www.corriere.it/economia/" = "ECONOMIA",
                "https://www.corriere.it/economia/finanza/" = "ECONOMIA",
                "https://www.corriere.it/economia/risparmio/" = "ECONOMIA",
                "https://www.corriere.it/economia/risparmio/guide/" = "ECONOMIA",
                "https://www.corriere.it/economia/tasse/" = "ECONOMIA",
                "https://www.corriere.it/pensioni-investimenti-risparmi-esperto-risponde/lettere/" = "ECONOMIA",
                "https://www.corriere.it/economia/consumi/" = "ECONOMIA",
                "https://www.corriere.it/economia/casa/" = "ECONOMIA",
                "https://www.corriere.it/economia/mutui/" = "ECONOMIA",
                "https://www.corriere.it/economia/affitti/" = "ECONOMIA",
                "https://www.corriere.it/economia/lavoro/" = "ECONOMIA",
                "https://www.corriere.it/economia/lavoro/guide/" = "ECONOMIA",
                "https://www.corriere.it/economia/pensioni/" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/" = "ECONOMIA",
                "https://www.corriere.it/economia/family-business/programma/" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/le-storie/" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/aprire-azienda/" = "ECONOMIA",
                "https://www.corriere.it/economia/economia-del-futuro/" = "ECONOMIA",
                "https://www.corriere.it/economia/moda-business/" = "ECONOMIA",
                
                #SPORT
                "https://www.corriere.it/sport/" = "SPORT",
                "https://www.corriere.it/sport/risultati-live/" = "SPORT",
                "https://www.corriere.it/sport/calcio/serie-a" = "SPORT",
                "https://www.corriere.it/sport/calcio/serie-a/calendario-risultati/" = "SPORT", 
                "https://www.corriere.it/sport/calcio/serie-a/classifica/" = "SPORT",
                "https://www.corriere.it/sport/calcio/serie-a/marcatori/" = "SPORT",
                "https://www.corriere.it/sport/calcio/serie-a/albo-d-oro/"	 = "SPORT",
                "https://www.corriere.it/sport/calcio/serie-b/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/serie-b/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/serie-b/play-off/" =  "SPORT",	
                "https://www.corriere.it/sport/calcio/serie-b/classifica/"	= "SPORT" ,
                "https://www.corriere.it/sport/calcio/serie-b/marcatori/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/coppe/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/champions-league/calendario-risultati/" = "SPORT",	
                "https://www.corriere.it/sport/calcio/europa-league/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/coppa-italia/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/nations-league/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/nations-league/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/risultati-live/"	= "SPORT",
                "https://www.corriere.it/sport/calcio/nations-league/classifica/" = "SPORT",	
                "https://www.corriere.it/sport/formula-1/"	= "SPORT",
                "https://www.corriere.it/sport/risultati-live/"	= "SPORT",
                "https://www.corriere.it/sport/motori/f1/calendario-risultati/" = "SPORT",	
                "https://www.corriere.it/sport/motori/f1/classifiche/"	= "SPORT",
                "https://www.corriere.it/sport/motomondiale/"	= "SPORT",
                "https://www.corriere.it/sport/risultati-live/"	= "SPORT",
                "https://www.corriere.it/sport/motori/motogp/calendario-risultati/"	= "SPORT",
                "https://www.corriere.it/sport/motori/motogp/classifiche/"	= "SPORT",
                "https://www.corriere.it/sport//"	= "SPORT",
                "https://www.corriere.it/sport/running-nuoto-bici/" = "SPORT",
                
                #ISTRUZIONE 
                "^https://www.corriere.it/scuola/" = "Istruzione")
)




# PART THREE --------------

#creating a folder to put the links 
dir.create("ARTICLESPAGES")


articoli11feb <- vector(mode = "list", length = length(CORRIERELinks))

for (i in 1:length(CORRIERELinks)) {
  
  cat("Iteration:", i, ". Scraping:", CORRIERELinks[i],"\n")
  
  #Getting the page
  page <- RCurl::getURL(CORRIERELinks[i], 
                         useragent = str_c(R.version$platform,
                                           R.version$version.string,
                                           sep = ", "),
                         httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  #Saving the page:
  file_path <- here::here("ARTICLESPAGES", str_c("articles_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  
  #Parsing and extracting
  articoli11feb[[i]] <- read_html(file_path) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(0) 
} 

datTEXT <- tibble(
  link = CORRIERELinks,
  article = articoli11feb
)

datTEXT 


# PART FOUR: CLEANING DATASET -----------

dat_sort <- datTEXT %>%
  filter(article != "character(0)")

dat_sort

# PART FIVE: IDENTIFYING CATEGORIES
dat <- select(economia, istruzione, sport)



dat <- filter(
  datlinks,
  CORRIERELinks %in% c("economia", "sport", "istruzione")
)

dat

section <- word(links, 5, sep = fixed('/'))

dat <- tibble(
  link = links,
  section = section
)


economia <- str_subset(CORRIERELinks, "^https://www.corriere.it/economia/")
sport <-  str_subset(CORRIERELinks, "^https://www.corriere.it/sport/")
istruzione <- str_subset(CORRIERELinks, "^https://www.corriere.it/scuola/")

dat1 <- tibble(
  link = links,
  istruzione = istruzione
)


dat1 <- tibble(
  link = links,
  argomenti = c(economia, sport, istruzione)
)



dat1 <- 
  dat %>%
  mutate()


  





