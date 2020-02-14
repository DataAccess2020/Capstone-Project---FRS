library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")


#PART ONE -------------- 

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


# PART TWO -----------


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
  Sys.sleep(0) 
} 

dat <- tibble(
  link = CORRIERELinks,
  article = articoli14feb
)

dat

# PART FOUR : new variable -> section
section <- word(CORRIERELinks, 4, sep = fixed('/'))

section

dat <- tibble(
  link = CORRIERELinks,
  article = articoli14feb,
  section = section,
)

dat


# PART FOUR: CLEANING DATASET -----------

cleandat <- dat %>%
  filter(article != "character(0)")

cleandatdat              
                
# PART SIX: remove duplicate data

dat <- unique (cleandat)

dat

# PART SIX: converting articles from list to character 

finaldat <- data.frame(sapply(dat$article, toString, windth=57))

dat <- cbind(finaldat, dat)
dat

# PART SEVEN: saving dataset 

save(dat, file = here::here("Corrierearticles1402.Rdata"))

