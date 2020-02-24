#                                           *The use of words in newspapers* 

## *Brench_fab*: the structure
This is the brench in which the articles of *Il Corriere della Sera* are scraped and analysed. In this file will be provided some information about the folders and the file within them. 

## DATA
This folder contains:
- the homepage of *Il Corriere della Sera* (17/02) saved into an html page: **Ilcorrieredellasera1702.html**; 
- The folder **ARTICLES** in which the html pages of each article are stored; 
- the saved dataset. 

##### Dataset 
There are three dataset:

**dat**: it is the starting dataset, created after the scraping part of my analysis. It is composed by:
- 30 observation (the articles published on the homepage on February 17);
- 3 variables: 
  1) Link;
  2) Articlestext; 
  3) Section;
- This dataset can be opened going to the folder **data** and then opening the file **Corrierearticles1702.Rdata**. 

**datcharacter**: it is the dataset in which the text of the articles is saved as character. 

**dat3**: it is the dataset in which the variable *"word"* is added. It presents 4 variables and 8440 observation. 
- This dataset was obtained in two steps:
  1) The first step is what we call *vectorization*: using the command **unnest_token** I divided the entire articles in single words. This way, I obtained a dataset with 18920 observations;
  2) The second step is about the *pre-processing*: I removed from the observations what was unusful for the analysis. This way I obtained *dat3*; 
- This dataset can be opened going to the folder **data** and then opening the file **IlCorriereDellaSera.Rdata**.

**corriere_words**: it is the dataset that contains only the words. 
- It is constituted by one variable and 8440 observations;
- This dataset can be opened going to the folder **data** and then opening the file **IlCorriereDellaSeraWORDS.Rdata**

**data_sentimet**: it is the dataset used to conduct both sentiment and emotional analysis. 

## **SRC**
This folder contains the scripts:
1. **00_setup**: it is the script containing all the used packages and the library of them; 
2. **01_scraping**: it is the script which contains the scraping part;
3. **02_textanalysis**: it is the script that contains 
   - the part of *tokenization* and *pre-processing*;
   - the part about *word frequencies* 
4. **03_sentiment**: it is the script containg the sentiment analysis. 

## **JUNK**
This folder contains all the things I didn't want to delate:
- **03_quantedatextanalysis**: it is a script in which I was sperimenting a new package for the text analysis; 
- **Scriptcorriere** and **Scriptcorrierebozza** which are the first script I used; they are a sort of draft. 

## **DICTIONARY** 
This folder contains the two dictionaries used to conduct the sentiment analysis:
- *DepecheMood_italian_token_full*: it is an emotive lexic with five different emotions (indignation, worry, sad, happy, satisfied);
- *opeNER_df*: it is a lexic with positive, negative and neutral sentiment; 

## **FIG**
This folder contains the graphs with descriptive names. 



