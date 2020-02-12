---
title: Contrastive Explanations
author: Muhammad Chenariyan Nakhaee
date: '2019-11-07'
slug: []
categories: []
tags:
  - Machine Learning
  - XAI
subtitle: ''
summary: ''
authors: []
lastmod: '2019-12-29T12:41:22+01:00'
featured: no
draft: TRUE
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

```r
library(reticulate)
options(jupyter.display = 'rich')
library(tidyverse)
conda_list()
```

```
##           name
## 1  r-miniconda
## 2 r-reticulate
## 3   Anaconda37
## 4 r-tensorflow
##                                                                              python
## 1                     C:\\Users\\iMuhammad\\AppData\\Local\\r-miniconda\\python.exe
## 2 C:\\Users\\iMuhammad\\AppData\\Local\\r-miniconda\\envs\\r-reticulate\\python.exe
## 3                                           D:\\ProgramData\\Anaconda37\\python.exe
## 4                       D:\\ProgramData\\Anaconda37\\envs\\r-tensorflow\\python.exe
```

```r
py_config()
```

```
## python:         D:/ProgramData/Anaconda37/python.exe
## libpython:      D:/ProgramData/Anaconda37/python37.dll
## pythonhome:     D:/ProgramData/Anaconda37
## version:        3.7.3 (default, Mar 27 2019, 17:13:21) [MSC v.1915 64 bit (AMD64)]
## Architecture:   64bit
## numpy:          D:/ProgramData/Anaconda37/Lib/site-packages/numpy
## numpy_version:  1.16.2
## 
## NOTE: Python version was forced by RETICULATE_PYTHON
```





```python
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
```









```
##   PassengerId Survived Pclass Age SibSp Parch    Fare Embarked_C Embarked_Q
## 0           1        0      3  22     1     0  7.2500          0          0
## 1           2        1      1  38     1     0 71.2833          1          0
## 2           3        1      3  26     0     0  7.9250          0          0
## 3           4        1      1  35     1     0 53.1000          0          0
## 4           5        0      3  35     0     0  8.0500          0          0
## 6           7        0      1  54     0     0 51.8625          0          0
##   Embarked_S Sex_binary
## 0          1          0
## 1          0          1
## 2          1          1
## 3          1          1
## 4          1          0
## 6          1          0
```

```python

X = titanic_dummified.drop(['Survived'],axis=1)
y = titanic_dummified['Survived']
train, test, labels_train, labels_test = train_test_split(X, y, train_size=0.80)
```



```python
rf = RandomForestClassifier(n_estimators=100)
rf.fit(train,labels_train)
```

```
## RandomForestClassifier(bootstrap=True, class_weight=None, criterion='gini',
##                        max_depth=None, max_features='auto', max_leaf_nodes=None,
##                        min_impurity_decrease=0.0, min_impurity_split=None,
##                        min_samples_leaf=1, min_samples_split=2,
##                        min_weight_fraction_leaf=0.0, n_estimators=100,
##                        n_jobs=None, oob_score=False, random_state=None,
##                        verbose=0, warm_start=False)
```

```python
rf.score(test,labels_test)
```

```
## 0.8321678321678322
```


```python
prd_ds = test.copy()
prd_ds['actual']  = labels_test
prd_ds['prds'] = rf.predict(test)

prd_ds['wrong']  =  prd_ds['prds'] == prd_ds['actual']
```


```r
py$prd_ds %>% head()
```

```
##     PassengerId Pclass Age SibSp Parch     Fare Embarked_C Embarked_Q
## 465         466      3  38     0     0   7.0500          0          0
## 297         298      1   2     1     2 151.5500          0          0
## 267         268      3  25     1     0   7.7750          0          0
## 97           98      1  23     0     1  63.3583          1          0
## 120         121      2  21     2     0  73.5000          0          0
## 9            10      2  14     1     0  30.0708          1          0
##     Embarked_S Sex_binary actual prds wrong
## 465          1          0      0    0  TRUE
## 297          1          1      0    1 FALSE
## 267          1          0      1    0 FALSE
## 97           0          0      1    0 FALSE
## 120          1          0      0    0  TRUE
## 9            0          1      1    1  TRUE
```


