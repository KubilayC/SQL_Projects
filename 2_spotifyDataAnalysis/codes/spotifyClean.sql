--Data Cleaning 
/*use data;
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Track,'Album Name',Artist,'Release Date','All Time Rank','Spotify Streams','Youtube Views','TikTok Likes') AS row_num
FROM spotify
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;*/

--Data Altering
/*
use data;
ALTER TABLE spotify
RENAME COLUMN `Album Name` TO `album_name`,
RENAME COLUMN `All Time Rank` TO `all_time_rank`,
RENAME COLUMN `Spotify Streams` TO `spotify_streams`,
RENAME COLUMN `YouTube Views` TO `youtube_views`,
RENAME COLUMN `YouTube Likes` TO `youtube_likes`,
RENAME COLUMN `TikTok Likes` TO `tiktok_likes`,
RENAME COLUMN `TikTok Views` TO `tiktok_views`,
RENAME COLUMN `Soundcloud Streams` TO `soundcloud_streams`
*/

/*use data;
SELECT COUNT(Album_Name),COUNT(DISTINCT(Album_Name)) FROM data.spotify;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Album_Name) AS row_num
FROM spotify)
SELECT *
FROM duplicate_cte WHERE row_num > 1
--As a result, similar tracks that were released in different albums appeared. I didn't remove them because the artists are differen
--Then, using the delete function, I removed the rows that did not contain data in our key fields of TikTok_Likes, YouTube_Likes, and YouTube_Views. As a result, around 15 records were cleaned.

--The only remaining column with null values was the SoundCloud column. Since these might be songs that were not released on SoundCloud, instead of removing this column, I simply replaced the missing data with 'no info'.
/*UPDATE spotify
SET Soundcloud_Streams = 'no info'
WHERE Soundcloud_Streams = '';*/
-- Finally, after the cleaning process, I checked for any duplicate data and found 8 tracks listed. However, this listing includes our 'All Time rank' column, which shows the overall listening rank of the songs on Spotify
-- Upon evaluation, the total number and the number of unique tracks were equal, indicating that there were no duplicate original tracks. After this, I began the querying process.
----------------------------------------------------------------------------------------------------------------------------------
--When I started the query, I noticed a new error: data types that should be integers, such as tiktok_views, are in text format in the dataset.
-- I need to convert them to integers. Before converting them to integers, I need to check if there are any non-generic inputs, as they could cause issues during the conversion.
/*
SELECT 
    *
FROM 
    spotify
WHERE 
    spotify_streams NOT REGEXP '^[0-9]+$' 
    OR tiktok_views NOT REGEXP '^[0-9]+$';*/

--Out of 1400 records, 1040 were found to have non-generic inputs. I need to correct these before proceeding.
------------------------------------------------------------------------------------------------------------------------------------------

--I removed commas and spaces, as they are generally present in text-based numeric data.
/*UPDATE spotify
SET 
    spotify_streams = REPLACE(REPLACE(spotify_streams, ',', ''), ' ', ''),
    tiktok_views = REPLACE(REPLACE(tiktok_views, ',', ''), ' ', '');*/

---------------------------------------------------------------------------------------------------------------------------------

--Afterwards i transfer data to integer
/*ALTER TABLE spotify
MODIFY spotify_streams BIGINT UNSIGNED,
MODIFY tiktok_views BIGINT UNSIGNED;
-----------------------------------------------------------------------------------------------------------------------------------------------
--Now we can use query