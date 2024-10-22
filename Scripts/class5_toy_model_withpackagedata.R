#### A quick script to show how to develop poverty maps using package data and the
#### the post estimation diagnostics of interest
### load the functions I have written in the helper_functions file
source("Scripts/helper_functions.R")

### please see link below for details on poverty mapping using
### povmap package in R
"https://cran.r-project.org/web/packages/emdi/vignettes/vignette_emdi.pdf"

if (sum(installed.packages()[,1] %in% "pacman") != 1){

  install.packages("pacman")

}

#### start with some model selection
pacman::p_load(glmmLasso, nlme, MASS, povmap,
               dplyr, sf, ggplot2, viridis)

#### we will be using the sample and census data from povmap package
### load as follows:

### we want to load the povmap test datasets into the global environment
### in order to use it for poverty mapping estimation.
data("eusilcA_smp")
data("eusilcA_pop")


### check the distribution of income within eusilcA
hist(eusilcA_smp$eqIncome)  ### a histogram

### using the ggplot geom_histogram system to plot the distribution of welfare
eusilcA_smp %>%
  ggplot() +
  geom_histogram(aes(x = eqIncome))

eusilcA_smp %>%
  ggplot() +
  geom_histogram(aes(x = log(eqIncome))) +
  xlab("Log Income") +
  ylab("Frequency") +
  ggtitle("Distribution of Income in Austria") +
  theme_minimal()


### transform the income variable with a log transformation
eusilcA_smp$logeqIncome <- log(eusilcA_smp$eqIncome)

### another method of transforming the variable with dplyr::mutate()
eusilcA_smp %>%
  mutate(logeqIncome = log(eqIncome))

hist(eusilcA_smp$logeqIncome) ### another histogram


# eusilcA_smp$fake1 <- rnorm(nrow(eusilcA_smp)) + eusilcA_smp$logeqIncome*2
# eusilcA_smp$fake2 <- rnorm(nrow(eusilcA_smp), mean = 2, sd = 3) - eusilcA_smp$eqIncome
#
# eusilcA_pop$fake1 <- rnorm(nrow(eusilcA_pop)) + mean(eusilcA_smp$logeqIncome*2, na.rm = TRUE)
# eusilcA_pop$fake2 <- rnorm(nrow(eusilcA_pop), mean = 2, sd = 3)- mean(eusilcA_smp$eqIncome,
#                                                                       na.rm = TRUE)

### we are going to perform some variable selection but first I need to create a
### vector of the candidate set of variables that will be used in our analysis.

### We need to use regular expressions to subset the set of candidate variables from
### the data. Below is a link to extensive R document on the regular expressions
### (i.e. regex) system in R. Note there are packages like "stringr" and "stringi"
### in R that make this easier
"https://cran.r-project.org/web/packages/stringr/vignettes/regular-expressions.html"

candidate_vars <-
  colnames(eusilcA_smp)[!grepl(pattern = "Income|state|district|weight|gender",
                               x = colnames(eusilcA_smp))]






### test that we have the same distribution of variables
means_dt <-
  ebp_test_means(varlist = candidate_vars,
                 pop_data = eusilcA_pop,
                 smp_data = eusilcA_smp,
                 weights = "weight")

candidate_vars <- means_dt$variable[means_dt$pvalue > 0.05]

# eusilcA_smp$male <- ifelse(eusilcA_smp$gender == "male", 1, 0)

### create more variables that obviously work better


### try soccer data to see why the function might be failing
vselect_obj <-
lassoebp_vselect(dt = eusilcA_smp,
                 yvar = "logeqIncome",
                 domain = "district",
                 candidate_vars = candidate_vars,
                 scale = TRUE,
                 family = gaussian(link = "identity"),
                 return_onlyvars = FALSE)

vselect_obj <-
  vselect_obj$coefficients[vselect_obj$coefficients != 0]

vselect_obj <-
  names(vselect_obj)[!(names(vselect_obj) %in% "(Intercept)")]

## equivalent to the above is using the grepl text matching system
names(vselect_obj)[!grepl(pattern = "(Intercept)",
                          x = names(vselect_obj))]

#### now lets try to create a poverty map and some post estimation diagnostics
##### construct the formula by creating format:
##### "as.formula(yvar ~ var1 + var2 + var3 ....)"
model_formula <- as.formula(paste("eqIncome ~ ",
                                  paste(vselect_obj,
                                        collapse = " + ")))

unit_model <- povmap::ebp(fixed = model_formula,
                          pop_data = eusilcA_pop,
                          smp_data = eusilcA_smp,
                          smp_domains = "district",
                          pop_domains = "district",
                          L = 2,
                          threshold = 0.5*mean(eusilcA_pop$eqIncome,
                                               na.rm = TRUE),
                          transformation = "log",
                          MSE = TRUE,
                          B = 3,
                          weights = "weight",
                          pop_weights = "hhsize",
                          Ydump = "data-clean/simulated_ydump_aus.csv")

