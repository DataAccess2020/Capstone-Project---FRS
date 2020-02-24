# COMPARATIVE ANALYSIS 
source(here::here("src","00_setup.R"))

#Loading the dataset which contains data about all our three newspapers. 
load(here::here("./IlCorriereDellaSera/data/comparative_dataset.Rdata"))

comparative_dataset        #It has four variables: link, section, text, newspaper

#changing the name of the dataset 
NEWSPAPERS <- comparative_dataset

#Creating corpus 
corp <- corpus(
  NEWSPAPERS
)

summary(corp)

#creating dfm
newspapers_dtm <- dfm(
  corp,
  group = "newspaper")

#SIMILARITY BETWEEN NEWSPAPERS' TEXT-----------

#cosine similarity: it is a measure of similarity between two texts, based on the angolar distance between two vectors
cos_sim <- newspapers_dtm %>%
  textstat_simil(method = "cosine",
                 margin = "documents")

cos_sim

#jaccard, extended jaccard: it is a measure of similarity based on the number of words in common at regard of the
#total number of words
jac_sim <- newspapers_dtm %>%
  textstat_simil(method = "jaccard",
                 margin = "documents") 
jac_sim


#comparison of sentiment analysis for the three newspapers --------

# CREATING OPENER
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


# opeNER_df --------
# Fix a mistake (join "nneutral" and "neutral")
opeNER_df$polarity <- ifelse(opeNER_df$polarity == "nneutral", 
                             "neutral", opeNER_df$polarity)

# Make quanteda dictionary 
opeNER_dict <- quanteda::dictionary(with(opeNER_df, split(lemma, polarity)))

# Saving it locally
write.csv(opeNER_df, file = here::here("dictionary","opeNER_df.csv"))

# Importing dictionary 
opeNER <- rio::import("./dictionary/opeNER_df.csv")
head(opeNER)

# deleting words without polarity
table(opeNER$polarity, useNA = "always")     
opeNER <- opeNER %>%                       #obs change 25098 - 25053
  filter(polarity != "")

#SENTIMENT GRAPH ---------

# Creare dizionario dal lessico opeNER
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity)
)
lengths(opeNERdict)

library(quanteda)

news_dtm <- dfm(
  corp,
  tolower = T,
  dictionary = opeNERdict
) %>%
  dfm_group(
    group = "newspaper"
  )


head(news_dtm)


quanteda::convert(news_dtm,
                  to = "data.frame") %>%
  rename(newspaper = document) %>%
  mutate(
    polar = (positive - negative)/(positive + negative)
  ) %>%
  ggplot(., aes(y = reorder(newspaper, polar), x = polar)) +
  geom_point() +
  ylab("") +
  xlab("Polarità sentiment\n(da negativo a positivo)") +
  theme_bw()

