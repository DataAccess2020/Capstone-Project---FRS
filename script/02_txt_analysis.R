#TXT ANALYSIS

#install and call packages
source(here::here("script","00_setup.R"))

#import dataset-------
load(here::here("data/rvest/articoli_repubblica_17_02_2020.Rdata"))

#remove double links-------------
dataset_pulito <- unique (dat_definitivo)

#"text" column transformed from factor to character---------------
text_cleaned <- sapply(dataset_pulito$text, toString, windth=57)

#replaced into "dataset_pulito"--------
dataset_pulito <- mutate(dataset_pulito, text = text_cleaned)

# Unnesting the token words----------
rep_anal <- dataset_pulito %>% unnest_tokens (word, text)

# Adding the line numbers:------------
rep_anal <- rep_anal %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())
#------------------------

#----------------------------

# Removing the stopwords -------------
rep_anal <- rep_anal %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  anti_join(get_stopwords(language = "en", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "en", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]')) %>% 
  filter(!str_detect(word, "true")) %>% 
  filter(!str_detect(word, "https")) %>% 
  filter(!str_detect(word, "http")) %>% 
  filter(!str_detect(word, "embed")) %>% 
  filter(!str_detect(word, "embedded")) %>% 
  filter(!str_detect(word, "catch")) 
  
  
# Saving this clean and vectorized dataset: 
write.csv(rep_anal, file = here::here("data/rvest/rep_analisi.csv"))        #as .CSV
save(dat_definitivo, file = here::here ("data/rvest/rep_analisi.Rdata")) #as .Rdata


# I created a new data containing only the word variable
# in order to calculate the frequency, without considering the links: 
repubblica_words <- tibble (word = rep_anal$word)


## FREQUECIES: -------
# The most frequent words in my data are: 
repubblica_words %>%
  count(word, sort = TRUE) 

# Wordcloud: 
repubblica_words %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 200))


# plot for the frequecies: 
repubblica_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# 1 Frequencies for the section "politica": --------
rep_anal %>%
  filter(section  == "politica") %>%
  ungroup() %>%
  count(word, sort = TRUE) 

# 1.1 Wordcloud: 
rep_anal %>%
  filter(section  == "politica") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 2 Frequencies for the section "ambiente": ---------
rep_anal %>%
  filter(section  == "ambiente") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 2.1 Wordcloud:
rep_anal %>%
  filter(section  == "ambiente") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 3 Frequencies for the section "cronaca": ------------
prova <- rep_anal %>%
  filter(section  == "cronaca") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 3.1 Wordcloud:
rep_anal %>%
  filter(section  == "cronaca") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 50))

# 4 Frequencies for the section "economia": ---------
rep_anal %>%
  filter(section  == "economia") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 4.1 Wordcloud:
rep_anal %>%
  filter(section  == "economia") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 5 Frequencies for the section "esteri": -----------
rep_anal %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 5.1 Wordcloud:
rep_anal %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))
# 6 Frequencies for the section "salute": -------
rep_anal %>%
  filter(section  == "salute") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 6.1 Wordcloud:
rep_anal %>%
  filter(section  == "salute") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 7 Frequencies for the section "spettacoli": --------
rep_anal %>%
  filter(section  == "spettacoli") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 7.1 Wordcloud:
rep_anal %>%
  filter(section  == "spettacoli") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))
# 8 Frequencies for the section "sport": -------
rep_anal %>%
  filter(section  == "sport") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 8.1 Wordcloud:
rep_anal %>%
  filter(section  == "sport") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))
# 9 Frequencies for the section "tecnologia": --------------
rep_anal %>%
  filter(section  == "tecnologia") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 9.1 Wordcloud:
rep_anal %>%
  filter(section  == "tecnologia") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))


# Create Corpus in order to use quanteda-----------
crp <- corpus(
  rep_anal$word)



## create DFM data frame matrix-----------------------

rep_dtm <- dfm(
  crp,
  verbose = T)


#weight DFM-------------------------

rep_dtm_wighted <- rep_dtm %>%
  dfm_trim(min_termfreq = 0.75, termfreq_type = "quantile", 
           max_docfreq = 0.25, docfreq_type = "prop",
           verbose = T)


#TF-IDF: ---------------------
rep_idf <- dfm_tfidf(
  rep_dtm)

textstat_frequency(rep_idf, n = 20, force=T)

textplot_wordcloud(rep_dtm_wighted, 
                   min_count = 10)
