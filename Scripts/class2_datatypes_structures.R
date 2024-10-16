######################################################################
################## DATA TYPES AND STRUCTURES IN R ####################
######################################################################

### the 4 data types that this class will focus on
### (numerics, characters, logicals and factors)

a1 <- 34.2 ###
class(a1)

a2 <- "maria"
class(a2)

a3 <- TRUE ## can also be represented with T or F
class(a3)

a4 <- factor("male")
class(a4)

### data structures
### VECTOR:
#### A 1 dimensional array (created using the c() function)
#### a vector can only contain one class of data type

num_vector <- c(1, 2, 3, 4, 5)
num_vector <- 1:5

chr_vector <- c("zonde", "taonga", "webby", "betha", "moses")

logical_vector <- c(TRUE, TRUE, TRUE, FALSE, FALSE)
logical_vector <- c(rep(x = TRUE, times = 3), rep(FALSE, 2))

flogical_vector <- factor(logical_vector)
fcharacter_vector <- factor(chr_vector)

# Create a vector for each data type, each of length 4.
# Create the following vector:
#   showcase <- c(“you”, 3, “me”, -9, “everyone”)
# What is the class of the vector? Is this strange? Why?

#### LISTS IN R

comb_list <- list(names = chr_vector,
                  logic_vals = logical_vector,
                  num_vals = num_vector)


### team exercise:
### create your own list:
# create a list of length 4. Each element of the list is
# a different data type each of length 4.

comb_list <- list(comb_list,
                  scores = c(90, 85, 23, 23, 200))

##### CREATING DATAFRAMES AND MATRICES IN R

df <- data.frame(rtrain_names = c("costain", "brenda", "webby", "mubita",
                                  "ify", "moses", "taonga", "humphrey",
                                  "zonde"),
                 values = c(90, 243, 345, 343, 223, 432, 200, 422, 234))

df2 <- data.frame(colors = c("white", "red", "green"),
                  values = c(90, 100, 110))

mat <- matrix(data = c(1:9),
              nrow = 3)


##### ACCESSING ELEMENTS OF THE DATA STRUCTURES
### VECTORS
chr_vector[1] ## return the first 3 elements of the chr_vector
chr_vector[c(1, 3, 5)] ### return the 1st, 3rd and 5th elements of the vector

comb_list <- list(names = chr_vector,
                  logic_vals = logical_vector,
                  num_vals = num_vector)

class(comb_list[3])
class(comb_list[[3]])
comb_list[3]*3
comb_list[[3]]*3

comb_list$names ## subsetting with the dollar sign
comb_list$logic_vals[3]

comb_list$num_vals <- 1:500


comb_list$num_vals[comb_list$num_vals >= 300] ## return the values that are
                                              ## that are greater than 300


##### class exercise

sample_df <- data.frame(colors = c(rep("red", 10000),
                                   rep("blue", 10000),
                                   rep("green", 10000),
                                   rep("white", 10000),
                                   rep("black", 10000)),
                        score = abs(100*rnorm(50000)))




































