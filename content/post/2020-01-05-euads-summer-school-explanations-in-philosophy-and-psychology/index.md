---
title: 'EuADS Summer School 2019, Explanations in Philosophy and Psychology Talk by Christos Bechlivanidis'
author: Muhammad Chenariyan Nakhaee
date: '2020-01-05'
slug: []
categories:
  - XAI
tags:
  - XAI
subtitle: ''
summary: ''
authors: []
lastmod: '2020-01-05T13:29:59+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---





In [my last post](https://mcnakhaee.com/post/2019-12-31-explainable-data-science-summer-school/), I shared my notes from two talks at Explainable Data Science summer school in Luxembourg.  Although every talk in the summer school was interesting  and taught me new things but I particularly liked the "Explanations in Philosophy and Psychology" talk by Christos Bechlivanidis. I learned a lot of new things from this this talk  specially because what I had focused by them was mainly about the more algorithmic aspect of explainability. In this post I am going to share my notes from this talk. The slides for this talk can be downloaded from this [link](https://euads.org/wp-content/uploads/2019/09/Explanations-in-Philosophy-and-Psychology-2.pdf).



### Producers and consumers of explanations in AI

The developer who produces the explanation and evaluates it or as Miller et al (2017), the inmates are running the asylum phenomena. But what makes the good explanation for the developer is not necessarily good for other users of the system. The developer has a deeper understanding of the system. He/she might be cursed by his/her knowledge. In addition, However, his/her understanding, perspective, or goals may be different from the end-user. When producing explanations we need to carefully assess the complexity of the explanation and the knowledge and beliefs of the audience. Fred is a simple person and does not know anything about how neural networks work.

![](1.png)



### What is an explanation?

Explanations are always expressed in  a contrastive manner and this contrast is usually implied by the context. Also, an explanations is not a description. 

Nevertheless, answering "what is an explanation? " depends on who we ask. 

Philosopher care about the **normative** side of an explanation and consider a (good) explanations to be a scientific explanation. But psychologists are interested in the **descriptive** side or what people consider as an explanation such as everyday explanations and what makes a good explanation.

Different philosophers and scientists have proposed different definition for an explanation:

**Aristotle**: Citing the *function*, *the material*, *the category* or the (efficient) cause of X. 

**Hempel**:  Producing an (logical) argument whose conclusion is the explanandum X. 
**Salmon**: Stating everything that affects the probability of X. In other words, If P(Β|Α) ≠ P(Β) then A is explanatory relevant to B (e.g. P(pregnant | male & contraceptives) = P(pregnant | male)). One downside of this definition is that A does not need to have a high probability to be explanatory. For example,if P(Β|Α) - P(Β) = 0.000001, A is still explanatory  relevant to B.

**Kitcher**: Showing how X fits a more general state of affairs

**Salmon:** Stating the causal history of X. An explanation of X will trace the causal processes and interactions that lead to X. But, in general, not all causal events in the past of X are explanatory relevant to X. The causal model  presented by Salmon has limitation in dealing with certain type of causation such as Double Prevention. Take the following image where a pink plane wants to drop a bomb on a city. A red plane with an alligator has a mission to shoot the pink plane and prevent the bombing. Also, A blue plane is there to prevent the red plane from shooting the pink plane. Now if the the  blue plane successfully shoot the red plane and the pink plane successfully drops its bomb on the city, does the blue plane cause the bombardment of the city.

![](2.png)





### **TYPES OF EXPLANATIONS**

![](3.png)

![](4.png)

### Why are we interested in explanations?

We seek explanations because:

1. **To prepare ourselves for similar events in the future :** Why is the phone turned off? because it has low battery.
2. **Just to explain, understand and assign responsibilities or blames in one-off events**: why did the assassination of Duke Ferdinand lead to WWI?
3. **To rationalize actions that we take:** Why didn't you vote?  Because it does not make any difference
4. **To find meaning** 
5. **To become satisfied from explanations**. The explanations are like orgasms.

Nevertheless, the explanations may not fulfill their    function or objective.

#### **A PREFERENCE FOR TELEOLOGY**

However, some people and children are often biased toward teleological explanations and they are looking for the purpose not the cause in their explanations:  Mountains were created to be climbed.

### Explanations virtues 

The following properties have been proposed as criteria of a good explanation:

1. **No Circularity**: "This diet pill works because it helps people lose weight" and "People lose weight because they use  this diet pill" are circular arguments. Although we can detect circularity from childhood, it is not always easy to identify it.

2. **Coherence** : Different elements of explanation must have internal consistency. It means that an explanation must be consistent with prior knowledge and current evidence.

   However, explaining the full set of elements (relations) may not be simple. For instance, to fully explain how a bicycle works we need to say how its various mechanical elements interact and constrain each other.

   Explanations are incomplete (even in science) because our mental representations are skeletal and incomplete. We tend to overestimate the depth of our own
   understanding. But the moment we start writing down our understanding, it becomes clear that our understanding is (mostly) shallow and incomplete. 

   **Tiger example**: Tigers have dark vertical stripes on their bodies but  can we tell without looking at an image of a tiger whether these stripes are vertical or horizontal on the tiger's tail and legs?!

   ![](5.png)

   **Bicycle example**: How much do you know how a bicycle work?  Draw one!

   ![](7.png)

   But sometimes compression is also needed.

   <img src="6.png" style="zoom:50%;" />

   - We rely heavily in expertise of other minds. In an experiment carried out by Zemla et al. (2017), it was observed that compared to other measures such as complexity, articulation, coherence, generality and truth, one of the most important measures of explanation quality for the participants was “perceived expertise”.  Perceived expertise indicates whether participants believed the explanation was written by an expert. The more we we trust in the expertise of the explainer, the more likely we accept the explanation.

3. **Relevance**:

   - From philosophical point of view,  only factors that make a difference to the explanandum or have a causal role should be included to generate a good explanation.  This level of details is ideal but not attainable and we usually find a trade-off by abstraction. Moreover, hyper-concrete explanations are too true  to be good (e.g. extremely detailed maps).

   - Strevens (2007) proposed that in order to create an optimal explanation first we need to include every imaginable event and then we remove and abstract every event that makes no difference to the occurrence of the explanandum. 

   - But is it true for non-experts? Philosophical view is different from non-expert view. Weisberg et al (2008) showed that adding irrelevant neuroscientific information (e.g. jargons) to an explanation increased its perceived quality by non-experts (naïve adults and neuroscience students). 

   - Another experiment  was carried out in which participant were asked to rate 3 types of explanations:

   - ![](8.png)

     <img src="9.png" style="zoom:80%;" />

   - The average ratings for the abstract explanation was significantly lower than the irrelevant explanation.

   - <img src="10.png" style="zoom:80%;" />

   -  On the other hand, the causal ratings for the abstract explanation was higher that the other two types of explanations 

   - <img src="11.png" style="zoom:80%;" />

4. **Match the epistemic status of the audience**

   - When producing explanations we need to carefully asses the knowledge and beliefs of the audience.

5. **Simplicity** 

   - Everyone agrees that explanations should be simple. But what do we mean by simplicity? (number of entities,number of entity types, shortest description? )
   - Paul Thagard (1989): simplicity is determined by the number of special required assumptions.  People prefer these kinds of simpler explanations because fewer assumptions means fewer unexplained causes .
   - However, when probabilities of assumptions are also included in the explanation, people choose the most probable explanation not the simplest. In case of equal probabilities, simpler explanations are preferred. 
   - Zemla et al (2017) it showed that  the quality of explanations was positively correlated both with the number of unexplained causes and its length (level of detail)

   ![s](12.png)

6. **Generality (Breadth– Scope - Coverage)**

   - Is it better to explain more things but less precisely or fewer things but more precisely?
   - Thagard (1992) argues that an explanations that explains more pieces of evidence should be favored.

### EVALUATING EXPLANATIONS

To evaluate our explanations, we need to ask a public audience. This audience can be our friends, family members and colleagues who may not have any knowledge of the system. However, we should take into account that the these evaluations can be biased and noisy. For this reason, we need to take a larger sample of people.

Alternatively, we can also collaborate with HCI experts,  psychologist and behavioral scientist to evaluate explanations.

Different groups of users see different explanation and same group of users see different explanation. We need to compare different versions of our explanations (like A/B testing) .

We can also utilize online crowdsourcing tools and run our analysis through them:

- •Amazon Mechanical Turk – mturk.co
- Prolific Academic - prolific.c
-  Gorilla - gorilla.sc
- Testable - testable.org

#### **What do we need to ask?**

- Do they think that the provided explanation is a good explanation?

- How well do they understand this explanation?
- Behavioral measures such as what did they expect from the explanation? 

> ### 