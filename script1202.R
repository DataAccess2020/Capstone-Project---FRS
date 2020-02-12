library("RCurl")
library("tidyverse")
library("rvest")
library("string")


#PART ONE -------------- 

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.corriere.it/")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("https://www.corriere.it///robots.txt")


##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("Ilcorrieredellasera1202.html")) 


# PART TWO -----------


#selecting the links of the articles

links <- read_html(here::here("Ilcorrieredellasera1202.html")) %>% 
  html_nodes(css = ".is-8 .has-text-black , .is-pd-t-0 > .bck-media-news") %>% 
  html_attr("href")

links

#selecting only the links of corriere 

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

#creating a dataset with the links

datlinks <- tibble(
  links = CORRIERELinks
)
datlink


datlinks$tema <- 1


datlinks1 <- mutate(
  datlinks, 
  tema = recode(links,
                "https://www.corriere.it/politica/20_febbraio_12/caso-gregoretti-oggi-si-vota-processare-salvini-maggioranza-favore-centrodestra-si-oppone-1adf0726-4d72-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/caso-gregoretti-oggi-si-vota-processare-salvini-maggioranza-favore-centrodestra-si-oppone-1adf0726-4d72-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/caso-gregoretti-oggi-si-vota-processare-salvini-maggioranza-favore-centrodestra-si-oppone-1adf0726-4d72-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/caso-gregoretti-oggi-si-vota-processare-salvini-maggioranza-favore-centrodestra-si-oppone-1adf0726-4d72-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/caffe-gramellini/20_febbraio_12/aldiqua-c2d3e080-4d1a-11ea-abdf-2e1b18f873ec.shtml" = "OPINIONE",	
                "https://www.corriere.it/caffe-gramellini/20_febbraio_12/aldiqua-c2d3e080-4d1a-11ea-abdf-2e1b18f873ec.shtml" = "OPINIONE",	
                "https://www.corriere.it/caffe-gramellini/20_febbraio_12/aldiqua-c2d3e080-4d1a-11ea-abdf-2e1b18f873ec.shtml" = "OPINIONE",
                "https://www.corriere.it/economia/aziende/20_febbraio_12/inchiesta-alitalia-sai-21-indagati-cui-mustier-mansi-laghi-844c7644-4d90-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/20_febbraio_12/inchiesta-alitalia-sai-21-indagati-cui-mustier-mansi-laghi-844c7644-4d90-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/20_febbraio_12/inchiesta-alitalia-sai-21-indagati-cui-mustier-mansi-laghi-844c7644-4d90-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/20_febbraio_12/inchiesta-alitalia-sai-21-indagati-cui-mustier-mansi-laghi-844c7644-4d90-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/aziende/20_febbraio_12/inchiesta-alitalia-sai-21-indagati-cui-mustier-mansi-laghi-844c7644-4d90-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/pensioni/cards/pensioni-meta-chi-incassa-non-ha-versato-contributi/pensioni-numeri_principale.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/pensioni/cards/pensioni-meta-chi-incassa-non-ha-versato-contributi/pensioni-numeri_principale.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/pensioni/cards/pensioni-meta-chi-incassa-non-ha-versato-contributi/pensioni-numeri_principale.shtml" = "ECONOMIA",
                "https://www.corriere.it/esteri/20_febbraio_11/coronavirus-chat-italiani-quarantena-ci-chiamiamo-come-promessi-sposi-e4ab73b0-4cf9-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/esteri/20_febbraio_11/coronavirus-chat-italiani-quarantena-ci-chiamiamo-come-promessi-sposi-e4ab73b0-4cf9-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/esteri/20_febbraio_11/coronavirus-chat-italiani-quarantena-ci-chiamiamo-come-promessi-sposi-e4ab73b0-4cf9-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/cronache/20_febbraio_12/preti-sposati-papa-francesco-nessuna-apertura-ecco-miei-4-sogni-l-amazzonia-a750847e-4d85-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/politica/20_febbraio_12/quegli-otto-colpi-pistola-finto-allarme-bomba-fuga-terroristi-131-bianca-cronaca-allora-aeacb3c8-4b14-11ea-aff7-4a3600894a18.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/quegli-otto-colpi-pistola-finto-allarme-bomba-fuga-terroristi-131-bianca-cronaca-allora-aeacb3c8-4b14-11ea-aff7-4a3600894a18.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/quegli-otto-colpi-pistola-finto-allarme-bomba-fuga-terroristi-131-bianca-cronaca-allora-aeacb3c8-4b14-11ea-aff7-4a3600894a18.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/quegli-otto-colpi-pistola-finto-allarme-bomba-fuga-terroristi-131-bianca-cronaca-allora-aeacb3c8-4b14-11ea-aff7-4a3600894a18.shtml" = "POLITICA",
                "https://www.corriere.it/cronache/20_febbraio_11/vittorio-bachelet-la-preghiera-suo-figlio-giovanni-nostra-generazione-scopri-vita-pubblica-5aad808a-4c0f-11ea-91c6-061fa519fab0.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_11/vittorio-bachelet-la-preghiera-suo-figlio-giovanni-nostra-generazione-scopri-vita-pubblica-5aad808a-4c0f-11ea-91c6-061fa519fab0.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_11/vittorio-bachelet-la-preghiera-suo-figlio-giovanni-nostra-generazione-scopri-vita-pubblica-5aad808a-4c0f-11ea-91c6-061fa519fab0.shtml" = "CRONACA",
                "https://www.corriere.it/esteri/20_febbraio_12/cella-nostro-patrick-chiede-libri-0c4d1d72-4d15-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/esteri/20_febbraio_12/cella-nostro-patrick-chiede-libri-0c4d1d72-4d15-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/esteri/20_febbraio_12/cella-nostro-patrick-chiede-libri-0c4d1d72-4d15-11ea-abdf-2e1b18f873ec.shtml" = "ESTERI",
                "https://www.corriere.it/sport/20_febbraio_12/nela-ho-visto-morte-faccia-suicidio-come-bartolomei-l-ho-pensato-non-ho-avuto-coraggio-55b86d14-4d7d-11ea-a2de-b4f1441c3f82.shtml" = "SPORT",
                "https://www.corriere.it/sport/20_febbraio_12/nela-ho-visto-morte-faccia-suicidio-come-bartolomei-l-ho-pensato-non-ho-avuto-coraggio-55b86d14-4d7d-11ea-a2de-b4f1441c3f82.shtml" = "SPORT",
                "https://www.corriere.it/sport/20_febbraio_12/nela-ho-visto-morte-faccia-suicidio-come-bartolomei-l-ho-pensato-non-ho-avuto-coraggio-55b86d14-4d7d-11ea-a2de-b4f1441c3f82.shtml" = "SPORT",
                "https://www.corriere.it/economia/casa/20_febbraio_12/case-all-asta-aumentate-25percento-un-anno-ci-sono-anche-castello-un-isola-73439b04-4ce4-11ea-abdf-2e1b18f873ec.shtml"	= "ECONOMIA", 
                "https://www.corriere.it/cronache/20_febbraio_12/trentino-150-studenti-si-sentono-male-hotel-a3fd3160-4d66-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/politica/20_febbraio_12/legge-spazzacorrotti-incostituzionale-l-applicazione-vecchi-reati-90fffcb0-4d97-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/legge-spazzacorrotti-incostituzionale-l-applicazione-vecchi-reati-90fffcb0-4d97-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/politica/20_febbraio_12/legge-spazzacorrotti-incostituzionale-l-applicazione-vecchi-reati-90fffcb0-4d97-11ea-a2de-b4f1441c3f82.shtml" = "POLITICA",
                "https://www.corriere.it/video-articoli/2020/02/12/rete-piena-gamberi-plastica-ecco-cosa-si-pesca-ogni-giorno-nostri-mari/0ba57d76-4cb4-11ea-abdf-2e1b18f873ec.shtml" = "VIDEO",
                "https://www.corriere.it/video-articoli/2020/02/12/rete-piena-gamberi-plastica-ecco-cosa-si-pesca-ogni-giorno-nostri-mari/0ba57d76-4cb4-11ea-abdf-2e1b18f873ec.shtml" = "VIDEO",
                "https://www.corriere.it/economia/finanza/20_febbraio_12/capasso-banca-sud-utile-fin-prima-guerra-mondiale-ceo-guadagna-solo-81mila-euro-4de6258a-4d65-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/finanza/20_febbraio_12/capasso-banca-sud-utile-fin-prima-guerra-mondiale-ceo-guadagna-solo-81mila-euro-4de6258a-4d65-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/finanza/20_febbraio_12/capasso-banca-sud-utile-fin-prima-guerra-mondiale-ceo-guadagna-solo-81mila-euro-4de6258a-4d65-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/opinioni/20_febbraio_12/air-italy-liquidazione-vicenda-alitalia-non-ha-insegnato-niente-b6810bb4-4d88-11ea-a2de-b4f1441c3f82.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/consumi/cards/rc-auto-familiare-come-funziona-idee-confuse-55-milioni-italiani/nuova-rc-auto-familiare_principale.shtml" = "ECONOMIA",
                "https://www.corriere.it/economia/consumi/cards/rc-auto-familiare-come-funziona-idee-confuse-55-milioni-italiani/nuova-rc-auto-familiare_principale.shtml" = "ECONOMIA",
                "https://www.corriere.it/cronache/20_febbraio_12/per-genitori-matteo-renzi-procura-chiede-rinvio-giudizio-46a8f87e-4d8d-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_12/per-genitori-matteo-renzi-procura-chiede-rinvio-giudizio-46a8f87e-4d8d-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_12/per-genitori-matteo-renzi-procura-chiede-rinvio-giudizio-46a8f87e-4d8d-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_12/per-genitori-matteo-renzi-procura-chiede-rinvio-giudizio-46a8f87e-4d8d-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/cronache/20_febbraio_12/per-genitori-matteo-renzi-procura-chiede-rinvio-giudizio-46a8f87e-4d8d-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/lodicoalcorriere/index/11-02-2020/index.shtml" = "OPINIONE",
                "https://www.corriere.it/lodicoalcorriere/index/11-02-2020/index.shtml" = "OPINIONE",
                "https://www.corriere.it/lodicoalcorriere/index/11-02-2020/index.shtml" = "OPINIONE",
                "https://www.corriere.it/economia/aziende/20_febbraio_11/coronavirus-supercervellone-che-cerca-cura-miliardi-calcoli-f6c38f88-4d08-11ea-abdf-2e1b18f873ec.shtml" = "ECONOMIA", 
                "https://www.corriere.it/buone-notizie/cards/italiani-vacanza-anche-cultura-vuole-sua-parte/mete-preferite-italia_principale.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/buone-notizie/cards/italiani-vacanza-anche-cultura-vuole-sua-parte/mete-preferite-italia_principale.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/buone-notizie/cards/italiani-vacanza-anche-cultura-vuole-sua-parte/mete-preferite-italia_principale.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/scuola/secondaria/20_febbraio_12/invalsi-maturita-colpo-spugna-risultati-resteranno-segreti-93692678-4d80-11ea-a2de-b4f1441c3f82.shtml" = "ISTRUZIONE",
                "https://www.corriere.it/scuola/secondaria/20_febbraio_12/invalsi-maturita-colpo-spugna-risultati-resteranno-segreti-93692678-4d80-11ea-a2de-b4f1441c3f82.shtml" = "ISTRUZIONE",
                "https://www.corriere.it/buone-notizie/civil-week/notizie/via-quaderni-per-giorno-cosi-diventiamo-cittadini-6cf4cf48-4cb7-11ea-abdf-2e1b18f873ec.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/buone-notizie/civil-week/notizie/via-quaderni-per-giorno-cosi-diventiamo-cittadini-6cf4cf48-4cb7-11ea-abdf-2e1b18f873ec.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/buone-notizie/civil-week/notizie/via-quaderni-per-giorno-cosi-diventiamo-cittadini-6cf4cf48-4cb7-11ea-abdf-2e1b18f873ec.shtml" = "BUONE NOTIZIE",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/bello-italia/notizie/senso-bello-signor-liquigas-8a97422e-4771-11ea-bec1-6ac729c309c6.shtml" = "BELLO ITALIA",
                "https://www.corriere.it/dataroom-milena-gabanelli/algoritmo/97712c3e-4cd6-11ea-abdf-2e1b18f873ec-va.shtml" = "DATAROOM",
                "https://www.corriere.it/dataroom-milena-gabanelli/algoritmo/97712c3e-4cd6-11ea-abdf-2e1b18f873ec-va.shtml" = "DATAROOM",
                "https://www.corriere.it/cronache/20_febbraio_12/terremoto-assolto-boeri-sono-felice-spero-che-centro-polivalente-ora-riapra-2d45572a-4d91-11ea-a2de-b4f1441c3f82.shtml" = "CRONACA",
                "https://www.corriere.it/esteri/20_febbraio_12/onu-milioni-persone-rischio-fame-l-invasione-locuste-8c4946f6-4d8b-11ea-a2de-b4f1441c3f82.shtml" = "ESTERI"),

    article = articoli11feb
)



creating a folder to put the links 
dir.create("ARTICLES")


articoli11feb <- vector(mode = "list", length = length(CORRIERELinks))

for (i in 1:length(CORRIERELinks)) {
  
  cat("Iteration:", i, ". Scraping:", CORRIERELinks[i],"\n")
  
  #Getting the page#
  page <- RCurl::getURL(CORRIERELinks[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  #Saving the page:
  file_path <- here::here("ARTICLES", str_c("articles_", i, ".html"))
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
                
                

write.csv2(datlinks1, file="dataset.csv", quote=F, na="", row.names=T, col.names=T)


write.table(datlinks1, "DATASET.csv", 
            sep = ";",             # punto e virgola
            row.names = FALSE,     # se abbiamo la variabile ID
            dec = ",",             # separatore di decimali
            na = "",               # dati mancanti come celle vuote
            quote = TRUE
)
