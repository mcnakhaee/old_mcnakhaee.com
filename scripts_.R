usethis::edit_r_profile(scope = "project")
library(reticulate)
blogdown::update_hugo()
conda_list()
py_config()

blogdown::build_site()
blogdown::serve_site()
servr::daemon_stop(1) 
servr::daemon_stop(3) 
pagedown::html_resume()

letters
LETTERS
