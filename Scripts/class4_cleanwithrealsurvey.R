################################################################
############ CLEANING & PREPARING REAL DATA IN R ###############
################################################################

##### this script shows how the fundamentals of cleaning data
##### with the famous dplyr library (part of the tidyverse) suit
##### of packages

##### make the library installer of choice is installed
##### this library is called "pacman"
if (sum(installed.packages()[,1] %in% "pacman") != 1){

  install.packages("pacman")

}

#### load necessary libraries
pacman::p_load(tidyverse)

#### prepare the beneficiary data to create the expenditure variables
file_dir <- "data-raw/data-cleaning-session/beneficiary_data"

exp_dt <- haven::read_sav(paste(file_dir, "expenditure.sav", sep = "/"))

#### explore the data a little bit
dplyr::glimpse(exp_dt)
head(exp_dt)
tail(exp_dt)

##### create an household level expenditure dataset
tapply(exp_dt$S6Q2)

### rename the variables to have more expressive names
exp_dt <-
  exp_dt %>%
  rename(totexp7 = S6Q2,
         totexp30 = S6Q4)

exp_dt <-
  exp_dt %>%
  rename(own_land = S2Q1,
         amt_landq = S2Q2Q,
         amt_landu = S2Q2U,
         amt_land_hhq = S2Q3AQ,
         amt_land_hhu = S2Q3AU,
         amt_fallowq = S2Q4AQ,
         amt_fallowu = S2Q4AU,
         amt_land_agprod = S2Q6Q,
         anymember_plant = S3Q1,
         worriedaboutfood = S8Q1,
         wholeday_starve = S8Q8)


totexp_dt <-
  exp_dt %>%
  group_by(interview__id, interview__key) %>%
  summarize(totexp7 = sum(totexp7, na.rm = TRUE), totexp30 = sum(totexp30, na.rm = TRUE))

### old plotting histograms
hist(totexp_dt$totexp7)
hist(totexp_dt$totexp30)

totexp_dt %>%
ggplot() +
  geom_histogram(aes(x = log(totexp7))) +
  xlab("Log Total Expenditure (7 day recall)") +
  ylab("Frequency") +
  ggtitle("Distribution of Beneficiary Expenditure")

### can you plot the graph for the 30 day recall?

#### prepare some variables from the advise dataset
advise_dt <- haven::read_sav(paste(file_dir, "advise.sav", sep = "/"))




#### prepare some variables from the assets dataset
asset_dt <- haven::read_sav(paste(file_dir, "assets.sav", sep = "/"))

asset_dt <-
  asset_dt %>%
  rename(own_land = S2Q1,
         amt_landq = S2Q2Q,
         amt_landu = S2Q2U,
         amt_land_hhq = S2Q3AQ,
         amt_land_hhu = S2Q3AU,
         amt_fallowq = S2Q4AQ,
         amt_fallowu = S2Q4AU,
         amt_land_agprod = S2Q6Q,
         anymember_plant = S3Q1,
         worriedaboutfood = S8Q1,
         wholeday_starve = S8Q8) %>%
  recode(across(c(anymember_plant, worriedaboutfood, wholeday_starve),
                ~ recode(as.numeric(.x), `2` = 0)))


#### running some regressions in R













