#SETUP SCRIPT
# list of required packages
want = c("here","RCurl","tidyverse", "rvest","Rcrawler", "stringr")
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)
#call required packages
library("here")
library("RCurl")
library("tidyverse")
library("rvest")
library("Rcrawler")
library("stringr")
