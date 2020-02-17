library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")


#1. downloading page-------------- 

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
           con = here::here("Ilcorrieredellasera1402.html")) 


# 2. links -----------


#selecting the links of the articles

links <- read_html(here::here("Ilcorrieredellasera1402.html")) %>% 
  html_nodes(css = ".is-8 .has-text-black , .is-pd-t-0 > .bck-media-news") %>% 
  html_attr("href")

links

#selecting only the links of corriere 

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

#creating a dataset with the links

dat <- tibble(
  links = CORRIERELinks
)
dat


#3. scraping text articles 

#creating a folder to put the links 
dir.create("ARTICLES")


articoli14feb <- vector(mode = "list", length = length(CORRIERELinks))


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
  articoli14feb[[i]] <- read_html(file_path) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2) 
} 

dat <- tibble(
  link = CORRIERELinks,
  article = articoli14feb
)

dat

# 4. new variable -> section
section <- word(CORRIERELinks, 4, sep = fixed('/'))

section

dat <- tibble(
  link = CORRIERELinks,
  article = articoli14feb,
  section = section,
)

dat


# 5. CLEANING DATASET -----------

cleandat <- dat %>%
  filter(article != "character(0)")

cleandat              
                
# 6. remove duplicate data

dat <- unique (cleandat)

dat

# 7. converting articles from list to character 

finaldat <- data.frame(articlestext = sapply(dat$article, toString, windth=57))


dat <- cbind(finaldat, dat)
dat

# 8. selecting variables 

dat <- select(dat, articlestext, link, section)

dat

# 9. saving dataset 

save(dat, file = here::here("Corrierearticles1402.Rdata"))

# 10. Analysis 
library(tidytext)
library(dplyr)
library(tidyr)
library(ggplot2)


#Trying to apply unnest_tokens at our dataset. 
#we should have a character vector that we want to analyse

as.tbl(dat, stringsAsFactor = FALSE)

dat <- mutate(dat, text = articlestext)

dat

dat <- select(dat, text, link, section)

articlestext <- sapply(dat$articlestext, toString, windth=57)

articlestext

dat1 <- tibble (link = link, section = section, text = articlestext, stringsAsFactor = FALSE)
dat1

word <- vector (mode = "character")

text_df<-tokenize_words(as.character(dat))

library(tokenizers)
library(SnowballC)

unlist(text_df)

text_df <- tibble(line = 1:27, text = text)

unlist(text)

articles <- data.frame(dat, stringsAsFactors = FALSE)

dat1 <- dat %>%
  unnest_tokens (word, text)

library(stopwords)
stopwords <- stopwords(language = "it", source = "snowball" )
stopwords


as.tbl(stopwords)

stopwords <- stopwords = c("ad", "al", "allo", "ai","agli","all" , "agl","alla", "alle") 
                           
                           
                           
                           ,"con","col","coi"  ,     
 "da"       ,  "dal"  ,      "dallo",      "dai"  ,      "dagli"    ,  "dall" ,     
 "dagl"     ,  "dalla"  ,    "dalle",      "di"         ,"del"        ,"dello" ,    
  "dei"        ,"degli"   ,   "dell"      , "degl"      , "della"   ,   "delle",     
  "in"    ,     "nel",        "nello" ,     "nei"   ,     "negli"     , "nell",      
  "negl"  ,     "nella" ,     "nelle"     , "su"      ,   "sul"     ,   "sullo",     
"sui"     ,   "sugli",      "sull"      , "sugl"  ,     "sulla",      "sulle" ,    
"per" ,       "tra" ,       "contro"    , "io",         "tu"        , "lui" ,      
 "lei"  , )



"noi"        "voi"        "loro"       "mio"        "mia"       
"miei"       "mie"        "tuo"        "tua"        "tuoi"       "tue"       
 "suo"        "sua"        "suoi"       "sue"        "nostro"     "nostra"    
"nostri"     "nostre"     "vostro"     "vostra"     "vostri"     "vostre"    
"mi"         "ti"         "ci"         "vi"         "lo"         "la"        
"li"         "le"         "gli"        "ne"         "il"         "un"        
"uno"        "una"        "ma"         "ed"         "se"         "perché"    
 "anche"      "come"       "dov"        "dove"       "che"        "chi"       
"cui"        "non"        "più"        "quale"      "quanto"     "quanti"    
"quanta"     "quante"     "quello"     "quelli"     "quella"     "quelle"    
 "questo"     "questi"     "questa"     "queste"     "si"         "tutto"     
"tutti"      "a"          "c"          "e"          "i"          "l"         
"o"          "ho"         "hai"        "ha"         "abbiamo"    "avete"     
"hanno"      "abbia"      "abbiate"    "abbiano"    "avrò"       "avrai"     
 "avrà"       "avremo"     "avrete"     "avranno"    "avrei"      "avresti"   
"avrebbe"    "avremmo"    "avreste"    "avrebbero"  "avevo"      "avevi"     
"aveva"      "avevamo"    "avevate"    "avevano"    "ebbi"       "avesti"    
"ebbe"       "avemmo"     "aveste"     "ebbero"     "avessi"     "avesse"    
"avessimo"   "avessero"   "avendo"     "avuto"      "avuta"      "avuti"     
"avute"      "sono"       "sei"        "è"          "siamo"      "siete"     
"sia"        "siate"      "siano"      "sarò"       "sarai"      "sarà"      
"saremo"     "sarete"     "saranno"    "sarei"      "saresti"    "sarebbe"   
 "saremmo"    "sareste"    "sarebbero"  "ero"        "eri"        "era"       
"eravamo"    "eravate"    "erano"      "fui"        "fosti"      "fu"        
"fummo"      "foste"      "furono"     "fossi"      "fosse"      "fossimo"   
"fossero"    "essendo"    "faccio"     "fai"        "facciamo"   "fanno"     
"faccia"     "facciate"   "facciano"   "farò"       "farai"      "farà"      
"faremo"     "farete"     "faranno"    "farei"      "faresti"    "farebbe"   
"faremmo"    "fareste"    "farebbero"  "facevo"     "facevi"     "faceva"    
"facevamo"   "facevate"   "facevano"   "feci"       "facesti"    "fece"      
 "facemmo"    "faceste"    "fecero"     "facessi"    "facesse"    "facessimo" 
"facessero"  "facendo"    "sto"        "stai"       "sta"        "stiamo"    
"stanno"     "stia"       "stiate"     "stiano"     "starò"      "starai"    
"starà"      "staremo"    "starete"    "staranno"   "starei"     "staresti"  
"starebbe"   "staremmo"   "stareste"   "starebbero" "stavo"      "stavi"     
"stava"      "stavamo"    "stavate"    "stavano"    "stetti"     "stesti"    
 "stette"     "stemmo"     "steste"     "stettero"   "stessi"     "stesse"    
 "stessimo"   "stessero"   "stando")



dat2 <- dat1 %>%
  anti_join(stopwords)


dat2 <- dat1 %>%
  count(word, sort = TRUE)


dat2 %>%
  count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
