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
