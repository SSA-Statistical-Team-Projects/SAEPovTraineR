################################################################
############ CLEANING & PREPARING REAL DATA IN R ###############
################################################################

pacman::p_load(tidyverse, ggplot2)

### read in the raw data in a list of data.frames

path_chr <- "data-raw/data-cleaning-session/beneficiary_data"


bdt_list <- lapply(X = list.files(path = path_chr, full.names = TRUE),
                   FUN = haven::read_sav)

names(bdt_list) <- sub(pattern = ".sav",
                       replacement = "",
                       x = list.files(path_chr))


### create a beneficiary dataset with all the variables we care about

##### quickly create a codebook, a dataset with all the column names and their
#### labels

varlabel_dt <- lapply(X = bdt_list,
                      FUN = function(x){

                        y <- colnames(x)

                        z <- lapply(y,
                                    FUN = function(cname){

                                      yy <- attr(x[[cname]], "label")

                                      # If no label is found, assign NA
                                      if (is.null(yy)){
                                        yy <- NA
                                      }

                                      yy <- data.frame(varname = cname,
                                                       varlabel = yy,
                                                       stringsAsFactors = FALSE)

                                    })

                        dt <- Reduce(f = rbind,
                                     x = z)


                        return(dt)

                      })

### add dataset name to each dataframe
varlabel_dt <-
  mapply(FUN = function(x, y){

    y$dataset <- x

    return(y)

  },
  x = names(varlabel_dt),
  y = varlabel_dt,
  SIMPLIFY = FALSE)


varlabel_dt <- Reduce(f = rbind,
                      x = varlabel_dt)

##### prepare the data with the sort of cleaning that we need for poverty mapping

####### first, let us prepare the expenditure data
exp_dt <-
  bdt_list$expenditure %>%
  group_by(interview__key, interview__id) %>%
  summarise(across(c(S6Q2, S6Q4),
                   ~ sum(.x, na.rm = TRUE))) %>%
  rename(totexp7 = S6Q2,
         totexp30 = S6Q4)

#### now lets prepare some correlates/predictors of expenditure

#### start by renaming the variables we care about
hhinfo_dt <-
  bdt_list$advise %>%
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
  mutate(across(c(anymember_plant, worriedaboutfood, wholeday_starve),
                ~ recode(as.numeric(.x), `1` = 0, `2` = 1))) %>%
  select(own_land, amt_landq, amt_land_hhq, amt_fallowq, amt_land_agprod,
         anymember_plant, worriedaboutfood, wholeday_starve, interview__key,
         interview__id)

### lets create some more variables from the hhinfo data
hhinfo_dt <-
  hhinfo_dt %>%
  mutate(fallow_rate = amt_fallowq / amt_landq) %>%
  mutate(agprod_rate = amt_land_agprod / amt_landq)



### merge both datasets created
dt <- merge(x = exp_dt,
            y = hhinfo_dt,
            by = c("interview__key", "interview__id"),
            all = TRUE)



#### quickly run a regression
reg_model <- lm(formula = totexp30 ~ own_land + anymember_plant + worriedaboutfood +
                  fallow_rate + agprod_rate,
                data = dt[, c("totexp30", "own_land", "anymember_plant",
                              "worriedaboutfood", "fallow_rate",
                              "agprod_rate")] %>%
                  na.omit())



#### plotting results

