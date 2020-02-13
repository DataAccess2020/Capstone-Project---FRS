library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")


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
           con = here::here("Ilcorrieredellasera1302.html")) 


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
datlinks




#creating a folder to put the links 
dir.create("ARTICLES")


articoli13feb <- vector(mode = "list", length = length(CORRIERELinks))

as.character(articoli13feb)

df <- data.frame(matrix(unlist(articoli13feb), byrow=T))

df

df <- unique (df)

df



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
  articoli13feb[[i]] <- read_html(file_path) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(0) 
} 

datTEXT <- tibble(
  link = CORRIERELinks,
  article = articoli13feb
)

datTEXT 


# PART FOUR: CLEANING DATASET -----------

dat_sort <- datTEXT %>%
  filter(article != "character(0)")

dat_sort                
                
                
# PART FIVE : new variable -> section
section <- word(CORRIERELinks, 4, sep = fixed('/'))

section

datsection <- tibble(
  link = CORRIERELinks,
  article = articoli13feb,
  section = section,
  data.frame(matrix(unlist(articoli13feb), byrow=T))
)

datsection

# PART SIX: remove duplicate data

datsection <- unique (datsection)

datsection <- data.frame(matrix(unlist(articoli13feb), byrow=T))


# PART SIX: saving dataset

save(datsection, file = "IlCorriere1302.Rdata")


# proviamo

K <- c("https://www.corriere.it/cronache/20_febbraio_13/omicidio-cerciello-video-esclusivo-hjorth-bendato-viene-interrogato-caserma-carabinieri-4a7acef2-4e5d-11ea-977d-98a8d6c00ea5.shtml",
  "https://www.corriere.it/politica/20_febbraio_13/prescrizione-ministre-italia-viva-pronte-disertare-consiglio-ministri-1255d57e-4e41-11ea-977d-98a8d6c00ea5.shtml",
  "https://www.corriere.it/economia/tasse/cards/partite-iva-novita-2020-requisiti-rimanere-o-entrare-flat-tax-15percento/modifiche-platea-flat-tax-valide-2020_principale.shtml")

new <- c("Ecco il video dell’interrogatorio avvenuto nella caserma dei carabinieri di via in Selci a Roma il 26 luglio scorso di Gabriel Christian Natale Hjorth, americano di 18 anni accusato di aver partecipato all’omicidio del brigadiere Mario Cerciello Rega. Il giovane è stato bendato e ammanettato, viene interrogato senza l’avvocato. La foto venne diffusa via chat e fece il giro del mondo. Questo filmato mostra adesso i carabinieri che gli stanno intorno, lo incalzano. Tra loro c’è anche una donna.In queste prime fasi riprese dopo l’arresto, nella stanza del nucleo investigativo c’è Andrea Varriale, il sottufficiale che era con Cerciello e ha lottato con Gabriele Natale Hjorth mentre l’altro giovane americano Lee Finnegan Elder colpiva Cerciello con undici coltellate. Il 18 dicembre la procura di Roma ha chiuso le indagini nei confronti di carabiniere Fabio Manganaro accusando di aver adottato «misura di rigore non consentita dalla legge» per avere bendato il giovane californiano. Il collega Silvio Pellegrini è accusato invece di abuso d’ufficio e pubblicazione di immagine di persona privata della libertà per avere scattato la foto, poi diffusa «su almeno due chat Whatsapp, delle quali una dal titolo Reduci ex Secondigliano con 18 partecipanti, dalla quale veniva poi ulteriormente diffusa da terzi ad altri soggetti e chat» arrecando al giovane statunitense «un danno ingiusto».", 
         "Un partito di maggioranza che si comporta come se «volesse fare un'opposizione aggressiva e maleducata»: è pesantissima l’accusa di Giuseppe Conte nei confronti di Italia Viva dopo l’annuncio delle ministre renziane di non voler partecipare al Consiglio dei ministri per ribadire la distanza sul lodo Conte bis, che stasera dovrebbe essere discusso insieme alla riforma del processo penale. A margine del 73esimo anniversario della fondazione dell’Unione cristiana imprenditori e dirigenti (Ucid), il presidente del Consiglio si sfoga: Italia viva «un giorno sì e l’altro pure dichiara che vuole produrre un atto di sfiducia nei confronti del ministro Bonafede: sfido gli italiani a comprendere come può un compagno di viaggio minacciare la sfiducia di un ministro che non è solo il capo delegazione della principale forza di maggioranza relativa, ma è anche il ministro che abbiamo lodato tutti per la riforma del processo civile». È palesemente irritato il tono del premier, che difende a spada tratta il ministro della Giustizia: «È un ministro che si è intestato una riforma della prescrizione che a non tutti piace» e che è «già in vigore». Ma Bonafede- ricorda Conte «si è reso disponibile a rivedere la norma e abbiamo trovato vari punti di mediazione. Non c’è più quindi la norma Bonafede in questo accordo; si insulta un ministro pubblicamente ma per cosa?», si chiede Conte.Una preoccupazione, quella del premier, condivisa dal segretario Pd Nicola Zingaretti, che fa suo «il richiamo alla serietà di tutta la maggioranza, per reagire a fibrillazioni che è giusto prendere sul serio e sulle quali si chiede una maggiore collegialità». Vento di crisi? «Non ho elementi per dire che siamo in presenza o alla vigilia di una crisi, che nessuno ha dichiarato», dice Zingaretti. «Conte ha richiamato tutti alle proprie responsabilità, è giusto porre domande come quelle che il premier oggi ha posto, non per distruggere ma per risolvere i problemi», aggiunge.",
         "Le nuove restrizioni per accedere al regime forfettario per le partite Iva devono essere applicate da subito, e non slittano al 2021 come qualcuno aveva ipotizzato inizialmente. A fare chiarezza è lo stesso governo: il paletto posto a 30 mila euro di redditi o 20 mila euro spesi per pagare gli stipendi ai lavoratori dipendenti o ai collaboratori deve essere riferito al 2019 per poter usufruire della flat tax fin dal 2020. Il cambio di passo sulle partite Iva è stato inserito nella Manovra 2020, pubblicata a fine dicembre in Gazzetta, ma il dubbio che attanagliava la platea dei possibili esclusi era sulla data di avvio delle nuove strette. Il Mef ha così chiarito che le nuove regole sono valide dal 1° gennaio 2020. Le restrizioni sono da riferire all’anno precedente, e così i contribuenti che nel 2019 hanno superato i limiti previsti dalla Manovra 2020 non potranno avere accesso alla flat tax al 15% nel 2020.
A scatenare il dubbio era un possibile contrasto tra l’entrata in vigore della Legge di Bilancio 2020, fissata al 1° gennaio, e la norma di tutela prevista dallo Statuto del Contribuente, che indica un termine minimo per l’entrata in vigore di nuovi adempimenti pari a 60 giorni.
Il caso non si pone, dato che, come precisato dal Mef, i limiti imposti dalla manovra al regime agevolato non comportano un nuovo adempimento, ma solo una verifica dell’eventuale superamento delle soglie.")


ultimo <- tibble(
  link = K,
  article = new)
