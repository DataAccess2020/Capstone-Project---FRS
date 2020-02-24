

#collect all link
link_xpath <- ContentScraper(Url = "https://www.repubblica.it", 
                             XpathPatterns = "//*/a/@href" ,
                             ManyPerPattern = TRUE)
#ispeziono l'elenco dei link
link_xpath[[1]]

#creo una lista con tutti i link
url_list_xpath <- c(link_xpath[[1]])
url_list_xpath


#pulisco l'elenco tenendo solo i link che iniziano con "https://www.repubblica.it"
url_list_xpath_cleaned <- str_subset(url_list_xpath,"^https://www.repubblica.it")
url_list_xpath_cleaned
