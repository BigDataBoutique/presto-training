----------------------------- 200 response codes

SELECT * FROM elb_logs_pq WHERE elb_response_code = '200' LIMIT 100;

------------------ Filtering on partition

SELECT distinct(elb_response_code),
         count(url)
FROM elb_logs_pq
WHERE year=2015
        AND month=1
        AND day=1
GROUP BY  elb_response_code

-------------------------------

SELECT elb_name,
       uptime,
       downtime,
       cast(downtime as DOUBLE)/cast(uptime as DOUBLE) uptime_downtime_ratio
FROM 
    (SELECT elb_name,
        sum(case elb_response_code
        WHEN '200' THEN
        1
        ELSE 0 end) AS uptime, sum(case elb_response_code
        WHEN '404' THEN
        1
        ELSE 0 end) AS downtime
    FROM elb_logs_pq
    GROUP BY  elb_name)
