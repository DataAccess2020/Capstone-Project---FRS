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

textplot_wordcloud(libero_dtm, 
                   min_count =5)


libero_dtm_tfidf <- dfm_tfidf(
  libero_dtm
)

textstat_frequency(libero_dtm_tfidf, n = 20, force=T)

textplot_wordcloud(libero_dtm_tfidf, 
                   min_count = 10)







