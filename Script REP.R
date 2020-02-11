#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.repubblica.it/?ref=RHHD-L")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("https://www.repubblica.it/robots.txt")

#Commenting the results


# POINT 2 ------------------------------------------------------------------------------------------------------
##Check out the following link: http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/. Download it using RCcurl::getURL() to download the page while informing the webmaster about your browser details and providing your email.

##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("La_repubblica.html"))


# POINT 3 --------------------------------------------------------------
# Create a data frame with all the HTML links in the page using the XML::getHTMLLinks().
# Then, use a regex to keep only those links that re-direct to other posts of the beppegrillo.it blog (so remove all other links).


#Using rvest:: instead of XML.

links <- read_html(here::here("La_repubblica.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links

filteredlinks2 <- str_subset(links2, "^https://www\\.repubblica\\.it")

argomenti <- str_subset(filteredlinks2, "^https://www\\.repubblica\\.it\\/argomenti")

argomenti

dat2 <- tibble(
  links2 = filteredlinks2
)
dat2

dir.create("linksFOLDER")

articoli10feb <- vector(mode = "list", length = length(filteredlinks2))

dir.create ("argomentifolder")
argomenti10feb <- vector(mode = "list", length = length(argomenti))

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
