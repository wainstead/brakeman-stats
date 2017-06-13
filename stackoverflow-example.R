library(git2r)
library(dplyr)
library(ggplot2)
library(purrr)
library(lubridate)

options(stringsAsFactors = FALSE)

repo <- repository('brakeman-from-github')

# Get relevant bits out of the list
analysis_df <-
  repo %>%
  commits(n = 285) %>% # 285 is roughly 10% of commits to date
  #commits() %>%
  map_df(
    ~ data.frame(
      name    = .@author@name,
      date    = .@author@when@time %>% as.POSIXct(origin="1970-01-01"),
      message = .@message
    )
  )

# A histogram of commits by day of the week;
analysis_df %>%
  mutate(weekday = weekdays(date)) %>%
  group_by(weekday) %>%
  tally() %>%
  ggplot(aes(x = weekday, y = n)) +
  geom_bar(stat = "identity")

# box plots of the message length by committer
# analysis_df %>%
#   mutate(message_length = nchar(message)) %>%
#   group_by(name) %>%
#   summarise(mean_message_length = mean(message_length)) %>% 
#   ggplot(aes(x = name, y = mean_message_length)) +
#   geom_boxplot(stat = "identity")
