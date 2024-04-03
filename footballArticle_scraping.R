# Automated Web Scraping in R


#Uncomment this to install this package
#install.packages("rvest") 
#install.packages("tidyverse")
#install.packages("lubridate")
#install.packages("stringr")
#install.packages("LSAfun")


#library
library(rvest) # extracting html information
library(tidyverse) # manipulating data
library(lubridate) # formatting dates
library(stringr) # for cleaning text
library(LSAfun) # for getting string summaries

# Reading the html link for R
football_wbpg <- read_html("https://theconversation.com/english-football-is-ready-for-a-rule-change-when-it-comes-to-financial-management-217034")


# Getting the title of the article
football_wbpg %>%
  html_node("title") %>% #See HTML source code for data within this tag
  html_text()

# Getting the paragraphs of the article using the p tag
football_wbpg %>%
  html_nodes("p") %>% #See HTML source code for data within this tag
  html_text()


# getting a list of football articles
football_articles <- read_html("https://theconversation.com/uk/topics/english-football-11193")

# getting the webpages of each article
webpg <- football_articles %>%
  html_elements("h2")

# getting the headers of each article
headers <- article %>%
  html_nodes("a") %>% 
  html_text()

# getting the URLs of each article
link <- article %>% 
  html_elements("a") %>% 
  html_attr("href")

mainLink <- "https://theconversation.com"

# Concatenate the text from each link onto mainLink
concatenated_links <- paste0(mainLink, link)


# getting the date and time
time <- football_articles %>% 
  html_elements("header") %>% html_elements("time") %>% 
  html_attr("datetime")

# Cleaning the time data by removing some letters
time_clean <- gsub("T", " ", time) 
time_clean2 <- gsub("Z", "", time_clean)


# setting the date time format
datetime_parse <- parse_date_time(time_clean2, "%Y-%m-%d %H:%M:%S")


# Converting to USA Eastern timezone
datetime_convert <- ymd_hms(datetime_parse, tz = "US/Eastern")
datetime_convert

#Converting to USA Pacific
datetime_convert <- with_tz(datetime_convert, "US/Pacific")
datetime_convert


# Creating a dataframe
footballArticle <- data.frame(Article = headers, URL = concatenated_links, Date = datetime_convert)

View(footballArticle)


# Collecting paragraphs from each article
bodies <- c()

for (i in footballArticle$URL){
  
  article_webpg <- read_html(i)
  body <- article_webpg %>% 
    html_nodes("p") %>% 
    html_text()
  
# After obtaining the text content, the code 
# concatenates all the text paragraphs into a single string
  one_body <- paste(body, collapse = " ")
  bodies <- append(bodies, one_body) # appends the concatenated text body to the vector bodies
}


# Adding the bodies column into the dataframe
footballArticle$Body <- bodies
View(footballArticle)

# Cleaning up the strings
clean_text_bodies <- str_squish(footballArticle$Body)
clean_text_bodies[1]

# Replacing the previous paragraph body with a clean paragraph body
footballArticle$Body <- clean_text_bodies