```python
import lime
import lime.lime_tabular
import dtreeviz
import shap
```





```python
explainer = lime.lime_tabular.LimeTabularExplainer(
train.to_numpy(),
feature_names = list(train.columns),
class_names = [0,1],
discretize_continuous = True
)
```



```python
instance = test.iloc[1,:]
exp = explainer.explain_instance(instance,
rf.predict_proba,
num_features = 5,
top_labels = 1
)
```



```python

from IPython.display import display, HTML
exp.show_in_notebook(show_table = True,show_all = True)

```

```
## <IPython.core.display.HTML object>
```

```python
s = exp.as_html()
```


```r
library(rvest)
```

```
## Loading required package: xml2
```

```
## 
## Attaching package: 'rvest'
```

```
## The following object is masked from 'package:purrr':
## 
##     pluck
```

```
## The following object is masked from 'package:readr':
## 
##     guess_encoding
```

```r
#htmltools::
```

```r
library(lime)
```

```
## 
## Attaching package: 'lime'
```

```
## The following object is masked from 'package:dplyr':
## 
##     explain
```

```r
library(tidymodels)
```

```
## -- Attaching packages -------------------------------------------------------------------------- tidymodels 0.0.3 --
```

```
## <U+221A> broom     0.5.4     <U+221A> recipes   0.1.9
## <U+221A> dials     0.0.4     <U+221A> rsample   0.0.5
## <U+221A> infer     0.5.1     <U+221A> yardstick 0.0.5
## <U+221A> parsnip   0.0.5
```

```
## -- Conflicts ----------------------------------------------------------------------------- tidymodels_conflicts() --
## x scales::discard()   masks purrr::discard()
## x lime::explain()     masks dplyr::explain()
## x dplyr::filter()     masks stats::filter()
## x recipes::fixed()    masks stringr::fixed()
## x dplyr::lag()        masks stats::lag()
## x dials::margin()     masks ggplot2::margin()
## x rvest::pluck()      masks purrr::pluck()
## x yardstick::spec()   masks readr::spec()
## x recipes::step()     masks stats::step()
## x recipes::yj_trans() masks scales::yj_trans()
```

```r
library(ranger) 
```


```r
library(naniar)
#vis_miss(titanic_training)
#complete.cases(titanic_training)
```







The lime package for R does not aim to be a line-by-line port of its Python counterpart. I







https://uc-r.github.io/lime
https://cran.r-project.org/web/packages/lime/vignettes/Understanding_lime.html


```python
import wikipedia
wikipedia.set_lang('nl')
wikipedia.summary('Abel Tasman')
```

```
## 'Abel Janszoon Tasman (Lutjegast, 1603 – Batavia, 10 oktober 1659) was een Nederlands ontdekkingsreiziger in dienst van de Vereenigde Oost-Indische Compagnie (VOC). Hij is het bekendst door zijn reizen tussen 1642 en 1644, opgezet door Antonie van Diemen. Tijdens deze reis ontdekte hij Tasmanië, Nieuw-Zeeland en Tongatapu. Alleen op het laatste eiland werd de bemanning vriendelijk onthaald.\nTasman had als opdracht het land te onderzoeken dat toen bekendstond als Nieuw-Holland (het tegenwoordige Australië), waarvan de westkust al door Nederlanders ontdekt was, om vast te stellen of het land deel uitmaakte van het vermeende Terra Australis, een zuidelijk continent, dat zou moeten bestaan om de aarde in evenwicht te houden. De VOC hoopte dat door deze reis dit onbekende continent voor de handel geopend en vervolgens geëxploiteerd zou kunnen worden.'
```

