SELECT CITY,COUNT(store_id) AS STORE_COUNT FROM dim_stores 
GROUP BY CITY ORDER BY STORE_COUNT DESC