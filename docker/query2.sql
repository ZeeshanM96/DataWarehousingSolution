-- Query#2: Report on highest and lowest spending members for each month.

WITH MonthlySpending AS (
    SELECT 
        EXTRACT(YEAR FROM OrderDate) AS Year,
        EXTRACT(MONTH FROM OrderDate) AS Month,
        MemberID,
        SUM(Total) AS TotalSpending
    FROM 
        Orders
    GROUP BY 
        EXTRACT(YEAR FROM OrderDate), 
        EXTRACT(MONTH FROM OrderDate),
        MemberID
),
RankedSpending AS (
    SELECT 
        Year,
        Month,
        MemberID,
        TotalSpending,
        RANK() OVER (PARTITION BY Year, Month ORDER BY TotalSpending DESC) AS RankHigh,
        RANK() OVER (PARTITION BY Year, Month ORDER BY TotalSpending ASC) AS RankLow
    FROM 
        MonthlySpending
)
SELECT 
    Year,
    Month,
    MemberID AS HighSpender,
    TotalSpending AS HighSpending
FROM 
    RankedSpending
WHERE 
    RankHigh = 1
UNION ALL
SELECT 
    Year,
    Month,
    MemberID AS LowSpender,
    TotalSpending AS LowSpending
FROM 
    RankedSpending
WHERE 
    RankLow = 1
ORDER BY 
    Year, Month;
-- Explanation
/*
The query check for the highest and lowest spending members for each month by:
- First aggregating total spending for each member by month.
- Then ranking members within each month based on their spending.
- Then extracting the top-ranked and bottom-ranked members.
*/