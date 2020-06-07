---
title: Happiest, Saddest, Most Energetic and Fastet Persian Singers on Spotify
author: ''
date: '2020-05-04'
slug: happiest-saddest-most-energetic-and-fastet-persian-singers-on-spotify
categories:
  - R
tags:
  - Spotiify
  - R
  - Visualization
subtitle: ''
summary: ''
authors: []
lastmod: '2020-05-04T22:47:57-07:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---



```{r message=FALSE, warning=FALSE}
library(gargle)
library(tidyverse)
library(googlesheets4)
library(tidymodels)
library(gghighlight)
library(hrbrthemes)
library(ggthemes)
library(ggrepel)
library(ggalt)
library(extrafont)
library(ggtext)
library(ggforce)
library(cowplot)
extrafont::fonttable()
extrafont::font_import()
```



```{r}

songs_audio_plus_pop <- read_csv('https://raw.githubusercontent.com/mcnakhaee/datasets/master/Persian_Songs_Spotify.csv')
songs_audio_plus_pop <- songs_audio_plus_pop %>%
  filter(
    !artist_name %in% c(
      'Hatam Asgari',
      'Kaveh Deylami',
      'Nasser Abdollahi',
      'Peyman Yazdanian',
      'Abbas Ghaderi',
      'Mohammad Golriz',
      'Hamid Hami',
      'Koveyti Poor',
      'Mohsen Sharifian'
    )
  )

```


```{r}

artists <-
  c( 'Sirvan Khosravi',
     'Hesameddin Seraj',
     'Rastak',
     'Shahram Nazeri',
    'Hossein Alizadeh',
    'Reza Sadeghi',
    'Alireza Eftekhari',
    'Mohammadreza Shajarian' ,
    'Salar Aghili',
    'Morteza Pashaei',
    'Alireza Ghorbani',
    'Homayoun Shajarian',
    'Mohsen Yeganeh' ,
    'Morteza Pashaei',
    'Moein',
     'Farzad Farzin',
     'Babak Jahanbakhsh',
    'Ehsan Khajeh Amiri',
    'Siavash Ghomayshi',
    'Xaniar Khosravi',
    'Tohi' ,
    'Mohsen Chavoshi',
    'Abbas Ghaderi',
    'Amir Tataloo',
    'Hamed Homayoun',
    'Kayhan Kalhor'
 )
levels = c('Hossein Alizadeh',
                   'Mohammadreza Shajarian',
                   'Kayhan Kalhor',
                   'Hesameddin Seraj',
                   'Alireza Eftekhari',
                   'Shahram Nazeri',
                   'Homayoun Shajarian',
                   'Alireza Ghorbani',
                   'Rastak',
                   'Salar Aghili',
                   'Mohsen Chavoshi',
                   'Sirvan Khosravi',
                   'Xaniar Khosravi',
                   'Ehsan Khajeh Amiri',
                    'Mohsen Yeganeh' ,
                   'Morteza Pashaei',
                   'Hamed Homayoun',
                   'Farzad Farzin',
                   'Babak Jahanbakhsh',
                   'Siavash Ghomayshi',
                   'Reza Sadeghi',
                   'Tohi',
                   'Amir Tataloo',
                   'Abbas Ghaderi',
                   'Moein')
artists <- factor(artists, levels = levels)
order <- c(
  "valence",
  "energy",
  "tempo",
  "loudness",
  "acousticness",
  "instrumentalness",
  "danceability"
)


normalized_features_long <- songs_audio_plus_pop %>%
  mutate_at(order, scales::rescale, to = c(0, 7)) %>%
  filter(!is.na(popularity)) %>%
  filter(artist_name %in% artists) %>%
  mutate(artist_name = factor(artist_name, levels = levels))  %>%
  pivot_longer(
    names_to = 'metric',
    cols = c(
      "valence",
      "energy",
      "tempo",
      "loudness",
      "acousticness",

      "danceability"),
    values_to = 'value'
  ) 
```



