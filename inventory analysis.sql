SELECT
    Supplier,
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) AS Stock_Outs,
    ROUND(
        SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Stock_Out_Rate_Percent
FROM raw
GROUP BY Supplier
ORDER BY Stock_Out_Rate_Percent DESC;

SELECT
    Category,
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) AS Stock_Outs,
    ROUND(
        SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Stock_Out_Rate_Percent
FROM raw
GROUP BY Category
ORDER BY Stock_Out_Rate_Percent DESC;



SELECT
    Product,
    Warehouse,
    Current_Stock,
    Reorder_Level,
    (Reorder_Level - Current_Stock) AS Stock_Shortage
FROM raw
WHERE Current_Stock < Reorder_Level
ORDER BY Stock_Shortage DESC;

SELECT
    Warehouse,
    SUM(Current_Stock) AS Total_Stock_Units,
    SUM(Current_Stock * Unit_Cost) AS Inventory_Value,
    COUNT(*) AS Total_Records
FROM raw
GROUP BY Warehouse
ORDER BY Inventory_Value DESC;


SELECT
    Supplier,
    ROUND(AVG(Lead_Time_Days), 2) AS Average_Lead_Time,
    MAX(Lead_Time_Days) AS Maximum_Lead_Time,
    MIN(Lead_Time_Days) AS Minimum_Lead_Time
FROM raw
GROUP BY Supplier
ORDER BY Average_Lead_Time DESC;


SELECT
    Product,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Current_Stock) AS Current_Stock,
    ROUND(
        SUM(Units_Sold) / NULLIF(SUM(Current_Stock), 0),
        2
    ) AS Sales_To_Stock_Ratio
FROM raw
GROUP BY Product
ORDER BY Sales_To_Stock_Ratio DESC;

SELECT
    Product,
    Warehouse,
    Current_Stock,
    Reorder_Level,
    Unit_Cost,
    (Current_Stock - Reorder_Level) AS Excess_Units,
    (Current_Stock - Reorder_Level) * Unit_Cost AS Excess_Inventory_Value
FROM raw
WHERE Current_Stock > Reorder_Level
ORDER BY Excess_Inventory_Value DESC;





SELECT
    Product,
    Warehouse,
    Current_Stock,
    Reorder_Level,
    Lead_Time_Days,
    CASE
        WHEN Current_Stock = 0 THEN 'Critical'
        WHEN Current_Stock < Reorder_Level THEN 'High'
        ELSE 'Low'
    END AS Risk_Level
FROM raw
WHERE Current_Stock < Reorder_Level
ORDER BY
    CASE
        WHEN Current_Stock = 0 THEN 1
        ELSE 2
    END,
    Lead_Time_Days DESC;
    
    
    
    
    
    SELECT
    Product,
    Warehouse,
    Current_Stock,
    Reorder_Level,
    Lead_Time_Days,
    (Reorder_Level - Current_Stock) AS Stock_Shortage,
    CASE
        WHEN Current_Stock = 0 AND Lead_Time_Days >= 7 THEN 'Urgent'
        WHEN Current_Stock = 0 THEN 'High'
        WHEN Current_Stock < Reorder_Level AND Lead_Time_Days >= 7 THEN 'High'
        ELSE 'Medium'
    END AS Reorder_Priority
FROM raw
WHERE Current_Stock < Reorder_Level
ORDER BY
    CASE
        WHEN Current_Stock = 0 AND Lead_Time_Days >= 7 THEN 1
        WHEN Current_Stock = 0 THEN 2
        WHEN Current_Stock < Reorder_Level AND Lead_Time_Days >= 7 THEN 3
        ELSE 4
    END;
    
    
    
    
    
    SELECT
    COUNT(*) AS Total_Records,
    SUM(Current_Stock) AS Total_Current_Stock,
    SUM(Current_Stock * Unit_Cost) AS Total_Inventory_Value,
    SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) AS Stock_Out_Records,
    ROUND(
        SUM(CASE WHEN Current_Stock = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Stock_Out_Rate,
    SUM(CASE WHEN Current_Stock < Reorder_Level THEN 1 ELSE 0 END) AS Reorder_Required,
    ROUND(
        SUM(CASE WHEN Current_Stock < Reorder_Level THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Reorder_Rate
FROM raw;




SELECT
    Product,
    COUNT(*) AS Stock_Out_Records
FROM raw
WHERE Current_Stock = 0
GROUP BY Product
ORDER BY Stock_Out_Records DESC, Product ASC
LIMIT 5;


SELECT
    Warehouse,
    COUNT(*) AS Stock_Out_Records
FROM raw
WHERE Current_Stock = 0
GROUP BY Warehouse
ORDER BY Stock_Out_Records DESC
LIMIT 5;