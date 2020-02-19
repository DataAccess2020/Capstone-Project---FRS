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


#4. Creating a dataset with only 2 variables: word and count ---------------

dat4 <- dat3 %>%
  ungroup() %>%
  count(word, sort = TRUE)


#5. Words graphs ----------------
dat5 %>%
  select(word) %>% 
  count(word) %>%
  with(wordcloud(word, n, max.words = 200)) 


#graphs "CRONACA"
dat3 %>%
  filter(section == "cronache") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200)) 
 

#graph "POLITICA"
dat3 %>%
  filter(section  == "politica") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))


#graph "ESTERI"
dat3 %>%
  filter(section  == "esteri") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))


#graph "ECONOMIA"
dat3 %>%
  filter(section  == "economia") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 35))




write.csv(dat3, file = here::here("Corrieredellasera.cvs"))

save(dat3, file = here::here("Corrierearticles1402TEXTANALYSIS.Rdata"))