```{r fig.height=35,fig.width=21,dpi = 1000}

subtitle <- "Every singer or composer has his/her own distinct musical style and audio charactristics. Based on 8 audio features extracted from Spotify's API, this plot compares several well-known Persian singers and musicians.\n These artists are compared by the minimum (red) , the average (orange) and maximum (yellow) values of each audio features in their songs"
subtitle <- str_wrap(subtitle,width = 100)

p_main <- ggplot() +
  geom_polygon(
    data = normalized_features_long %>%  group_by(artist_name, metric) %>%
      summarise_at(c("value"), mean) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = artist_name,),
    alpha = .54,
    size = 1.5,
    show.legend = T,
    fill = '#FF1654'
  ) +
  geom_polygon(
    data = normalized_features_long %>%  group_by(artist_name, metric) %>%
      summarise_at(c("value"), max) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = artist_name,),
    alpha = .44,
    size = 1.5,
    show.legend = T,
    fill = '#FFE066'
  ) +
  geom_polygon(
    data = normalized_features_long %>%  group_by(artist_name, metric) %>%
      summarise_at(c("value"), min) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = artist_name,),
    alpha = .84,
    size = 1.5,
    show.legend = T,
    fill =  "#EF476F"
    ) +
  scale_x_discrete(
    limits = order,
    labels = c(
      "Happy",
      "Energy",
      "Fast",
      "Loud",
      "Acoustic",
      "Instrumental",
      "Danceable"  ) )+
  coord_polar(clip = 'off') +
  theme_minimal() +
  labs(title = "Persian Singers and Their Audio Characteristics",
      
        subtitle = subtitle,
    caption = 'Source: Spotify \n Visualization: mcnakhaee') +
  
  ylim(0, 8) +
  facet_wrap( ~ artist_name, ncol = 4) +
  theme(
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(family =  'Montserrat', size = 13.5,
                               margin = ggplot2::margin(30, 0, 20, 0)),
    
    plot.caption = element_text(
      family = 'Montserrat',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 11,
      color = 'grey80'
    ) ,
    text = element_text(family =  'Montserrat'),
    strip.text = element_text(family =  'Montserrat', size = 18),
    strip.text.x = element_text(margin = ggplot2::margin(1, 1, 1, 1, "cm")),
    #panel.spacing.x = unit(5.5, "lines"),
    #panel.spacing.y = unit(5.5, "mm"),
    #plot.margin = grid::unit(c(0,0,0,0), "mm"),
    #panel.spacing = unit(4, "lines"),
    
    #plot.margin = unit(c(1, 1, 1, 1), "lines"),
    panel.spacing = unit(3.5,"lines"),
    panel.grid = element_blank(),
    #panel.border = element_blank(),
    plot.title = element_text(
      family = 'Montserrat',
      hjust = .5,
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 32,
      color = 'gray10'
    ),
    plot.subtitle = element_text(
      family = 'Montserrat',
      size = 18,
      color = 'gray10',
      hjust = .5,
      margin = ggplot2::margin(30, 0, 20, 0),
    ),
    plot.background = element_rect(fill = '#FCF0E1'),
    #panel.background = element_rect(fill = '#FCF0E1'),
    #panel.border = element_rect(fill = '#FCF0E1'),
  ) 

p_main
```

Let's compare Persian Singers with S

```{r}
eng_spotify_songs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv')

artists <-
  c( 'Queen',
     'Drake',
     'The Chainsmokers',
     'Ed Sheeran',
    '50 Cent',
    'Rihanna',
    'Selena Gomez',
    'Eminem' ,
    'Salar Aghili',
    'Katy Perry',
    'The Cranberries',
    'The Rolling Stones',
    'Taylor Swift' ,
    'Snoop Dogg',
    'Justin Bieber',
     'Beyoncé',
     'Shakira',
    'David Guetta',
    'Martin Garrix',
    'Calvin Harris',
    'Kygo' ,
    'Don Omar',
    'Maroon 5',
    'Luis Fonsi',
    'Billie Eilish',
    'Shakira'
 )

order <- c(
  "acousticness",
  "instrumentalness",
  'speechiness',
  "tempo",
  "loudness",
  "valence",
  "energy",
  "danceability"
)


normalized_features_long <- eng_spotify_songs %>%
  mutate_at(order, scales::rescale, to = c(0, 7)) %>%
  filter(track_artist %in% artists) %>%
  pivot_longer(
    names_to = 'metric',
    cols = c(
      "acousticness",
      "instrumentalness",
      'speechiness',
      "tempo",
      "loudness",
      "valence",
      "energy",
      "danceability"),
    values_to = 'value'
  )
```


