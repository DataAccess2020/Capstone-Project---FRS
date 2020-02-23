# Capstone project: team FRS

# This script includes the sentiment and emotional analysis on the articles scraped from "Libero Quotidiano":
# - downloading and saving the sentiement dictionary; --> opeNER_df.csv
# - importing the "depeche mood" dictionary; --> DepecheMood_italian_token_full.tsv
# - Sentiment analysis: 
#    - creating the dataset with only the 4 sections I need;
#    - creating the corpus;
#    - creating the DFM;
# - Sentiment graphs: for each of the 4 sections and for the whole dataset;
# - Emotion analysis: 




# sourcing the packages: 
source(here::here("scr","00_setup.R"))

library(hunspell)


# Dictionary 1: -----------------------------------------------------
# Read file and find the nodes
opeNER_xml <- read_xml("./dictionary/it-sentiment_lexicon.lmf.xml")
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

# Make quanteda dictionary: 
opeNER_dict <- quanteda::dictionary(with(opeNER_df, split(lemma, polarity)))

# Saving it locally: 
write.csv(opeNER_df, file = here::here("opeNER_df.csv"))

# Import it: 
opeNER <- rio::import("./dictionary/opeNER_df.csv")
head(opeNER)

# Words without polarity: 
table(opeNER$polarity, useNA = "always")
opeNER <- opeNER %>%
  filter(polarity != "")

# Depeche Mood: 
dpm <- rio::import("./dictionary/DepecheMood_italian_token_full.tsv")
head(dpm)

# Sentiment: -----------------------------------------------------
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity)
)
lengths(opeNERdict)

# create the a dataset with the text (as character) and the section(filtered)
data_sentiment <-  dat_character %>% 
  select(section, text) %>% 
  filter(!is.na(section))

table(dat_character$section)
data_sentiment <- subset (data_sentiment, section == "esteri" | section =="italia" | section=="politica"| section=="sfoglio") 


# create the corpus for the sentiment analysis: 
crp_prova <- corpus(
  data_sentiment
)

# create the DFM for the sentiment analysis: 
libero_dtm1 <- dfm(
  crp_prova,
  tolower = T,
  dictionary = opeNERdict
) %>%
  dfm_group(
    group = "section"
  )
head(libero_dtm1)

# SENTIMENT GRAPH, for each of the 4 sections: ---------------------------------------------------
quanteda::convert(libero_dtm1,
                  to = "data.frame") %>%
  rename(section = document) %>%
  gather(var, val, -section) %>%
  group_by(section) %>%
  mutate(
    val = val/sum(val)
  ) %>%
  ggplot(., aes(x = var, y = val)) +
  geom_bar(aes(fill = section), 
           stat = "identity", alpha = 0.5) +
  facet_wrap(~section, ncol = 3) +
  scale_y_continuous(labels = scales::percent) +
  theme_bw()

# SENTIMENT GRAPH for the whole dataset: ------------------------------------------------------------
quanteda::convert(libero_dtm1,
                  to = "data.frame") %>%
  rename(section = document) %>%
  mutate(
    polar = (positive - negative)/(positive + negative)
  ) %>%
  ggplot(., aes(y = reorder(section, polar), x = polar)) +
  geom_point() +
  ylab("") +
  xlab("Polarità sentiment\n(da negativo a positivo)") +
  theme_bw()

## SENTIMENT WITH CONTINOUS CATEGORIES: analysis of the emotions---------------------------------------------------
# Creating vectors for each categories of the DPM, each is weighted:
# saving the words from DPM in a vector: 
dpm_words <- dpm$V1

# Creating vectors for each categories of the DPM, each is weighted:
# 1. Indignato / Outraged: 
dpm_ind <- dpm$INDIGNATO
names(dpm_ind) <- dpm_words

# 2. Preoccupato / Worried:
dpm_pre <- dpm$PREOCCUPATO
names(dpm_pre) <- dpm_words

# 3. Triste / Sad: 
dpm_sad <- dpm$TRISTE
names(dpm_sad) <- dpm_words

# 4. Divertito / Entertained: 
dpm_div <- dpm$DIVERTITO
names(dpm_div) <- dpm_words

# 5. Soddisfatto / Pleased: 
dpm_sat <- dpm$SODDISFATTO
names(dpm_sat) <- dpm_words

# creating a DFM: 
libero_sent_dpm <- dfm(
  crp_prova,
  tolower = T,
  select = dpm_words,
  groups = "section"
)
libero_sent_dpm

# 1. Indignato
libero_sent_ind <- libero_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_ind) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Indignato = ".") %>%
  rownames_to_column("section")

# 2. Preoccupato
libero_sent_pre <- libero_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_pre) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Preoccupato = ".")

# 3. Triste
libero_sent_sad <- libero_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sad) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Triste = ".")

# 4. Divertito
libero_sent_div <- libero_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_div) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Divertito = ".")

# 5. Soddisfatto
libero_sent_sat <- libero_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sat) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Soddisfatto = ".")

# unisco: 
libero_sent_emo <- bind_cols(
  libero_sent_ind, libero_sent_pre, libero_sent_sad, libero_sent_div, libero_sent_sat
)
libero_sent_emo

# GRAPHS FOR EMOTIONS: 
# for each sections:
libero_sent_emo %>%
  gather(var, val, -section) %>%
  ggplot(., aes(x = reorder_within(var, val, section), y = val)) +
  geom_bar(aes(fill = section),
           stat = "identity", 
           col = "black", alpha = 0.5) +
  facet_wrap(~section, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::percent) +
  scale_x_reordered() +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "bottom")

# emotions ranked: 

libero_sent_emo %>%
  gather(var, val, -section) %>%
  ggplot(., aes(x = reorder_within(section, val, var), y = val)) +
  geom_bar(aes(fill = var),
           stat = "identity", 
           col = "black", alpha = 0.5) +
  facet_wrap(~var, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::percent) +
  scale_x_reordered() +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "bottom")





