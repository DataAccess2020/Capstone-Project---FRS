# COMPARATIVE ANALYSIS 
source(here::here("src","00_setup.R"))

#RIC DATASET ------
#converting text of dataset ric to character 
datset_pulito <- unique (dat_definitivo)
text_cleaned <- sapply(datset_pulito$text, toString, width = 57)
datset_pulito <- mutate(datset_pulito, text = text_cleaned)

#adding "newspaper" variable
newspaper <- rep ("La Repubblica", length = 19)
datset_pulito <-mutate(datset_pulito, newspaper)

#FAB DATASET -----
#Adding a variable to identify the newspaper 
newspaper <- rep ("Il Corriere della Sera", length = 30)
datcharacter <- mutate(datcharacter, newspaper)

save(datcharacter, file = here::here("/data/datcharacter1.Rdata"))


#SOF DATASET ----
newspaper <- rep ("Libero", length = 63)
dat_character <- mutate(dat_character, newspaper)

save(dat_character, file = here::here ("./data/sofdataset.Rdata"))



# Merging dataset --------
NEWSPAPERS <- full_join(
  datset_pulito,
  rio::import ("./data/datcharacter1.Rdata")
)

NEWSPAPERS <- full_join(
  NEWSPAPERS,
  rio::import ("./data/sofdataset.Rdata")
)


#Creating corpus 
corp <- corpus(
  NEWSPAPERS
)

summary(corp)

#creating dfm
newspapers_dtm <- dfm(
  corp,
  group = "newspaper")

#
#this is a kind of statistic which refers to the importance of a word in a specific context: it says if a word is a 
#key-word in a document

head(
  textstat_keyness(newspapers_dtm,
                   target = "Il Corriere della Sera"),
  n = 10
)

#PLOT
textplot_keyness(
  textstat_keyness(newspapers_dtm,
                   target = "Il Corriere della Sera")
)


#SIMILARITY BETWEEN TEXT -----------

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
