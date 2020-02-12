library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
library("stringr")

#Browsing the page 
url <- URLencode("https://www.repubblica.it")
browseURL(url)

#Downloading the page while specifying our browser and providing our email
repubblica_page <- RCurl:: getURL(url, 
                          useragent = str_c(R.version$platform,
                                            R.version$version.string,
                                            sep = ", "),
                          httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 


#Saving the page 
writeLines(repubblica_page, 
           con = here::here("repubblica.html"))

#extract  the links
link_pagine <- read_html(here::here("repubblica.html")) %>% 
                          html_nodes(".block-8-2 .entry-title a , .block-8-1 a , .rep-small , .no-media a") %>%            #controllare nodo dei link
                          html_attr("href")


#Creating a folder where to store all the pages:
dir.create("Repubblica")

#Specifying lenght and mode of the vector
articoli_repubblica <- vector(mode = "list", length = length(link_pagine))

#Applying the for loop function to get all the links and their texts.
for (i in 1:length(link_pagine)) {
  
  cat("Iteration:", i, ". Scraping:", link_pagine[i],"\n")
  
  #Getting the page
  page <- RCurl:: getURL(link_pagine[i], 
                         useragent = str_c(R.version$platform,
                                           R.version$version.string,
                                           sep = ", "),
                         httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
  
  #Saving the page:
  file_path <- here::here("Repubblica", str_c("pag_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  #Parsing and extracting
  articoli_repubblica[[i]] <- read_html(file_path) %>% 
    html_nodes(".body-text span") %>%                  #controllare nodo del testo
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2) 
} 
