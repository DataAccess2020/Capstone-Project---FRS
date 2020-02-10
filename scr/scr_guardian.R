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

# 

#https://www.theguardian.com/
"(?<=MFG\\s{0,100}:\\s{0,100})\\w+"

dat_pg <- str_extract(link, "(https?:\\/\\/(www\\.)?guardian\\.com)\\w+")

dat_pg

# css for the text = .js-article__body p
