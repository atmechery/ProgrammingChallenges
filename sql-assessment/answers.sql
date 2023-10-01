-- Author: Andrea Mechery
-- Date: October 1, 2023

-- 1.
-- Write a query to get the sum of impressions by day.
-- I understood this to be the sum of total impressions per date.

SELECT DISTINCT date as Day, SUM(impressions) "Total Impressions"
FROM marketing_performance mp 
GROUP BY date;

-- 2.
--Write a query to get the top three revenue-generating states in order of best to worst. 

SELECT state, SUM(revenue) "Total Revenue"  
FROM website_revenue wr 
GROUP BY state
ORDER by revenue desc
LIMIT 3;

-- How much revenue did the third best state generate?
-- The third best state, Texas, generated $34,080 in total revenue.

-- 3.
-- Write a query that shows total cost, impressions, clicks, and revenue of each campaign. 
-- Make sure to include the campaign name in the output.

SELECT
    ci.name AS "Campaign Name",
    SUM(md.cost) AS "Total Cost",
    SUM(md.impressions) AS "Total Impressions",
    SUM(md.clicks) AS "Total Clicks",
    (
        SELECT SUM(wr.revenue)
        FROM website_revenue wr
        WHERE wr.campaign_id = ci.id
    ) AS "Revenue"
FROM
    campaign_info ci
LEFT JOIN
    marketing_performance md ON ci.id = md.campaign_id
GROUP BY
    ci.name
ORDER BY
    ci.name;


-- #4
-- Write a query to get the number of conversions of Campaign5 by state. 

SELECT mp.geo, SUM(mp.conversions) "Total Conversions"  
FROM marketing_performance mp 
JOIN campaign_info ci on mp.campaign_id  = ci.id 
WHERE ci.name = 'Campaign5'
GROUP BY mp.geo ;

-- Which state generated the most conversions for this campaign?
-- Based on the query, the state that generated most conversions for Campaign 5 is Georgia with a total of 672 conversions.
