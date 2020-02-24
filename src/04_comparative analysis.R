# COMPARATIVE ANALYSIS 
source(here::here("src","00_setup.R"))

#Loading the dataset which contains data about all our three newspapers. 
load(here::here("./data/comparative_dataset.Rdata"))

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



#WORKING WITH SECTIONS

SECTIONS <- filter(NEWSPAPERS, section == "esteri" | section =="cronache" | section=="politica"| section=="economia" | section== "la-lettura" | section== "scuola") 

#Creating corpus 
corp1 <- corpus(
  SECTIONS
)

summary(corp)

sections_dtm <- dfm(
  corp1,
  group = "section")

#cosine similarity: it is a measure of similarity between two texts, based on the angolar distance between two vectors
cos_sim1 <- sections_dtm %>%
  textstat_simil(method = "cosine",
                 margin = "documents")

cos_sim1

#jaccard, extended jaccard: it is a measure of similarity based on the number of words in common at regard of the
#total number of words
jac_sim1 <- sections_dtm %>%
  textstat_simil(method = "jaccard",
                 margin = "documents") 
jac_sim1


quanteda::convert(newspapers_dtm,
                  to = "data.frame") %>%
  rename(section = document) %>%
  gather(var, val, -newspaper) %>%
  group_by(newspaper) %>%
  mutate(
    val = val/sum(val)
  ) %>%
  ggplot(., aes(x = var, y = val)) +
  geom_bar(aes(fill = newspaper), 
           stat = "identity", alpha = 0.5) +
  facet_wrap(~newspaper, ncol = 3) +
  scale_y_continuous(labels = scales::percent) +
  theme_bw()

