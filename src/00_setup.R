#Setup

want = c("here","RCurl","tidyverse", "rvest","Rcrawler", "stringr", "readr", "tidytext", "tidyr", "stopwords", "wordcloud", "quanreda","xml2")

have = want %in% rownames(installed.packages())

if ( any(!have) ) { install.packages( want[!have] ) }

rm(have, want)


library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
library("stringr")
library("readr")
library("tidytext")
library("tidyr")
library("stopwords")
library("wordcloud")
library("quanteda")
library("xml2")

