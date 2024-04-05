# In case you dont have the following libraries:
# install.packages(rvest)
# install.packages(tidyverse)
# install.packages(XML)


# Libraries
library(tidyverse)
library(rvest)
library(XML)



# Scraping from bing

# Storing the link into a variable
url <- "https://www.etsy.com/uk/c/clothing?ref=catnav-374"

# Reading the html and storing it
first_page <- read_html(url)


# getting the links fo each listing
listing_links <- first_page %>% 
  html_elements(".js-merch-stash-check-listing") %>% 
  html_element("a") %>% 
  html_attr("href")


# Getting the names of each listings
get_name <- function(item){
  
  open_listing <- read_html(item)
  
  name <- open_listing %>% 
    html_elements(".wt-text-body-01.wt-line-height-tight.wt-break-word.wt-mt-xs-1") %>% 
    html_text2()
  
  return(name)
}

listing_names <- sapply(listing_links, FUN = get_name, USE.NAMES = FALSE)

# Getting the prices of each listings
get_price <- function(item){
  
  open_listing <- read_html(item)
  
  price <- open_listing %>% 
    html_elements(".wt-text-title-larger.wt-mr-xs-1") %>% 
    html_text2() %>% gsub("Price: ", "", .)
  
  return(price)
}

listing_price <- sapply(listing_links, FUN = get_price, USE.NAMES = FALSE)
listing_price

pages <- data.frame()

for (listing_page in seq(from = 1, to = 3, by = 1)) {
  link <- paste0("https://www.etsy.com/uk/c/clothing?ref=pagination&page=", listing_page)
  
  page <- read_html(link)
  
  # Getting the links for each listing
  listing_links <- page %>% 
    html_elements(".js-merch-stash-check-listing") %>% 
    html_element("a") %>% 
    html_attr("href")
  
  listing_names <- sapply(listing_links, FUN = get_name, USE.NAMES = FALSE)
  listing_price <- sapply(listing_links, FUN = get_price, USE.NAMES = FALSE)
  
  # Combine names and prices into a dataframe and bind it to pages
  page_data <- data.frame(Product = unlist(listing_names), Price = unlist(listing_price), stringsAsFactors = FALSE)
  pages <- rbind(pages, page_data)
  
  # Print current page number
  print(paste("Page:", listing_page))
}

View(pages)
