###########################################################
########### DATA CLEANING AND MANIPULATION IN R ###########
###########################################################

### beginning with a small recap of yesterday's work

num_vector <- 1:10
chr_vector <- rep(c("moses", "taonga", "humprey",
                "zonde", "ify"), 2)
logic_vector <- c(rep(TRUE, 3), rep(FALSE, 7))
factor_vector <- factor(rep(c("Old", "New"), 5))

### creating a list from our vectors
comb_list <- list(numerals = num_vector,
                  characters = chr_vector,
                  logicals = logic_vector,
                  facts = factor_vector)

comb_list2 <- list(num_vector,
                   chr_vector,
                   logic_vector,
                   factor_vector)


### creating dataframes in R

df <- data.frame(numerals = num_vector,
                 names = chr_vector,
                 logicals = logic_vector,
                 facts = factor_vector)


### how to subset and interact with our objects
length(comb_list)

### ways of subsetting the first element of the named list
comb_list[1]
comb_list$numerals
comb_list2[[1]]

### select the first 5 values of the 3 element in comb_list

comb_list$logicals[1:5]

### select the numbers (in numerals) that are less than 4
### or greater than 8
comb_list$numerals[comb_list$numerals < 4 |
                     comb_list$numerals > 8]


### subsetting our dataframe
### select the first column

df[,1] ##subsetting the first column by index
df$numerals ## subsetting the first column by name
df[,"numerals"] ## subsetting the first column by name
df["numerals"] ## otherways of subsetting the first column
df[["numerals"]]

### subsetting the first row
df[1,]

### subsetting the first column and the first 5 observations
df[1:5,1]

###########################################################
################### FOR TODAY'S CLASS #####################
###########################################################

# Let’s perform some operations to the numeric columns:
#   a) The scores are too low, so lets add 10 to each score
# in a new column called adj_score.
# b) Create another column for gender i.e. each person has
# to be categorized as male or female.
# Extra points, if the %in% function is used.
# c) Make column created in (b) a factor variable i.e.
# the gender column should be converted to class ‘factor’
# d) create another column called ‘indicator’, if the
# values are greater than 60, indicator should be 1
# otherwise, indicator is 0.
#

person_list <- c(rep("ify", 1000),
                 rep("taonga", 1000),
                 rep("moses", 1000),
                 rep("humphrey", 1000),
                 rep("mutaba", 1000),
                 rep("bertha", 1000),
                 rep("edith", 1000),
                 rep("grace", 1000),
                 rep("james", 1000),
                 rep("mary", 1000))

set.seed(123) ### to ensure replicable random generation

### creating a list of randomly generated
### non-negative scores
length_person <- length(person_list)
scores <- rnorm(n = length_person)
scores <- 100*scores
scores <- abs(scores)

sample_df <- data.frame(indiv = person_list,
                        scores = scores)

#### a few functions for inspecting your data in R
View(sample_df) ## view my data in a window
head(sample_df) ### first 6 observations outputted in console
head(sample_df, 100)
tail(sample_df)
tail(sample_df, 100)
str(sample_df) ### shows the structure of the dataframe

### NOTE that str() also works for every object in R to
### see the structure of the data that is created

sample_df$adj_score <- sample_df$scores + 10
sample_df["adj_score"] <- sample_df["scores"] + 10










