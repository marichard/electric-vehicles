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