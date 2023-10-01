-- Author: Andrea Mechery
-- Date: October 1, 2023

-- 1.
-- Write a query to get the sum of impressions by day.
-- I understood this to be the sum of total impressions per date.

SELECT DISTINCT date as Day -- Return each Date
, SUM(impressions) "Total Impressions" -- Sum of all impressions per date
FROM marketing_performance mp 
GROUP BY date;

-- 2.
--Write a query to get the top three revenue-generating states in order of best to worst. 

SELECT state
, SUM(revenue) "Total Revenue"   -- Sum of Revenue per State
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
    ) AS "Revenue" -- Subquery to Calculate Total Revenue per Campaign
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

SELECT DISTINCT mp.geo State
, SUM(mp.conversions) "Total Conversions"  -- Sum of all conversions per state
FROM marketing_performance mp 
JOIN campaign_info ci on mp.campaign_id  = ci.id 
WHERE ci.name = 'Campaign5' -- Returns instances that include Campaign 5
GROUP BY mp.geo ;

-- Which state generated the most conversions for this campaign?
-- Based on the query, the state that generated most conversions for Campaign 5 is Georgia with a total of 672 conversions.

-- 5.
-- In your opinion, which campaign was the most efficient, and why?
-- To determine efficiency, I analyzed the campaign data using metrics such as ROI, cost per conversion, and conversion rate.

SELECT ci.name as name
, (((SELECT SUM(wr.revenue)
	FROM website_revenue wr
	WHERE wr.campaign_id = ci.id)
 - SUM(mp.cost))/SUM(mp.cost)) * 100 as ROI -- Determines ROI as %
, SUM(mp.cost) / SUM(mp.conversions) as cost_per_conversion -- Determines Spent Cost for One (1) Conversion
, 100 * SUM(mp.conversions) / SUM(mp.clicks) as conversion_rate -- Determines Proportion of Conversions to the total number of Clicks as %
FROM campaign_info ci 
LEFT JOIN marketing_performance mp on ci.id = mp.campaign_id 
GROUP BY ci.name 
ORDER BY ROI DESC;

-- Since information about the campaigns objectives are not provided, I would consider profitability to be the primary goal. Based on the data, Campaign 5 has the highest ROI at 7,706% indicating it is the most efficient at profitability.

-- However, if minimizing the cost of acquiring conversions is the focus of the campaigns, then Campaign4 with the lowest cost per conversion is the most efficient. Additionally, if converting a higher percentage of visitors is the goal, then Campaign2 and Campaign3 with the highest conversion rates are the most efficient.


