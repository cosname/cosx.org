rm(list = ls())
library(tidycensus)
options(tigris_use_cache = TRUE)
# 下载 NC tract level 行政边界数据
# 下载失败是因为网络问题，可去美国统计局官网下载
nc_tract_map <- tigris::tracts(state = 37, cb = T, year = 2021, class = "sf")
# ACS 调查区域的大小和居民的居住密度有关系
# 调查区域包含的人口应在在 1200-8000，最好在 4000 人

###################################################################
# 普查级：收入和白人占比数据
###################################################################

# 家庭收入中位数 B19013_001
# 白人占比 变量代码 2015-2019 年度收入数据
nc_tract_income <- get_acs(
  state = "NC", 
  geography = "tract",
  variables = "B19013_001", 
  geometry = F, output = "wide", 
  year = 2019, survey = "acs5", 
  moe_level = 90
)

# B02001_001 总人口数 Estimate!!Total
# B02001_002 白人数 Estimate!!Total!!White alone
# 白人占比 pctWhite = B02001_002E / B02001_001E
# 种族数据
nc_tract_race <- get_acs(
  year = 2019, geography = "tract",
  state = 37, 
  output = "wide", survey = "acs5", 
  variables = c("B02001_001E", "B02001_002E")
)
# 收入数据和白人占比数据合并
nc_tract_race_income <- merge(x = nc_tract_income, y = nc_tract_race, by = c("GEOID", "NAME"))

###################################################################
# 区县级：收入和白人占比数据
###################################################################

# 家庭收入中位数 B19013_001
# 白人占比 变量代码 2015-2019 年度收入数据
nc_county_income <- get_acs(
  state = "NC", 
  geography = "county",
  variables = "B19013_001", 
  geometry = F, output = "wide", 
  year = 2019, survey = "acs5", 
  moe_level = 90
)

# B02001_001 总人口数 Estimate!!Total
# B02001_002 白人数 Estimate!!Total!!White alone
# 白人占比 pctWhite = B02001_002E / B02001_001E
# 种族数据
nc_county_race <- get_acs(
  year = 2019, geography = "county",
  state = 37, 
  output = "wide", survey = "acs5", 
  variables = c("B02001_001E", "B02001_002E")
)
# 收入数据和白人占比数据合并
nc_county_race_income <- merge(x = nc_county_income, y = nc_county_race, by = c("GEOID", "NAME"))

# 保存北卡普查级、郡县级数据
save(nc_tract_race_income, nc_county_race_income, file = "nc_race_income.RData")

