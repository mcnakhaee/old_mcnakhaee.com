usethis::edit_r_profile(scope = "project")
library(reticulate)
blogdown::update_hugo()
conda_list()
py_config()

blogdown::build_site()
blogdown::serve_site()
servr::daemon_stop(1) 
servr::daemon_stop(2) 
pagedown::html_resume()

letters
LETTERS

```{r eval=FALSE, fig.height=, fig.width=40, include=FALSE}
embedding %>%
  ggplot(aes(x = element_1, y = element_2 , color = selected_artist)) +
  geom_point(aes(size = point_size_selected_artist)) +
  gghighlight(selected_artist != "",
              unhighlighted_params = list(alpha = 0.2, color = '#FFE66D')) +
  scale_color_manual(
    values = c(
      '#5BC0EB',
      '#FDE74C',
      '#7FB800',
      '#E55934',
      '#FA7921',
      '#1A936F' ,
      '#F0A6CA',
      '#B8BEDD')) +
  guides(size = FALSE,
         color = guide_legend(override.aes = list(alpha = 0.9, size = 12))) +
  geom_text_repel(
    aes(label = popular_tracks_selected_artist),
    size = 7,
    family = 'Montserrat',
    point.padding = 2.2,
    box.padding = .5,
    force = 1,
    min.segment.length = 0.1) +
  labs(
    x = "",
    y = "" ,
    title = 'The Map of Spotify Songs\n',
    subtitle = 'Using the UMAP algorithm, the audio features of each song are mapped into a 2D space.\n Each point represents a unique song and the most popular songs of several known artist are also shown\n',
    color = '') +
  theme_modern_rc() +
  theme(
    legend.position = 'top',
    legend.text   = element_text(size = 24),
    plot.title = element_text(
      family = 'Montserrat',
      face = "bold",
      size = 50,
      hjust = 0.5,
      color = '#FFE66D'),
    plot.subtitle = element_text(
      family = 'Montserrat',
      size = 30,
      hjust = 0.5),
    strip.background = element_blank(),
    axis.ticks.x = element_blank() ,
    axis.ticks.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x.bottom  = element_blank(),
    axis.text.y.left = element_blank(),
    axis.text.x = element_blank()
  ) 





iris_recipe <- training(iris_split) %>%
  #recipe(Species ~.) %>% 
  #step_corr(all_predictors()) %>% 
  prep()







data_split <- initial_split(spotify_songs_ds,prop = 0.7)
trianing_set <- data_split %>% 
  training()
test_set <- data_split %>% 
  testing()

rf <- rand_forest(trees = 200, ) %>% 
  set_engine("ranger") %>% 
  #set_mode(mode = 'classification') %>% 
  set_mode(mode = 'regression') %>% 
  fit(track_popularity ~. ,data = trianing_set) 
#fit(playlist_genre ~. ,data = trianing_set) 

args(rand_forest)
#metric_set(rmse,mae,rsq )
metric_set(accuracy )


rf %>% 
  predict(test_set) %>% 
  bind_cols(test_set) %>% 
  #metrics(truth = playlist_genre, estimate = .pred_class)
  metrics(truth = track_popularity, estimate = .pred)


rf %>% 
  collect_metrics()
```



## Sentiment Analysis

```{r}
debates_sentiment <- debates %>%
  filter(type == 'Candidate') %>%
  filter(!is.na(speech)) %>%
  unnest_tokens(word, speech) %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(speaker, type, gender, debate) %>%
  mutate(sentiment = sum(value),
         speech_text = paste0(word, collapse = ' ')) %>%
  ungroup() %>%
  distinct(speaker, type, gender, debate, .keep_all = TRUE)

head(debates_sentiment)
```






```{r fig.height=10, fig.width=30}
debates_sentiment %>%
  #filter(speaker %in% speakers)%>%
  filter(type != 'Moderator') %>%
  ggplot(aes(x = debate, y = sentiment, color = speaker)) +
  #ggplot(aes(x = order,y= sentiment,color = speaker))
  geom_line(size = 2) +
  scale_color_tableau() +
  gghighlight(speaker %in% speakers, label_params = list(label.size = 2,segment.color = "white"))
```

I didn't use the bing sentiment lexicon becuase interestingly it considers "trump" to be a positive word.
```{r}
debates_sentiment <- debates %>%
  filter(type != 'Moderator') %>%
  filter(!is.na(speech)) %>%
  unnest_tokens(word, speech) %>%
  #anti_join(stop_words) %>%
  inner_join(get_sentiments("nrc")) %>%
  filter(word != 'trump') %>%
  count(speaker,sentiment)

head(debates_sentiment,12)
```
```{r eval=FALSE, fig.height=20, fig.width=20, include=FALSE}
debates_sentiment %>% 
  filter(speaker %in% speakers) %>% 
  mutate(speaker = reorder_within(speaker,n,sentiment)) %>% 
ggplot(aes(x = speaker, y = n,fill = speaker)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment,scales = "free_y") +
      coord_flip() +
    scale_x_reordered() +
  scale_fill_tableau() +
  #scale_y_reordered() +
  theme_fivethirtyeight() +
    theme(
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    legend.position = 'top',
    legend.title = element_text(
      family = 'Montserrat',
      face = "bold",
      size = 25,
      hjust = 0.5,
      margin = margin(0, 0, 20, 0),
    ),
    plot.title = element_text(
      family = 'Montserrat',
      face = "bold",
      size = 50,
      margin = margin(0, 0, 20, 0),
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      family = 'Montserrat',
      size = 30,
      margin = margin(0, 0, 60, 0),
      hjust = 0.5
    ),
    strip.text = element_text(
      family = 'Montserrat',
      size = 30,
    ),
    legend.text = element_text(     
      family = 'Montserrat',
      size = 20,
      margin = margin(0, 20, 0, 0)
      ),

    legend.text.align = 0,
     legend.direction = "horizontal",
    panel.spacing = unit(2, "points")
  )
```
```{r}
library(reticulate)
```

```{python}
import spacy
```

