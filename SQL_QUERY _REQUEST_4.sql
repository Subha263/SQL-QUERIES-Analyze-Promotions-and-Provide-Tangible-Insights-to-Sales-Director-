with CTE2 as(
WITH CTE AS(
SELECT P.category,C.campaign_name,F.campaign_id,F.product_code,F.`quantity_sold(before_promo)`, F.`quantity_sold(after_promo)`
FROM fact_events AS F 
JOIN dim_products AS P ON F.product_code = P.product_code
JOIN dim_campaigns AS C ON F.campaign_id = C.campaign_id)
select category,sum(`quantity_sold(before_promo)`) as before_promoo,sum(`quantity_sold(after_promo)`) as after_promoo
from cte where campaign_name='Diwali'group by category)
select category,((after_promoo/before_promoo)-1)*100 as 'ISU%',
RANK()OVER(ORDER BY ((after_promoo/before_promoo)-1)*100 DESC) AS RANK_ORDER
 from CTE2

