## CAPSTONE PROJECT: team FRS

# SETUP SCRIPT

# This script is the set up for the data analysis of the project:

# List of the required packages:------------------------------------------------------------------
want = c("here","RCurl","tidyverse", "rvest","Rcrawler", "stringr", "readr", "tidytext", "tidyr", "stopwords", "udpipe", "dplyr", "wordcloud", "xml2", "quanteda", "ggplot2")
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)

# Calling the required packages: -------------------------------------------------------------------
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
library("dplyr")
library("wordcloud")
library("xml2")
library("quanteda")
library("ggplot2")