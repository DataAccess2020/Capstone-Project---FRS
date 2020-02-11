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
dir.create("ARTICLESPAGES")

#

articoli11feb <- vector(mode = "list", length = length(CORRIERELinks))

for (i in 152:length(articoli11feb)) {
  
  cat("Iteration:", i, ". Scraping:", CORRIERELinks[i],"\n")
  
  #Getting the page
  page <- RCurl::getURL(CORRIERELinks[i], 
                         useragent = str_c(R.version$platform,
                                           R.version$version.string,
                                           sep = ", "),
                         httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  #Saving the page:
  file_path <- here::here("ARTICLESPAGES", str_c("articles_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  #Parsing and extracting
  articoli11feb[[i]] <- read_html(file_path) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2) 
} 


dat %>%
  mutate(economia = str_subset(CORRIERELinks, "^https://www.corriere.it/economia/")) %>%
  mutate(sport = str_subset(CORRIERELinks, "^https://www.corriere.it/sport/")) %>%
  mutate(istruzione = str_subset(CORRIERELinks, "^https://www.corriere.it/scuola/")) %>%
  mutate()
  
      
  





