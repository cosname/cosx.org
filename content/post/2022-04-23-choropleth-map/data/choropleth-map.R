library(tidycensus)
library(sf)
options(tigris_use_cache = TRUE)
Sys.setenv(CENSUS_API_KEY="YOUR_KEY")

# -------------------------------------------------
# 北卡家庭月收入和白人数量
# -------------------------------------------------
## 郡级
nc_income_race_county <- get_acs(
  state = "NC",
  geography = "county",
  variables = c("B19013_001", "B02001_001E", "B02001_002E"),
  geometry = TRUE, output = "wide",
  year = 2019, survey = "acs5",
  moe_level = 90
)
## 社区级
nc_income_race_tract <- get_acs(
  state = "NC",
  geography = "tract",
  variables = c("B19013_001", "B02001_001E", "B02001_002E"),
  geometry = TRUE, output = "wide",
  year = 2019, survey = "acs5",
  moe_level = 90
)
## 查看郡级收入分布
plot(nc_income_race_county["B19013_001E"])
## 查看社区级收入分布
plot(nc_income_race_tract["B19013_001E"])

### 社区级家庭月收入的空间分布
showtext::showtext_auto()
par(mar = c(2, 0, 0, 0))
plot(nc_income_race_tract["B19013_001E"],
     key.pos = 1,
     pal = viridisLite::plasma, reset = FALSE,
     breaks = c(0:10, 15, 20, 25) * 10000,
     border = "gray80", main = "", lwd = 0.1
)
### 添加郡边界
plot(st_geometry(nc_income_race_county), border = "gray", lwd = 0.25, add = TRUE)
mtext(text = "数据源：美国人口调查局", side = 1, adj = 0.05)

## 保存数据
saveRDS(nc_income_race_county, file = "Desktop/nc_income_race_county.rds")
saveRDS(nc_income_race_tract, file = "Desktop/nc_income_race_tract.rds")

# -------------------------------------------------
# 北卡地图数据
# -------------------------------------------------
## NC 社区普查级地图数据
nc_tract_map <- tigris::tracts(state = 37, cb = T, year = 2019, class = "sf")
## NC 郡级地图数据
nc_county_map <- tigris::counties(state = 37, cb = T, year = 2019, class = "sf")
## 保存地图数据
saveRDS(nc_county_map, file = "Desktop/nc_county_map.rds")
saveRDS(nc_tract_map, file = "Desktop/nc_tract_map.rds")

# -------------------------------------------------
# 2019 年美国州、郡地图数据 比例尺 1:20 million
# -------------------------------------------------
# 州级地图数据
us_state_map <- tigris::states(cb = T, year = 2019, resolution = "20m", class = "sf")
us_state_map <- tigris::shift_geometry(us_state_map, geoid_column = "GEOID", position = "below")
# 郡级地图数据
us_county_map <- tigris::counties(cb = T, year = 2019, resolution = "20m", class = "sf")
us_county_map <- tigris::shift_geometry(us_county_map, geoid_column = "GEOID", position = "below")
# 保存地图数据
saveRDS(us_state_map, file = "Desktop/us_state_map.rds")
saveRDS(us_county_map, file = "Desktop/us_county_map.rds")
# 预览地图数据
plot(st_geometry(us_state_map))
plot(st_geometry(us_county_map))
