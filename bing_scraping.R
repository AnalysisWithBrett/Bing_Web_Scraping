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
url <- "https://www.bing.com/search?q=R+User+Groups&sp=-1&gch=1&1q=0&pq=r+user+group&sc=10-12&qs=n&sk=&cvid=64380926D8A64535A12305FB86740629&ghsh=0&ghacc=0&ghpl=&FPIG=F515DEFCDB7440F681458E6C19149D3F&first=1&FORM=PERE"

# Reading the html and storing it
first_page <- read_html(url)


# getting the <a> body that contains the links
pages <- first_page %>% 
  html_elements("h2") %>% 
  html_elements("a")
pages

# getting the title of each links
headings <- pages %>%
  html_text()
headings

# getting the links
links <- pages %>% 
  html_attr("href")
links

# putting all this together iinto a dataframe
bing_result <- data.frame(
  Headings = headings,
  URL = links
)

# seeing the dataframe
View(bing_result)

# getting the results from the first three pages using a loop
for (j in 1:3){
  pg = 1 + (j * 10) - 10
  
  # this opens up a page with any number given by j
  url <- paste0("https://www.bing.com/search?q=R+User+Groups&sp=-1&gch=1&1q=0&pq=r+user+group&sc=10-12&qs=n&sk=&cvid=64380926D8A64535A12305FB86740629&ghsh=0&ghacc=0&ghpl=&FPIG=F515DEFCDB7440F681458E6C19149D3F&first=",j,"&FORM=PERE")
  first_page <- read_html(url)
  html_text(first_page)
  
  pages <- first_page %>% 
    html_elements("h2") %>% 
    html_elements("a")
  
  headings <- pages %>% 
    html_text()
  
  links <- pages %>% 
    html_attr("href")
  
  output <- data.frame(
    Headings = headings,
    URL = links
  )
  bing_results <- rbind(bing_result, output)
}


View(bing_results)
