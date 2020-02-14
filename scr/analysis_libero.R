library(tidytext)

text_df %>%
  unnest_tokens(word, text)

libero_cleaned <- dat_sort %>%
  select(articles) %>% 
  unnest_tokens(word, articles)