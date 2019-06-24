setwd("~/Desktop/Modisha/Freelance/chinese-tools-scraping")

library(tidyverse)  
library(rvest)
library(glob2rx)

for (page in 1:100) {
  #access the url and extract the content, one page at a time
  url <- paste0("https://www.chinese-tools.com/chinese/chengyu/dictionary/detail/", page, ".html")
  print(url)
  h <- read_html(url)
  
  #scrape the language section
  chengyu <- h %>% html_nodes(".ctCyT1") %>% html_text()
  pinyin <- h %>% html_nodes(".ctCyT2") %>% html_text()
  english <- h %>% html_nodes(".ctCyT3") %>% html_text()
  chengyu_word <- h %>% html_nodes(".ctCyC1") %>% html_text()
  pinyin_and_english_words <- h %>% html_nodes(".ctCyC2") %>% html_text()
  
  #enter blanks for unavailable fields
  if(length(chengyu) == 0){
    english <- "Chengyu"
    chengyu_word = ""
  }
  if(length(pinyin) == 0){
    english <- "Pinyin"
    pinyin_and_english_words[1] = ""
  }
  if(length(english) == 0){
    english <- "English"
    pinyin_and_english_words[2] = ""
  }
  
  #scrape "explanation" section
  header <- h %>% html_nodes(".ctCyInfoH") %>% html_text()
  data <- h %>% html_nodes(".ctCyInfoB") %>% html_text()

  
  chengyu_section <- data.frame(chengyu, chengyu_word, "")
  pinyin_section <- data.frame(pinyin, pinyin_and_english_words[1], "")
  english_section <- data.frame(english, pinyin_and_english_words[2], "")
  explanation <- data.frame(header, data, "")
  
  #write to CSV
  write.table(chengyu_section, file = "chinese-tools.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = FALSE)
  write.table(pinyin_section, file = "chinese-tools.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = FALSE)
  write.table(english_section, file = "chinese-tools.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = FALSE)
  write.table(explanation, file = "chinese-tools.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = FALSE)
  write.table("---------------------------------------------------------------", file = "chinese-tools.csv", append = TRUE, quote = FALSE, sep = "|", eol = "\r", row.names = FALSE, col.names = FALSE)
}
