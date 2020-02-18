#Analysis: 

library(tidytext) library(tidyr)
library(stopwords)
library(tidyverse)
library(wordcloud)

# trasforming the text from factor to character: 
text_cleaned <- sapply(dat_3$text, toString, windth=57)

dat_3 <- mutate(dat_3, text = text_cleaned)

as.tbl(dat_3, stringsAsFactor = FALSE)

# unnesting the token words

libero <- dat_3 %>%
  unnest_tokens (word, text)

#adding the line numbers:

libero <- libero %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

  
# removing the stopwords: 

new_stops <- c("eâ", "lâ", "â", "â")

libero <- libero %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]')) %>% 
  filter(!str_detect(word, new_stops)) 

# saving: 
write.csv(dat_4, file = here::here("libero.csv"))

libero_words <- tibble (word = libero$word)

libero_words %>%
  count(word, sort = TRUE) %>% 
  with(wordcloud(word, n, max.words = 500))

libero %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

# graphs

# wordclouds: 





