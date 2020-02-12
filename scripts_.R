usethis::edit_r_profile(scope = "project")
library(reticulate)
blogdown::update_hugo()
conda_list()
py_config()

blogdown::build_site()
blogdown::serve_site()
servr::daemon_stop(1) 
servr::daemon_stop(5) 
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
```