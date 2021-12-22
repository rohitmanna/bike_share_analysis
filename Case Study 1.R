install.packages("tidyverse")
install.packages("janitor")
install.packages("lubridate")
install.packages("dplyr")
library(tidyverse)
library(readr)
library(janitor)
library(dplyr)
df1 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_1.csv")
df2 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_2.csv")
df3 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_3.csv")
df4 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_4.csv")
df5 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_5.csv")
df6 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_6.csv")
df7 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_7.csv")
df8 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_8.csv")
df9 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_9.csv")
df10 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_10.csv")
df11 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_11.csv")
df12 <- read_csv("C:\\Users\\adity\\OneDrive\\Desktop\\Project Files\\month_12.csv")


##                  Combining the 12 datasets into 1
library(janitor)
bike_rides <- rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)

 # Removing empty columns and rows
bike_rides<- remove_empty(bike_rides,which = c("cols")) 
bike_rides<- remove_empty(bike_rides,which = c("rows"))

# Converting Date Time
library(lubridate)
bike_rides$ymd <- as.Date(bike_rides$started_at)
bike_rides$started_at <- lubridate::ymd_hms(bike_rides$started_at)
bike_rides$ended_at <- lubridate::ymd_hms(bike_rides$ended_at)

bike_rides$start_hour <- lubridate::hour(bike_rides$started_at)
bike_rides$end_hour <- lubridate::hour(bike_rides$ended_at)


## The bike_rides$any <- as.Date(bike_rides$started_at)
##  Left Side: the $ adds column any to bike_rides
##  Right Side: the started as column of bike_rides is formatted as date and added to 'any'

# Calculating Trip Duration

bike_rides$hours <- difftime(bike_rides$ended_at,bike_rides$started_at,units = c("hours"))
bike_rides$minutes <- difftime(bike_rides$ended_at,bike_rides$started_at,units = c("mins"))
colnames(bike_rides_1)

# Renaming member_casual as membership_types
bike_rides <-rename(bike_rides,membership_type=member_casual)  
clean_names(bike_rides)
View(bike_rides)

# Filtering and Summarizing 
library(dplyr)
bike_rides_1 <- bike_rides %>% 
  filter(minutes>0) %>% 
  


# Summary Data Frame
bike_rides_2 <- bike_rides_1 %>%
  group_by(Weekly=floor_date(ymd,"week"),start_hour,membership_type) %>% 
  summarise(
    minutes = sum(minutes),
    avg_time = mean(minutes),
    median_time = median(minutes),
    max_time = max(minutes),
    min_time = min(minutes),
    Count= n()
  ) %>% 
  ungroup()

  ## Summary Rideable Type
bike_rides_3<- bike_rides_1 %>%
  group_by(Weekly=floor_date(ymd,"week"),rideable_type, minutes) %>% 
  summarise(
    minutes = sum(minutes),
    avg_time = mean(minutes),
    median_time = median(minutes),
    max_time = max(minutes),
    min_time = min(minutes),
    Count = n()
  ) %>% 
  arrange(ymd=FALSE) %>% 
  ungroup()


# Plots
library(ggplot2)
library(scales)
options(scipen =999) #Changes The scientific notation (e) to actual numerics
 

## Rides  Per Hour
bike_rides_2 %>% ggplot() + geom_col(mapping = aes(x =start_hour, y = Count),color = "blue") +
  scale_y_continuous(labels = comma)+
labs(title="Traffic By The Hours",subtitle="Rides Taken At Diferent Hours of The Day ",x="Hours",y="Rides Per Hour")

## Average Rides  Per Day
bike_rides_2 %>% ggplot() + geom_col(mapping = aes(x =Weekly, y = Count),color = "blue") +
  scale_y_continuous(labels = comma)+
  labs(title="Count Of Rides Per Day", ,x="Months",y="Average Rides Per Day")

# Behaviour of Membership Types
bike_rides_2 %>% ggplot() + geom_col(mapping = aes(x =start_hour, y = Count,color=membership_type)) +
  scale_y_continuous(labels = comma)+
  labs(title="Traffic By The Hours",subtitle="Rides Taken At Diferent Hours of The Day ",x="Hours",y="Rides Per Hour")+
  facet_wrap(~membership_type)


# Rideable Types
bike_rides_3 %>% ggplot() + geom_area(mapping = aes(x =Weekly, y = Count,fill=rideable_type)) +
  scale_y_continuous(labels = comma)+
  labs(title="Trend of Rideable Types",subtitle=" Counts Rides As Per Type Of Bikes ",x="Months",y="Count Of Rides")
#+
  facet_wrap(~membership_type)
  
  
# Membership Over Months
  bike_rides_2 %>% ggplot() + geom_col(mapping = aes(x =Weekly, y = Count,fill=membership_type))+
    labs(title="Count Of Rides By Rider Type ",subtitle=" Ride Trend Of Riders Over 12 Months ",x="Months")
    
  ## Bike Types Over Minutes
 ggplot(bike_rides_3,aes(x=Weekly,y=minutes,fill=rideable_type))+
   geom_area(stat = "identity",position = position_dodge(),alpha=0.75)+
   scale_y_continuous(labels = comma)+
   labs(title=" Ride Duration By Rideable Type ",subtitle=" Ride Duration Covered By Bike Types over Months ",x="Months",y="Ride Duration In Minutes", angle=45)+
   facet_wrap(~rideable_type)
 
 
 # Station Summary & plot
 bike_rides %>% 
   count(start_station_name,sort = TRUE) %>% 
   drop_na() %>% 
   top_n(20) %>% 
   ggplot()+geom_col(mapping = aes(x=reorder(start_station_name,n),y=n),color="green")+
   coord_flip()+
   labs(title="Start Station Traffic Index",subtitle=" The Top 20 Start Stations By Ride Count ",x="Stations",y="Count Of Rides")

 
 # Station Summary Alt Plot ~ Same Result
 bike_rides %>% 
   count(start_station_name,sort = TRUE) %>% 
   drop_na() %>% 
   mutate(start_station_name=factor(start_station_name,levels=start_station_name)) %>% 
   top_n(20) %>% 
   ggplot()+geom_col(mapping = aes(x=start_station_name,y=n),color="green")+
   labs(title="Start Station Traffic Index",subtitle=" The Top 20 Start Stations By Ride Count ",x="Stations",y="Count Of Rides")
 
 # Mutating the column as a factor helps the co;umn graph order according to count
 
 
 
 
 
