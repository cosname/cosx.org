# 原始地图文件
# https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_county_20m.zip
# https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_state_20m.zip

rm(list = ls())
source(file = "shift-geometry2.R")

###################################################################
# 州级区划地图数据
###################################################################

library(sf)
us_states <- read_sf("cb_2020_us_state_20m/cb_2020_us_state_20m.shp")
us_states_shifted <- shift_geometry2(us_states)

# 查看数据
library(ggplot2)
ggplot(us_states) +
  geom_sf() +
  theme_void()

ggplot(us_states_shifted) +
  geom_sf() +
  theme_void()

# 坐标参考系 ESRI:102003
st_crs(us_states_shifted)
# 保存数据
saveRDS(us_states_shifted, file = "us_states_shifted.rds")

###################################################################
# 区县级区划地图数据
###################################################################

us_county <- read_sf("cb_2020_us_county_20m/cb_2020_us_county_20m.shp")
us_county_shifted <- shift_geometry2(us_county)
# 查看数据
ggplot(us_county) +
  geom_sf() +
  theme_void()

ggplot(us_county_shifted) +
  geom_sf() +
  theme_void()

# 保存数据
saveRDS(us_county_shifted, file = "us_county_shifted.rds")

###################################################################
# 普查级区划地图数据
###################################################################
# https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html
# 数据源 Source: US Census Bureau, Geography Division

# 选择 2019年 选择 FTP Archive 选择 Census Tract 选择 North Carolina 下载 Zip 压缩文件
# https://www2.census.gov/geo/tiger/TIGER2019/TRACT/tl_2019_37_tract.zip
us_nc_tract <- read_sf("tl_2019_37_tract/tl_2019_37_tract.shp")
us_nc_tract
# 检查数据
plot(st_geometry(us_nc_tract))
saveRDS(us_nc_tract, file = "us_nc_tract.rds")

load(file = "nc_race_income.RData")

us_nc_tract_2019 = merge(x = us_nc_tract, y = nc_tract_race_income, by = "GEOID")

us_nc_tract_2019 <- within(us_nc_tract_2019, {
  pctWhite <- B02001_002E / B02001_001E
  medInc <- B19013_001E
})

# 才 2195 个多边形区域
plot(us_nc_tract_2019["medInc"],
  pal = viridisLite::plasma,
  breaks = c(seq(0, 10, 1), 15, 20, 25) * 10000,
  border = "gray", main = "", lwd = 0.25
)

# 部分调查区域的收入数据缺失

range(us_nc_tract_2019["medInc"]$medInc, na.rm = T)

hist(us_nc_tract_2019["medInc"]$medInc)
# 添加区县边界
plot(st_geometry(nc_county_map), border = "white")
