#Analysis: 

library(tidytext) library(tidyr)
library(tokenizers)
library(SnowballC)

text_cleaned <- sapply(dat_3$text, toString, windth=57)

dat_3 <- mutate(dat_3, text = text_cleaned)

as.tbl(dat_3, stringsAsFactor = FALSE)

dat <- select(dat, text, link, section)

word <- vector (mode = "character")

dat_4 <- dat_3 %>%
  unnest_tokens (word, text)

dat_4 <- dat_4 %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())
  