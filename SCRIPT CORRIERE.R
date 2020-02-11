library("RCurl")
library("tidyverse")
library("rvest")

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.corriere.it//?ref=RHHD-L")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("https://www.corriere.it//robots.txt")

#Commenting the results

library(stringr)

##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("Ilcorrieredellasera.html"))


#selecting the links of the articles 

links <- read_html(here::here("Ilcorrieredellasera.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

# CAPIRE MEGLIO ------------------------------------------------

ARTICOLILinks <- str_subset(links, "^https://www\\.corriere\\.it\\/*\\/*")

#creating a dataset with the links

dat <- tibble(
  links = CORRIERELinks
)
dat

#creating a folder to put the links 
dir.create("FOLDERLINKS")

#

articoli11feb <- vector(mode = "character", length = length(CORRIERELinks))


#Scraping the article 
for (i in 1:length(filteredlinks2)) {
  
  cat("Iteration:", i, ". Scraping:", filteredlinks2[i],"\n")
  
  #Getting the page
  page3 <- RCurl::getURL(filteredlinks2[i], 
                         useragent = str_c(R.version$platform,
                                           R.version$version.string,
                                           sep = ", "),
                         httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  #Saving the page:
  file_path_1 <- here::here("linksFOLDER", str_c("links_", i, ".html"))
  writeLines(page3, 
             con = file_path_1)
  
  #Parsing and extracting
  articoli10feb[[i]] <- read_html(file_path_1) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2) 
} 



aricletext <- read_html(links) %>% 
  html_nodes(css = "p") %>% 
  html_text()

nextarticle
