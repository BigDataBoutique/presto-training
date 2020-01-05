-- Airline Queries

--What is an average delay of airplanes by year?
select avg(DepDelayMinutes) as delay, year from flights_orc group by year order by year desc;

-- What is correlation between average delay and airplane congestion?
with number_of_flights as (select count(*) no, year from flights_orc group by year),
       avg_delay as (select avg(depdelayminutes) as delay, year from flights_orc group by year),
       combined as (select no, delay, n.year from number_of_flights n, avg_delay d where n.year = d.year)
select corr(no, delay) from combined;

--What is an average delay of airplane by month in 2014?
select avg(DepDelayMinutes) as delay, month from flights_orc where year = 2014 group by month order by month asc;

-- What are the most popular destinations for flights in 2014
select count(*) as number_of_flights, destcityname from flights_orc where year = 2014 group by destcityname order by number_of_flights desc;

-- When people are flying the most often
select count(*) as number_of_flights, month from flights_orc where year = 2014 group by month order by number_of_flights desc;

-- What are the best days of the week to fly out of Boston in the month of February?
select dayofweek, avg(depdelayminutes) as delay from flights_orc where month=2 AND origincityname like '%Boston%' group by dayofweek order by dayofweek;

-- What airport is the worst airport to make a connection at per airline?
 with avg_arr_delays as (select avg(arrdelay) as arr_delay, carrier from flights_orc where
 dest = 'LAX' group by carrier),
     avg_dept_delays as (select avg(depdelay) as dept_delay, carrier from flights_orc where
  origin = 'LAX' group by carrier),
     time_frames as (select dept_delay - arr_delay as time_frame, a.carrier from avg_arr_delays a, avg_dept_delays d where a.carrier = d.carrier group by (dept_delay - arr_delay), a.carrier),
     min_max as (select min(time_frame) min_time_to_change, carrier from time_frames group
 by carrier)
 select t.* from time_frames t inner join min_max m on t.time_frame = m.min_time_to_change
 order by t.time_frame asc;
