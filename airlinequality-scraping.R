setwd("~/Desktop/Modisha/Freelance/airlinequality-scraping")

library(tidyverse)  
library(rvest)
library(glob2rx)

for (page in 1:92) {
  #access the url and extract the content, one page at a time
  url <- paste0("https://www.airlinequality.com/airline-reviews/southwest-airlines/page/", page)
  print(url)
  h <- read_html(url)
  
  #retrieve review date
  date <- h %>% html_nodes("time") %>% html_text()
  
  #retrieve the review
  review <- h %>% html_nodes(".text_content") %>% html_text()
  
  #retrieve the recommended field
  selector = '//*[contains(concat( " ", @class, " " ), concat( " ", "review-value rating-yes", " " ))]|//*[contains(concat( " ", @class, " " ), concat( " ", "review-value rating-no", " " ))]'
  recommended <- h %>% html_nodes(xpath = selector) %>% html_text()
  
  #gather everything on to a data frame
  output <- data.frame(date, review, recommended)
  
  #write the data to a csv
  write.table(output, file = "southwest-airlines.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = TRUE)
}

