# 04_inequality.R
# Who is left behind? Account ownership by group in Uganda, 2024

library(tidyverse)

# Reuse the Uganda data prepared in script 02
source("scripts/02_explore_uganda.R")

# Keep 2024 only, and the groups we want to compare
gaps <- uganda %>%
  filter(year == 2024, group != "all", group != "laborforce") %>%
  mutate(
    category = recode(group,
      gender = "Gender",
      age_cat = "Age",
      education = "Education",
      income = "Income",
      urbanicity = "Location"
    ),
    label = str_to_title(group2)
  ) %>%
  select(category, label, account_t_d)

gaps

# Chart 3: account ownership by group, 2024
p3 <- ggplot(gaps, aes(x = account_t_d, y = reorder(label, account_t_d))) +
  geom_col(fill = "#1b9e77", width = 0.7) +
  geom_text(aes(label = scales::percent(account_t_d, accuracy = 0.1)),
            hjust = -0.1, size = 4) +
  scale_x_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(
    title = "Who has an account? Uganda, 2024",
    subtitle = "Share of adults (15+) with an account, by group",
    x = NULL, y = NULL,
    caption = "Source: World Bank Global Findex 2025"
  ) +
  theme_minimal(base_size = 14)

ggsave("outputs/03_inequality.png", p3, width = 8, height = 6, dpi = 300, device = "png", bg = "white")