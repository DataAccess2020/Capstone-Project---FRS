#Analysis: 

library(tidytext) 
library(tidyr)
library(stopwords)
library(tidyverse)
library(wordcloud)

# trasforming the text from factor to character: 
text_cleaned <- sapply(dat_3$text, toString, windth=57)

# adding the new text format to the data frame: 
dat_3 <- mutate(dat_3, text = text_cleaned)

as.tbl(dat_3, stringsAsFactor = FALSE)

# unnesting the token words into a new dataset:-----------------------------

libero <- dat_3 %>%
  unnest_tokens (word, text)

# adding the line numbers:----------------------------------------

libero <- libero %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

# removing the stopwords: --------------------------------------

new_stops <- c("eâ", "lâ", "â", "â", "â")

libero <- libero %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]')) %>% 
  filter(!str_detect(word, new_stops)) 

# saving this clean data: 
write.csv(libero, file = here::here("libero.csv"))

# I created a new data containing only the word variable, in order to calculate the frequency, without considering the links: 
libero_words <- tibble (word = libero$word)

## FREQUECIES: ------------------------------------------
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

# 1. Frequencies for the section "politica": ---------------------------
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

# 2. Frequencies for the section "italia": -------------------------------
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

# 3. Frequencies for the section "personaggi": --------------------------------------------
libero %>%
  filter(section  == "personaggi") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 3.1 Wordcloud:
libero %>%
  filter(section  == "personaggi") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 4. Frequencies for the section "esteri": -------------------------------------------
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 4.1 Wordcloud:
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

# 5. Frequencies for the section "spettacoli": --------------------------------------
libero %>%
  filter(section  == "spettacoli") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 5.1 Wordcloud:
libero %>%
  filter(section  == "spettacoli") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

#____________________________________________________________

# maybe sentiment?

library(xml2)
library(quanteda)

# Read file and find the nodes
opeNER_xml <- read_xml("it-sentiment_lexicon.lmf.xml")
entries <- xml_find_all(opeNER_xml, ".//LexicalEntry")
lemmas <- xml_find_all(opeNER_xml, ".//Lemma")
confidence <- xml_find_all(opeNER_xml, ".//Confidence")
sentiment <- xml_find_all(opeNER_xml, ".//Sentiment")

# Parse and put in a data frame
opeNER_df <- data.frame(
  id = xml_attr(entries, "id"),
  lemma = xml_attr(lemmas, "writtenForm"),
  partOfSpeech = xml_attr(entries, "partOfSpeech"),
  confidenceScore = as.numeric(xml_attr(confidence, "score")),
  method = xml_attr(confidence, "method"),
  polarity = as.character(xml_attr(sentiment, "polarity")),
  stringsAsFactors = F
)
# Fix a mistake
opeNER_df$polarity <- ifelse(opeNER_df$polarity == "nneutral", 
                             "neutral", opeNER_df$polarity)

# Make quanteda dictionary
opeNER_dict <- quanteda::dictionary(with(opeNER_df, split(lemma, polarity)))

#################################################

dfm <- dfm(libero$word)
dfm_lookup(dfm, dictionary =  opeNER_dict, valuetype = "regex")




