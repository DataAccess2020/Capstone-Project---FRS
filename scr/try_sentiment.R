# try sentiment: 

# sourcing the packages: 
source(here::here("scr","00_setup.R"))

library(hunspell)

#parole_libero <- libero_words %>%
#  str_replace_all("[^[:alnum:][:space:]]", " ") %>%
#  str_to_lower() %>%
 # str_split(" ") %>%
  #unlist() %>%
  #str_trim("both") %>%
  #unique()

# controllo delle parole presenti nel dizionario (incluso in R - sezione spelling):
#head(hunspell_check(parole_libero, dict = "it_IT"))

# quali parole non sono state riconosciute: 
#parole_libero[hunspell_check(parole_libero, dict = "it_IT") == F]
# riunisco in un unico vector: 
#parole_libero <- str_c(parole_libero, collapse = " ")

# CORPUS:----------------------------------------------------- 
crp <- corpus(
  libero_words$word
)
summary(crp)
names(crp)

# contesto in cui compaiono certe parole nel corpus: 
#kwic(corpus, "mussolini")
#kwic(corpus, "coronavirus")
#kwic(corpus, "salvini")


## TOKENS: ------------------------------------------------------
#corpus_frasi <- corpus %>%
 # corpus_reshape(to = "sentences")
# I testi ora sono frasi singole
#texts(corpus_frasi)[3]

# rimuovo numeri e punteggiatura: 
#token_frasi <- corpus_frasi %>%
 # tokens(remove_punct = T,
  #       remove_numbers = T,
   #      verbose = T)

#head(token_frasi[[6]])

# rimuovo apostrofi: 
#texts(corpus_frasi) <- texts(corpus_frasi) %>%
 # str_replace_all("([a-z])\\'", "\\1 ")

#token_frasi <- corpus_frasi %>%
 # tokens(remove_punct = T,
         #remove_numbers = T)
#head(token_frasi[[6]], n = 7)

#STEMMING:---------------------------------------------

#stopwords: 
#stp <- c(stopwords("italian"), "d", "eâ", "lâ", "â", "â", "â")

# get_stopwords(language= "it", source = "snowball"), get_stopwords(language= "it", source = "stopwords-iso")
# rimuovo sia stopwords che maiuscole: 
#token_frasi <- token_frasi %>%
 # tokens_tolower() %>%                     # Porta tutto in minuscolo
  #tokens_remove(stp) %>%                   # Rimuove stop words (lista aggiornata da noi)
#  tokens_wordstem(language = "italian")    # Stemming
#head(token_frasi[[1]], n = 10)

# N - GRAMMI: ---------------------------------------------------

#ngr <- textstat_collocations(
 # token_frasi, 
#  size = 2:3,                 # Sequence di 2 e 3 parole
 # min_count = 3) 

#ngr %>%
 # arrange(-count)

# unisco all'oggetto precedente: 

#token_frasi <- tokens_compound(
#  token_frasi, 
 # phrase(ngr$collocation), 
#  join = T
#)

## DOCUMENT - TERM MATRIX:-------------------------------------------------

# Matrice nella quale le righe sono i documenti, le colonne le parole, 
# e nelle celle il conteggio delle volte che una determinata parola compare in un determinato documento
libero_dtm <- dfm(
  crp,
  verbose = T
)
libero_dtm

# most frequent words: 
topfeatures(libero_dtm)
textstat_frequency(libero_dtm, n = 20)
# Wordcloud: 
textplot_wordcloud(libero_dtm, 
                   min_count =5)

#Filtrare la DTM eliminando i termini poco informativi o problematici e Pesare i valori nelle celle in base alla frequenza del termine nel corpus (TF) rispetto alla frequenza del termine tra vari documenti (IDF)

libero_dtm_trim <- libero_dtm %>%
  dfm_trim(min_termfreq = 0.75, termfreq_type = "quantile", 
           max_docfreq = 0.25, docfreq_type = "prop",
           verbose = T)

libero_dtm_trim

textplot_wordcloud(libero_dtm_trim, 
                   min_count = 10)

#TF-IDF: 
libero_dtm_tfidf <- dfm_tfidf(
  libero_dtm
)

textstat_frequency(libero_dtm_tfidf, n = 20, force=T)

textplot_wordcloud(libero_dtm_tfidf, 
                   min_count = 10)

# Dizionari: -----------------------------------------------------
opeNER <- rio::import("./dictionary/opeNER_df.csv")
head(opeNER)

# words without polarity: 
table(opeNER$polarity, useNA = "always")
opeNER <- opeNER %>%
  filter(polarity != "")

# Depeche Mood: 
dpm <- rio::import("./dictionary/DepecheMood_italian_token_full.tsv")
head(dpm)

# Sentiment: -----------------------------------------------------
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity)
)
lengths(opeNERdict)

# create the a dataset with the text (as character) and the sectin( filtered)
data_sentiment <-  dat_character %>% 
  select(section, text) %>% 
  filter(!is.na(section))


table(dat_character$section)
data_sentiment <- subset (data_sentiment, section == "esteri" | section =="italia" | section=="politica"| section=="sfoglio") 


# create the corpus for the sentiment analysis: 
crp_prova <- corpus(
  data_sentiment
)

# create the DFM for the sentiement analysis: 
libero_dtm1 <- dfm(
  crp_prova,
  tolower = T,
  dictionary = opeNERdict
) %>%
  dfm_group(
    group = "section"
  )
head(libero_dtm1)

# Graph of the sentiments: 
quanteda::convert(libero_dtm1,
                  to = "data.frame") %>%
  rename(section = document) %>%
  gather(var, val, -section) %>%
  group_by(section) %>%
  mutate(
    val = val/sum(val)
  ) %>%
  ggplot(., aes(x = var, y = val)) +
  geom_bar(aes(fill = section), 
           stat = "identity", alpha = 0.5) +
  facet_wrap(~section, ncol = 3) +
  scale_y_continuous(labels = scales::percent) +
  theme_bw()















