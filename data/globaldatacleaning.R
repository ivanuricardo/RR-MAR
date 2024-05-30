library(readr)
library(tidyr)
library(dplyr)

interestrate <- read_csv("~/Desktop/Projects/PHDYear1/TensorSCCF/data/longir.csv")

interestrate <- interestrate %>%
    group_by(Location) %>%
    mutate(Value = c(NA, diff(Value)))
dfir <- spread(interestrate, key = Location, value = Value)

################################################################################

gdp_data <- read_csv("~/Desktop/Projects/PHDYear1/TensorSCCF/data/gdpextended.csv")

gdp_data <- gdp_data %>% 
    group_by(Location) %>% 
    mutate(Value = c(NA, diff(log(Value))))
dfgdp <- spread(gdp_data, key = Location, value = Value)

################################################################################

prod_data <- read_csv("~/Desktop/Projects/PHDYear1/TensorSCCF/data/prodextended.csv")

prod_data <- prod_data %>% 
    group_by(Location) %>% 
    mutate(Value = c(NA, diff(log(Value))))
dfprod <- spread(prod_data, key = Location, value = Value)

################################################################################

consumerprice <- read_csv("~/Desktop/Projects/PHDYear1/TensorSCCF/data/cpiextended.csv")

dfcpi <- spread(consumerprice, key = Location, value = Value)
dfcpipre <- dfcpi[,2:6]
yt <- embed(as.matrix(dfcpipre), 5)[,1:5]
yt4 <- embed(as.matrix(dfcpipre), 5)[,21:25]
newdfcpi <- log(yt) - log(yt4)

dfcpi <- data.frame(dfcpi$Period[5:116], newdfcpi)
colnames(dfcpi) <- c("Period", "CAN", "DEU", "FRA", "GBR", "USA")

################################################################################

# We start from the 21st observation. In total, we have 96 observations,
# from 1996-Q1 to 2019-Q4. For a 20x20 VAR, this is plenty of observations.

matdata <- array(NA, dim = c(96, 4, 5))
matdata[,1,1] <- dfir$USA[21:116]
matdata[,1,2] <- dfir$CAN[21:116]
matdata[,1,3] <- dfir$DEU[21:116]
matdata[,1,4] <- dfir$FRA[21:116]
matdata[,1,5] <- dfir$GBR[21:116]

matdata[,2,1] <- dfgdp$USA[21:116]
matdata[,2,2] <- dfgdp$CAN[21:116]
matdata[,2,3] <- dfgdp$DEU[21:116]
matdata[,2,4] <- dfgdp$FRA[21:116]
matdata[,2,5] <- dfgdp$GBR[21:116]

matdata[,3,1] <- dfprod$USA[21:116]
matdata[,3,2] <- dfprod$CAN[21:116]
matdata[,3,3] <- dfprod$DEU[21:116]
matdata[,3,4] <- dfprod$FRA[21:116]
matdata[,3,5] <- dfprod$GBR[21:116]

matdata[,4,1] <- dfcpi$USA[17:112]
matdata[,4,2] <- dfcpi$CAN[17:112]
matdata[,4,3] <- dfcpi$DEU[17:112]
matdata[,4,4] <- dfcpi$FRA[17:112]
matdata[,4,5] <- dfcpi$GBR[17:112]

save(matdata, file = "globaldata.rda")