#### lets plot the results

plot(unit_model)

#### the above function produces plots for residual analysis
#### this shows how well the assumptions about normality
#### are met for the error residual (idiosyncratic errors)
#### and the random area effect (i.e. the ward specific
#### effect in the case of Zambia)

#### compare the distributions of the predicted welfare in census with
#### direct estimate welfare in the survey

predwelf_dt <- read.csv("data-clean/simulated_ydump_aus.csv")

### add a household ID to the census data
predwelf_dt <-
predwelf_dt %>%
  group_by(L) %>%
  mutate(hhid = 1:nrow(eusilcA_pop)) %>%
  ungroup() %>%
  group_by(hhid) %>%
  summarize(Simulated_Y = mean(Simulated_Y, na.rm = TRUE))

# avpredwelf_dt <-
#   predwelf_dt %>%
#   group_by(hhid) %>%
#   summarize(Simulated_Y = mean(Simulated_Y, na.rm = TRUE))

welf_dt <- rbind(predwelf_dt %>%
                   mutate(identifier = "census") %>%
                   select(Simulated_Y, identifier),
                 eusilcA_smp %>%
                   mutate(Simulated_Y = eqIncome) %>%
                   mutate(identifier = "survey") %>%
                   select(Simulated_Y, identifier)) %>%
  rename(welfare = Simulated_Y)


#### compare the distributions of survey and census
ggplot() +
  geom_histogram(aes(x = log(welf_dt$welfare[welf_dt$identifier == "survey"]),
                     y = ..density..,
                 fill = "survey"),
                 alpha = 0.3) +
  geom_histogram(aes(x = log(welf_dt$welfare[welf_dt$identifier == "census"]),
                     y = ..density..,
                 fill = "census"),
                 alpha = 0.3) +
  scale_fill_manual(values = c("census" = "blue",
                               "survey" = "red")) +
  xlab("Welfare") +
  ylab("Density") +
  ggtitle("Comparing the Distribution of Welfare in Census vs Survey") +
  theme_minimal()


#### quick post estimation diagnostics and tables that will go into your paper
direct_est <- direct(y = "eqIncome",
                     smp_data = eusilcA_smp,
                     smp_domains = "district",
                     weights = "weight",
                     var = TRUE,
                     B = 2,
                     threshold = 0.5*mean(eusilcA_pop$eqIncome,
                                          na.rm = TRUE))

descriptives_dt <-
ebp_reportdescriptives(model = unit_model,
                       direct = direct_est,
                       smp_data = eusilcA_smp,
                       weights = "weight",
                       pop_weights = "hhsize",
                       CV_level = "state",
                       pop_data = eusilcA_pop,
                       pop_domains = "district")



# ### test that we have the same distribution of variables
# means_dt <-
#   ebp_test_means(varlist = candidate_vars,
#                  pop_data = eusilcA_pop,
#                  smp_data = eusilcA_smp,
#                  weights = "weight")

results_dt <-
ebp_reportcoef_table(model = unit_model,
                     decimals = 4)

# full data of highest population below threshold by rank (descending order)
ebp_report_byrank(model = unit_model,
                  pop_data = eusilcA_pop,
                  pop_domains = "district",
                  pop_weights = "hhsize")

# full data of highest rate below threshold by rank (descending order)
ebp_report_byrank(model = unit_model,
                  pop_data = eusilcA_pop,
                  pop_domains = "district",
                  pop_weights = "hhsize",
                  byrank_indicator = "rate")

# bottom 10 poverty count below threshold by rank (in ascending order)
ebp_report_byrank(model = unit_model,
                  pop_data = eusilcA_pop,
                  pop_domains = "district",
                  pop_weights = "hhsize",
                  number_to_list = 10,
                  head = FALSE)


#### compute the different kinds of CV
cv_dt <-
  ebp_compute_cv(model = unit_model,
                 threshold = 0.5*mean(eusilcA_pop$eqIncome,
                                      na.rm = TRUE))

normality_fit <-
  ebp_normalityfit(model = unit_model)

##### plot the poverty map
### load the shapefile file for Austria
load("data-raw/shape_austria_dis.rda")

plot(st_geometry(shape_austria_dis))
plot1 <-
shape_austria_dis %>%
  merge(y = unit_model$ind[, c("Domain", "Head_Count")],
        by.x = "PB",
        by.y = "Domain") %>%
  ggplot() +
  geom_sf(aes(fill = Head_Count)) +
  scale_fill_viridis(option = "A",
                     direction = -1) +
  theme_bw() +
  ggtitle("Poverty Map in Austria")

#### for more information on color schemes:
### http://cookbook-r.com/Graphs/Colors_(ggplot2)/

###https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/




ggsave(plot1,
       filename = "analysis/austria_poverty_map.png")


save.image("data-clean/povertymap_image.RData")



### for more documentation on how to create maps
### please go ahead and look at
### https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf









