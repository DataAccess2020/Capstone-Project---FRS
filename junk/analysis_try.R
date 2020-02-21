## prova

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

################################################################################
corpus <- corpus(dat_3$text)

summary(corpus)

dfm <- dfm(corpus)

freq <- textstat_frequency(dfm, n = 30)

ggplot(data = freq) +
  geom_point(aes(x = reorder(feature, frequency), y = frequency)) +
  coord_flip() +
  labs(x = NULL, y = "Frequency", title = "Descriptive frequencies") +
  theme_bw()

inaug_lx <- dfm(corpus, 
                what = 'word', 
                tolower = TRUE, 
                stem = FALSE,
                remove_numbers = TRUE,
                remove_punct = TRUE,
                remove_separators = TRUE,
                remove_url = TRUE,
                ngrams = 1, 
                dictionary = opeNER_dict)   # <--- Note this line!

inaug_lx_trim <- dfm_trim(inaug_lx, 
                          termfreq_type = "prop",
                          min_termfreq = 0.05,
                          min_docfreq = 3)

as_tibble(inaug_lx_trim) %>% 
  mutate(share_pos = positive / (negative + positive) * 100) %>% 
  ggplot(aes(x= inaug_lx_trim, y = share_pos)) + 
  geom_point() +
  geom_smooth(method = "loess", ) + 
  labs(x = "Year", y = "Share of positive terms", title = "Sentiment US inaugural speeches") +
  theme_bw()


inaug_lx_trim <- dfm_trim(inaug_lx, 
                          termfreq_type = "prop",
                          min_termfreq = 0.05,
                          min_docfreq = 3)


dfm_lookup(dfm, dictionary =  opeNER_dict, valuetype = "glob")


myDfm <- dfm(dfm, dictionary = opeNER_dict)
myDfm
dfm_lookup(myDfm, dictionary =  opeNER_dict, valuetype = "glob")

