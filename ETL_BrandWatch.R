install.packages("readxl")
library("readxl")

df <- read_excel(file.choose())
df <- as.data.frame(df)


associations <- str_c(df$`Association Name`, collapse = "\" OR \"")
associations <- paste0("\"", associations, "\"")
associations <- str_replace_all(associations, "OR \"\" OR", " OR ")
write(associations, file = "C:\\temp\\associations.txt")

fb_accounts <- str_remove_all(df$Facebook, "(http(s)*:)*(//)*((www)*(.)*[Ff]acebook)*(.com)*(/pages/)*|-[^-]*$|\\?[^\\?]*$|/|.org") %>%
  str_remove_all("-[^-]*$|\\?[^\\?]*$|/|.org") %>% str_remove_all("status(\\d+)$") %>% str_remove_all("explorelocations(\\d+)(\\s*)") %>%
  str_replace_all("-"," ") %>%  na.omit()
fb_accounts <- str_c(fb_accounts, collapse = "\" OR \"")
fb_accounts <- paste0("\"", fb_accounts, "\"")
fb_accounts <- str_replace_all(fb_accounts, "OR \"\" OR", " OR ")
fb_accounts
write(fb_accounts, file = "C:\\temp\\fb_accounts.txt")


twitter_accounts <- str_remove_all(df$Twitter, "(http(s)*:)*(//)*((www)*(.)*[Tt]witter)*(.com)*(/pages/)*") %>%
  str_remove_all("-[^-]*$|\\?[^\\?]*$|/|.org") %>% str_remove_all("status(\\d+)$") %>%  str_replace_all("-"," ") %>% 
  str_remove_all("explorelocations(\\d+)(\\s*)") %>%  na.omit()
twitter_accounts <- str_c(twitter_accounts, collapse = "\" OR \"")
twitter_accounts <- paste0("\"",twitter_accounts, "\"")
twitter_accounts <- str_replace_all(twitter_accounts, "OR \"\" OR", " OR ")
twitter_accounts
write(twitter_accounts, file = "C:\\temp\\twitter_accounts.txt")


instagram_accounts <- str_remove_all(df$Instagram, "(http(s)*:)*(//)*((www)*(.)*[Ii]nstagram)*(.com)*(/pages/)*") %>%
  str_remove_all("-[^-]*$|\\?[^\\?]*$|/|.org") %>% str_remove_all("status(\\d+)$") %>% str_remove_all("explorelocations(\\d+)(\\s*)") %>% 
  str_replace_all("-"," ") %>%  na.omit()
instagram_accounts <- str_c(instagram_accounts, collapse = "\" OR \"")
instagram_accounts <- paste0("\"", instagram_accounts, "\"")
instagram_accounts <- str_replace_all(instagram_accounts, "OR \"\" OR", " OR ")
instagram_accounts
write(instagram_accounts, file = "C:\\temp\\instagram_accounts.txt")


/*
all_accounts <- str_c(associations,twitter_accounts, fb_accounts, instagram_accounts, sep = " OR ")
all_accounts <- str_remove_all(all_accounts, "\"\"")
all_accounts <- str_replace_all(all_accounts, "OR  OR", " OR ")
str(all_accounts)
write(all_accounts, file = "C:\\temp\\sdge_partners_query_bw.txt")
*/


