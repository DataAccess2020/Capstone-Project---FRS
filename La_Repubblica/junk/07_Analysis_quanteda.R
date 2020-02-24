#install and call packages
source(here::here("script","00_setup.R"))

#import dataset
load(here::here("data/rvest/articoli_repubblica_17_02_2020.Rdata"))

#remove double links-------------
dataset_pulito <- unique (dat_definitivo)

#clean the text from factor to character---------------
text_cleaned <- sapply(dataset_pulito$text, toString, windth=57)

#replace in the dataset--------
dataset_pulito <- mutate(dataset_pulito, text = text_cleaned)

#table with definitive dataset-----------------
as.tbl(dataset_pulito, stringsAsFactor = FALSE)

#creating a corpus in order to use quanteda
corpus <- corpus(dataset_pulito)

summary(corpus)

#divide text in words
tokens(corpus, "word")

#divido il testo degli articoli in frasi
corpus_frasi <- corpus %>%
  corpus_reshape(to = "sentences")

#rimuovo numero e punteggiatura
token_frasi <- corpus_frasi %>%
  tokens(remove_punct = T,
         remove_numbers = T,
         verbose = T)

#come si nota in questo esempio abbiamo il problema degli apostrofi
head(token_frasi[[56]])

#ricreiamo i tokens rimuovendo gli apostrofi
texts(corpus_frasi) <- texts(corpus_frasi) %>%
  str_replace_all("([a-z])\\'", "\\1 ")

token_frasi <- corpus_frasi %>%
  tokens(remove_punct = T,
         remove_numbers = T)

#controllo di aver effettivamente rimosso gli apostrofi
head(token_frasi[[56]], n = 7)

