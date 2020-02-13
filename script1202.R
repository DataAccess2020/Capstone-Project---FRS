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
           con = here::here("Ilcorrieredellasera1302.html")) 


# PART TWO -----------


#selecting the links of the articles

links <- read_html(here::here("Ilcorrieredellasera1202.html")) %>% 
  html_nodes(css = ".is-8 .has-text-black , .is-pd-t-0 > .bck-media-news") %>% 
  html_attr("href")

links

#selecting only the links of corriere 

CORRIERELinks <- str_subset(links, "^https://www\\.corriere\\.it")

CORRIERELinks

#creating a dataset with the links

datlinks <- tibble(
  links = CORRIERELinks
)
datlinks




#creating a folder to put the links 
dir.create("ARTICLES")


articoli13feb <- vector(mode = "list", length = length(CORRIERELinks))

as.character(articoli13feb)


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
  articoli13feb[[i]] <- read_html(file_path) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(0) 
} 

datTEXT <- tibble(
  link = CORRIERELinks,
  article = articoli13feb
)

datTEXT 


# PART FOUR: CLEANING DATASET -----------

dat_sort <- datTEXT %>%
  filter(article != "character(0)")

dat_sort                
                
                
# PART FIVE : new variable -> section
section <- word(CORRIERELinks, 4, sep = fixed('/'))

section

datsection <- tibble(
  link = CORRIERELinks,
  article = articoli13feb,
  section = section
)

datsection

# PART SIX: remove duplicate data

datsection <- unique (datsection)



# PART SIX: saving dataset

save(datsection, file = "data.Rdata")
