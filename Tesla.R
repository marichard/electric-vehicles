#libraries
library(dplyr)
library(tidyr)

#read in the dataset
df <- read.csv("C:/Users/marcu/Github/electric-vehicles/Dataset/Electric_Vehicle_Population_Data.csv")

#data cleaning
clean_df <- df %>%
  rename_all(~ gsub("\\.","_", .)) %>%
  mutate(
    Base_MSRP = as.numeric(Base_MSRP),
    Tesla = if_else(Make == "TESLA","TESLA","OTHER")
  )

# 1. What percentage of EVs in Washington are Teslas? 42.9%
# how to find: teslas/all vehicles * 100
total_vehicles <- nrow(clean_df)
tesla_vehicles <- clean_df %>% filter(Tesla == "TESLA") %>% nrow()
tesla_market_share <- round(tesla_vehicles/total_vehicles * 100, 1)

# 2. Top Tesla Models Selling in the area
# - How much are we making from these models?
make_model_sold <- clean_df %>%
  filter(Tesla == "TESLA") %>%
  group_by(Make,Model) %>%
  summarise(count_sold = n(), .groups = "drop") %>%
  arrange(desc(count_sold))

msrp_by_year <- clean_df %>%
  filter(Base_MSRP > 0) %>%
  filter(Tesla == "TESLA") %>%
  group_by(Model_Year, Make, Model) %>%
  summarise(min(Base_MSRP)) %>%
  arrange(Model_Year, Make, Model)

# had to bring in online dataset to complete
df_tesla_prices <- read.csv("C:/Users/marcu/Github/electric-vehicles/Dataset/Tesla_Current_Base_Prices.csv")

# transform data
df_tesla_prices <- df_tesla_prices %>%
  mutate(
    Model = toupper(Model)
  )

# get numbers
Top_Tesla_Models_Priced <- make_model_sold %>%
  left_join(df_tesla_prices, by = "Model") %>%
  mutate(
    Estimate_revenue = as.numeric(count_sold) * as.numeric(Base_Price_USD)
  )

# Final estimates for lifetime sales
Top_Tesla_Models_Priced <- Top_Tesla_Models_Priced %>%
  filter(!is.na(Estimate_revenue)) %>%
  group_by(Model) %>%
  slice_min(Base_Price_USD) %>%
  ungroup()