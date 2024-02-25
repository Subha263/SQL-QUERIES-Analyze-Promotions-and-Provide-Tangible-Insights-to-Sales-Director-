SELECT * FROM retail_events_db.fact_events;
WITH CTE AS(
SELECT 
        product_code,
        SUM(base_price * `quantity_sold(before_promo)`) / 1000000 AS total_revenue_before_promotion,
        SUM(CASE 
                WHEN promo_type = '50% OFF' THEN (base_price / 2) * `quantity_sold(after_promo)`
                WHEN promo_type = '25% OFF' THEN (base_price * 0.75) * `quantity_sold(after_promo)`
                when  promo_type ="33% off" then base_price*.67*`quantity_sold(after_promo)`
                WHEN promo_type = 'BOGOF' THEN base_price  * `quantity_sold(after_promo)`
                WHEN promo_type = '500 Cashback' THEN (base_price - 500) *`quantity_sold(after_promo)`
                ELSE base_price * `quantity_sold(after_promo)`
            END) / 1000000 AS total_revenue_after_promotion from fact_events group by product_code)
    SELECT P.product_name,(C.total_revenue_after_promotion/C.total_revenue_before_promotion-1)*100 
    AS 'IR%',RANK()OVER(ORDER BY (C.total_revenue_after_promotion/C.total_revenue_before_promotion-1)*100 DESC ) AS RANK_ORDER
FROM CTE AS C JOIN dim_products AS P
    ON C.product_code=P.product_code LIMIT 5