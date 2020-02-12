library("RCurl")
library("tidyverse")
library("rvest")
library("string")


#PART ONE -------------- 

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.corriere.it//?ref=RHHD-L")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("https://www.corriere.it//robots.txt")


##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("Ilcorrieredellasera.html")) 


# PART TWO -----------


#selecting the links of the articles

links <- read_html(here::here("Ilcorrieredellasera.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links

#selecting only the links of corriere 

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

#creating a dataset with the links

datlinks <- tibble(
  links = CORRIERELinks
)
dat


# PART THREE --------------

#creating a folder to put the links 
dir.create("ARTICLESPAGES")


articoli11feb <- vector(mode = "list", length = length(CORRIERELinks))

for (i in 1:length(CORRIERELinks)) {
  
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
  Sys.sleep(0) 
} 

datTEXT <- tibble(
  link = CORRIERELinks,
  article = articoli11feb
)

datTEXT 




#


section <- word(links, 5, sep = fixed('/'))

dat <- tibble(
  link = links,
  section = section
)


economia <- str_subset(CORRIERELinks, "^https://www.corriere.it/economia/")
sport <-  str_subset(CORRIERELinks, "^https://www.corriere.it/sport/")
istruzione <- str_subset(CORRIERELinks, "^https://www.corriere.it/scuola/")

dat1 <- tibble(
  link = links,
  istruzione = istruzione
)


dat1 <- tibble(
  link = links,
  argomenti = c(economia, sport, istruzione)
)



dat1 <- 
  dat %>%
  mutate()


  





