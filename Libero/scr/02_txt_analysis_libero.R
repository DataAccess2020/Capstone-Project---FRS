# Capstone project: team FRS

# This script includes the text analysis on the articles scraped from "Libero Quotidiano":
# - unnesting the token words;
# - adding the line numbers;
# - removing the stopwords;
# - saving the clean and vectorized dataset in csv --> libero.csv
# - creating a dataset with only the words (libero_words)
# - analysis of the most frequent words (in the whole dataset and by sections);
# - wordclouds of the frequencies;
# - creating the corpus;
# - creating the document-term matrix and filtering it;
# - creating the TF-IDF;


# sourcing all the needed packages: ---------------------------------------------
source(here::here("Libero/scr","00_setup.R"))


# Unnesting the token words:-----------------------------

libero <- dat_character %>%
  unnest_tokens (word, text)

# Adding the line numbers:----------------------------------------

libero <- libero %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

# Removing the stopwords: --------------------------------------

# Those are words that were probably not scraped in the right encoding. Since those are not usual italian stopwords, I'm deleting them manually: 
new_stops <- c("eâ", "lâ", "â", "â", "â")

libero <- libero %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]')) %>% 
  filter(!str_detect(word, new_stops)) 

# Saving this clean and vectorized dataset: 
write.csv(libero, file = here::here("libero.csv"))

# I created a new data containing only the word variable, in order to calculate the frequency, without considering the links: 
libero_words <- tibble (word = libero$word)

## FREQUENCIES: ------------------------------------------
# The most frequent words in my data are: 
libero_words %>%
  count(word, sort = TRUE) 
# Wordcloud: 
libero_words %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))
# plot for the frequecies: 
libero_words %>%
  count(word, sort = TRUE) %>%
  filter(n > 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# 1. Frequencies for the section "politica": -------------------------------------
libero %>%
  filter(section  == "politica") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 1.1 Wordcloud: 
libero %>%
  filter(section  == "politica") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 2. Frequencies for the section "italia": --------------------------------------------
libero %>%
  filter(section  == "italia") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 2.1 Wordcloud:
libero %>%
  filter(section  == "italia") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 3. Frequencies for the section "esteri": -------------------------------------------
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 3.1 Wordcloud:
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 50))

# 4. Frequencies for the section "sfoglio": --------------------------------------
libero %>%
  filter(section  == "sfoglio") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 4.1 Wordcloud:
libero %>%
  filter(section  == "sfoglio") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

#____________________________________________________________

# TEXT ANALYSIS: 

# CORPUS:----------------------------------------------------- 
crp <- corpus(
  libero_words$word
)
summary(crp)
names(crp)

## DOCUMENT - TERM MATRIX:-------------------------------------------------

libero_dtm <- dfm(
  crp,
  verbose = T
)
libero_dtm

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






