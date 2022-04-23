
library(tidycensus)
options(tigris_use_cache = TRUE)
# 有哪些变量可以用
acs_vars <- load_variables(year = 2019, dataset = "acs5")
View(acs_vars)
# 去掉行政边界数据可以顺利下载
orange <- get_acs(
  state = "CA", county = "Orange", geography = "tract",
  variables = "B19013_001", geometry = F,
  year = 2019, survey = "acs5", moe_level = 90
)
# state 可以用名称或 FIPS 码
# county 可以用县的名称或 FIPS 码
#
# moe_level 置信水平
# B19013_001 是变量的编码，过去12个月家庭收入的中位数，已根据 2019 年的美国通货膨胀情况调整，这种调整使得各个年份的数据是可比的
# 详细的说明见 dat[dat$name == 'B19013_001',]

# 查看州名和缩写
state.name
state.abb
library(maps)
# 查看州和县的名称和代码 county_code
# North Carolina
fips_codes[fips_codes$state == "NC", ]

# 2015-2019 年 5-year 北卡各个县的普查级的 ACS 调查数据
# Census Tract 普查单元
nc_tract <- get_acs(
  state = "NC", # county = c("Washington", "Scotland"),  # 可以限定县
  geography = "tract",
  variables = "B19013_001", geometry = F,
  year = 2019, survey = "acs5", moe_level = 90
)

# 县级数据
nc_county <- get_acs(
  state = "NC",
  geography = "county",
  variables = "B19013_001", geometry = F,
  year = 2019, survey = "acs5", moe_level = 90
)

library(sf) # 县级的地图数据
# 读取数据，且读取后不要转化为 tibble 数据类型
nc_map <- read_sf(system.file("gpkg/nc.gpkg", package = "sf"), as_tibble = FALSE)
# 县级地图数据和 ACS 调查数据合并
nc_county_data <- merge(x = nc_map, y = nc_county, by.x = "FIPS", by.y = "GEOID")

# 绘制北卡各个县的收入数据
library(ggplot2)
ggplot(data = nc_county_data, aes(fill = estimate)) +
  geom_sf(color = NA) +
  coord_sf(crs = 4267) +
  scale_fill_viridis_c(option = "plasma")

# 保存可获得的变量名，北卡普查级、郡县级的 ACS 调查数据
save(acs_vars, nc_tract, nc_county, file = "~/Desktop/us_census_acs_nc.RData")
