# 从国家癌症研究机构获取2000年美国标准人口分组
library(xml2) # read_html
library(magrittr)
library(rvest) # html_table/html_element
# https://seer.cancer.gov/stdpopulations/stdpop.19ages.html
us_std_pop <- read_html("https://seer.cancer.gov/stdpopulations/stdpop.19ages.html")
# 提取表格数据
us_std_pop_df <- us_std_pop %>%
  html_element("table") %>%
  html_table(header = T)
# 清理表头
colnames(us_std_pop_df) <- gsub(x = colnames(us_std_pop_df), pattern = "(\r|\n|\t)", replacement = "", perl = T)
# 保存数据
saveRDS(us_std_pop_df, file = "~/Desktop/us_std_pop.rds")

us_std_pop <- readRDS(file = "data/us_std_pop.rds")
# 去掉汇总列
us_std_pop <- subset(x = us_std_pop, subset = Age != "Total", select = setdiff(colnames(us_std_pop), "2000 U.S. Standard Population (Census P25-1130)"))
# 继续清理表头
colnames(us_std_pop) <- gsub(x = colnames(us_std_pop), pattern = "( U.S. Standard Million)", replacement = "", perl = T)
# 清理 Age 列
us_std_pop$Age <- gsub(x = us_std_pop$Age, pattern = "( years)", replacement = "", perl = T)

us_std_pop
# 数据重塑，宽格式变长格式，准备用 ggplot2 绘图
us_std_pop_reshape <- reshape(
  data = us_std_pop, varying = c(
    "2000", "1990", "1980", "1970",
    "1960", "1950", "1940"
  ),
  times = c(
    "2000", "1990", "1980", "1970",
    "1960", "1950", "1940"
  ),
  v.names = "Pop", # 人口数量
  timevar = "Year", # 年份
  idvar = "Age", # 年龄段
  new.row.names = 1:(7 * 19),
  direction = "long"
)
us_std_pop_reshape
# 去掉所有的逗号
us_std_pop_reshape$Pop <- gsub(x = us_std_pop_reshape$Pop, pattern = "(,)", replacement = "")
# 人口数转为整型
us_std_pop_reshape$Pop <- as.integer(us_std_pop_reshape$Pop)

library(ggplot2)

# 人口年龄结构图
ggplot(data = us_std_pop_reshape, aes(x = Year, y = Pop / 1000000)) +
  geom_col(aes(fill = Age), position = "stack") +
  scale_y_continuous(labels = scales::percent, n.breaks = 10) +
  labs(y = "Pop (%)")
