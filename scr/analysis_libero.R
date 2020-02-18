#Analysis: 

library(tidytext) library(tidyr)
library(stopwords)

# trasforming the text from factor to character: 
text_cleaned <- sapply(dat_3$text, toString, windth=57)

dat_3 <- mutate(dat_3, text = text_cleaned)

as.tbl(dat_3, stringsAsFactor = FALSE)

# unnesting the token words

dat_4 <- dat_3 %>%
  unnest_tokens (word, text)

#adding the line numbers:

dat_4 <- dat_4 %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

  
# removing the stopwords: 

dat_4 <- dat_4 %>% 
  anti_join(get_stopwords(language = "it", source= "snowball")) 

new_stops <- c("eâ", "lâ", "â")

dat_4 <- str_remove(dat_4, new_stops)

dat_4 %>%
  count(word, sort = TRUE) 

install.packages("wordcloud")
library(wordcloud)

dat_4 %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 200))

write.csv(dat_4, file = here::here("libero.csv"))

