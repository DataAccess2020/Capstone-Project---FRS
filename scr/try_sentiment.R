# try sentiment: 

library(hunspell)

parole_libero <- libero_words %>%
  str_replace_all("[^[:alnum:][:space:]]", " ") %>%
  str_to_lower() %>%
  str_split(" ") %>%
  unlist() %>%
  str_trim("both") %>%
  unique()

# controllo delle parole presenti nel dizionario (incluso in R - sezione spelling):
head(hunspell_check(parole_libero, dict = "it_IT"))

# quali parole non sono state riconosciute: 
parole_libero[hunspell_check(parole_libero, dict = "it_IT") == F]
