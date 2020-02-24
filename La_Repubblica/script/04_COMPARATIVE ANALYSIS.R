# COMPARATIVE ANALYSIS 
source(here::here("script","00_setup.R"))

load(here::here("data/comparative_dataset.Rdata"))

#Creating corpus 
comparative_corp <- corpus(
  comparative_dataset)

summary(comparative_corp)

#creating dfm
newspapers_dtm <- dfm(
  comparative_corp,
  group = "newspaper")

# SIMILARITY BETWEEN NEWSPAPERS-------

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

# sentiment----

opeNER <- rio::import("C:/Users/Riccardo/Desktop/git repo/CAPSTONE/Capstone-Project---FRS/La_Repubblica/dictionary/opeNER_df.csv")
head(opeNER)
opeNERdict <- quanteda::dictionary(
  split(opeNER$lemma, opeNER$polarity))

news_dtm <- dfm(
  comparative_corp,
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

