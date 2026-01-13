data <- read.csv("C:/Users/topra/Desktop/BMM 422/Project/ProjectData.csv",
                 sep = ",",
                 header = TRUE)

#Filtering Germany rows

germany_data <- data[data$Country == "Germany", ]

#Converting the Date column to Date format

germany_data$Date_reported <- as.Date(germany_data$Date_reported)

#Start date of the first week

first_week_start <- as.Date("2021-03-01")

num_weeks <- 10

#Vectors to store the results

week_start   <- as.Date(rep(NA, num_weeks))
mean_deaths  <- numeric(num_weeks)
var_deaths   <- numeric(num_weeks)
n_smaller    <- integer(num_weeks)
prob_smaller <- numeric(num_weeks)

set.seed(123)

#Loop over weeks

for (w in 1:num_weeks) {
  
  #Start date of the first week
  
  start_date <- first_week_start + 7 * (w - 1)
  
  #Row number of this date
  
  row_index <- which(germany_data$Date_reported == start_date)
  
  #Getting 7-day death counts
  
  deaths_week <- germany_data[row_index:(row_index + 6), "New_deaths"]
  
  #Mean and variance
  
  mean_week <- mean(deaths_week)
  var_week  <- var(deaths_week)
  
  #1000 Poisson simulations
  
  sim_vars <- numeric(1000)
  for (i in 1:1000) {
    sim_week    <- rpois(7, lambda = mean_week)
    sim_vars[i] <- var(sim_week)
  }
  
  #Those with variance smaller than the actual week's variance
  
  smaller_count <- sum(sim_vars < var_week)
  prob          <- smaller_count / 1000
  
  #Write to the vectors
  
  week_start[w]   <- start_date
  mean_deaths[w]  <- mean_week
  var_deaths[w]   <- var_week
  n_smaller[w]    <- smaller_count
  prob_smaller[w] <- prob
}

#Suspicious week label

alpha <- 0.05
flag <- ifelse(prob_smaller < alpha, "supheli", "normal")

#Results table

results <- data.frame(
  week_number  = 1:num_weeks,
  week_start   = week_start,
  mean_deaths  = mean_deaths,
  var_deaths   = var_deaths,
  n_smaller    = n_smaller,
  prob_smaller = prob_smaller,
  flag         = flag
)

#COMMENT-1
#In this section, daily death data for 10 selected weeks for Germany were examined.
#For each week, the mean and variance were calculated, and
#1000 new weeks were simulated from a Poisson distribution with the same mean value.
#The number of cases where the simulation variances were smaller than the actual week
#(n_smaller) and the probability (prob_smaller) were calculated.
#If prob_smaller < 0.05, the relevant week would be labeled as "suspicious".
#However, since prob_smaller = 1 for all weeks, no week is suspicious.
#The code that displays the output as results is at the very end.

#Germany - USA comparison

#Filtering USA data

usa_data <- data[data$Country == "United States of America", ]

#Converting to Date format

usa_data$Date_reported <- as.Date(usa_data$Date_reported)

#Date range to be used for comparison

compare_start <- as.Date("2020-12-28")
compare_end   <- as.Date("2022-01-09")

#Germany's data within these dates

germany_range <- germany_data[
  germany_data$Date_reported >= compare_start &
    germany_data$Date_reported <= compare_end, ]

#USA's data within these dates

usa_range <- usa_data[
  usa_data$Date_reported >= compare_start &
    usa_data$Date_reported <= compare_end, ]

#Population values (approximate)

pop_germany <- 83000000
pop_usa     <- 331000000

#Normalizing daily death counts per 1 million people

germany_dpm <- germany_range$New_deaths / pop_germany * 1000000
usa_dpm     <- usa_range$New_deaths     / pop_usa     * 1000000

#Creating a day index for the x-axis

days <- 1:length(germany_dpm)

#Plot: Germany vs USA

plot(days, germany_dpm, 
     type = "l", 
     col  = "blue",
     lwd  = 2,
     xlab = "Days from 28 Dec 2020 to 9 Jan 2022",
     ylab = "Covid-19 deaths per million",
     main = "Germany vs USA",
     xlim = c(0, 400),
     axes = FALSE)

#COMMENT-2
#For the Germany vs USA comparison plot:
#This plot shows the daily Covid-19 deaths (per million people)
#for Germany and the USA between 28 Dec 2020 - 9 Jan 2022.
#The death rates in the USA are generally higher and more variable.
#In both countries, peaks are observed in winter months, while
#clear declines are seen in summer months.
#While the USA shows a sharper increase in autumn 2021,
#Germany follows a more moderate trend.
#Overall, throughout the period, the USA curve remains above Germany's.

#In summary:
#Germany is more stable and has lower death rates.
#The USA is higher and more volatile.
#This difference reflects how the pandemic evolved differently across countries,
#the effects of variants,
#and variability in reporting policies.


box()

axis(1, labels = TRUE,  tck = 0.05)   
axis(2, labels = TRUE,  tck = 0.05)   
axis(3, labels = FALSE, tck = 0.05)   
axis(4, labels = FALSE, tck = 0.05)   

#USA line

lines(days, usa_dpm, col = "red", lwd = 2)

#Legend

legend("topright",
       legend = c("Germany", "USA"),
       col    = c("blue", "red"),
       lwd    = 2,
       lty    = 1,
       bty    = "n")

results

#FINAL COMMENT
#As can be seen in the results table, the analysis shows that there is
#no statistically unusual regularity in Germany’s
#selected 10-week death data.
#All weeks turned out to be "normal" and are
#consistent with the behavior expected by the Poisson model.
#The Germany–USA comparison, on the other hand, reveals that the USA
#had higher Covid-19 death rates throughout the period.

