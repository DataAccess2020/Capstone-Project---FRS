#Text analysis 
source(here::here("src","00_setup.R"))


# 1. vectorization -----------------
articles <- sapply(dat$articlestext, toString, windth=57)

dat <- mutate(dat, text = articles)

as.tbl(dat, stringsAsFactor = FALSE)

dat <- select(dat, text, link, section)


dat1 <- dat %>%
  unnest_tokens (word, text)

#2. grouping by articles ----------------
dat2 <- dat1 %>%
  group_by(link) %>%
  mutate(linenumber = row_number())

#3. Removing stopwords, digits, punctuation----------------------
dat3 <- dat2 %>%
  anti_join(get_stopwords(language = "it", source ="snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]'))

#4. Counting words ---------------
dat4 <- dat3 %>%
  ungroup() %>%
  count(word, sort = TRUE)
dat4

#5. words graphs 


dat %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100, size = 1000))


dat3 %>%
  count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

library(wordcloud)
  
dat3 %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 35)) %>%
  filter(., section %in% "cronaca")



library(lexicon)

?lexicon