```{r fig.height=32,fig.width=22,dpi = 1000}



p_main <- ggplot() +
  geom_polygon(
    data = normalized_features_long %>%  group_by(track_artist, metric) %>%
      summarise_at(c("value"), mean) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = track_artist,),
    alpha = .54,
    size = 1.5,
    show.legend = T,
    fill = '#02C39A'
  ) +
  geom_polygon(
    data = normalized_features_long %>%  group_by(track_artist, metric) %>%
      summarise_at(c("value"), max) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = track_artist,),
    alpha = .44,
    size = 1.5,
    show.legend = T,
    fill = '#00A896'
  ) +
  geom_polygon(
    data = normalized_features_long %>%  group_by(track_artist, metric) %>%
      summarise_at(c("value"), min) %>%
      arrange(factor(metric, levels = order)) %>%
      ungroup(),
    aes(x = metric, y = value, group = track_artist,),
    alpha = .84,
    size = 1.5,
    show.legend = T,
    fill =  "#028090"
    ) +
  scale_x_discrete(
    limits = order,
    labels = c(
      "acousticness",
      "instrumentalness",
      'speechiness',
      "tempo",
      "loudness",
      "valence",
      "energy",
      "danceability"
      #'مدت زمان'
      )
    
    
    
  ) +
  coord_polar(clip = 'off') +
  theme_minimal() +
  labs(title = "مقایسه ای بین ویژگی های صوتی برخی از  چهره های شاخص موسیقی ایران",
       subtitle = subtitle,
    caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی') +
  
  ylim(0, 8) +
  facet_wrap( ~ track_artist, ncol = 4) +
  theme(
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(family =  'B Tehran', size = 12),
    
    plot.caption = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 20
    ) ,
    text = element_text(family =  'B Mitra'),
    strip.text = element_text(family =  'B Tehran', size = 27),
    strip.text.x = element_text(margin = ggplot2::margin(1, 0, 1, 0, "cm")),
    panel.spacing.x = unit(6.5, "lines"),
    #panel.grid = element_blank(),
        panel.border = element_blank(),
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(0, 0, 80, 0),
      size = 45,
      color = 'gray10'
    ),
    plot.subtitle = element_text(
      family = 'B Mitra',
      size = 25,
      color = 'gray10',
      hjust = .5
    ),
  )

p_main
```





# Jitter


```{r eval=FALSE,}
songs_audio_plus_pop_jitter <- songs_audio_plus_pop %>% 
  filter(artist_name %in% artists) %>% 
  mutate(is_popular = !is.na(popularity)) %>%
  distinct(artist_name_farsi,track_name,.keep_all = T) %>% 
  mutate(is_popular_size = if_else(!is.na(popularity),popularity,25),
         is_popular_alpha = if_else(!is.na(popularity),0.8,0.5)) %>% 
  mutate(track_name_farsi = str_wrap(track_name_farsi, width = 15)) %>% 
  mutate(track_farsi_avail = if_else(!is.na(track_name_farsi)& !is.na(popularity) & nchar(track_name_farsi) < 20 & !explicit,track_name_farsi,'')) 
```



```{r eval=FALSE, fig.height=30, fig.width=20,dpi=2000}
songs_audio_plus_pop_jitter %>%
  ggplot(aes(x = artist_name_farsi, y = valence)) +
  geom_jitter(
    aes(
      color = is_popular,
      size = is_popular_size,
      alpha = is_popular_alpha
    ),
    size = 6,
    width = 0.2,
    
  ) +
  geom_text_repel(
    aes(label = track_farsi_avail , x = artist_name_farsi , y = valence),
    family = 'B Mitra',
    color = 'gray99',
    size = 7,
    force = 0.6,
    max.iter = 2000,
    box.padding = 0.4,
    point.padding = 0.6,
    min.segment.length = 0.15,
    nudge_y      = 0.001,
    hjust = 0.5,
    segment.alpha = 0.6,
    segment.size = 0.6
  ) +
  stat_summary(
    fun = mean,
    geom = 'point',
    color = '#FF9F1C',
    size = 5,
    aes(group = artist_name_farsi)
  ) +
  scale_color_manual(values = c('#FFD166', '#EF476F')) +
  labs(
    x = '',
    y = 'شادی',
    title = 'مقایسه ای بین شادی در آهنگ های برخی از خوانندگان (نوازندگان) ایرانی',
    subtitle = '',
     caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی') +
  scale_y_continuous(sec.axis = dup_axis()) +
  coord_flip()


```


