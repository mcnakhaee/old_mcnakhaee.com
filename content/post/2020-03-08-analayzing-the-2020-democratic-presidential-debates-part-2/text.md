Introduction

It wasn’t possible for many of us to watch every 2020 Democratic Primary debate. It was important for some of us to know what happened during the debates. In my case, I was reading about what happened in debates in some kind of online newspapers or I watched a highlight of a debate on Youtube the next day. However, they only give a short summary of a debate or just broadcast a portion of debates that includes a heated exchange of opinions between candidates. As a result, many important issues raised by candidates will be **ignored and forgotten in the** aftermath of a debate.So, it is important to summarize the content of a debate in such a way that everyone could understand what went on in a debate and what issues each candidate addressed during his/her speech. In this blog post, I will show you how I used some NLP techniques for exploring the content of debates and give you a comprehensive overview of topics that each candidate discussed. 

[In my last blog post](https://mcnakhaee.com/post/2020-02-23-the-most-eloeuent-democratic-candidate/), I explained that I had the three following goals in mind when I started exploring the 2020 Democratic Debates :

1. To know how eloquent presidential candidate are.
2. To find out who used more positive or more negative words in his/her speech by performing sentiment analysis.
3. A map of topics, individual and entities that each candidate mentioned in his/her speech by using named entity recognition and network analysis..

I s time to investigate the third and last one.

Initially, my aim from using network analysis was to determine potential allies and enemies on the debate stage. For example, [Elizabeth Warren mentioned Mike Bloomberg several times and attacked him harshly in the 9th debate](https://www.theguardian.com/us-news/2020/mar/04/mike-bloomberg-out-60-second-attack-elizabeth-warren-destroyed-campaign). During the same debate, [Amy Klobuchar and Pete Buttigieg clashed bitterly with each other](https://www.independent.co.uk/news/world/americas/us-election/amy-klobuchar-pete-buttigieg-handshake-democratic-debate-video-a9348621.html). These are just two instances of many other heated exchanges between the candidates that happened over the course of 10 debates.

> I transformed my objective into two questions that I would like to answer to make things more clear, :

> 1. How many times did a candidate address (mention) other candidates during a debate?
> 2. How did he/she do it (in a friendly or unfriendly manner)?

A simple approach to answer these questions is to store the names of all candidates in a variable (for example a vector in R or a list in Python), iterate over the transcript, compute the sentiment, count and store the number of times that a candidate’s name was brought up by another candidate.

However, this approach is a little bit challenging and requires a lot of manual data pre-processing efforts. For each democratic candidate, one must compile a comprehensive combinations of ways that may be used to call a candidate and preparing such a list seems to be a very time-consuming task. For example, other candidates mentioned Bernie Sanders in many different ways including Bernie, Bernie Sanders or Senator Sanders. only discussed how I approached the first two aspects of my experiment in my last blogpost. Now it is time to investigate the third and last one.

Initially, my aim from using network analysis was to determine potential allies and enemies on the debate stage. For example, [Elizabeth Warren mentioned Mike Bloomberg several times and attacked him harshly in the 9th debate](https://www.theguardian.com/us-news/2020/mar/04/mike-bloomberg-out-60-second-attack-elizabeth-warren-destroyed-campaign). During the same debate, [Amy Klobuchar and Pete Buttigieg clashed bitterly with each other](https://www.independent.co.uk/news/world/americas/us-election/amy-klobuchar-pete-buttigieg-handshake-democratic-debate-video-a9348621.html). These are just two instances of many other heated exchanges between the candidates that happened over the course of 10 debates.

> I transformed my objective into two questions that I would like to answer to make things more clear, :

> 1. How many times did a candidate address (mention) other candidates during a debate? 
> 2. How did he/she do it (in a friendly or unfriendly manner)?

A simple approach to answer these questions is to store the names of all candidates in a variable (for example a vector in R or a list in Python), iterate over the transcript, compute the sentiment, count and store the number of times that a candidate’s name was brought up by another candidate.

However, this approach is a little bit challenging and requires a lot of manual data pre-processing efforts. For each democratic candidate, one must compile a comprehensive combinations of ways that may be used to call a candidate and preparing such a list seems to be a very time-consuming task. For example, other candidates mentioned Bernie Sanders in many different ways including Bernie, Bernie Sanders or Senator Sanders.



Then, I realized that I can use Named Entity Recognition (NER), a technique from Natural Language Processing (NLP) literature, to extract the name of candidates from the transcript and solve this problem more efficiently. By using this approach, not only I can find candidates’ names form the transcript, but I can also find the names of other politicians, individuals and even organizations and further extend my analysis to include much more topics and issues.

Workflow:

I made use of both python and R in my analysis. My workflow includes the following steps:

1. access the transcript of debates using this package.
2. I use tidytext to split the transcript into multiple sentences and also for sentiment analysis.
3. I extract several types of Named Entities from each sentence, using Spacy,
4. I compute the sentiment of each sentence using TextBlob library in Python.
5. I transferred the results to R for visualization. There, I visualize the network of mentions and entities using ggraph and ggplot library.

Note that I could have implemented all the steps in R. For instance, Spacy has an R wrapper called Spacyr which gives the same functionality that I need for this analysis. However, I’d like to increase the number of tools that I can use. Particularly, using Python and R side by side is an interesting challenge for me.



As you can see, there are many types of named entities but I narrow down my analysis to just a handful of them including `PERSON`, `ORG`, `GPE`, `NORP`, `LAW` and `LOC`.  The named entity labels are stored in `label_` attribute. To do so, we need to create `Doc` object using `nlp()` method. When we call `nlp()` on the input text, spacy uses the language model to tokenize the document first. Then, spacy applies a tagger, parser and named entity recognizer steps as its processing pipeline. The named entities can be accessed `ents`. 

If you are interested to learn more about Spacy and how it works, I have provided some links at the end of this post.

I define a python function that iterates over all named entities and and see to which class of named entities (by default `PERSON`) they belong. Then, I apply this function to the transcript column in the original dataset and store each extracted type of entities as a separate column. 