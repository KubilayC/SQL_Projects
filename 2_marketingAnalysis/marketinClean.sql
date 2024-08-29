
--In a dataset containing 8000 records, I started the data cleaning process by adjusting the column names for usability and correcting some typographical errors.
/*use data;
ALTER TABLE marketing
RENAME COLUMN `ï»¿CustomerID` TO `customer_id`,
RENAME COLUMN `Age` TO `age`,
RENAME COLUMN `Gender` TO `gender`,
RENAME COLUMN `Income` TO `income`,
RENAME COLUMN `CampaignChannel` TO `campaign_channel`,
RENAME COLUMN `CampaignType` TO `campaign_type`,
RENAME COLUMN `AdSpend` TO `ad_spend`,
RENAME COLUMN `ClickThroughRate` TO `click_through_rate`,
RENAME COLUMN `WebsiteVisits` TO `website_visits`,
RENAME COLUMN `PagesPerVisit` TO `pages_per_visit`,
RENAME COLUMN `TimeOnSite` TO `time_on_site`,
RENAME COLUMN `SocialShares` TO `social_shares`,
RENAME COLUMN `EmailClicks` TO `email_clicks`,
RENAME COLUMN `EmailOpens` TO `email_opens`,
RENAME COLUMN `PreviousPurchases` TO `previous_purchases`,
RENAME COLUMN `LoyaltyPoints` TO `loyalty_points`,
RENAME COLUMN `AdvertisingPlatform` TO `advertising_platform`,
RENAME COLUMN `AdvertisingTool` TO `advertising_tool`,
RENAME COLUMN `ConversionRate` TO `conversion_rate`,
RENAME COLUMN `Conversion` TO `conversion`;

----------------------------------------------------------------------------------------------------------------

--When I checked for any null values in the dataset, I found that there were no null values among the 8000 records.
SELECT * 
FROM data.marketing
WHERE click_through_rate IS NULL
   OR conversion_rate IS NULL
   OR website_visits IS NULL
   OR pages_per_visit IS NULL
   OR time_on_site IS NULL
   OR social_shares IS NULL
   OR email_opens IS NULL
   OR email_clicks IS NULL
   OR previous_purchases IS NULL
   OR loyalty_points IS NULL
   OR advertising_platform IS NULL
   OR advertising_tool IS NULL
   OR conversion IS NULL;
   
----------------------------------------------------------------------------------------------------------------------

-- The absence of any duplicate or null values surprised me. 
--Therefore, I proceeded with some logical validations and further checks to control the data and make it more manageable.

SELECT * 
FROM data.marketing 
WHERE age < 0 OR income < 0;
------------------------------------No logical errors found-------------------------------------------------------

SELECT 
    customer_id, 
    CAST(age AS UNSIGNED) AS age_type_check, 
    CAST(income AS DECIMAL(10,2)) AS income_type_check 
FROM data.marketing;
------------------------------------- No errors found--------------------------------------------------------------------

-- For better visibility, I converted specific fields to uppercase.
UPDATE data.marketing 
SET campaign_channel = UPPER(campaign_channel);
-----------------------------------------------------------------------------------------------------------------------
--I also checked for any outliers, and no outlier was found.
SELECT * 
FROM data.marketing 
WHERE click_through_rate > 1.0 
   OR conversion_rate > 1.0 
   OR pages_per_visit > 100;



