source(here::here("src","00_setup.R"))


# SENTIMENT ANALYSIS 
# Read file and find the nodes
opeNER_xml <- read_xml("./IlCorriereDellaSera/dictionary/it-sentiment_lexicon.lmf.xml")
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


# opeNER_df --------
# Fix a mistake (join "nneutral" and "neutral")
opeNER_df$polarity <- ifelse(opeNER_df$polarity == "nneutral", 
                             "neutral", opeNER_df$polarity)

# Make quanteda dictionary 
opeNER_dict <- quanteda::dictionary(with(opeNER_df, split(lemma, polarity)))

# Saving it locally
write.csv(opeNER_df, file = here::here("dictionary","opeNER_df.csv"))

# Importing dictionary 
opeNER <- rio::import("./IlCorriereDellaSera/dictionary/opeNER_df.csv")
head(opeNER)

# deleting words without polarity
table(opeNER$polarity, useNA = "always")     
opeNER <- opeNER %>%                       #obs change 25098 - 25053
  filter(polarity != "")

# DEPECHE MOOD --------
# importing Depeche Mood dictionary: 
dpm <- rio::import("./IlCorriereDellaSera/dictionary/DepecheMood_italian_token_full.tsv")
head(dpm)


# Creare dizionario dal lessico opeNER
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity)
)
lengths(opeNERdict)


#ANALYSIS ----

#importing dataset with the text of the article as character
rio::import("./IlCorriereDellaSera/data/datcharacter.Rdata")

#create the a dataset with only two variables: section and text 
data_sentiment <-  datcharacter %>% 
  select(section, text) %>% 
  filter(!is.na(section))

#looking at the number of articles divided for sections
table(datcharacter$section)

#selecting interesting section
data_sentiment <- subset(data_sentiment, section == "esteri" | section =="cronache" | section=="politica"| section=="economia" | section== "la-lettura" | section== "scuola") 

data_sentiment

save(data_sentiment, file = here::here("./IlCorriereDellaSera/data/datasentiment.Rdata"))

#creating the corpus
crp <- quanteda::corpus (
  data_sentiment
  )

crp

#creating dfm that allows us to arrange documents on the basis of the document's variables
crp_sentiment <- dfm(
  crp,
  tolower = T,
  dictionary = opeNERdict
) %>%
  dfm_group(
    group = "section"
  )

head(crp_sentiment)

#the graph showing 
quanteda::convert(crp_sentiment,
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




## SENTIMENT WITH CONTINOUS CATEGORIES: analysis of the emotions---------------------------------------------------
# Creating vectors for each categories of the DPM, each is weighted:
# saving the words from DPM in a vector: 
dpm_words <- dpm$V1

# Creating vectors for each categories of the DPM, each is weighted:
# 1. Indignato / Outrage: 
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
corriere_sent_dpm <- dfm(
  crp,
  tolower = T,
  select = dpm_words,
  groups = "section"
)

corriere_sent_dpm

# 1. Indignato
corriere_sent_ind <- corriere_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_ind) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Indignato = ".") %>%
  rownames_to_column("section")

# 2. Preoccupato
corriere_sent_pre <-  corriere_sent_dpm  %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_pre) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Preoccupato = ".")

# 3. Triste
corriere_sent_sad <-  corriere_sent_dpm  %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sad) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Triste = ".")

# 4. Divertito
corriere_sent_div <- corriere_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_div) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Divertito = ".")

# 5. Soddisfatto
corriere_sent_sat <- corriere_sent_dpm %>%
  dfm_weight(scheme = "prop") %>%
  dfm_weight(weights = dpm_sat) %>%
  rowSums() %>%
  as.data.frame() %>%
  rename(Soddisfatto = ".")

# unisco: 
corriere_sent_emo <- bind_cols(
  corriere_sent_ind, corriere_sent_pre, corriere_sent_sad, corriere_sent_div, corriere_sent_sat
)
corriere_sent_emo

# GRAPHS FOR EMOTIONS: 
# for each sections:
corriere_sent_emo %>%
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

corriere_sent_emo %>%
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
