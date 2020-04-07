# Master Thesis - Political Polarization in 2016 US Election

## About

* Exploring the effect of Trump's comments toward controversial issues, including race, immigration and gender, on public opinion and mass political polarization on social media during 2016 US presidential campaign.



## Data

* FB Data
* Hate Crime Data


## Method

## Estimating ideology score

* Extract every pages a single user likes from raw data (SQL) [code](code/SQL/1000_pages_politician_user_like_pages.sql)
* Create page-by-page matrix (python) 
* Use SVD and take the first component variation as the estimation of pages' ideology score, setting liberals at left. (python)
* Using page ideology score to calculate users' ideology score (python)
* Dynamic: Calculate ideology every week using data in 4 weeks (eg. For 2015-05-24~2015-05-30, we use data from 2015-05-03)
* [Code](code/python/ideology_score)

## Estimating index of ideology segregation

* Mean ideology difference:  Using user's ideology distance between two president candidates to define their preference, a user will be defined to be a candidate's supporter if his/her ideology score is closer to him/her. Then we calculate the ideology mean of Trump and Clinton's supporters, and obtain mean ideology difference as an estimation of political polarization.
* Right/Left-Wing extremist: The proportion/total of extremist, whose ideology is out of 2 standard deviation/the most extreme 5%/10%.
* Standard deviation of ideology.
* [Code](code/python/ideology_difference)
* [Plot](plot)

## Event Selection

* We use media volume to determine which event to use.
* Pages: Top 10 pages in each category(TV/radio/website/newspaper/magazine)
* Method: We first use keyword searching to select issue-related posts, then observe the trend of media volume among these pages, selecting events which induce the largest media volume.

## Posts Selection

* Our data includes posts on all US politician fan pages, top 1000 pages talking about Trump and Clinton, and other related pages.
* We mainly select posts related to immigrants, mexican, muslim, black, race, abortion and access hollywood tape.
* Methods: CNN Classifier
* [Code](code/python/posts)

## Post Analysis

* Sentiment Classification: Mainly uses CNN Classifier

## Page Analysis

*

## Comment Analysis

* Our data includes comments on all US politician fan pages and top 1000 pages talking about Trump and Clinton.
* We use the comments under our selected posts.
* Method: Clustering and text summarization using CNN as feature extractor.

## User Analysis (related to posts)

* Matching, Difference in difference, T-test.

## User Analysis (Trump and Clinton's followers)

* Track Trump and Clinton's followers' ideology time trend.

## Regression

*

## Hate Crime Analysis

* We combine hate crime data and Facebook data in order to connect political behavior on social media and real world behavior (crime activities) together.
* Time Trend: 2006~2017 monthly trend.
* Ideology segregation: Using our index of ideology segregation as independent variable to estimate the treatment effect of polarization on hate crime.
* Model: Panel Fixed-effect
* Sentiment:


## Programming Languages used

### [R](code/R)

* Data Visualization.
* Controling BigQuery.

### [Python](code/python)

* Data preprocessing
* Calculation of variables
* Analysis
* Ploting

### [SQL](code/SQL)

* Data Cleaning
* Merging/concatenating data or extracting variables while data is large


## Reference





