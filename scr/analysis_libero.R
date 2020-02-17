#Analysis: 

library(tidytext) library(tidyr)
library(tokenizers)
library(SnowballC)

libero_cleaned <- dat_3 %>%
  unnest_tokens(word, sapply.dat_sort.articles..toString..windth...57.)


# try

word <- vector (mode = "character")

test_df<-tokenize_words(as.character(dat_3$text))
test_df <- unlist(test_df)
test_df

test_df <- tibble(line = 1:63, text = text)