```{r eval=FALSE, fig.height=30, fig.width=20}
songs_audio_plus_pop_jitter %>%
  ggplot(aes(x = artist_name_farsi, y = energy)) +
  geom_jitter(
    aes(
      color = is_popular,
      size = is_popular_size,
      alpha = is_popular_alpha
    ),
    size = 6,
    width = 0.2,
    
  ) +
  geom_text_repel(
    aes(label = track_farsi_avail , x = artist_name_farsi , y = energy),
    family = 'B Mitra',
    color = 'gray90',
    size = 6,
    force = 0.6,
    max.iter = 2000,
    box.padding = 0.4,
    point.padding = 0.6,
    min.segment.length = 0.15,
    nudge_y      = 0.001,
    hjust = 0.5,
    segment.alpha = 0.6,
    segment.size = 0.6
  ) +
  stat_summary(
    fun = mean,
    geom = 'point',
    color = '#FF9F1C',
    size = 5,
    aes(group = artist_name_farsi)
  ) +
  scale_color_manual(values = c('#EF476F', '#EF476F')) +
  labs(
    x = '',
    y = 'انرژی',
    title = 'مقایسه ای بین انرژی در آهنگ های برخی از خوانندگان (نوازندگان) ایرانی',
    subtitle = '',
     caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی') +
  scale_y_continuous(sec.axis = dup_axis()) +
  coord_flip() +
  theme_void() +
  theme(
    text = element_text(family =  'B Mitra'),
    axis.text.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      color = 'gray80',
      size = 20
    ),
    axis.text.y = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      color = 'gray80',
      size = 20
    ),
    axis.title.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 27,
      color = 'gray80'
    ),
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(40, 0, 40, 0),
      size = 35,
      color = 'gray80'
    ),
    plot.caption = element_text(family ='B Mitra',
                                  margin = ggplot2::margin(30, 0, 20, 20),
                                      size = 20,
                                  color = 'gray70') ,
    legend.position = 'none',
    plot.background = element_rect(fill = "#516869")
  )

```





```{r eval=FALSE, fig.height=30, fig.width=20, include=FALSE}
songs_audio_plus_pop_jitter %>%
  ggplot(aes(x = artist_name_farsi, y = acousticness)) +
  geom_jitter(
    aes(
      color = is_popular,
      size = is_popular_size,
      alpha = is_popular_alpha
    ),
    size = 6,
    width = 0.2,
    
  ) +
  geom_text_repel(
    aes(label = track_farsi_avail , x = artist_name_farsi , y = acousticness),
    family = 'B Mitra',
    color = 'gray90',
    size = 6,
    force = 0.6,
    max.iter = 2000,
    box.padding = 0.4,
    point.padding = 0.6,
    min.segment.length = 0.15,
    nudge_y      = 0.001,
    hjust = 0.5,
    segment.alpha = 0.6,
    segment.size = 0.6
  ) +
  stat_summary(
    fun = mean,
    geom = 'point',
    color = '#FF9F1C',
    size = 5,
    aes(group = artist_name_farsi)
  ) +
  #'#EF476F'
  scale_color_manual(values = c('#118AB2', '#06D6A0')) +
  labs(
    x = '',
    y = 'آواشنودی',
    title = 'مقایسه ای بین میزان آواشنودی (آکوستیک) در آهنگ های برخی از خوانندگان (نوازندگان) ایرانی',
    
    subtitle = '',
    caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی'
  ) +
  scale_y_continuous(sec.axis = dup_axis()) +
  coord_flip() +
  theme_void() +
  theme(
    text = element_text(family =  'B Mitra'),
    axis.text.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      color = 'gray80',
      size = 20
    ),
    axis.text.y = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      color = 'gray80',
      size = 20
    ),
    axis.title.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 27,
      color = 'gray80'
    ),
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(40, 0, 40, 0),
      size = 35,
      color = 'gray80'
    ),
    plot.caption = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      size = 20,
      color = 'gray70'
    ) ,
    legend.position = 'none',
    plot.background = element_rect(fill = "#516869")
  )

```


