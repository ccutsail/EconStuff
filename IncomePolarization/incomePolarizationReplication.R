library(bea.R)
library(tidyr)
library(plm)
library(gridExtra)
# Begin by grabbing BEA data from the Regional table
# We want personal income and population by county for the years 1969 - 2017
# Personal income is 'LineCode' = 1
# Population is 'LineCode' = 2

# My BEA key
beaKey <- rstudioapi::askForPassword('Enter BEA key')

# Set up specs for personal income
beaSpecs <- list(
  'UserID' = beaKey ,
  'Method' = 'GetData',
  'datasetname' = 'Regional',
  'TableName' = 'CAINC1',
  'LineCode' = '1',
  'GeoFips' = 'COUNTY',
  'Year' = 'ALL')
beaPayload <- beaGet(beaSpecs)

# Specs for population
beaSpecs <- list(
  'UserID' = beaKey ,
  'Method' = 'GetData',
  'datasetname' = 'Regional',
  'TableName' = 'CAINC1',
  'LineCode' = '2',
  'GeoFips' = 'COUNTY',
  'Year' = 'ALL')
beaPayload_pop <- beaGet(beaSpecs)

# Stack data -- 
# BEA provides as. . .
# GeoFips | GeoName | DataValue1 | DataValue2 | DataValue3 | . . . | DataValueN
# This stacks the datavalues by
reshapedBeaPayload <- gather(beaPayload, GeoFips, pinc, DataValue_1969:DataValue_2017)
reshapedBeaPayload_pop <- gather(beaPayload_pop, GeoFips, Pop, DataValue_1969:DataValue_2017)

# There is an issue in my gather above -- it places Year in the GeoFips column (correct later)
# This pulls the last four characters from the 'GeoFips' column, 
# which (because of the faulty gather) corresponds to the column name in the original payload
# The last four characters in the column name are the year of the data
reshapedBeaPayload <- reshapedBeaPayload %>%
  dplyr::mutate(Year = str_extract(GeoFips, "[^_]+$"))

reshapedBeaPayload_pop <- reshapedBeaPayload_pop %>%
  dplyr::mutate(Year = str_extract(GeoFips, "[^_]+$"))

# Get rid of some (unneeded) fields
reshapedBeaPayload <- subset(reshapedBeaPayload, select = -c(Code,CL_UNIT,UNIT_MULT, GeoFips))
reshapedBeaPayload_pop <- subset(reshapedBeaPayload_pop, select = -c(Code,CL_UNIT,UNIT_MULT, GeoFips))

# combine the two datasets (personal income and population)
df <- merge(reshapedBeaPayload, reshapedBeaPayload_pop)

# Create a field for per capita personal income
df$pincpc <- df$pinc/df$Pop

# Some cleaning: I keep two dataframes, one for states and one for counties
# All counties have a column in the GeoName field: this drops all records with a comma
states <- df[!grepl(",", df$GeoName), ]
# Some records have asterisks. Reason here is unclear (I need to look into this!)
# but for short-run purposes, I just drop them from the dataset
states <- states[!grepl("\\*", states$GeoName), ]
# Drop Hawaii and Alaska (only the lower 48 (sensitivity?))
states <- states[!grepl("HI", states$GeoName), ]
states <- states[!grepl("AK", states$GeoName), ]

# Repeat the above, but only keep the records with commas in GeoName 
# This will become our county panel
df <- df[grepl(",", df$GeoName), ]
df <- df[!grepl("HI", df$GeoName), ]
df <- df[!grepl("AK", df$GeoName), ]
df <- df[!grepl("\\*", df$GeoName), ]

# Create panel data frames. Necessary for growth rate calculations
coPanel <- pdata.frame(df, index = c("GeoName", "Year"))
stPanel <- pdata.frame(states, index = c("GeoName", "Year"))

# Generate growth rates
stPanel$growthRate <- (stPanel$pincpc - plm::lag(stPanel$pincpc))/plm::lag(stPanel$pincpc)
coPanel$growthRate <- (coPanel$pincpc - plm::lag(coPanel$pincpc))/plm::lag(coPanel$pincpc)

# Create columns for mean and standard deviation by year. . . I had some trouble
# generating relative income when I skipped this step for the county data
yrMeanSd <- coPanel %>%
  subset(select=c(Year,pincpc)) %>%
  group_by(Year) %>%
  summarize(mean=mean(pincpc), sd = sd(pincpc))
