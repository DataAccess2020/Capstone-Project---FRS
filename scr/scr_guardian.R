

browseURL("https://www.theguardian.com/robots.txt")

url <- URLencode("https://www.theguardian.com/international")

library(stringr)
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it")) 


writeLines(page,
           con = here :: here("guardian.html"))

# Obtaining the links in the page:
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

