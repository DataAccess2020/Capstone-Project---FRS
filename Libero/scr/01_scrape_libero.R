# Capstone project: team FRS

# This script includes the scraping of the newspaper "Libero Quotidiano":
# - browsing the robots.txt file;
# - downloading and saving the HTML;
# - extracting the links in the homepage using Rvest;
# - extracting the section/category for each article;
# - extracting the text of the articles;
# - sorting the dataset;
# - adding the newspaper name in the dataset;
# - saving the final dataset as Rdata--> dat_3.Rdata
# - saving the dataset with the variable text as character --> dat_character.Rdata

# Sourcing all the needed packages: ---------------------------------------------------
source(here::here("Libero/scr","00_setup.R"))

# Browsing the robots.txt file: -------------------------------------------------------
browseURL("https://www.liberoquotidiano.it/robots.txt")

# Downloading and saving the HTML of the homepage: ----------------------------------------------------
url <- URLencode("https://www.liberoquotidiano.it/")

page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it")) 

writeLines(page,
           con = here :: here("libero.html"))

# Extracing the links in the homepage using Rvest:--------------------------------------

link <- read_html(here :: here("libero.html"))%>%
  html_nodes(css = ".titolo a") %>%
  html_attr("href")

link <- str_subset(link, "^https://www\\.liberoquotidiano\\.it")

link

# Creating the data frame:

dat <- tibble(
  link = link)

dat

# Extracting the section of each article: ----------------------------------------------

section <- word(link, 5, sep = fixed('/'))

dat <- tibble(
  link = link,
  section = section
)

# Loop for extracting the text of the files: ------------------------------------------------

dir.create("articles_libero")
articles <- vector(mode = "list", length = length(link))

for (i in 1:length(link)) {
  
  cat("Iteration:", i, ". Scraping:", link[i],"\n")
  
  page <- RCurl::getURL(link[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "sofiagiovanna.ragazzi@studenti.unimi.it"))
  
  file_path <- here::here("articles_libero", str_c("art_", i, ".html"))
  writeLines(page, 
             con = file_path)
  
  articles[[i]] <- read_html(file_path) %>% 
    html_nodes(".testoResize p") %>% 
    html_text()
  
  Sys.sleep(2)
} 

# Updating the tibble with the 3 variables: 
dat <- tibble(
  link = link,
  articles = articles,
  section = section
)
dat

# Deleting NAs: ------------------------------------------------------------

dat_1 <- dat %>%
   filter(articles != "character(0)")

articles

# Cleaning and reformatting the categories: now the articles are text
dat_2 <- data.frame(sapply(dat_2$articles, toString, windth=57))

# adding the newspaper name in the dataset: 

newspaper <- rep ("Libero Quotidiano", length = 63)

# Creating the final dataset: -------------------------------------------------
dat_3 <- cbind(dat_2, dat_1)

# making sure that the variable "text" is a character vector: 
text_df <- mutate(dat_2, text = articles$articles)

dat_3 <- tibble (link = dat_3$link, section = dat_3$section, text = text_df$sapply.dat_2.articles..toString..windth...57., newspaper = newspaper)
dat_3 

# Saving it locally: 
save(dat_3, file = here::here("libero_articles_1702.Rdata"))

# trasforming the text from factor to character: 
text_cleaned <- sapply(dat_3$text, toString, windth=57)

# adding the new text format to the data frame: 
dat_character <- mutate(dat_3, text = text_cleaned)

as.tbl(dat_character, stringsAsFactor = FALSE)

# saving it locally: 
save(dat_character, file = here::here("dat_character.Rdata"))

