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
repubblica_page <- getURL(url, 
                          useragent = str_c(R.version$platform,
                                            R.version$version.string,
                                            sep = ", "),
                          httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 


#Saving the page 
writeLines(repubblica_page, 
           con = here::here("repubblica.html"))

#Creating an object to grab all the links
link_pagine <- read_html(here::here("repubblica.html")) %>% 
                          html_nodes("a") %>% 
                          html_attr("href")


#Creating a folder where to store all the pages:
dir.create("prova_Rvest_Loop")

#Specifying lenght and mode of the vector
articoli_repubblica <- vector(mode = "list", length = length(link_pagine))

#Applying the for loop function to get all the links and their texts.
for (i in 1:length(link_pagine)) {
  
  cat("Iteration:", i, ". Scraping:", link_pagine[i],"\n")
  
  #Getting the page
  page3 <- RCurl::getURL(link_pagine[i], 
                         useragent = str_c(R.version$platform,
                                           R.version$version.string,
                                           sep = ", "),
                         httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
  
  #Saving the page:
  file_path_1 <- here::here("prova_Rvest_Loop", str_c("pag_", i, ".html"))
  writeLines(page3, 
             con = file_path_1)
  
  #Parsing and extracting
  articoli_repubblica[[i]] <- read_html(file_path_1) %>% 
    html_nodes(".body-text span") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2) 
} 