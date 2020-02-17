#Text analysis 
library("RCurl")
library("tidyverse")
library("rvest")
library("stringr")
library("tidytext")
library("dplyr")
library("tidyr")
library("ggplot2")
library("stopwords")


# 1. vectorization 
articles <- sapply(dat$articlestext, toString, windth=57)

dat <- mutate(dat, text = articles)

as.tbl(dat, stringsAsFactor = FALSE)

dat <- select(dat, text, link, section)

word <- vector (mode = "character")

dat1 <- dat %>%
  unnest_tokens (word, text)

#2. grouping by articles 
dat2 <- dat1 %>%
  group_by(link) %>%
  mutate(linenumber = row_number())

#3. 

Todeletewords <- stopwords(language = "it", source = "snowball" )

as.tbl(Todeletewords)

stopwords <- Todeletewords


as.tbl(stopwords, stringsAsFactor = FALSE)

dat3 <- dat2 %>%
  anti_join("stopwords" = "Todeletewords")




y <- if (stopwords =1) {
   0
} else {
  1 
}

y


dat4 <- select(dat2, word, stopwords)

dat4 <- filter(
  dat4, 
  word != stopwords
)


dat2 <- dat1 %>%
  count(word, sort = TRUE)


dat2 %>%
  count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()



