################################################################################
############### A VERY SHORT TREATMENT OF FUNCTIONAL PROGRAMMING IN R ##########
################################################################################

#### the basic structure of functions

####### a quick function that computes sums

weighted.sum <- function(x, w, drop_missing_values = FALSE){

  y <- sum(x*w, na.rm = drop_missing_values)

  return(y)

}


weighted.sum(x = 1:5,
             w = 1:5)

weighted.sum(x = 1:5,
             w = c(1:3, NA, 5))


weighted.sum(x = 1:5,
             w = c(1:3, NA, 5))



###### team exercise

#### write a power function that takes a vector, x, and an argument "n"
#### to compute the nth power of x.

power_fn <- function(x, n){

  y <- x^n

  dt <- data.frame(xvalues = x,
                   powervalues = y)

  return(dt)

}

power_fn(1:50, 3)



#### for more thorough treatment of functional programming please see here:
#### https://adv-r.hadley.nz/functionals.html











