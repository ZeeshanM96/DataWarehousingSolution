-- Query#4:Calculate average order processing and delivery times per store.

WITH OrderTimes AS (
    SELECT 
        O.StoreID,
        OS.OrderID,
        MIN(CASE WHEN OS.Status = 'In Progress' OR OS.Status = 'Processed' THEN OS.StatusTimestamp END) 
            AS ProcessingTime,
        MIN(CASE WHEN OS.Status = 'Delivered' THEN OS.StatusTimestamp END) 
            AS DeliveryTime,
        O.OrderDate
    FROM 
        Orders O
    JOIN 
        Order_Status OS ON O.OrderID = OS.OrderID
    GROUP BY 
        O.StoreID, OS.OrderID, O.OrderDate
),
ProcessingAndDeliveryTimes AS (
    SELECT
        StoreID,
        OrderID,
        EXTRACT(EPOCH FROM (ProcessingTime - OrderDate)) / 3600 AS ProcessingTimeHours,
        EXTRACT(EPOCH FROM (DeliveryTime - OrderDate)) / 3600 AS DeliveryTimeHours
    FROM 
        OrderTimes
    WHERE 
        ProcessingTime IS NOT NULL AND DeliveryTime IS NOT NULL
)
SELECT
    StoreID,
    AVG(ProcessingTimeHours) AS AvgProcessingTimeHours,
    AVG(DeliveryTimeHours) AS AvgDeliveryTimeHours
FROM 
    ProcessingAndDeliveryTimes
GROUP BY 
    StoreID
ORDER BY 
    StoreID;

-- Explanation
/*
Since the Order_Status table has history of order statuses, so used a CASE statement, to get:
- Processing Time: The earliest timestamp where the order status is "In Progress" or "Processed".
- Delivery Time: The earliest timestamp where the order status is "Delivered".

Then for each order, we calculated:
- Processing Time: Difference between the OrderDate in the Orders table and the timestamp of the "In Progress/Processed" status.
- Delivery Time: Difference between the OrderDate and the timestamp of the "Delivered" status.
- Used EXTRACT(EPOCH) to compute time differences in seconds, then convert to hours.

Then aggregate at the Store Level by Grouping by StoreID and calculate the average processing and delivery times (AVG()).

Here we made one assumptions that the status "In Progress" or "Processed" shows the beginning of order processing.
*/