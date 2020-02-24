##SENTIMENT ANALYSIS

#install and call packages
source(here::here("script","00_setup.R"))


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
  stringsAsFactors = F)

# Fix a mistake
opeNER_df$polarity <- ifelse(opeNER_df$polarity == "nneutral", 
                             "neutral", opeNER_df$polarity)

# Make quanteda dictionary 
opeNER_dict <- quanteda::dictionary(with(opeNER_df, split(lemma, polarity)))

# Saving it locally
write.csv(opeNER_df, file = here::here("dictionary","opeNER_df.csv"))

# Import it
opeNER <- rio::import("./dictionary/opeNER_df.csv")
head(opeNER)

# Words without polarity
table(opeNER$polarity, useNA = "always")
opeNER <- opeNER %>%
  filter(polarity != "")

# Depeche Mood
dpm <- rio::import("./dictionary/DepecheMood_italian_token_full.tsv")
head(dpm)

# Sentiment----------------------------------------------------
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity)
)
lengths(opeNERdict)

# import dataset-------
load(here::here("data/articoli_repubblica_17_02_2020.Rdata"))

# remove double links-------------
dataset_pulito <- unique (dat_definitivo)

# "text" column transformed from factor to character---------------
text_cleaned <- sapply(dataset_pulito$text, toString, windth=57)

# replaced into "dataset_pulito"--------
dataset_pulito <- mutate(dataset_pulito, text = text_cleaned)

# create a dataset with the text (as character) and the section(filtered)-----
data_sentiment <-  dataset_pulito %>% 
  select(section, text) %>% 
  filter(!is.na(section))

table(dataset_pulito$section)

data_sentiment <- subset (data_sentiment, section == "cronaca" | section =="salute" | section=="esteri"| section=="politica") 


# create the corpus for the sentiment analysis----
crp_sent <- corpus(
  data_sentiment)

# create the DFM for the sentiement analysis----
rep_dtm1 <- dfm(
  crp_sent,
  tolower = T,
  dictionary = opeNERdict
) %>%
  dfm_group(
    group = "section")

head(rep_dtm1)

# SENTIMENT GRAPH, for each of the 4 sections------------
quanteda::convert(rep_dtm1,
                  to = "data.frame") %>%
  rename(section = document) %>%
  gather(var, val, -section) %>%
  group_by(section) %>%
  mutate(
    val = val/sum(val)) %>%
  ggplot(., aes(x = var, y = val)) +
  geom_bar(aes(fill = section), 
           stat = "identity", alpha = 0.5) +
  facet_wrap(~section, ncol = 3) +
  scale_y_continuous(labels = scales::percent) +
  theme_bw()

# SENTIMENT GRAPH for the whole dataset------
quanteda::convert(rep_dtm1,
                  to = "data.frame") %>%
  rename(section = document) %>%
  mutate(
    polar = (positive - negative)/(positive + negative)
  ) %>%
  ggplot(., aes(y = reorder(section, polar), x = polar)) +
  geom_point() +
  ylab("") +
  xlab("Polarity sentiment\n(from negative to positive)") +
  theme_bw()

## SENTIMENT WITH CONTINOUS CATEGORIES-----------------
# analysis of the emotions
# Creating vectors for each categories of the DPM, each is weighted
# saving the words from DPM in a vector
dpm_words <- dpm$V1

# Creating vectors for each categories of the DPM, each is weighted-----

# 1 Indignato / Outrage----
dpm_ind <- dpm$INDIGNATO
names(dpm_ind) <- dpm_words

# 2 Preoccupato / Worried----
dpm_pre <- dpm$PREOCCUPATO
names(dpm_pre) <- dpm_words

# 3 Triste / Sad----
dpm_sad <- dpm$TRISTE
names(dpm_sad) <- dpm_words

# 4 Divertito / Entertained----
dpm_div <- dpm$DIVERTITO
names(dpm_div) <- dpm_words

# 5 Soddisfatto / Pleased----
dpm_sat <- dpm$SODDISFATTO
names(dpm_sat) <- dpm_words

# creating a DFM
rep_sent_dpm <- dfm(
  crp_sent,
  tolower = T,
  select = dpm_words,
  groups = "section")

# 1 Indignato----
rep_sent_ind <- rep_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_ind) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Indignato = ".") %>%
  rownames_to_column("section")

# 2 Preoccupato----
rep_sent_pre <- rep_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_pre) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Preoccupato = ".")

# 3 Triste----
rep_sent_sad <- rep_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sad) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Triste = ".")

# 4 Divertito----
rep_sent_div <- rep_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_div) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Divertito = ".")

# 5 Soddisfatto----
rep_sent_sat <- rep_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sat) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Soddisfatto = ".")

# Merge 
rep_sent_emo <- bind_cols(
  rep_sent_ind, rep_sent_pre, rep_sent_sad, rep_sent_div, rep_sent_sat)

rep_sent_emo

# GRAPHS FOR EMOTIONS------------
# for each sections:
rep_sent_emo %>%
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

# emotions ranked
rep_sent_emo %>%
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
