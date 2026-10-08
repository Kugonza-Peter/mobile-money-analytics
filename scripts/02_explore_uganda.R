# 02_explore_uganda.R
# Explore Uganda's financial inclusion data (World Bank Global Findex 2025)

library(tidyverse)

# Load the full Findex database
findex <- read_csv("data/GlobalFindexDatabase2025.csv", show_col_types = FALSE)

# Keep only Uganda
uganda <- findex %>% filter(countrynewwb == "Uganda")

# Overall trend: any account vs mobile money account
overall <- uganda %>%
  filter(group == "all") %>%
  select(year, account_t_d, mobileaccount_t_d)

# Gender gap
gender <- uganda %>%
  filter(group == "gender") %>%
  select(year, group2, account_t_d, mobileaccount_t_d)

overall
gender