```{r eval=FALSE, fig.height=30, fig.width=20}
songs_audio_plus_pop_jitter %>%
  ggplot(aes(x = artist_name_farsi, y = danceability)) +
  geom_jitter(
    aes(
      color = is_popular,
      size = is_popular_size,
      alpha = is_popular_alpha
    ),
    size = 6,
    width = 0.2,
    
  ) +
  geom_text_repel(
    aes(label = track_farsi_avail , x = artist_name_farsi , y = danceability),
    family = 'B Mitra',
    color = 'gray90',
    size = 6,
    force = 0.6,
    max.iter = 2000,
    box.padding = 0.4,
    point.padding = 0.6,
    min.segment.length = 0.15,
    nudge_y      = 0.001,
    hjust = 0.5,
    segment.alpha = 0.6,
    segment.size = 0.6
  ) +
  stat_summary(
    fun = mean,
    geom = 'point',
    color = '#FF9F1C',
    size = 5,
    aes(group = artist_name_farsi)
  ) +
  #'#EF476F'
  scale_color_manual(values = c('#A5668B', '#EF476F')) +
  labs(
    x = '',
    y = 'رقص آوری',
    title = 'مقایسه ای بین میزان رقص آوری در آهنگ های برخی از خوانندگان (نوازندگان) ایرانی',
    subtitle = '',
    caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی'
  ) +
  scale_y_continuous(sec.axis = dup_axis()) +
  coord_flip() +
  theme_void() +
  theme(
    text = element_text(family =  'B Mitra'),
    axis.text.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      color = 'gray80',
      size = 20
    ),
    axis.text.y = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      color = 'gray80',
      size = 20
    ),
    axis.title.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 27,
      color = 'gray80'
    ),
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(40, 0, 40, 0),
      size = 35,
      color = 'gray80'
    ),
    plot.caption = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      size = 20,
      color = 'gray70'
    ) ,
    legend.position = 'none',
    plot.background = element_rect(fill = "#516869")
  )

```




```{r eval=FALSE, fig.height=30, fig.width=20}
songs_audio_plus_pop_jitter %>%
  ggplot(aes(x = artist_name_farsi, y = loudness)) +
  geom_jitter(
    aes(
      color = is_popular,
      size = is_popular_size,
      alpha = is_popular_alpha
    ),
    size = 6,
    width = 0.2,
    
  ) +
  geom_text_repel(
    aes(label = track_farsi_avail , x = artist_name_farsi , y = loudness),
    family = 'B Mitra',
    color = 'gray90',
    size = 6,
    force = 0.6,
    max.iter = 2000,
    box.padding = 0.4,
    point.padding = 0.6,
    min.segment.length = 0.15,
    nudge_y      = 0.001,
    hjust = 0.5,
    segment.alpha = 0.6,
    segment.size = 0.6
  ) +
  stat_summary(
    fun = mean,
    geom = 'point',
    color = '#FF9F1C',
    size = 5,
    aes(group = artist_name_farsi)
  ) +
  #'#EF476F'
  scale_color_manual(values = c('#06D6A0', '#EF476F')) +
  labs(
    x = '',
    y = 'بلندی',
    title = 'مقایسه ای بین میزان بلندی آهنگ های برخی از خوانندگان (نوازندگان) ایرانی',
    subtitle = '',
    caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی'
  ) +
  scale_y_continuous(sec.axis = dup_axis()) +
  coord_flip() +
  theme_void() +
  theme(
    text = element_text(family =  'B Mitra'),
    axis.text.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      color = 'gray80',
      size = 20
    ),
    axis.text.y = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      color = 'gray80',
      size = 20
    ),
    axis.title.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 27,
      color = 'gray80'
    ),
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(40, 0, 40, 0),
      size = 35,
      color = 'gray80'
    ),
    plot.caption = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 20),
      size = 20,
      color = 'gray70'
    ) ,
    legend.position = 'none',
    plot.background = element_rect(fill = "#516869")
  )

```

## Most Popular Songs

