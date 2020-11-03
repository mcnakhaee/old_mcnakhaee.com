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

"My name is Muhammad. I began my adventure in data science five years ago. Since then, I have been involved in a wide range of related projects such as machine learning for traffic accident data, social network analysis of Telegram messaging application, stock market prediction, and my personal text mining projects. I was recently a machine learning researcher in Data Science at the University of Twente in the Netherlands. My project was funded by ProRail, a Dutch company that is responsible for maintaining the railway infrastructure in the Netherlands. My project aimed to combine machine learning and big data techniques with formal method tools such as Fault Trees to help ProRail optimize their maintenance operations."