/* 1.1 - Total number of trips in 2016 */
-- SELECT COUNT(*) as Trips, year(start_date) as Year
-- FROM trips
-- WHERE year(start_date) = '2016'
-- GROUP BY Year;
   
 /* 1.2 - Total amount of trips in 2017 */
-- SELECT COUNT(*) as Trips, year(start_date) as Year
-- FROM trips
-- WHERE year(start_date) = '2017'
-- GROUP BY Year;

/* 1.3 - Total amount of trips in 2016 broken down by month */
-- SELECT COUNT(*) as Trips, 
-- 	   	  month(start_date) as Month, 
--        year(start_date) as Year
-- FROM trips
-- WHERE year(start_date) = '2016'
-- GROUP BY Month, Year;
     
/* 1.4 - Total amount of trips in 2017 broken down by month */
-- SELECT COUNT(*) as Trips, 
--   	  month(start_date) as Month, 
--        year(start_date) as Year
-- FROM trips
-- WHERE year(start_date) = '2017'
-- GROUP BY Month, Year;
      
/* 1.5 - Average number of trips per month for 2016-2017 */
-- SELECT year(start_date) as Year,
-- 	   month(start_date) as Month,
--        round(count(*) / (count(distinct day(start_date)))) as Avg_Trips_per_Day
-- FROM trips
-- GROUP BY Year, Month
-- ORDER BY Year, Month;

/* 1.6 - Create a table called working_table1 */
-- DROP TABLE IF EXISTS working_table1;
-- CREATE TABLE working_table1
-- SELECT year(start_date) as Year,
-- 	   	  month(start_date) as Month,
--        round(count(*) / (count(distinct day(start_date)))) as Avg_Trips_per_Day
-- FROM trips
-- GROUP BY Year, Month
-- ORDER BY Year, Month;
      
/* 2.1 - Total trips by members vs nonmembers in 2017 */
-- SELECT COUNT(is_member) AS 2017_Trips_by_Members_vs_Nonmembers
-- FROM trips
-- WHERE year(start_date) = '2017'
-- GROUP BY is_member;

-- SELECT is_member as member, count(*) as num_trips
-- FROM trips
-- WHERE year(start_date) = 2017
-- GROUP BY is_member;
      
/* 2.2 - Percentage of Total Trips by Members in 2017 */      
-- SELECT SUM(is_member = '1') / COUNT(*) * 100 as percentage_of_trips_by_members, 
-- 		  month(start_date) as Month, 
--        year(start_date) as Year
-- FROM trips
-- WHERE year(start_date) = '2017'
-- GROUP BY Year, Month;

/* 3.1 - Months of the year that are the busiest */
-- SELECT COUNT(*) as Trips, MAX(month(start_date)) as Month
-- FROM trips
-- GROUP BY month(start_date)
-- ORDER BY COUNT(*) DESC;

-- SELECT
-- 	month(start_date) as Month,
--     SUM(IF(Year(start_date)=2016, 1, 0)) as year_2016,
--     SUM(IF(Year(start_date)=2017, 2, 0)) as year_2017
-- FROM trips
-- GROUP BY MONTH;

/* 3.2 - Months of the year to offer special promotions to non-members */
-- SELECT COUNT(*) as Trips, MIN(month(start_date)) as Month
-- FROM trips
-- GROUP BY month(start_date)
-- ORDER by COUNT(*)
-- LIMIT 4;

/* 4.1 - 5 most popular starting stations */
-- SELECT name as Starting_Stations, COUNT(*) as Total_Amount
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.start_station_code
-- GROUP BY Starting_Stations
-- ORDER BY Total_Amount DESC
-- LIMIT 5;

/* 4.2 - 5 most popular starting stations using a subquery */
-- SELECT name as Starting_Stations, Total_Amount
-- FROM
--     (SELECT trips.start_station_code, COUNT(*) as Total_Amount
--     FROM trips
--     GROUP BY trips.start_station_code) as trip_count
-- JOIN stations
-- 	 ON stations.code = trip_count.start_station_code
-- ORDER BY Total_Amount DESC
-- LIMIT 5;

