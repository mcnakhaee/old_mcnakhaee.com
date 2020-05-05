---
title: Analyzing the 2020 Democratic Presidential Debates - Part  2
author: Muhammad Chenariyan Nakhaee
date: '2020-03-08'
slug: []
categories:
  - NLP
  - Python
  - R
tags:
  - NLP
  - Python
  - R
  - social network analysis
subtitle: ''
summary: ''
authors: []
lastmod: '2020-03-08T00:10:58+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []

---

> ## Summary

It is not be possible for many of us to watch every 2020 Democratic Primary debate. Nevertheless, it is important for us to know what happened during a debate. In my case I usually read about debates in online newspapers or watch a highlight of a debate on Youtube. However, online newspapers and Youtube channels provide a short summary of a debate or just broadcast a portion of it that includes a heated exchange of opinions and attract attentions. This way many important issues raised by candidates are lik**ely being ignored and forgotten in the** aftermath of a debate. What if we can summarize the content of a debate in such a way that My goal from this analysis is to use data science techniques to explore the content of debates and give you a comprehensive summary of topics that were discussed by each candidate. This article describes how to I used natural language processing techniques to summarize the content of debates.

[In my last blog post](https://mcnakhaee.com/post/2020-02-23-the-most-eloeuent-democratic-candidate/), I explained that I had the three following goals in mind I study the 2020 Democratic  Debates from:

1. Determining the most eloquent presidential candidate.
2. Sentiment analysis of the transcripts to find out who used positive or most negative words on the stage.
3. Network analysis of the transcripts.

Also, I only discussed how I approached the first two aspects of my experiment. Now it is time to explore the third and last aspect by applying network analysis to the transcript. 

My aim from using  network analysis is to determine potential allies and enemies on the debate stage.  For example, [Elizabeth Warren mentioned Mike Bloomberg several times and attacked him harshly in the 9th debate](https://www.theguardian.com/us-news/2020/mar/04/mike-bloomberg-out-60-second-attack-elizabeth-warren-destroyed-campaign). During the same debate, [Amy  Klobuchar and Pete Buttigieg clashed bitterly with each other](https://www.independent.co.uk/news/world/americas/us-election/amy-klobuchar-pete-buttigieg-handshake-democratic-debate-video-a9348621.html). But  these two examples are just two instances of many other heated exchanges between the candidates.

> To make things more clear, I transformed my goal into two questions that I would like to answer:
>
> 1. How many times did a candidate address (mention) other candidates during a debate? 
> 2. How did he/she do it (in a friendly or unfriendly manner)?



A simple approach to answer these questions is to store the names of all candidates in a variable (for example a vector in R or a list in Python), iterate through the transcript,  measure the its sentiment , and count and store the number of times that a candidate's name was brought up by another candidate. 



However, adopting this solution is a little bit challenging and requires a lot of manual data pre-processing efforts.  For each democratic candidate, I had to compile a comprehensive list of possible ways that may be used to address that candidate.  As you can guess this solution seems to be a very time-consuming task. For example, Bernie Sanders might have been mentioned by other candidates in many different ways including Bernie, Bernie Sanders or Senator Sanders. 

I realized that I can use a different but smarter approach to extract the names of candidate from the transcript and still achieve my goal. Also, using this approach not only I can find candidates' names form the transcript, but also I can find the names of other politicians, individuals and even organization  and I can extend my analysis to them.

I used a very powerful technique from Natural Language Processing (NLP) literature called Names Entity Recognition (NER) to extract the name of candidates. 

I made use of both python and R in my analysis. My workflow includes the following steps:

1. I download the transcript of debates using this package (R). 
2. I use tidytext to tokenize the transcript by splitting into multiple sentences and also for sentiment analysis (R). 
3. I extract several pre-defined categories Named Entities from each sentence using Spacy.(Python)
4. I compute the sentiment of each sentence using TextBlob library (Python). 
5. I transferred the results to R for visualization. There, I visualize the network of mentions and entities using ggraph and ggplot library. 

### 3. Loading data

```{r message=FALSE, warning=FALSE}
library(demdebates2020)
library(tidytext)
library(tidyverse)
library(gghighlight)
library(ggthemes)
library(kableExtra)
library(reticulate)
```

```{r ,eval=FALSE}
head(debates) 
```


```{r echo=FALSE}
head(debates)  %>% 
kable() %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
```

### 2. Tokenization



### 3. Named Entity Recognition using Spacy

We need to install and import some python libraries.

```{python,eval=FALSE}
import pandas as pd
import spacy
from textblob import TextBlob
```


There are rows for both the candidates and the moderators who posed the questions to candidates in the transcript dataset. However, I am particularly interested in what the candidates said, so I only selected rows corresponding to the candidates.

```{python ,eval=FALSE}
candidates = debates[(debates['type'] == 'Candidate') & (pd.notnull(debates['speech']))  ]
```

We are ready to use Spacy and extract named entities. But to use Spacy’s NLP features such as NER, we first need to download and load a pre-trained language model for English.  There are [several English language models](https://spacy.io/usage/models) with different sizes available in Spacy but I used the largest language model available.

```{python,eval=FALSE}
nlp = spacy.load('en_core_web_lg')
```

Spacy's NER model is trained on the [OntoNotes 5](https://catalog.ldc.upenn.edu/LDC2013T19) corpus and it can detect several types of named entities including:

| TYPE          | DESCRIPTION                                          |
| ------------- | ---------------------------------------------------- |
| `PERSON`      | People, including fictional.                         |
| `NORP`        | Nationalities or religious or political groups.      |
| `FAC`         | Buildings, airports, highways, bridges, etc.         |
| `ORG`         | Companies, agencies, institutions, etc.              |
| `GPE`         | Countries, cities, states.                           |
| `LOC`         | Non-GPE locations, mountain ranges, bodies of water. |
| `PRODUCT`     | Objects, vehicles, foods, etc. (Not services.)       |
| `EVENT`       | Named hurricanes, battles, wars, sports events, etc. |
| `WORK_OF_ART` | Titles of books, songs, etc.                         |
| `LAW`         | Named documents made into laws.                      |
| `LANGUAGE`    | Any named language.                                  |
| `DATE`        | Absolute or relative dates or periods.               |
| `TIME`        | Times smaller than a day.                            |
| `PERCENT`     | Percentage, including ”%“.                           |
| `MONEY`       | Monetary values, including unit.                     |
| `QUANTITY`    | Measurements, as of weight or distance.              |
| `ORDINAL`     | “first”, “second”, etc.                              |
| `CARDINAL`    | Numerals that do not fall under another type.        |

As you can notice, there are many types of named entities but I limited my analysis to a handful of them including `PERSON`, `ORG`, `GPE`, `NORP`, `LAW` and `LOC`.

I defined a python function that for each type of named entities explores the input transcript and extracts all named entities from that piece of text. Later, I store each extracted type of entities as a separate column in the original dataset. 

```{python,eval=FALSE}
def extract_entities_delim(text,type_ent = 'PERSON'):
    ent_text = ''
    doc = nlp(text)
    for e in doc.ents:
        if e.label_ == type_ent:
            ent_text = e.text+ ';' +  ent_text 
    return ent_text
```

```{python, eval=FALSE}
candidates['PERSON'] = candidates['speech'].apply(lambda x:extract_entities_delim(x))
candidates['ORG'] = candidates['speech'].apply(lambda x:extract_entities_delim(x,'ORG'))
candidates['GPE'] = candidates['speech'].apply(lambda x:extract_entities_delim(x,'GPE'))
candidates['NORP'] = candidates['speech'].apply(lambda x:extract_entities_delim(x,'NORP'))
candidates['LAW'] = candidates['speech'].apply(lambda x:extract_entities_delim(x,'LAW'))
candidates['LOC'] = candidates['speech'].apply(lambda x:extract_entities_delim(x,'LOC'))
```

### Sentiment Analysis

Next, I use TextBlob  to compute the sentiment of each sentence and store store its polarity score in a separate column called `polarity_sentiment`.  TextBlob returns a sentiment value between -1 and 1. If the value is larger than 0, it means that the sentence has a positive sentiment. On the other hand, if the returned value is smaller than 0, it indicates that the sentiment of the sentence is negative.

```{python,eval=FALSE}
def polarity_sentiment(text):
    blob = TextBlob(text)
    return blob.sentiment.polarity
    
candidates['polarity_sentiment'] = candidates.speech.apply(lambda x:polarity_sentiment(x))
```



## Network Visualization

A network (graph) can nicely represent how individuals and entities were mentioned by candidates in their remarks.  We have two types of nodes in this network:

1. The first set of nodes represent candidates on the debate stage (**from nodes)**. 
2. The second set  of nodes represent named entities (including the name of candidates themselves) that the candidates referred to in their speeches (**to** **nodes**).

If a candidate speaks of a named entity in his/her speech,  we connect the candidate node and the named entity node via an edge in our network. Also, It is fair to assume that the candidate-entity network should be a weighted network because candidates tend to place a varying level of importance on different issues and topics.

We have two options for specifying edges in the network:

1. We can use the number of times that a candidate mentioned a named entity in his/her speech. This shows how much a named entity was important to that  candidate.
2. We can group by candidates and named entities and compute their average sentiment score. By doing so, we can measure how each candidate described these named entities.

Now, it is time to go back to R and visualize the network of candidates and named entities using the [``ggraph``](https://github.com/thomasp85/ggraph) and ``tidygraph`` libraries.  For each class of named entities, I use ``as_tbl_graph()`` function and create a unique graph table dataset , and visualize the network separately.

Again, I should point out to the fact that in the beginning of the primary there were many democratic candidates in the race and also on the debate stage. If I visualize every individual that each candidate had ever mentioned, the results will become unreadable. So, just like my last blog post, I selected a few democratic candidates to show my analysis.

```R
candidates <- c( "Bernie Sanders"  , "Elizabeth Warren" ,"Mike Bloomberg"   ,"Pete Buttigieg"  ,
"Amy Klobuchar"  ,  "Joe Biden")
```



#### The Candidate/Person Network





If you look at the graph carefully, you notice that there are two issues with the network. First of all, there are several nodes in the network that belong to the same individual. For example,



Secondly, some nodes do not represent a person. The transcripts are full of errors and many names are misspelled.  Also, although Spacy is a very powerful library for NER,  but sometimes it gives us wrong results and its detected named entities are not always correct t.   For this reason, after some trial and error, I removed some incorrectly spelled words or replaced them with the correct ones.

```R
non_person <- c('y adema' ,'Appalachia' , 'AUMF' ,'bias','nondisclosur' , 'Mathew 25','Idlib','ye','Everytown')

gf_persons<- speech_sentiments %>%

separate_rows(PERSON,sep = ';') %>%
#,debate == 10
filter( PERSON !='',debate  %in% c(8,9,10) )  %>%
mutate(from = speaker, to =  wordStem(PERSON, language="english")  )  %>% 
mutate(from = speaker, to =  wordStem(PERSON, language="english")  )  %>% 
filter( !to %in% non_person ,
       from %in% candidates ) %>% 
mutate(   
    
   to =  case_when(
  to %in% c('Joe Biden','Joe', 'Biden') ~ "Joe Biden",
  to %in% c('Pete','Pete Buttigieg', 'Buttigieg', 'Mayor Buttigieg') ~ 'Pete Buttigieg',
    to %in% c('Amy Klobuchar','Amy', 'Klobuchar' ,'Ami') ~ "Amy Klobuchar",
    to %in% c('Tom','Tom Steyer', 'Steyer') ~ 'Tom Steyer',
    to %in% c('Donald','Donald Trump', 'Trump', 'President Trump') ~ 'Donald Trump',
    to %in% c('Warren','Elizabeth', 'Elizabeth Warren') ~ "Elizabeth Warren",
       
str_detect(to,'Vind')~'Vindman',
 str_detect(to,'Assad')~'Assad', 
    str_detect(to,'Bern')  ~ 'Bernie Sanders',
       str_detect(to,'Buttigieg')  ~ 'Pete Buttigieg',
       str_detect(to,'Trudeau')  ~ 'Justin Trudeau', 
       str_detect(to,'Bannon')  ~ 'Steve Bannon', 
       str_detect(to,'Netanyahu')  ~ 'Netanyahu', 
       str_detect(to,'Martin Luther')  ~ 'Martin Luther King', 
       str_detect(to,'Hillar')  ~ 'Hillary Clinton', 
       str_detect(to,'Obama')  ~ 'Barack Obama', 
       str_detect(to,'Bloomberg')  ~ 'Mike Bloomberg', 
       str_detect(to,'Mandela')  ~ 'Mandela', 
       str_detect(to,'Mike')  ~ 'Mike Bloomberg', 
       str_detect(to,'Xi')  ~ 'Xi Jinping',
       str_detect(to,'Putin')  ~ 'Putin',
        str_detect(to,'Sander')  ~ 'Bernie Sanders',
  TRUE ~ to
)) %>%
group_by(from,to,debate) %>%
summarize(n_mentions = n(),
         mean_sent = mean(polarity_sentiment)) %>%
ungroup() %>%

as_tbl_graph()

```

```{r}
speech_sentiments <- read_csv('candidates_1_10_debate_polarity.csv')

dem_candidates <- c("Bernie Sanders" ,  "Elizabeth Warren", "Mike Bloomberg"  ,
                    "Pete Buttigieg" ,  "Amy Klobuchar"   ,"Joe Biden" )

gf_persons <- 
speech_sentiments %>% 

separate_rows(PERSON,sep = ';') %>%
filter( PERSON !='',debate == 10)  %>%
mutate(from = speaker, to = PERSON)  %>% 
group_by(from,to,debate) %>%
summarize(n_mentions = n(),
         mean_sent = mean(polarity_sentiment)) %>%
ungroup() %>%
as_tbl_graph()  %>%
  mutate(name_bernie = if_else(name %in% dem_candidates,name,'Others'))

```

#### The Candidate/Place Network



```{r}
colors <- c('#C42199', '#409EB1','#845CCD','#DA8B46', '#F6E560', '#8ADDAF')

custom_palette <-
  c(
    'Mike Bloomberg' = '#F6E560',
    'Amy Klobuchar' = '#8ADDAF' ,
    'Joe Biden' = '#C42199',
    'Pete Buttigieg' = '#DA8B46',
    'Elizabeth Warren' =  '#845CCD',
    'Bernie Sanders' = '#409EB1',
    'Others' ='gray90'
  )



```


```{r message=FALSE, warning=FALSE, fig.height = 20,fig.width=20}
ggraph(gf_persons, layout = 'graphopt') + 
    geom_edge_link(aes(edge_width = n_mentions,color = n_mentions ),
                   arrow = arrow(length = unit(2, 'mm')), 
                   end_cap = circle(3, 'mm')) +
  #scale_color_gradient(low = "yellow", high = "red")+
    #geom_node_point() + 
geom_node_label(aes(label = name,color = name_bernie),fontface = "bold", hjust = "inward") + 
    #facet_edges(~debate ,ncol = 1) + 
  #scale_color_brewer(palette="Set2") +
  scale_fill_manual(values = custom_palette) + 
  
#facet_wrap(debate~)
    theme_graph(foreground = 'steelblue', fg_text_colour = 'white') 

```

http://www.favstats.eu/post/demdebates/



#### The Candidate/Candidate Network



