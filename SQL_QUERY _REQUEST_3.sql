WITH RevenueSummary AS (
    SELECT 
        C.campaign_name,
        SUM(F.base_price * F.`quantity_sold(before_promo)`) / 1000000 AS total_revenue_before_promotion,
        SUM(CASE 
                WHEN promo_type = '50% OFF' THEN F.base_price*.5 * F.`quantity_sold(after_promo)`
                WHEN promo_type = '25% OFF' THEN (F.base_price * 0.75) * F.`quantity_sold(after_promo)`
                when  promo_type ="33% off" then base_price*.67*`quantity_sold(after_promo)`
                WHEN promo_type = 'BOGOF' THEN F.base_price  * F.`quantity_sold(after_promo)`
                WHEN promo_type = '500 Cashback' THEN (F.base_price - 500) * F.`quantity_sold(after_promo)`
                ELSE F.base_price * F.`quantity_sold(after_promo)`
            END) / 1000000 AS total_revenue_after_promotion
    FROM 
        fact_events AS F
    JOIN 
        dim_campaigns AS C ON F.campaign_id = C.campaign_id
    GROUP BY 
        C.campaign_name
)
SELECT 
    campaign_name,
    CASE 
        WHEN campaign_name = 'Sankranti' THEN FORMAT(total_revenue_before_promotion, 4)
        WHEN campaign_name = 'Diwali' THEN FORMAT(total_revenue_before_promotion, 4)
        ELSE FORMAT(total_revenue_before_promotion, 4)
    END AS "totaI_revenue(before_promotion)",
    CASE 
        WHEN campaign_name = 'Sankranti' THEN FORMAT(total_revenue_after_promotion, 4)
        WHEN campaign_name = 'Diwali' THEN FORMAT(total_revenue_after_promotion, 4)
        ELSE FORMAT(total_revenue_after_promotion, 4)
    END AS "totaI_revenue(after_promotion)"
FROM 
    RevenueSummary;
