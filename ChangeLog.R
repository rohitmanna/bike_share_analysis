#  CHANGE LOG

## 1. Using "r.bind" to bind all the individual datasets  into one dataframe named "bike_rides".
## 2. Changed datatype of variables "started_at" and ""ended_at" from characters to datetime.
## 3. Mutated New Variables such as "start_hour" & "end_hour" into the bike_rides dataframe.

## 4. New Variables "hours" and "minutes" created. 
## 4.1. They record the trip duration of the rides in hours and minutes respectively.

## 5. Renamed variable "member_casual" as "membership_type".
## 6. Cleaned variables to get rid of extra spaces.

## 7. New DataFrame "bike_rides_1" created, storing data about all the rides from "bike_rides"
##    which have a duration greater than 0 minutes. OF 54,79,096 Total Observations, 45,25.274 fit into the criteria.

## 8. Scientific Notation (e) removed, to get actual values of minutes, hours and trip duration.

## 9. Summary Table "bike_rides_2" created
## 9.1. Variable "Weekly" mutated into it using floor_date.
## 9.2. Sum of total minutes, mean time as average and count of rides on specific months summarized

## 10. Summary Table "bike_rides_3" created
## 10.1 Summarizes data in perspective of months,rideable_types and membership_types.
## 10.2 Sum of total minutes, mean time as average and count of rides on specific months summarized

## 11. Summary of stations created in order to rank them
## 11.1. The data on exploration showed null values only on station_id, start_station & end_station variables.
## 11.2. All null stations were dropped and counts of the rest are taken into perspective.

## 12. Plots of summary data are created to analyze rider trends and fulfilll the business task.



