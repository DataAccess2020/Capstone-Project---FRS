#install and call packages
source(here::here("script","00_setup.R"))

#import dataset-------
load(here::here("data/rvest/articoli_repubblica_17_02_2020.Rdata"))

#remove double links-------------
dataset_pulito <- unique (dat_definitivo)

#pulisco il testo from factor to character---------------
text_cleaned <- sapply(dataset_pulito$text, toString, windth=57)

#sostituisco nel dataframe definitivo la colonna text con il character (al posto del factor)--------
dataset_pulito <- mutate(dataset_pulito, text = text_cleaned)

# Unnesting the token words:-----------------------------
rep_anal <- dataset_pulito %>% unnest_tokens (word, text)

# Adding the line numbers:----------------------------------------

rep_anal <- rep_anal %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

# Removing the stopwords: --------------------------------------

# Those are words that were probably not scraped in the right encoding.
#Since those are not usual italian stopwords, I'm deleting them manually:

rep_anal <- rep_anal %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  anti_join(get_stopwords(language = "en", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "en", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]'))

# Saving this clean and vectorized dataset: 
write.csv(rep_anal, file = here::here("data/rvest/rep_analisi.csv"))

# I created a new data containing only the word variable
# in order to calculate the frequency, without considering the links: 
repubblica_words <- tibble (word = rep_anal$word)

## FREQUECIES: ------------------------------------------
# The most frequent words in my data are: 
repubblica_words %>%
  count(word, sort = TRUE) 

# Wordcloud: 
repubblica_words %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 400))

warnings()

# plot for the frequecies: 
repubblica_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# 1. Frequencies for the section "politica": -------------------------------------
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

# 2. Frequencies for the section "ambiente": --------------------------------------------
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

# 3. Frequencies for the section "cronaca": -------------------------------------------
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

# 4. Frequencies for the section "economia": --------------------------------------
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

#____________________________________________________________

# TEXT ANALYSIS: 

# CORPUS:----------------------------------------------------- 
crp <- corpus(
  rep_anal$word
)
summary(crp)
names(crp)

## DOCUMENT - TERM MATRIX:-------------------------------------------------

rep_dtm <- dfm(
  crp,
  verbose = T
)
rep_dtm

#Filtrare la DTM eliminando i termini poco informativi o problematici e Pesare i valori nelle celle in base alla frequenza del termine nel corpus (TF) rispetto alla frequenza del termine tra vari documenti (IDF)

libero_dtm_trim <- libero_dtm %>%
  dfm_trim(min_termfreq = 0.75, termfreq_type = "quantile", 
           max_docfreq = 0.25, docfreq_type = "prop",
           verbose = T)

libero_dtm_trim

#TF-IDF: 
libero_dtm_tfidf <- dfm_tfidf(
  libero_dtm
)

textstat_frequency(libero_dtm_tfidf, n = 20, force=T)

textplot_wordcloud(libero_dtm_tfidf, 
                   min_count = 10)
