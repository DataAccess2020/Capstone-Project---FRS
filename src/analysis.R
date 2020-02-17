#Text analysis 
library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")
library("tidytext")
library("dplyr")
library("tidyr")
library("ggplot2")


# 1. vectorization 
articles <- sapply(dat$articlestext, toString, windth=57)

dat <- mutate(dat, text = articles)

as.tbl(dat, stringsAsFactor = FALSE)

dat <- select(dat, text, link, section)

word <- vector (mode = "character")

dat1 <- dat %>%
  unnest_tokens (word, text)

#adding line 

dat2 <- dat1 %>%
  group_by(link)
