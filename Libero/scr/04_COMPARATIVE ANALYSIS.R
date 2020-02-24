# COMPARATIVE ANALYSIS 
source(here::here("Libero/scr","00_setup.R"))

load(here::here("Libero/data/recoded_data/comparative_dataset.Rdata"))

#Creating corpus 
comparative_corp <- corpus(
  comparative_dataset)

summary(comparative_corp)

#creating dfm
newspapers_dtm <- dfm(
  comparative_corp,
  group = "newspaper")

#KEYNESS 
#this is a kind of statistic which refers to the importance of a word in a specific context:
#it says if a word is a key-word in a document

head(
  textstat_keyness(newspapers_dtm),
  n = 10)

#PLOT
textplot_keyness(
  textstat_keyness(newspapers_dtm))


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

SECTIONS <- filter(comparative_dataset, section == "esteri" | section =="cronache" | section=="politica"| section=="economia" | section== "la-lettura" | section== "scuola") 

#Creating corpus 
corp1 <- corpus(
  SECTIONS)



sections_dtm <- dfm(
  corp1,
  group = "section")

#cosine similarity: it is a measure of similarity between two texts, based on the angolar distance between two vectors
cos_sim1 <- sections_dtm %>%
  textstat_simil(method = "cosine",
                 margin = "documents")



#jaccard, extended jaccard: it is a measure of similarity based on the number of words in common at regard of the
#total number of words
jac_sim1 <- sections_dtm %>%
  textstat_simil(method = "jaccard",
                 margin = "documents") 
jac_sim
