source(here::here("src","00_setup.R"))

library(hunspell)

#Assicurarci che non ci siano caratteri estranei:
#1- rimuoviamo la punteggiatura;
#2- convertiamo tutte le parole in minuscolo;
#3- eliminaiamo lo spazio bianco ai margini (prodotto eliminando la punteggiatura);
#4- usiamo la funzione unique() per selezionare i valori unici

corriere_words <- as.matrix(corriere_words) #we need an atomic vector 

corriere_words2 <- corriere_words %>%
  str_replace_all("[^[:alnum:][:space:]]", " ") %>%
  str_to_lower() %>%
  str_split(" ") %>%
  unlist() %>%
  str_trim("both") %>%
  unique()

corriere_words2

# Ora possiamo usare la funzione hunspell_check() per cercare le parole che
# sono presenti nel dizionario.

head(hunspell_check(corriere_words, dict = "it_IT"))

# parole che non sono state riconosciute

corriere_words[hunspell_check(corriere_words, dict = "it_IT") == F]

writeLines( corriere_words, "./data/corrierewords.txt")


#quanteda --- 

library(quanteda)

corrierewords_dtm <- dfm (
  corriere_words2,
  verbose = T)

corrierewords_dtm

#parole che compaiono più frequentemente
topfeatures(corrierewords_dtm)

#Resoconto più dettagliato
textstat_frequency(corrierewords_dtm, n = 8440)

# Word cloud
textplot_wordcloud(corrierewords_dtm, 
                   min_count = 3)

#filtrare e pesare la DTM

corrierewords_dtm_trim <- corrierewords_dtm %>%
  dfm_trim(min_termfreq = 0.75, termfreq_type = "quantile", 
           max_docfreq = 0.25, docfreq_type = "prop",
           verbose = T)

textplot_wordcloud(corrierewords_dtm_trim, 
                   min_count = 3)

# SENTIMENT ----------------------------
??opeNER

opeNER <- import("./dizionari/opeNER_df.csv")
head(opeNER)


#CORPUS -------------------------------

#creo un corpus   
corp_it <- corpus(
    corriere_words
  )

#struttura del corpus 
summary(corp_it)

#contenuto del corpus
names(corp_it)

# Aggiungere nomi partiti in una nuova variabile
docvars(corp_it, "giornalee") <- "IlCorriere"

# La variabile sarà salvata all'interno di "documents"
corp_it$documents$IlCorriere


kwic(corp_it, "raga", valuetype = "regex")

corpus1 <- corpus(
  corriere_words$word
)
summary(corpus1)
names(corpus1)


corp_it <- corpus(
  corriere_words
)

kwic(corpus1, "giovani", valuetype = "regex")
