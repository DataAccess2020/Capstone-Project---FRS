# Capstone project:

# This script includes the scraping of the newspaper "The Guardian":
# - browsing the robots.txt file;
# - downloading and saving the HTML;
# - extracting the links in the homepage using Rvest:
# - extracting the section/category for each article:
# - extracting the text of the articles
# - sorting the dataset

# Browsing the robots.txt file: -------------------------------------------------------
browseURL("https://www.liberoquotidiano.it/robots.txt")

# Downloading and saving the HTML: ----------------------------------------------------
url <- URLencode("https://www.liberoquotidiano.it/")

library(stringr)
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it")) 

writeLines(page,
           con = here :: here("libero.html"))

# Extracing the links in the homepage using Rvest:--------------------------------------
library(rvest)
link <- read_html(here :: here("libero.html"))%>%
  html_nodes(css = ".titolo a") %>%
  html_attr("href")

link <- str_subset(link, "^https://www\\.liberoquotidiano\\.it")

link

# Creating the data frame:
library(tidyverse)
dat <- tibble(
  link = link)

dat

# Extracting the section of each article: ----------------------------------------------

section <- word(link, 5, sep = fixed('/'))

dat <- tibble(
  link = link,
  section = section
)

# Loop for extracting the text of the files: ------------------------------------------------

dir.create("articles_libero")
articles <- vector(mode = "list", length = length(link))

for (i in 1:length(link)) {
  
  cat("Iteration:", i, ". Scraping:", link[i],"\n")
  
  page <- RCurl::getURL(link[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it"))
  
  file_path <- here::here("articles_libero", str_c("art_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  articles[[i]] <- read_html(file_path) %>% 
    html_nodes(".testoResize p") %>% 
    html_text()
  
  Sys.sleep(2)
} 

# Updating the tibble with the 3 variables: 
dat <- tibble(
  link = link,
  articles = articles,
  section = section
)
dat

# Sorting the dataset, deleting empty rows: ------------------------------------------------------------
library(dplyr)
dat_1 <- dat %>%
   filter(articles != "character(0)")

articles

# cleaning and reformatting the categories: now the articles are text
dat_2 <- data.frame(sapply(dat_2$articles, toString, windth=57))

# adding the newspaper name in the dataset: 

newspaper <- rep ("Libero Quotidiano", length = 63)

# creating the final dataset: 
dat_3 <- cbind(dat_2, dat_1)

text_df <- mutate(dat_2, text = articles$articles)

dat_3 <- tibble (link = dat_3$link, section = dat_3$section, text = text_df$sapply.dat_2.articles..toString..windth...57., newspaper = newspaper)
dat_3 

# saving it locally: 
save(dat_3, file = here::here("libero_articles_1702.Rdata"))


