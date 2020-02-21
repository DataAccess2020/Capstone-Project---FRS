#                                           *The use of words in newspapers* 

## *Brench_fab*
This is the brench in which the articles of *Il Corriere della Sera* are scraped and analysed. 

## Structure


## Dataset 
In this brench there are three main dataset:

- *dat*: it is the starting dataset, created after the scraping part of my analysis. It is composed by:

         - 30 observation (the articles published on the homepage on February 17);
         - 3 variables: 
           1) Link;
           2) Articlestext; 
           3) Section;
         - This dataset can be opened going to the folder **data** and then opening the file **Corrierearticles1702.Rdata**. 
           
- *dat3*: it is the dataset in which the variable *"word"* is added. It presents 4 variables and 8440 observation. 
This dataset was obtained in two steps:

         1) The first step is what we call *vectorization*: using the command **unnest_token** I divided the entire articles in single words. This way, I obtained a dataset with 18920 observations;
         2) The second step is about the *pre-processing*: I removed from the observations what was unusful for the analysis. This way I obtained *dat3*; 



--------------------------------------
## Introduction
This is the repository for the final assingment of the course Data Access and Regulation, module II. We are three students from the University of Milan enrolled in a two year MA in Data Analytics (for short, DAPS&CO). 
During this course we learned how to scrape data from HTTP web pages and we had an introduction on text and sentiment analysis. 
The main goal for this project is to apply the scraping knowledge that we learned in the seminar and to go behind it, trying to use some new packages and functions. This way we will test our ability to *self-learn*.  

## The research question 
The starting point of our research is the idea that newspapers which position themselves in diverse political areas tend to structure their homepages in different ways. From this we decided to scrape 3 italian newspapers and to conduct on each a text and a sentiment analysis in order to discover whether the political orientation influences the content of the articles, in particular the words used to discuss events and facts.

The three newspapers are:
 - *Libero* (dx);
 - *Il corriere della sera* (cx);
 - *La Repubblica* (sx).

## Steps: 
We can define five different steps in which our project is divided: 
 1. Scraping
 2. Pre-processing the obtained data
 3. Text-analysis
 4. Sentiment analysis
 5. Reporting of the results in a meaningful way

## Team's organization:
Each one of us partecipied in all the phases of the project, since we decided it would be best to not assign a specific task to a single member. But in general, to each member was assigned a newspaper. 
This decision depends on two main reasons:
1. All of us were interested in improving and testing our skills in all the differentn phases of the project; 
2. Each newspaper required different css in the scraping part and different manipulation of the data in order to obtain a clear dataset. 

## Repository structure: 
We created **three brench** so everyone could conduct analysis without creating conflicts:
 - **branch_ric**: it contains the part about *La Repubblica*;
 - **branch_sof**: it contains the part about *Libero Quotidiano*;
 - **branch_fab**: it contains the part about *Il Corriere della Sera*. 
 
 ## Folders structure: 
 Each branch is organized in four folders:
  - **data**: is the folder in which are stored the html pages that we scraped, the links of the articles (contained in a specific folder that each one created in its script) and the dataset; 
  - **junk**;
  - **src/script**: is the folder in which we saved the script. In general we created three script for each newspaper:
                    1. *00_setup*: it is about the packages used;
                    2. *01_scraping*: it is about the scraping;
                    3. *02_analysis*: it is about the analysis;
   - **fig**: is the folder in which the graphs are saved in a png format;
   - **dictionary**: it contains the dictionaries for the sentiment analysis. 



The team
