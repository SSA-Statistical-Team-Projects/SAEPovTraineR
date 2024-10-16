###############################################################################
############ R PROGRAMMING TUTORIAL TOWARDS POVERTY MAPPING CENSUS EB #########
###############################################################################

### comments

# here is my first comment


### variable assignment (use <- and not = for assignment)

var1 <- 5

var1


############################################################################
# Arithmetic: +,  -,  *,  /,  ^ (add, subtract, multiply, divide and power)
# Relational: ==, !=, >, <, >=, <= (equal to, not equal to, less than,
# greater than, less than or equal to, greater than or equal to)
# Logical: &, |, !  (and, or, not or negate)
############################################################################

### simple arithmetic operations
a <- 5 + 10 ### summation in R
a2 <- 34 - 11 ### subtration in R
a3 <- a * a2 ### multiplication in R
a4 <- a3 / a2 #### division
a5 <- a4 ^ 3 ### power calculation in R
a5 <- a4 ^ 2 ### notice that you can overwrite results in R

### simple relational operators in R
a == a2
a == a
a3 > a4
a3 >= a4


#### exercise 2
a <- 10
b <- 5

c <- a * b
d <- a / b
e <- a + b
f <- a - b

### exercise 3
is_a_greater <- a > b
is_b_greater <- a < b
is_ab_equal <- a == b
is_ab_neq <- a != b

### exercise 4
num1 <- 15
num2 <- 20

check_sum30 <- (num1 + num2) > 30
check_prod30 <- (num1 * num2) > 300

### bonus exercise

x <- 100
y <- 45

remainder <- x %% y

xpowery <- x ^ y

is_even <- (x / y) %% 2 == 0












