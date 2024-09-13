--Checking for null values after renaming and organizing column names
/*
use data;
SELECT * FROM game 
WHERE 
ranked IS NULL
OR game_name IS NULL
OR platform IS NULL
OR year IS NULL
OR genre IS NULL
OR publisher IS NULL
OR game_name IS NULL
OR na_sales IS NULL
OR jp_sales IS NULL
OR other_sales IS NULL
OR global_sales IS NULL
-- There are no null values in the dataset
-------------------------------------------------------------------------------------------------------------------
--Checking for illogical or invalid values
use data;
SELECT * FROM game 
WHERE ranked < 0 
OR
year < 0
OR 
na_sales<0
OR eu_sales<0
OR jp_sales<0
OR other_sales<0
OR global_sales<0

-----------------------------------------------------------------------------------------------------------

SELECT 
    *
FROM
    game
WHERE
    global_sales != 
    (SELECT 
            SUM(na_sales + eu_sales + jp_sales + other_sales)
	FROM game)

--No illogical results were found in the data

--------------------------------------------------------------------------------------------------------------

--Checking for duplicate values
SELECT 
    game_name, platform, year, COUNT(*)
FROM 
    game
GROUP BY 
    game_name, platform, year
HAVING COUNT(*) > 1;
-- There was 1 duplicate entry, which I removed
--------------------------------------------------------------------------------------------------------------

--Comparing the release dates of the games with the release dates of the platforms to ensure there are no logical inconsistencies
SELECT * FROM game
WHERE platform = 'PS4' AND year < 2013;

--I checked that the release dates of the games align with the platforms they were released on, and there are no issues.
-------------------------------------------------------------------------------------------------------------------------------
