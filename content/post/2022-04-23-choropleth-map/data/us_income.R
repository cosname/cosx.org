library(tidycensus)
library(sf)
library(ggplot2)
library(showtext)
showtext_auto()

# 美国各州家庭月收入
us_income_state <- get_acs(
  geography = "state",
  variables = "B19013_001",
  geometry = TRUE, shift_geo = TRUE,
  year = 2019, survey = "acs5", moe_level = 90
)
# 美国各郡家庭月收入
us_income_county <- get_acs(
  geography = "county",
  variables = "B19013_001",
  geometry = TRUE, shift_geo = TRUE,
  year = 2019, survey = "acs5", moe_level = 90
)

# 保存数据
saveRDS(us_income_state, file = "Desktop/us_income_state.rds")
saveRDS(us_income_county, file = "Desktop/us_income_county.rds")

ggplot() +
  geom_sf(
    data = us_income_state, aes(fill = estimate/10000), colour = NA
  ) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey80") +
  coord_sf(crs = st_crs("ESRI:102003")) +
  labs(
    fill = "家庭月收入", title = "2015-2019 年度美国各州家庭月收入",
    caption = "数据源：美国人口调查局"
  ) +
  theme_void(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5))

# 各郡家庭月收入分布
hist(us_income_county$estimate)

ggplot() +
  geom_sf(
    data = us_income_county, aes(fill = estimate/10000), colour = NA
  ) +
  geom_sf(
    data = us_income_state,
    colour = alpha("gray80", 1 / 4), fill = NA, size = 0.15
  ) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey80") +
  coord_sf(crs = st_crs("ESRI:102003")) +
  labs(
    fill = "家庭月收入", title = "2015-2019 年美国各郡家庭月收入",
    caption = "数据源：美国人口调查局"
  ) +
  theme_void(base_size = 13) +
  theme(plot.title = element_text(hjust = 0.5))
