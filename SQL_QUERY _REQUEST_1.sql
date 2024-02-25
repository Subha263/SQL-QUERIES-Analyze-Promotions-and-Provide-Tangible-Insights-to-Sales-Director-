
WITH CTE AS(
select F.product_code,P.product_name,F.base_price,F.promo_type 
FROM fact_events AS F 
JOIN dim_products AS P
ON F.product_code=P.product_code)
SELECT  distinct product_name,base_price,promo_type FROM CTE WHERE base_price>500 AND promo_type="BOGOF" 