#Text analysis 
source(here::here("src","00_setup.R"))


# 1. vectorization -----------------

articles <- sapply(dat$articlestext, toString, windth=57)

dat <- mutate(dat, text = articles)

as.tbl(dat, stringsAsFactor = FALSE)

dat <- select(dat, text, link, section)

dat1 <- dat %>%
  unnest_tokens (word, text)


#2. grouping by articles: created new variable "linenumber"---------------

dat2 <- dat1 %>%
  group_by(link) %>%
  mutate(linenumber = row_number())


#3. Removing stopwords, digits, punctuation----------------------

dat3 <- dat2 %>%
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source ="snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]'))

#4. Saving vectorized dataset 

save(dat3, file = here::here("/data/IlCorriereDellaSera.Rdata"))


#5. Creating a dataset with only 2 variables: word and count ---------------
corriere_words <- tibble (word = dat3$word)

save(corriere_words, file = here::here("/data/IlCorriereDellaSeraWORDS.Rdata"))


#6. Word frequencies 
corriere_words %>%
  count(word, sort = TRUE) 

#graph 

corriere_words %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

corriere_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

#. Sections: word frequencies 
#"CRONACA"
dat3 %>%
  filter(section == "cronache") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section == "cronache") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200)) 

dat3 %>%
  filter(section == "cronache") %>%
  count(word, sort = TRUE) %>%
  filter(n > 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
 

#"POLITICA"
dat3 %>%
  filter(section == "politica") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section  == "politica") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

dat3 %>%
  filter(section == "politica") %>%
  count(word, sort = TRUE) %>%
  filter(n > 3) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


#"ESTERI"
dat3 %>%
  filter(section == "esteri") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section  == "esteri") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

dat3 %>%
  filter(section == "esteri") %>%
  count(word, sort = TRUE) %>%
  filter(n > 5) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


#"ECONOMIA"
dat3 %>%
  filter(section == "economia") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section  == "economia") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

dat3 %>%
  filter(section == "economia") %>%
  count(word, sort = TRUE) %>%
  filter(n > 5) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

#LA-LETTURA
dat3 %>%
  filter(section == "la-lettura") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section  == "la-lettura") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 20))

dat3 %>%
  filter(section == "la-lettura") %>%
  count(word, sort = TRUE) %>%
  filter(n > 3) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

#SCUOLA
dat3 %>%
  filter(section == "scuola") %>%
  count(word, sort = TRUE) 

dat3 %>%
  filter(section  == "scuola") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 20))

dat3 %>%
  filter(section == "scuola") %>%
  count(word, sort = TRUE) %>%
  filter(n > 2) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