```{r eval=FALSE,fig.width=20,fig.height=30}
songs_audio_plus_pop <-
  read_csv('songs_audio_plus_pop_06_04_2020_v9.csv')
songs_audio_plus_pop <- songs_audio_plus_pop %>%
  filter(
    !artist_name %in% c(
      'Hatam Asgari',
      'Kaveh Deylami',
      'Nasser Abdollahi',
      'Peyman Yazdanian',
      'Abbas Ghaderi',
      'Mohammad Golriz',
      'Hamid Hami',
      'Koveyti Poor',
      'Mohsen Sharifian',
      'Soheil Nafissi'
    )
  )
s0 <-
  "با های آهنگ اسپاتیفای در زبان فارسی نوازندگان و خوانندگان برتر آهنگ 10 میان از"
s1 <-
  "<br/> دارند اسپاتیفای کاربران میان در را محبوبیت میانگین بالاترین مانکن ساسی های آهنگ ،خاص طور به .اند شده مرتب (نوازنده) خواننده هر محبوبیت میانگین اساس بر اسامی."
s2 <- " اند شده نمایش نمودار این در محبوبیت مقدار"
s3 <- "<span style='color:#118ab2'> بیشترین</span> "
s4 <- "<span style='color:#ef476f'> کمترین و </span>"
s_ <- paste0(s2, s4, s3, s0, collapse = ' ')
s_ <- paste0(s1, s_, collapse = '</br>')
songs_audio_plus_pop %>%
  filter(!is.na(popularity)) %>%
  mutate(track_name = if_else(!is.na(track_name), track_name, track_name)) %>%
  group_by(artist_name) %>%
  
  filter(artist_name != 'سایر') %>%
  summarize(
    avg_pop = mean(popularity),
    min_pop = min(popularity),
    max_pop = max(popularity),
    most_popular = track_name[which.max(popularity)],
    least_popular = track_name[which.min(popularity)]
  ) %>%
  mutate(
    artist_name = fct_reorder(artist_name, avg_pop),
    size_text = if_else(str_detect(least_popular, 'When'), 12, 12)
  ) %>%
  
  ggplot(aes(x = min_pop , xend = max_pop, y = artist_name)) +
  geom_dumbbell(
    colour_x = '#ef476f',
    colour_xend = '#118ab2',
    size_x = 7,
    size_xend = 7
  ) +
  geom_text(
    aes(x = min_pop - 1, y = artist_name, label = least_popular),
    size = 7,
    family = 'B Tehran',
    hjust = 1
  ) +
  geom_text(
    aes(x = max_pop + 1, y = artist_name, label = most_popular),
    size = 7,
    family = 'B Tehran',
    hjust = 0
  ) +
  labs(title = 'محبوب ترین آهنگ ها و خواننده های ایرانی در اسپاتیفای',
       subtitle = s_,
       x = 'محبوبیت',
       caption = 'منبع: اسپاتیفای\n  مصورسازی: محمد چناریان نخعی') +
  scale_x_continuous(sec.axis = dup_axis()) +
  theme_tufte() +
  theme(
    plot.title = element_text(
      family = 'B Mitra',
      hjust = .5,
      margin = ggplot2::margin(0, 0, 40, 0),
      size = 45
    ),
    plot.subtitle = element_markdown(
      family = 'B Mitra',
      size = 15,
      margin = ggplot2::margin(20, 0, 40, 0),
      hjust = 1
      
    ),
    axis.text.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 20
    ),
    
    axis.text.y = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 20
    ),
    axis.title.x = element_text(
      family = 'B Mitra',
      margin = ggplot2::margin(30, 0, 20, 0),
      size = 30
    ),
    plot.caption = element_text(family ='B Mitra',
                                  margin = ggplot2::margin(30, 0, 20, 20),
                                      size = 20,
                                  color = 'gray20') ,
    axis.title.y = element_blank(),
    plot.background = element_rect(fill = '#FCF0E1'),
    plot.margin = unit(c(1, 1, 1.5, 1.2), "cm")
  )




```



# Over Time

```{r eval=FALSE,fig.height=20,fig.width=20}

years <- normalized_features %>% 
  distinct(album_release_year) %>% 
  filter(album_release_year >1984) %>% 
  pull()

normalized_features %>%
  select(album_release_year, danceability, energy, loudness, speechiness, liveness, valence, tempo, duration_ms,popularity
         ) %>% 
  mutate_at(vars(-album_release_year),scale) %>% 
  group_by(album_release_year) %>% 
  summarise_at(vars(everything()),mean,na.rm = TRUE) %>% 
  pivot_longer(names_to = 'metric',cols =c(danceability, energy, loudness, speechiness, liveness, valence, tempo, duration_ms,popularity
                                           ),
           values_to = 'value') %>% 
  ggplot(aes(album_release_year,y= value,color = metric)) +
  geom_line(color = 'indianred',size = 1.5,alpha = 1) + 
  gghighlight( use_direct_label = FALSE,unhighlighted_params = list(size = 1.5,width = 0.5,color ='#F6DAB4',alpha  = 0.7)) +
  scale_x_continuous(breaks = years,labels = years,limits = c(1985,2020)) +
  facet_wrap(~ metric,
          #   scales = 'free_y'
           ncol = 2 ) +
  theme_fivethirtyeight()

```


https://github.com/jakelawlor/TidyTuesday_JL/blob/master/CodeFiles/Jan21.20.Spotify.Rmd

https://github.com/jakelawlor/TidyTuesday_JL/blob/master/CodeFiles/Feb.18.20.CO2Food.R

http://nagvayeasheghi.blogfa.com/post/1417/اینسترومنتال-(Instrumental)-چیست-