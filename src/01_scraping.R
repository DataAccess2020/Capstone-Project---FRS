library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")


#1. downloading page-------------- 

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
           con = here::here("/data/Ilcorrieredellasera1702.html")) 


# 2. links -----------


#selecting the links of the articles

links <- read_html(here::here("/data/Ilcorrieredellasera1402.html")) %>% 
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


#3. scraping text articles 

#creating a folder to put the links 
dir.create("/data/ARTICLES")


articoli17feb <- vector(mode = "list", length = length(CORRIERELinks))


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
  Sys.sleep(2) 
} 

dat <- tibble(
  link = CORRIERELinks,
  article = articoli17feb
)

dat

# 4. new variable -> section
section <- word(CORRIERELinks, 4, sep = fixed('/'))

section

dat <- tibble(
  link = CORRIERELinks,
  article = articoli17feb,
  section = section,
)

dat


# 5. CLEANING DATASET -----------

cleandat <- dat %>%
  filter(article != "character(0)")

cleandat              
                
# 6. remove duplicate data

dat <- unique (cleandat)

dat

# 7. converting articles from list to character 

finaldat <- data.frame(articlestext = sapply(dat$article, toString, windth=57))


dat <- cbind(finaldat, dat)
dat

# 8. selecting variables 

dat <- select(dat, articlestext, link, section)

dat

# 9. saving dataset 

save(dat, file = here::here("/data/Corrierearticles1702.Rdata"))

 # ---
text_cleaned <- sapply(dat$articlestext, toString, windth=57)

# adding the new text format to the data frame: 
dat_character <- mutate(dat, articlestext = text_cleaned)

as.tbl(dat_character, stringsAsFactor = FALSE)

# saving it locally: 
save(dat_character, file = here::here("dat_character.Rdata"))


