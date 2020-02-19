# **Capstone Project - Giannuzzi, Ragazzi, Ruta** 
# *The use of words in newspapers* 

## Introduction
This is the repository for the final assingment of the course Data Access and Regulation, module II. We are three students from the University of Milan enrolled in a two year MA in Data Analytics (for short, DAPS&CO). 
During this course we learned how to scrape data from HTTP web pages and we had an introduction in text analysis and sentiment analysis. 
The main goal of our project is both to apply the knowledge we learned in the seminar but also to go behind them, trying to use some new packages and functions. This way we will test our capability to *self-learning*.  

## The research question 
The starting point of our research is the idea that newspapers which position themselves in diverse political areas tend to structure their homepages in different ways. On the basis of this idea we decided to scrape three italian newspapers and to conduct both a text and a sentiment analysis in order to discover (?) whether the political orientation influences the content of the articles, in particular the words used to discuss events and facts.

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
 5. Reporting the results in a meaningful way

## Team's organization
Each one of us partecipied to all the phases of the project because we decided to not assign specific task to a single member of the team. Each member in fact was assigned to one of the three newspaper. 
This decision depends on two main reasons:
1. All of us were interested in improving and testing our skills in all the phases of the project; 
2. Each newspaper required different css in the scraping part and different manipulation to the data to obtain a clear dataset. 

## Repository structure 
We created **three brench** so everyone can conduct analysis without creating conflict and then compare what we obtained in order to choose the best way to achieve the same goal:
 - **brench_ric**: it contains the part about *La Repubblica*;
 - **brench_sof**: it contains the part about *Libero*;
 - **brench_fab**: it contains the part about *Il Corriere della sera*. 
 
 Each brench is organized in four folders:
  - **data**: is the folder in which are stored the html pages that we scraped, the links of the articles (contained in a specific folder that each one created in its script) and the dataset; 
  - **junk**;
  - **src/script**: is the folder in which we saved the script. In general we created three script for each newspaper:
                    1. *00_setup*: it is about the packages used;
                    2. *01_scraping*: it is about the scraping;
                    3. *02_analysis*: it is about the analysis;
   - **fig**: is the folder in which the graphs are saved in a png format. 



The team
