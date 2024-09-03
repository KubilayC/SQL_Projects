--Success rate of advertising expenditures

--In this data set, the first topic I want to examine is how the money spent on advertisements translates into returns. 
--According to my research, an ideal click-through rate (click_through_rate) is considered to be above 5%, so I want to focus on that first.
/*
WITH click_through_five AS (
SELECT 
    campaign_channel,
    campaign_type,
    ROUND(ad_spend),
    click_through_rate,
    conversion_rate,
    ROUND(pages_per_visit)
FROM
    data.marketing
WHERE 
click_through_rate >0.05  // <0.05
)
SELECT COUNT(*) FROM click_through_five; 

--As a result, I found that 6,881 advertising campaigns achieved ideal results. 
--The number of campaigns with a click-through rate below 0.005 was 1,119. 
--Based on these results, I will examine the relationship between their failures and their advertising budgets."

---------------------------------------------------------------------------------------------------------------------
--The highest advertising expenditure is $9,999 and the lowest is $100. Considering these values, I am applying filters. 
--First, I am examining advertising campaigns with ideal click-through rates and above.
SELECT
    SUM(CASE WHEN ad_spend > 9000 THEN 1 ELSE 0 END) AS "9000+",
    SUM(CASE WHEN ad_spend BETWEEN 8000 AND 8999 THEN 1 ELSE 0 END) AS "8000-8999",
    SUM(CASE WHEN ad_spend BETWEEN 7000 AND 7999 THEN 1 ELSE 0 END) AS "7000-7999",
    SUM(CASE WHEN ad_spend BETWEEN 6000 AND 6999 THEN 1 ELSE 0 END) AS "6000-6999",
    SUM(CASE WHEN ad_spend BETWEEN 5000 AND 5999 THEN 1 ELSE 0 END) AS "5000-5999",
    SUM(CASE WHEN ad_spend BETWEEN 4000 AND 4999 THEN 1 ELSE 0 END) AS "4000-4999",
    SUM(CASE WHEN ad_spend BETWEEN 3000 AND 3999 THEN 1 ELSE 0 END) AS "3000-3999",
    SUM(CASE WHEN ad_spend BETWEEN 2000 AND 2999 THEN 1 ELSE 0 END) AS "2000-2999",
    SUM(CASE WHEN ad_spend BETWEEN 1000 AND 1999 THEN 1 ELSE 0 END) AS "1000-1999",
    SUM(CASE WHEN ad_spend BETWEEN 500 AND 999 THEN 1 ELSE 0 END) AS "500-999",
    SUM(CASE WHEN ad_spend BETWEEN 100 AND 499 THEN 1 ELSE 0 END) AS "100-499",
    SUM(CASE WHEN ad_spend < 100 THEN 1 ELSE 0 END) AS "<100"
FROM 
    data.marketing
WHERE 
    click_through_rate > 0.05;
    
--I used this code to find the number of successes within the specified ranges and reflected the results in the report. 
--Similarly, I performed the reverse operation to display the advertising campaigns with poor results.

-------------------------------------------------------------------------------------------------------------------

--So, the advertisement reached the ideal audience. But did these individuals make purchases or subscriptions on the site through the advertisement? 
--I am curious about the relationship between this and the conversion rate. Since the highest conversion rate is three times the click-through rate, I increased the ideal output by the same proportion and performed the same analysis.

WITH click_conversion AS(
SELECT 
    campaign_channel,
    campaign_type,
    ROUND(ad_spend),
    click_through_rate,
    conversion_rate,
    ROUND(pages_per_visit)
FROM
    data.marketing
WHERE 
click_through_rate >0.05 AND conversion_rate > 0.15
)
SELECT COUNT(*) FROM click_conversion 

--As a result, out of the 6,881 advertisements, 1,798 exceeded this threshold. Another point of interest is whether the conversion rate on the site is considered successful even if the click-through rate is below 5%.
--I found that 281 advertisements were successful in this scenario, and I will revisit this result later.

--Assuming that a 15% conversion rate is an exaggerated expectation, I needed to document this result to examine other outcomes. I did the same analysis for the scenario with poor results.

SELECT
    SUM(CASE WHEN conversion_rate > 0.15 THEN 1 ELSE 0 END) AS ">%15",
	SUM(CASE WHEN conversion_rate BETWEEN 0.10 AND 0.15 THEN 1 ELSE 0 END) AS ">%10-%15",
	SUM(CASE WHEN conversion_rate BETWEEN 0.05 AND 0.10 THEN 1 ELSE 0 END) AS ">%5-%10",
    SUM(CASE WHEN conversion_rate < 0.05 THEN 1 ELSE 0 END) AS "<%5"
    FROM
    data.marketing 
    WHERE click_through_rate >0.05

--This also validates the accuracy of the data by comparing it with the previous results

---------------------------------------------------------------------------------------------------------------------

--In the final stage of evaluating the impact of advertising expenditures, I wanted to assess the pages visited. 
--I set the minimum number of pages as 1 and the maximum as 10 in the dataset. Based on this, I defined a successful page visit as 7 pages and an unsuccessful one as 4 pages.

WITH click_visit AS(
SELECT 
    campaign_channel,
    campaign_type,
    ROUND(ad_spend),
    click_through_rate,
    conversion_rate,
    ROUND(pages_per_visit)
FROM
    data.marketing
WHERE 
click_through_rate >0.05 AND pages_per_visit >= 7
)
SELECT COUNT(*) FROM click_visit

-----------------------------------------------------------------------------------------------------------------------
--All the analyses I performed above are general, and I created them for detailed analysis in the future.
---------------------------------------------------------------------------------------------------------------------

--Success rate of advertising expenditures[In More Depth]

WITH click_visit AS(
SELECT 
    campaign_channel,
    campaign_type,
    ROUND(ad_spend),
    click_through_rate,
    conversion_rate,
    ROUND(pages_per_visit)
FROM
    data.marketing
WHERE 
click_through_rate >0.05 AND pages_per_visit >= 7        // and belows
)
SELECT 
    campaign_type,
    COUNT(campaign_type) AS total 
FROM 
    click_visit 
GROUP BY 
    campaign_type;
--I have found the number of successful and unsuccessful advertising models.
------------------------------------------------------------------------------------------------------------------

--Then, I combined two different CTEs to see which channels were used by these models.

WITH click_visit AS (
    SELECT 
        campaign_channel,
        campaign_type,
        ROUND(ad_spend) AS ad_spend,
        click_through_rate,
        conversion_rate,
        ROUND(pages_per_visit) AS pages_per_visit
    FROM
        data.marketing
    WHERE 
        click_through_rate > 0.05 
        AND pages_per_visit >= 7
),
channel_s AS (
    SELECT 
        campaign_type,
        COUNT(campaign_type) AS total 
    FROM 
        click_visit 
    GROUP BY 
        campaign_type
)
SELECT 
    c.campaign_type,
    c.total,
    SUM(CASE WHEN cv.campaign_channel = 'SOCIAL MEDIA' THEN 1 ELSE 0 END) AS "SOCIAL MEDIA",
    SUM(CASE WHEN cv.campaign_channel = 'EMAIL' THEN 1 ELSE 0 END) AS "EMAIL",
    SUM(CASE WHEN cv.campaign_channel = 'PPC' THEN 1 ELSE 0 END) AS "PPC",
    SUM(CASE WHEN cv.campaign_channel = 'SEO' THEN 1 ELSE 0 END) AS "SEO",
    SUM(CASE WHEN cv.campaign_channel = 'REFERRAL' THEN 1 ELSE 0 END) AS "REFERRAL"
FROM 
    channel_s c
JOIN 
    click_visit cv ON c.campaign_type = cv.campaign_type
GROUP BY 
    c.campaign_type, c.total;
--------------------------------------------------------------------------------------------------------------------

-- I wanted to see how much each channel spent, showing 'successful/unsuccessful'.

WITH channel_spend AS (
    SELECT
        campaign_channel,
        SUM(ad_spend) AS total_spend
    FROM
        data.marketing
    WHERE 
        click_through_rate > 0.05 
        AND pages_per_visit >= 7
    GROUP BY
        campaign_channel
)
SELECT 
    campaign_channel,
    ROUND(total_spend)
FROM 
    channel_spend
ORDER BY 
    total_spend DESC;

-----------------------------------------------------------------------------------------------------------------------

--I measured how different social media channels contribute to retention.

WITH social_email_interaction AS (
    SELECT
        campaign_channel,
        campaign_type,
        SUM(social_shares) AS total_social_shares,
        SUM(email_opens) AS total_email_opens,
        SUM(email_clicks) AS total_email_clicks,
        AVG(conversion_rate) AS avg_conversion_rate,
        AVG(loyalty_points) AS avg_loyalty_score
    FROM
        data.marketing
    GROUP BY
        campaign_channel, campaign_type
)
SELECT
    campaign_channel,
    campaign_type,
    total_social_shares,
    total_email_opens,
    total_email_clicks,
    avg_conversion_rate,
    avg_loyalty_score,
    CASE 
        WHEN total_social_shares > total_email_opens THEN 'Social Media More Effective'
        WHEN total_email_opens > total_social_shares THEN 'Email More Effective'
        ELSE 'Both Equally Effective'
    END AS effectiveness
FROM
    social_email_interaction
ORDER BY
    avg_conversion_rate DESC, avg_loyalty_score DESC;

