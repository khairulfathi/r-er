# url : 
#   1. https://www.programmableweb.com/news/how-to-access-any-restful-api-using-r-language/how-to/2017/07/21?page=2
#   2. https://github.com/huseinzol05/Stock-Prediction-Models/blob/master/misc/kijang-emas-bank-negara.ipynb

# import required packages
require("httr")
require("jsonlite")
require("dplyr")
require("tidyverse")

# call 2018 data
data_2018 <- data.frame()

for(i in 1:12)
{
  resp_2018 <- GET(paste("https://api.bnm.gov.my/public/kijang-emas/year/2018/month/", i, sep = ""), add_headers(Accept = "application/vnd.BNM.API.v1+json"), user_agent("insomnia/6.3.2"))
  text_2018 <- content(resp_2018, "text")
  json_2018 <- fromJSON(text_2018, flatten = TRUE)
  
  data_2018 <- bind_rows(data_2018, json_2018)
  
  i <- i + 1
}

one_selling <- na.omit(data_2018[c(1,3)])
one_selling$effective_date <- as.Date(one_selling$effective_date, "%Y-%m-%d")

ggplot(one_selling, aes(effective_date, one_oz.selling)) + geom_point()
