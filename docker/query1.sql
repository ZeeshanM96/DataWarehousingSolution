-- Query#1: Report totals gross revenue by store and campaign.

SELECT 
    StoreID,
    COALESCE(CampaignID, 'No Campaign') AS CampaignID,
    SUM(Total) AS GrossRevenue
FROM 
    Orders
GROUP BY 
    StoreID, CampaignID
ORDER BY 
    StoreID, CampaignID;

-- Explanation
/*COALESCE(CampaignID, 'No Campaign'): Replaces NULL values in the CampaignID column with 'No Campaign' for readability.
SUM(Total): Aggregates the total gross revenue for each combination of StoreID and CampaignID.
GROUP BY StoreID, CampaignID: Groups data by StoreID and CampaignID to calculate revenue for each unique pair.
ORDER BY StoreID, CampaignID: Orders the result.
*/