-- Query#3: Retrieve the top 2 most and least popular items for each month.

WITH ItemPopularity AS (
    SELECT
        EXTRACT(YEAR FROM OrderDate) AS Year,
        EXTRACT(MONTH FROM OrderDate) AS Month,
        ItemName,
        ARRAY_AGG(OI.OrderID) AS OrderIDs,
        COUNT(*) AS Popularity
    FROM
        Order_Items OI
    JOIN
        Orders O ON OI.OrderID = O.OrderID
    GROUP BY
        EXTRACT(YEAR FROM OrderDate),
        EXTRACT(MONTH FROM OrderDate),
        ItemName
),
RankedItems AS (
    SELECT
        Year,
        Month,
        ItemName,
        OrderIDs,
        Popularity,
        RANK() OVER (PARTITION BY Year, Month ORDER BY Popularity DESC) AS RankHigh,
        RANK() OVER (PARTITION BY Year, Month ORDER BY Popularity ASC) AS RankLow
    FROM
        ItemPopularity
)
SELECT
    Year,
    Month,
    ItemName AS Item,
    OrderIDs,
    Popularity,
    'Most Popular' AS PopularityRank
FROM
    RankedItems
WHERE
    RankHigh <= 2
UNION ALL
SELECT
    Year,
    Month,
    ItemName AS Item,
    OrderIDs,
    Popularity,
    'Least Popular' AS PopularityRank
FROM
    RankedItems
WHERE
    RankLow <= 2
ORDER BY
    Year, Month, PopularityRank, Popularity DESC;

-- Explanation
/*
First we used Join Order_Items with Orders to combine the ItemName from Order_Items with the OrderDate from Orders by matching the OrderID to group items by month and year of their associated orders.
Then we Aggregated Popularity and Collect OrderIDs
by using COUNT(*) to calculate the popularity of each ItemName (number of times it appears in orders) and used ARRAY_AGG(OrderID) to gather all OrderIDs associated with each item into an array.
Then Ranked Items by RANK() to assigns a rank to each item within a given month:
    RankHigh: Based on highest popularity (ORDER BY Popularity DESC).
    RankLow: Based on lowest popularity (ORDER BY Popularity ASC).
We filtered the top 2 Most and Least Popular Items by:
    Select items with RankHigh <= 2 for the top 2 most popular.
    Select items with RankLow <= 2 for the top 2 least popular.
To combine Results, we use UNION ALL to merge the results for the most and least popular items into a single output.
*/