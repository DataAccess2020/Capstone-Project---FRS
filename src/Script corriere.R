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

data(stop_words)

dat <- dat %>%
  anti_join(stop_words)

rlang::last_error()


articlestext

link

str(text_df)

