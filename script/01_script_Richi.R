library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
link <- "https://www.nytimes.com/"
RobotParser ( link , str_c(R.version$platform,
                          R.version$version.string,
                          sep = ", ") )

Rcrawler (Website = "https://www.nytimes.com ", no_cores=8, nbcon =8, Obeyrobots = TRUE, Useragent= "str_c(R.version$platform,
                          R.version$version.string,
                          sep = ", ")" )

Rcrawler(Website = "https://www.nytimes.com", no_cores = 4, no_conn = 4)
