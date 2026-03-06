#libraries
library(dplyr)
library(tidyr)

#read in the dataset
df <- read.csv("C:/Users/marcu/Github/electric-vehicles/Dataset/Electric_Vehicle_Population_Data.csv")

#data cleaning
clean_df <- df %>%
  rename_all(~ gsub("\\.","_", .)) %>%
  mutate(
    Tesla = if_else(Make == "TESLA","TESLA","OTHER")
  )

# 1. What percentage of EVs in Washington are Teslas? 42.9%
# how to find: teslas/all vehicles * 100
total_vehicles <- nrow(clean_df)
tesla_vehicles <- clean_df %>% filter(Tesla == "TESLA") %>% nrow()
tesla_market_share <- round(tesla_vehicles/total_vehicles * 100, 1)

# 2. Top Tesla Models Selling in the area
# - How much are we making from these models?