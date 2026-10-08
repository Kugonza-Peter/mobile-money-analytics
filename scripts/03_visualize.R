# 03_visualize.R
# Charts of financial inclusion in Uganda (World Bank Global Findex 2025)

library(tidyverse)

# Reuse the data prepared in script 02
source("scripts/02_explore_uganda.R")

# Reshape so each row is one year and one type of account
trend <- overall %>%
  pivot_longer(
    cols = c(account_t_d, mobileaccount_t_d),
    names_to = "type",
    values_to = "share"
  ) %>%
  mutate(type = recode(type,
    account_t_d = "Any account",
    mobileaccount_t_d = "Mobile money account"
  ))

# Chart 1: account ownership over time
p1 <- ggplot(trend, aes(x = year, y = share, colour = type)) +
  geom_line(linewidth = 1.2, na.rm = TRUE) +
  geom_point(size = 3, na.rm = TRUE) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  scale_x_continuous(breaks = c(2011, 2014, 2017, 2021, 2024)) +
  labs(
    title = "Account ownership in Uganda, 2011 to 2024",
    subtitle = "Share of adults (15+) with an account",
    x = NULL, y = NULL, colour = NULL,
    caption = "Source: World Bank Global Findex 2025"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")

p1
ggsave("outputs/01_account_trend.png", p1, width = 8, height = 5, dpi = 300, device = "png", bg = "white")

# Chart 2: gender gap in account ownership
p2 <- gender %>%
  ggplot(aes(x = year, y = account_t_d, colour = group2)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  scale_x_continuous(breaks = c(2011, 2014, 2017, 2021, 2024)) +
  labs(
    title = "Gender gap in account ownership, Uganda",
    subtitle = "Share of adults (15+) with an account, men vs women",
    x = NULL, y = NULL, colour = NULL,
    caption = "Source: World Bank Global Findex 2025"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")

ggsave("outputs/02_gender_gap.png", p2, width = 8, height = 5, dpi = 300, device = "png", bg = "white")