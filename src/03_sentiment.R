source(here::here("src","00_setup.R"))

library(hunspell)

as.matrix(corriere_words)

corriere_words2 <- corriere_words %>%
  str_replace_all("[^[:alnum:][:space:]]", " ") %>%
  str_to_lower() %>%
  str_split(" ") %>%
  unlist() %>%
  str_trim("both") %>%
  unique()

head(hunspell_check(corriere_words, dict = "it_IT"))

is.character(words)

opeNER_xml <- read_xml("it-sentiment_lexicon.lmf.xml")


??preferences

corpus1 <- corpus(
  corriere_words$word
)
summary(corpus1)
names(corpus1)


corp_it <- corpus(
  corriere_words
)

kwic(corpus1, "giovani", valuetype = "regex")


CORRIERE <- corriere_words %>%
  str_replace_all("[^[:alnum:][:space:]]", " ") %>%
  str_to_lower() %>%
  str_split(" ") %>%
  unlist() %>%
  str_trim("both") %>%
  unique()

# controllo delle parole presenti nel dizionario (incluso in R - sezione spelling):
head(hunspell_check(CORRIERE, dict = "it_IT"))

# quali parole non sono state riconosciute: 
parole_libero[hunspell_check(parole_libero, dict = "it_IT") == F]
# riunisco in un unico vector: 
parole_libero <- str_c(parole_libero, collapse = " ")