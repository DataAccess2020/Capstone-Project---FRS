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


dat1 <- dat %>%
  unnest_tokens (word, text)

#2. grouping by articles 
dat2 <- dat1 %>%
  group_by(link) %>%
  mutate(linenumber = row_number())

#3. Removing stopwords 
dat3 <- dat2 %>%
  anti_join(get_stopwords(language = "it", source ="snowball"))

#4. Counting words

dat3 <- dat3 %>%
  count(word, sort = TRUE)
dat3

dat3 %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 15))

dat3 %>%
  count(word, sort = TRUE) %>%
  filter (n < 4) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

library(wordcloud)
  
dat2 %>%
  count(word) %>%
  with(wordcloud(word, n))

       