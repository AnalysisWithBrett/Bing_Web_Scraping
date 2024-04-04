# IMdb webscraping

# install.packages(rvest)
# install.packages(tidyverse)
# install.packages(writexl)

# library 
library(tidyverse)
library(rvest)
library(writexl)


# Set your working directory. For exxample:
setwd("C:\\Users\\hoybr\\Documents\\coding tutorial\\web scraping")  


# Getting the link of the IMbd website
link <- "https://www.imdb.com/search/title/?title_type=feature&num_votes=25000,&genres=adventure&sort=user_rating,desc"

# Reading the html link into R
page <- read_html(link)


# Obtaining the titles of the films
name <- page %>% 
  html_nodes(".ipc-title__text") %>%
  html_text()

# Removing the numbers in the title
title_cleaned <- gsub("^\\d+\\.\\s*", "", name)

# Choosing movie titles only
title_cleaned <- title_cleaned[2:51]
  

# Extract the year of release, duration and content
info_movie <- page %>% 
  
  # original - sc-b0691f29-8 ilsLEX dli-title-metadata-item. Replace spaces with '.'
  html_elements(".sc-b0691f29-8.ilsLEX.dli-title-metadata-item") %>% 
  html_text2()

# Using arithmetic sequence to split up years, duration of movie and movie content apart
list_number <- (0:49)
year_seq <- (1 + (3 * (list_number)))
duration_seq <- (2 + (3 * list_number))
content_seq <- (3 + (3 * list_number))


# Using for loop to split up the information
for (i in info_movie){
  years <- as.integer(info_movie[year_seq]) # converting to integer for year
  duration <- info_movie[duration_seq]
  content <- info_movie[content_seq]
}



# Extracting the ratings
rating <- page %>% 
  html_elements(".ipc-rating-star.ipc-rating-star--base.ipc-rating-star--imdb.ratingGroup--imdb-rating") %>% 
  html_text2()

# Extract decimal number from each string
movie_rating <- as.numeric(substr(rating, 1, 3))




# Extracting the movie details
synopsis <- page %>% 
  html_elements('.ipc-html-content-inner-div') %>% 
  html_text2()




# Storing the variables in the dataframe
movie <- data.frame(Title = title_cleaned, Year = year, Duration = duration,
                    Content = content, Synopsis = synopsis)


# Exported in excel file to your working directory
write_xlsx(movie, "movies.xlsx")
