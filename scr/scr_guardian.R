# Capstone project:

# This script includes the scraping of the newspaper "The Guardian":
# - browsing the robots.txt file;
# - downloading and saving the HTML;
# - extracing the links in the homepage using Rvest:


# Browsing the robots.txt file: -------------------------------------------------------
browseURL("https://www.theguardian.com/robots.txt")

# Downloading and saving the HTML: ----------------------------------------------------
url <- URLencode("https://www.theguardian.com/international")

library(stringr)
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it")) 


writeLines(page,
           con = here :: here("guardian.html"))

# Extracing the links in the homepage using Rvest:--------------------------------------
library(rvest)
link <- read_html(here :: here("guardian.html"))%>%
  html_nodes(css = ".fc-sublink__link , .js-headline-text") %>%
  html_attr("href")

link <- na.omit(link)

link

# Creating the data frame:
library(tidyverse)
dat <- tibble(
  link = link)

dat

# THIS should be where I extract the category of each article.

#https://www.theguardian.com/
"(?<=MFG\\s{0,100}:\\s{0,100})\\w+"

dat_pg <- str_extract(link, "(https?:\\/\\/(www\\.)?guardian\\.com)\\w+")

dat_pg


# Loop for extracting the text of the files: 
dir.create("articles_guardian")
articles <- vector(mode = "list", length = length(link))

for (i in 1:length(link)) {
  
  cat("Iteration:", i, ". Scraping:", link[i],"\n")
  
  page <- RCurl::getURL(link[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it"))
  
  file_path <- here::here("articles_guardian", str_c("art_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  articles[[i]] <- read_html(file_path) %>% 
    html_nodes(".js-article__body p") %>% 
    html_text()
  
  Sys.sleep(2)
} 

dat2 <- tibble(
  link = link,
  article = articles
)
dat2

save(dat, file = here::here("Guardian_articles.RData"))

Sys.getlocale()
Sys.setlocale("LC_ALL", 'en_GB.UTF-8')
sys.set

writeLines(articles, 
           con = file_path)

art_character <- as.character(articles)
Encoding(art_character) <- "UTF-8"
art_character
enc2utf8(articles)



