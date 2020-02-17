# Capstone project:

# This script includes the scraping of the newspaper "The Guardian":
# - browsing the robots.txt file;
# - downloading and saving the HTML;
# - extracting the links in the homepage using Rvest:
# - extracting the section/category for each article:
# - extracting the text of the articles
# - sorting the dataset

source(here::here("script","00_setup.R"))

# Browsing the robots.txt file: -------------------------------------------------------
browseURL("https://www.repubblica.it/robots.txt")

# Downloading and saving the HTML: ----------------------------------------------------
url <- URLencode("https://www.repubblica.it/")

page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 

writeLines(page,
           con = here :: here("data/rvest/repubblica.html"))

# Extracting the links in the homepage using Rvest:--------------------------------------

link <- read_html(here :: here("data/rvest/repubblica.html"))%>%
  html_nodes(css = ".Articolo , .entry-subtitle a , .entry-title a") %>%
  html_attr("href")

link <- str_subset(link, "^https://www\\.repubblica\\.it")

link

#DT with links-------------

dat_0 <- tibble(
  link = link)

dat_0

#DT with links and section----------------

# Extracting the section of each article
section <- word(link, 4, sep = fixed('/'))

dat_1 <- tibble(
  link = link,
  section = section
)

# Loop for extracting the text of the files: ------------------------------------------------
dir.create("data/rvest/articles_repubblica")
articles <- vector(mode = "list", length = length(link))

for (i in 1:length(link)) {
  
  cat("Iteration:", i, ". Scraping:", link[i],"\n")
  
  page <- RCurl::getURL(link[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
  
  file_path <- here::here("data/rvest/articles_repubblica", str_c("art_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  articles[[i]] <- read_html(file_path) %>% 
    html_nodes(".middle-img h1 , .summary , .body-text > span") %>% 
    html_text()
  
  Sys.sleep(2)
} 

#DT with links, section and the articles text---------------- 
dat_2 <- tibble(
  link = link,
  articles = articles,
  section = section
)


# Sorting the dataset, deleting empty rows: -----------------
dat_3 <- dat_2 %>%
  filter(articles != "character(0)")

# clean the article row--------------
dat_4 <- data.frame(sapply(dat_3$articles, toString, windth=57))

# combino dat4 e dat5---------------
dat_5 <- cbind(dat_3, dat_4)

#DT definitivo------------

dat_definitivo <- tibble(link= dat_5$link,
                         section= dat_5$section,
                         text= dat_5$sapply.dat_3.articles..toString..windth...57.)
save(dat_definitivo, file = here::here ("data/rvest/articoli_repubblica_17_02_2020.Rdata"))
