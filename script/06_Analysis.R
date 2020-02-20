#Analysis: 

#install and call packages
source(here::here("script","00_setup.R"))

#import dataset
load(here::here("data/rvest/articoli_repubblica_17_02_2020.Rdata"))

#remove double links-------------
dataset_pulito <- unique (dat_definitivo)

#pulisco il testo from factor to character---------------
text_cleaned <- sapply(dataset_pulito$text, toString, windth=57)

#sostituisco nel dataframe definitivo la colonna text con il character (al posto del factor)--------
dataset_pulito <- mutate(dataset_pulito, text = text_cleaned)

#creo tabella con dataset definitvo-----------------
as.tbl(dataset_pulito, stringsAsFactor = FALSE)

#divido le parole----------------
dat_6 <- dataset_pulito %>%
  unnest_tokens (word, text)

#assegno la linenumber--------------
dat_7 <- dat_6 %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

#remove useless words with stopwords
dat_8 <- dat_7 %>%
  anti_join(get_stopwords(language = "it", source = "stopwords-iso")) %>% 
              anti_join(get_stopwords(language = "en", source = "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source = "snowball")) %>% 
  anti_join(get_stopwords(language = "en", source = "snowball")) %>% 
  anti_join(get_stopwords(source = "smart"))

#visualizzo le parole opiù utilizzate
dat_8 %>%
  count(word, sort =TRUE)

#creo una tabella con solo le parole per usare "count"
tibble_words <- tibble(word= dat_8$word)

tibble_words %>% count(word, sort =TRUE)

#----------TIDYTEXT.STOPWORDS.UDPIPE-----------
help("tidytext")
help("count")
help("stopwords")
help("udpipe")
browseVignettes(package = "tidytext")
stopwords_getsources()
# usare stop words
#aggiungere al dizionario di stopwords le parole più frequenti che non sono parole utili
#----------TIDYTEXT-----------


