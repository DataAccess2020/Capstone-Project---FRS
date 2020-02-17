#Analysis: 

source(here::here("script","00_setup.R"))


#pulisco il testo from factor to character---------------
text_cleaned <- sapply(dat_definitivo$text, toString, windth=57)

#sostituisco nel dataframe definitivo la colonna text con il character (al posto del factor)--------
dat_definitivo <- mutate(dat_definitivo, text = text_cleaned)

#creo tabella con dataset definitvo-----------------
as.tbl(dat_definitivo, stringsAsFactor = FALSE)

#divido le parole----------------
dat_6 <- dat_definitivo %>%
  unnest_tokens (word, text)

#assegno la linenumber--------------
dat_7 <- dat_6 %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

#----------TIDYTEXT-----------
# usare stop words
#aggiungere al dizionario di stopwords le parole più frequenti che non sono parole utili
#----------TIDYTEXT-----------


#visualizzo le parole opiù utilizzate
dat_7 %>%
count(word, sort =TRUE)
