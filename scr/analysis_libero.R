library(tidytext)

text_df %>%
  unnest_tokens(word, text)

libero_cleaned <- dat_3 %>%
  select(sapply.dat_sort.articles..toString..windth...57.) %>% 
  unnest_tokens(word, sapply.dat_sort.articles..toString..windth...57.)

dat_3

text_df <- mutate(dat_2, text = articles$articles)
