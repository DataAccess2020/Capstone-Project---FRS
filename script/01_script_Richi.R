library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
link <- "https://www.nytimes.com/"
RobotParser ( link , str_c(R.version$platform,
                          R.version$version.string,
                          sep = ", ") )

Rcrawler (Website = "https://www.nytimes.com/", Useragent= "Mozilla 3.11",
          RequestsDelay = 2,
          Encod = "utf-8",
          URLlenlimit = 255,
          MaxDepth = 0)

ListProjects()

MyDATA<-LoadHTMLFiles("nytimes.com-101811", type = "list")

df<-data.frame(do.call("rbind", MyDATA))