coPanel <- merge(coPanel, yrMeanSd)

# Remove out the top and bottom percentiles (done in Park, Shin)
coPanel <- coPanel[coPanel$pincpc >= quantile(coPanel$pincpc,0.01) & 
                     coPanel$pincpc <= quantile(coPanel$pincpc,0.99),]

# Compute relative income
stPanel$relIncome <- (stPanel$pincpc - mean(stPanel$pincpc))/sd(stPanel$pincpc)
coPanel$relIncome <- (coPanel$pincpc - coPanel$mean)/coPanel$sd


#coPanel$yearNum <- as.numeric(coPanel$Year)
#coPanel$pd <- coPanel$yearNum >= 25
#baseYearData <- coPanel %>% filter(Year==1974) %>% subset(select=-c(mean,sd))

# Brief diversion from the replication goal
# to take a look at the sample paths of growth rates by population
yoy <- coPanel %>% 
  subset(select=c(Year, growthRate,Pop))
yoy <- yoy %>% 
  mutate(co_type = ifelse(Pop > 50000, "Urban", ifelse(Pop>10000,"Suburban","Rural")))
yoy_mgr <- yoy %>% 
  subset(select=c(Year,growthRate,co_type)) %>% 
  group_by(Year,co_type) %>% 
  summarize(meangr=mean(growthRate),sdgr=sd(growthRate))
ggplot(yoy_mgr,aes(x=Year,y=meangr,color=co_type,group=co_type)) + 
  geom_line() + 
  geom_point() + 
  scale_y_continuous(labels = scales::percent) + 
  scale_x_discrete(breaks=seq(1967, 2017, 10))

# Break the county panel into subperiods
cp_ft <- coPanel %>% 
  filter(Year %in% c(seq(1970,1974),seq(1993,1997),seq(2014,2017))) %>%
  mutate(period = ifelse(Year %in% seq(1970,1974),0,ifelse(Year %in% seq(1993,1997),1,2)))

# Compute mean period two growth rate
cpCp <- cp_ft %>% 
  subset(select = c(GeoName, growthRate, period, pincpc)) %>% 
  group_by(GeoName, period) %>% 
  summarize(meangr=mean(growthRate)) %>%
  filter(period==1) %>%
  subset(select=-c(period))

# Compute mean period 0 personal income
cpCp_pinc <- cp_ft %>% 
  subset(select = c(GeoName, growthRate, period, pincpc)) %>% 
  group_by(GeoName, period) %>% 
  summarize(meanpc=mean(pincpc)) %>%
  filter(period==0) %>%
  subset(select=-c(period))

# Create regression df
modDat <- merge(cpCp,cpCp_pinc)
modDat$meanpc <- modDat$meanpc/mean(modDat$meanpc)
# Regress mean initial personal income on terminal period growth rate
gEq <- lm(modDat$meangr~modDat$meanpc)
summary(gEq)
ggplot(modDat, aes(x=meanpc,y=meangr)) + 
  geom_point(color='maroon') + 
  geom_abline(intercept = gEq$coefficients[1],slope=gEq$coefficients[2])

# Nonparametric estimation
npGrEq <- npreg(modDat$meangr ~ modDat$meanpc)
plot(npGrEq)

# Compute mean period two growth rate
periodIncome <- cp_ft %>% 
  subset(select = c(GeoName, pincpc, period)) %>% 
  group_by(GeoName, period) %>% 
  summarize(meanincome=mean(pincpc)) %>%
  spread(period, meanincome)

periodIncome <- periodIncome[complete.cases(periodIncome), ]

periodIncome$`0` <- periodIncome$`0`/mean(periodIncome$`0`)
periodIncome$`1` <- periodIncome$`1`/mean(periodIncome$`1`)
periodIncome$`2` <- periodIncome$`2`/mean(periodIncome$`2`)

dens01 <- ggplot(periodIncome, aes(x=`0`,y=`1`)) + 
  stat_density2d(aes(fill = ..level..),n = 100,contour = TRUE,geom = "polygon")

dens12 <- ggplot(periodIncome, aes(x=`1`,y=`2`)) + 
  stat_density2d(aes(fill = ..level..),n = 100,contour = TRUE,geom = "polygon")

dens02 <- ggplot(periodIncome, aes(x=`0`,y=`2`)) + 
  stat_density2d(aes(fill = ..level..),n = 100,contour = TRUE,geom = "polygon")

grid.arrange(dens01, dens12, dens02, ncol=3)
