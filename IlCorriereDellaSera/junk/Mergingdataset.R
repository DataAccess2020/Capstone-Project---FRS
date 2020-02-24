# MERGING DATASET -> NOT REPRODUCIBLE 

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
