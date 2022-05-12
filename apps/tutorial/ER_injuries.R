library(shiny)
library(vroom)
library(tidyverse)
library(ggelegant)

app_root <- "./apps/tutorial"
data_path <-file.path(app_root, "neiss")
dir.create(data_path)

download <- function(where, name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), file.path(where, name), quiet = TRUE)
}

download(data_path, "injuries.tsv.gz")
download(data_path, "population.tsv")
download(data_path, "products.tsv")

injuries <- vroom::vroom(file.path(data_path, "injuries.tsv.gz"))
products <- vroom::vroom(file.path(data_path, "products.tsv"))
population <- vroom::vroom(file.path(data_path, "population.tsv"))

products

population

selected <- injuries %>% 
  filter(prod_code == 649)

nrow(selected)

selected %>% 
  count(location, wt = weight, sort = TRUE)

selected %>% 
  count(body_part, wt = weight, sort = TRUE)

selected %>% 
  count(diag, wt = weight, sort = TRUE)

summary <- selected %>% 
  count(age, sex, wt = weight)

summary %>% 
  ggplot(aes(age, n, colour = sex)) + 
  geom_line() + 
  geom_smooth(se = FALSE) +
  labs(y = "Estimated number of injuries") +
  theme_elegante_std(base_family =  "Ubuntu Condensed")


summary <- selected %>% 
  count(age, sex, wt = weight) %>% 
  left_join(population, by = c("age", "sex")) %>% 
  mutate(rate = n / population * 1e4)

summary %>% 
  ggplot(aes(age, rate, colour = sex)) + 
  geom_line(na.rm = TRUE) + 
  geom_smooth(se = FALSE) +
  labs(y = "Injuries per 10,000 people") +
  theme_elegante_std(base_family =  "Ubuntu Condensed")

selected %>% 
  sample_n(10) %>% 
  pull(narrative)

selected %>% 
  sample_n(10) %>% 
  select(narrative)