/* 5.1a - Number of starts for Mackay/de Maisonneuve throughout the day */
-- SELECT
-- 	CASE 
-- 		WHEN HOUR(start_date) between 7 and 11 then 'morning'
-- 		WHEN HOUR(start_date) between 12 and 16 then 'afternoon'
-- 		WHEN HOUR(start_date) between 17 and 21 then 'evening'
-- 		ELSE 'night'
-- 	END AS 'Time_of_Day',
--     name as Station,
--     count(*) as Starts_Throughout_Day
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.start_station_code
-- WHERE name = 'Mackay / de Maisonneuve'
-- GROUP BY CASE when hour(start_date) between 7 and 11 then 'morning'
-- 			WHEN HOUR(start_date) between 12 and 16 then 'afternoon'
-- 			WHEN HOUR(start_date) between 17 and 21 then 'evening'
-- 			ELSE 'night'
-- 		end
-- ORDER BY Starts_Throughout_Day DESC;

/* 5.1b - Number of ends for Mackay/de Maisonneuve throughout the day */
-- SELECT
-- 	CASE 
-- 		WHEN HOUR(end_date) between 7 and 11 then 'morning'
-- 		WHEN HOUR(end_date) between 12 and 16 then 'afternoon'
-- 		WHEN HOUR(end_date) between 17 and 21 then 'evening'
-- 		ELSE 'night'
-- 	END AS 'Time_of_Day',
--     name as Station,
--     count(*) as End_Throughout_Day
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.end_station_code
-- WHERE name = 'Mackay / de Maisonneuve'
-- GROUP BY CASE when hour(end_date) between 7 and 11 then 'morning'
-- 			WHEN HOUR(end_date) between 12 and 16 then 'afternoon'
-- 			WHEN HOUR(end_date) between 17 and 21 then 'evening'
-- 			ELSE 'night'
-- 		end
-- ORDER BY End_Throughout_Day DESC;

-- /* 6.1 - The number of starting trips per station */
-- SELECT name as Station, COUNT(*) as Starts_per_Station
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.start_station_code
-- GROUP BY Station
-- ORDER BY Starts_per_Station DESC;

-- /* 6.2 - The number of round trips per station */
-- SELECT name as Station, COUNT(*) as Roundtrips
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.start_station_code
-- WHERE trips.start_station_code = trips.end_station_code
-- GROUP BY Station
-- ORDER BY Roundtrips DESC;

-- /* 6.3 - Fraction of round trips to total number of starting trips per station */
-- SELECT name as Station, 
-- 		(count(*) / bixi.starts_station) * 100 as Percentage
-- FROM 
-- (SELECT name, stations.code as bike_stations, count(*) as starts_station
-- FROM stations
-- JOIN trips
-- 	 on stations.code = trips.start_station_code
-- GROUP BY name, bike_stations) as bixi
-- JOIN trips
-- 	on trips.start_station_code = bixi.bike_stations
-- WHERE trips.start_station_code = trips.end_station_code
-- GROUP BY name, bike_stations
-- ORDER BY Percentage desc;

-- SELECT
-- 	start_station_code,
--     s.name,
--     SUM(IF(start_station_code=end_station_code, 1, 0))/COUNT(*) as round_trips_frac
-- FROM trips t
-- JOIN stations as s
-- on s.code = start_station_code
-- GROUP BY start_station_code, s.name
-- ORDER BY round_trips_frac DESC;
	
/* 6.4 - 500 start trips & 10% are roundtrip */
-- SELECT name as Station,
-- 	   (count(*) / bixi.starts_per_station) * 100 as Percent_Roundtrips
-- FROM
-- (SELECT name, stations.code as bike_stations, COUNT(*) as starts_per_station
-- FROM stations
-- JOIN trips
-- 	 ON stations.code = trips.start_station_code
-- GROUP BY name, bike_stations) as bixi
-- JOIN trips
-- 	on trips.start_station_code = bixi.bike_stations
-- WHERE trips.start_station_code = trips.end_station_code
-- GROUP by name, bike_stations, starts_per_station
-- HAVING starts_per_station >= 500
-- 	  and Percent_Roundtrips >= 10
-- ORDER by Percent_Roundtrips desc;