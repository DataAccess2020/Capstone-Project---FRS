#install and call packages
source(here::here("script","00_setup.R"))

# Browsing the robots.txt file: -------------------------------------------------------
browseURL("https://www.repubblica.it/robots.txt")

# Downloading and saving the HTML: ----------------------------------------------------

#assign the url an object called "url"
url <- URLencode("https://www.repubblica.it/")

#download the page
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 
#save the HTML
writeLines(page,
           con = here :: here("data/rvest/repubblica.html"))

# Extracting the links by the homepage using Rvest:--------------------------------------

link <- read_html(here :: here("data/rvest/repubblica.html"))%>%
  html_nodes(css = ".Articolo , .entry-subtitle a , .entry-title a, body-text") %>%
  html_attr("href")

#clean the list, remove all useless links
link <- str_subset(link, "^https://www\\.repubblica\\.it")


#DT (dataset) with links-------------

dat_0 <- tibble(
  link = link)

#DT with links and section----------------

# Extracting the section of each article
section <- word(link, 4, sep = fixed('/'))

dat_1 <- tibble(
  link = link,
  section = section
)

# Loop for extracting the text of all the articles ------------------------------------------------

#create a folder to store the data
dir.create("data/rvest/articles_repubblica_2")

#create an object for the list of links
articles <- vector(mode = "list", length = length(link))

#the loop
for (i in 1:length(link)) {
  
  cat("Iteration:", i, ". Scraping:", link[i],"\n")
  
  page <- RCurl::getURL(link[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
  
  file_path <- here::here("data/rvest/articles_repubblica_2", str_c("art_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  articles[[i]] <- read_html(file_path) %>% 
    html_nodes(".body-text,.summary , .body-text,.body-text > span,.detail_summary , .detail_body,p+ p,P") %>% 
    html_text()
  
  Sys.sleep(2)
} 

#DT with links, section and the articles text---------------- 
dat_2 <- tibble(
  link = link,
  articles = articles,
  section = section)


# Sorting the dataset, deleting empty rows: -----------------
dat_3 <- dat_2 %>%
  filter(articles != "character(0)")

# clean the article column--------------
dat_4 <- data.frame(sapply(dat_3$articles, toString, windth=57))

# combine dat4 e dat5---------------
dat_5 <- cbind(dat_3, dat_4)

#DT definitivo------------

dat_definitivo <- tibble(link= dat_5$link,
                         section= dat_5$section,
                         text= dat_5$sapply.dat_3.articles..toString..windth...57.)

#where to save definitive dataset
save(dat_definitivo, file = here::here ("data/rvest/02_articoli_repubblica_17_02_2020.Rdata"))
