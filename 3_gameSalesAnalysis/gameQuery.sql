--ilk olarak en çok satış hangi platfromlarda olmuş ve bu platfromlardaki en çok satılan oyunları merak ettim

/*WITH RankedGames AS (
    SELECT 
        platform,
        game_name,
        global_sales,
        ROW_NUMBER() OVER (PARTITION BY platform ORDER BY global_sales DESC) AS first
    FROM 
        data.game
)
SELECT 
    platform,
    ROUND(SUM(global_sales)) AS Total_Sales_In_Million,
    MAX(CASE WHEN first = 1 THEN game_name END) AS Most_Selling_Game
FROM
    RankedGames
GROUP BY 
    platform
ORDER BY 
    Total_Sales_In_Million DESC;

---------------------------------------------------------------------------------------------