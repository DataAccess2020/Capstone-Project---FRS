# Capstone project: team FRS

# This script includes the text analysis on the articles scraped from "Libero Quotidiano":
# - unnesting the token words;
# - adding the line numbers;
# - removing the stopwords;
# - saving the clean and vectorized dataset in csv --> libero.csv
# - creating a dataset with only the words (libero_words)
# - analysis of the most frequent words (in the whole dataset and by sections);
# - wordclouds of the frequencies;


# sourcing all the needed packages: ---------------------------------------------
source(here::here("scr","00_setup.R"))


# Unnesting the token words:-----------------------------

libero <- dat_character %>%
  unnest_tokens (word, text)

# Adding the line numbers:----------------------------------------

libero <- libero %>% 
  group_by(link) %>% 
  mutate(linenumber = row_number())

# Removing the stopwords: --------------------------------------

# Those are words that were probably not scraped in the right encoding. Since those are not usual italian stopwords, I'm deleting them manually: 
new_stops <- c("eâ", "lâ", "â", "â", "â")

libero <- libero %>% 
  anti_join(get_stopwords(language = "it", source= "stopwords-iso")) %>%
  anti_join(get_stopwords(language = "it", source= "snowball")) %>%
  filter(!str_detect(word, '\\d+')) %>%
  filter(!str_detect(word, '[[:punct:]]')) %>% 
  filter(!str_detect(word, new_stops)) 

# Saving this clean and vectorized dataset: 
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

# 1. Frequencies for the section "politica": -------------------------------------
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

# 2. Frequencies for the section "italia": --------------------------------------------
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

# 3. Frequencies for the section "esteri": -------------------------------------------
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 3.1 Wordcloud:
libero %>%
  filter(section  == "esteri") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 50))

# 4. Frequencies for the section "sfoglio": --------------------------------------
libero %>%
  filter(section  == "sfoglio") %>%
  ungroup() %>%
  count(word, sort = TRUE) 
# 4.1 Wordcloud:
libero %>%
  filter(section  == "sfoglio") %>%
  ungroup() %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

#____________________________________________________________

# maybe sentiment?

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

write.csv(opeNER_df, file = here::here("opeNER_df.csv"))


#################################################

corpus <- corpus(dat_3$text)

summary(corpus)

dfm <- dfm(corpus)

freq <- textstat_frequency(dfm, n = 30)

ggplot(data = freq) +
  geom_point(aes(x = reorder(feature, frequency), y = frequency)) +
  coord_flip() +
  labs(x = NULL, y = "Frequency", title = "Descriptive frequencies") +
  theme_bw()

inaug_lx <- dfm(corpus, 
                what = 'word', 
                tolower = TRUE, 
                stem = FALSE,
                remove_numbers = TRUE,
                remove_punct = TRUE,
                remove_separators = TRUE,
                remove_url = TRUE,
                ngrams = 1, 
                dictionary = opeNER_dict)   # <--- Note this line!

inaug_lx_trim <- dfm_trim(inaug_lx, 
                          termfreq_type = "prop",
                          min_termfreq = 0.05,
                          min_docfreq = 3)

as_tibble(inaug_lx_trim) %>% 
  mutate(share_pos = positive / (negative + positive) * 100) %>% 
  ggplot(aes(x= inaug_lx_trim, y = share_pos)) + 
  geom_point() +
  geom_smooth(method = "loess", ) + 
  labs(x = "Year", y = "Share of positive terms", title = "Sentiment US inaugural speeches") +
  theme_bw()


inaug_lx_trim <- dfm_trim(inaug_lx, 
                          termfreq_type = "prop",
                          min_termfreq = 0.05,
                          min_docfreq = 3)






dfm_lookup(dfm, dictionary =  opeNER_dict, valuetype = "glob")


myDfm <- dfm(dfm, dictionary = opeNER_dict)
myDfm
dfm_lookup(myDfm, dictionary =  opeNER_dict, valuetype = "glob")


