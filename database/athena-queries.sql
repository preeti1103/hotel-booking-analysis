-- Query: Overall Cancellation Rate

SELECT 
    ROUND( (SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS overall_cancellation_rate
FROM 
    "hotel_db"."cleaned_bookings";

-- Query: Cancellation Rate by Hotel Type

SELECT 
    hotel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND( (SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM 
    "hotel_db"."cleaned_bookings"
GROUP BY 
    hotel
ORDER BY 
    cancellation_rate DESC;

-- Query: Average Daily Rate (ADR) by Hotel and Month

SELECT 
    hotel,
    arrival_date_month,
    ROUND(AVG(adr), 2) AS average_daily_rate
FROM 
    "hotel_db"."cleaned_bookings"
GROUP BY 
    hotel, arrival_date_month
ORDER BY 
    hotel, arrival_date_month;

-- Query: Estimated Room Revenue by Country
SELECT 
    country,
    SUM(adr * (stays_in_week_nights + stays_in_weekend_nights)) AS estimated_room_revenue -- Changed alias
FROM 
    "hotel_db"."cleaned_bookings"
WHERE 
    is_canceled = 0
GROUP BY 
    country
ORDER BY 
    estimated_room_revenue DESC -- Changed here too
LIMIT 10;

-- Query: Lead Time vs. Cancellation Rate

SELECT 
    -- Group lead time into buckets
    CASE 
        WHEN lead_time < 31 THEN '0-30 Days'
        WHEN lead_time < 61 THEN '31-60 Days'
        WHEN lead_time < 91 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS lead_time_bucket,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND( (SUM(is_canceled) * 100.0 / COUNT(*)), 2) AS cancellation_rate
FROM 
    "hotel_db"."cleaned_bookings"
GROUP BY 
    1 -- Groups by the first field (the CASE statement)
ORDER BY 

    MIN(lead_time); -- Order the buckets logically
--Query: Investigate ADR Bias
SELECT
    is_canceled,
    COUNT(*) AS number_of_bookings,
    ROUND(AVG(adr), 2) AS average_adr
FROM
    "hotel_db"."cleaned_bookings"
GROUP BY
    is_canceled;
