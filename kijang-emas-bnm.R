# url : 
#   1. https://www.programmableweb.com/news/how-to-access-any-restful-api-using-r-language/how-to/2017/07/21?page=2
#   2. https://github.com/huseinzol05/Stock-Prediction-Models/blob/master/misc/kijang-emas-bank-negara.ipynb

# import required packages
require("httr")
require("jsonlite")
require("dplyr")
require("tidyverse")

# initialize empty data frame
data <- data.frame()

for(y in 2014:2018)
{
  for(m in 1:12)
  {
    resp <- GET(paste("https://api.bnm.gov.my/public/kijang-emas/year/", y, "/month/", m, sep = ""), add_headers(Accept = "application/vnd.BNM.API.v1+json"), user_agent("insomnia/6.3.2"))
    text <- content(resp, "text")
    json <- fromJSON(text, flatten = TRUE)
    
    data <- bind_rows(data, json)
    
    m <- m + 1
  }
  
  Sys.sleep(10) # to avoid API limit error 
  y <- y + 1
}

# drop un-necessary variables and empty rows
data <- data[!names(data) %in% c("last_updated", "total_result")]
data <- na.omit(data)

# format effective_date as Date class
data$effective_date <- as.Date(data$effective_date, "%Y-%m-%d")

# plot simple graph
ggplot(data, aes(data$effective_date, data$one_oz.selling)) + geom_point()