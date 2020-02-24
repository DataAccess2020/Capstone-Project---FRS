#SETUP SCRIPT

# list of required packages
want <- c("wordcloud", "here","RCurl","tidyverse", "rvest","Rcrawler", "stringr", "readr", "tidytext", "tidyr", "stopwords", "udpipe", "quanteda","hunspell","cowplot","ggplot2", "magick" )
have <- want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)

#call required packages
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
library("udpipe")
library("quanteda")
library("wordcloud")
library("hunspell")
library("xml2")
library("cowplot")
library("ggplot2")
library("magick")