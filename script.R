#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("https://www.independent.co.uk/")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("http://www.independent.co.uk/robots.txt")

library(stringr)

options(rsconnect.http='curl')

RCurl::curlVersion()$ssl_version


##Downloading the file
page <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("/data/Beppe_grillo_blog.html"))