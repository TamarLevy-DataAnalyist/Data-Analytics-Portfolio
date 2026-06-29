--PROJECT 2
--1.
WITH YearlyIncome AS (
    SELECT
        YEAR(i.InvoiceDate) as InvoiceYear,
        SUM(il.ExtendedPrice - il.TaxAmount) as IncomePerYear,
        COUNT(DISTINCT MONTH(i.InvoiceDate)) as NumberOfDistinctMonth,
		 SUM(il.ExtendedPrice - il.TaxAmount) * 12.0 
		 / COUNT(DISTINCT MONTH(i.InvoiceDate)) as YearlyLinearIncome
    FROM Sales.InvoiceLines il
    JOIN Sales.Invoices i
        ON il.InvoiceID = i.InvoiceID
    GROUP BY YEAR(i.InvoiceDate)
)
SELECT InvoiceYear,FORMAT(IncomePerYear,'N2') as IncomePerYear,NumberOfDistinctMonth,
    FORMAT(YearlyLinearIncome,'N2') as YearlyLinearIncome,
  FORMAT(ROUND((YearlyLinearIncome - LAG(YearlyLinearIncome) OVER (ORDER BY InvoiceYear))
        / LAG(YearlyLinearIncome) OVER (ORDER BY InvoiceYear) * 100, 2), 'N2') as GrowthRate
FROM YearlyIncome
ORDER BY InvoiceYear;

--2.
WITH CustomerRevenue AS(
	SELECT
		YEAR(inv.InvoiceDate) as TheYear,
		DATEPART(QUARTER, inv.InvoiceDate)  as TheQuarter,
		cust.CustomerName,
		SUM(il.Quantity * il.Unitprice) as IncomePerYear	
	FROM Sales.Invoices inv 
		JOIN sales.InvoiceLines il
		on inv.InvoiceID = il.InvoiceID
		join sales.Orders o
		on inv.OrderID = o.OrderID
		join sales.Customers cust
		on o.CustomerID = cust.CustomerID
		GROUP BY year (inv.InvoiceDate),DATEPART(QUARTER, inv.InvoiceDate),
		cust.CustomerName
	),
	RankedCustomers  as(
		SELECT theYear, TheQuarter, CustomerName, IncomePerYear, 
		 ROW_NUMBER()OVER (PARTITION BY theYear,TheQuarter
		 ORDER BY IncomePerYear DESC
		   ) as CustomerRank		 
		FROM CustomerRevenue
	)
	SELECT *
	FROM RankedCustomers
	WHERE CustomerRank <=5
	ORDER BY  TheYear,TheQuarter, CustomerRank; 

--3.
SELECT TOP 10 si.StockItemID,si.stockitemname, 
		sum(il.ExtendedPrice - il.TaxAmount) as TotalProfit
FROM sales.InvoiceLines as il
	join Warehouse.stockitems as si
		on il.StockItemID= si.StockItemID
	join Sales.Invoices as i
		on il.InvoiceID=i.InvoiceID
WHERE i.IsCreditNote = 0
GROUP BY si.StockItemID,si.StockItemName
ORDER BY totalProfit DESC;

--4.
SELECT
    ROW_NUMBER() OVER (ORDER BY (si.RecommendedRetailPrice - si.UnitPrice) DESC) as Rn,
    si.StockItemID,
    si.StockItemName,
    si.UnitPrice,
    si.RecommendedRetailPrice,
    (si.RecommendedRetailPrice - si.UnitPrice) as NominalProductProfit,
DENSE_RANK() OVER (ORDER BY (si.RecommendedRetailPrice - si.UnitPrice) DESC) as DNR
FROM Warehouse.StockItems as si
WHERE si.ValidTo >GETDATE()
ORDER BY NominalProductProfit DESC;


--5.

SELECT CAST(s.SupplierID as varchar(10)) + ' - ' + s.SupplierName as SupplierDetails,
    STRING_AGG(CAST(si.StockItemID AS varchar(10)) + ' ' + si.StockItemName,',/ ') as ProductDetails
FROM Purchasing.Suppliers as s
JOIN Warehouse.StockItems as si
    ON s.SupplierID = si.SupplierID
GROUP BY s.SupplierID,s.SupplierName
ORDER BY s.SupplierID;

--6.
SELECT TOP 5 c.CustomerID,ct.CityName,co.CountryName,co.Continent,co.Region,
   FORMAT( SUM(il.ExtendedPrice),'N2') as TotalExtendedPrice
FROM Sales.InvoiceLines as il
JOIN Sales.Invoices as i
    ON il.InvoiceID = i.InvoiceID
JOIN Sales.Customers as c
    ON i.CustomerID = c.CustomerID
JOIN Application.Cities as ct
    ON c.DeliveryCityID = ct.CityID
JOIN Application.StateProvinces as sp
    ON ct.StateProvinceID = sp.StateProvinceID
JOIN Application.Countries as co
    ON sp.CountryID = co.CountryID
GROUP BY c.CustomerID,ct.CityName,co.CountryName,co.Continent,co.Region
ORDER BY SUM(il.ExtendedPrice) DESC;

--7.
WITH MonthlyTotals AS (
    SELECT
        YEAR(i.InvoiceDate)  as InvoiceYear,
        MONTH(i.InvoiceDate) as InvoiceMonth,
        SUM(il.ExtendedPrice - il.TaxAmount) as MonthlyTotal
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
        ON i.InvoiceID = il.InvoiceID
		WHERE i.IsCreditNote = 0
    GROUP BY YEAR(i.InvoiceDate),MONTH(i.InvoiceDate)
),
WithCumulative AS (
    SELECT InvoiceYear,InvoiceMonth,MonthlyTotal,
        SUM(MonthlyTotal) OVER (PARTITION BY InvoiceYear
		ORDER BY InvoiceMonth ROWS UNBOUNDED PRECEDING) as CumulativeTotal
    FROM MonthlyTotals
),
FinalResult AS(
SELECT
    InvoiceYear,
    CAST(InvoiceMonth AS VARCHAR(20)) as InvoiceMonth,
    MonthlyTotal,CumulativeTotal,InvoiceMonth AS SortMonth
FROM WithCumulative
UNION ALL

SELECT	InvoiceYear,'Grand Total' as InvoiceMonth,
	SUM(MonthlyTotal),SUM(MonthlyTotal), 13 
FROM MonthlyTotals
GROUP BY InvoiceYear
)
SELECT InvoiceYear,InvoiceMonth,
    FORMAT(MonthlyTotal, 'N2') as MonthlyTotal,
    FORMAT(CumulativeTotal, 'N2') as CumulativeTotal
FROM FinalResult
ORDER BY InvoiceYear, SortMonth;

--8.
SELECT OrderMonth,
    ISNULL([2013], 0) as [2013],
    ISNULL([2014], 0) as [2014],
    ISNULL([2015], 0) as [2015],
    ISNULL([2016], 0) as [2016]
FROM (
    SELECT
        MONTH(o.OrderDate) as OrderMonth,
        YEAR(o.OrderDate)  as OrderYear,
        o.OrderID
    FROM Sales.Orders o
) AS OrdersByMonthAndYear
PIVOT (COUNT(OrderID)
    FOR OrderYear IN ([2013], [2014], [2015], [2016])) as p
ORDER BY OrderMonth;

--9.
WITH OrdersWithPrev AS (
    SELECT o.CustomerID,c.CustomerName,o.OrderDate,
        LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) as PreviousOrderDate
    FROM Sales.Orders o
    JOIN Sales.Customers c
        ON o.CustomerID = c.CustomerID
),

OrdersWithAvg AS (
    SELECT CustomerID,CustomerName,OrderDate,PreviousOrderDate,
        DATEDIFF(DAY, PreviousOrderDate, OrderDate) as DaysBetweenOrders,
        AVG(DATEDIFF(DAY, PreviousOrderDate, OrderDate))
		OVER (PARTITION BY CustomerID) as AvgDaysBetweenOrders
    FROM OrdersWithPrev
),
LastOrderPerCustomer AS (
    SELECT *,
        MAX(OrderDate) OVER (PARTITION BY CustomerID) as LastCustomerOrderDate,
        MAX(OrderDate) OVER () as LastOrderDateAll
    FROM OrdersWithAvg
)
SELECT CustomerID,CustomerName,OrderDate,PreviousOrderDate,
    CAST(AvgDaysBetweenOrders as INT) as AvgDaysBetweenOrders,LastCustomerOrderDate,
    DATEDIFF(DAY,LastCustomerOrderDate,LastOrderDateAll) as DaysSinceLastOrder,
    CASE WHEN DATEDIFF(DAY, LastCustomerOrderDate, LastOrderDateAll) > 2 * AvgDaysBetweenOrders
        THEN 'Potential Churn'
        ELSE 'Active'
    END AS CustomerStatus
FROM LastOrderPerCustomer
ORDER BY CustomerID, OrderDate;

--10.

WITH CustomersNormalized AS (
    SELECT
        CASE
            WHEN c.CustomerName LIKE 'Wingtip%' THEN 'Wingtip Customers'
            WHEN c.CustomerName LIKE 'Tailspin%' THEN 'Tailspin Customers'
            ELSE c.CustomerName
        END as NormalizedCustomerName,
        cc.CustomerCategoryName,
        c.CustomerID
    FROM Sales.Customers c
		JOIN Sales.CustomerCategories cc
		 ON c.CustomerCategoryID = cc.CustomerCategoryID		
),
CustomerCounts AS (
    SELECT CustomerCategoryName,
        COUNT(DISTINCT NormalizedCustomerName) as CustomerCOUNT
    FROM CustomersNormalized
    GROUP BY CustomerCategoryName
),
TotalCustomers AS (
    SELECT
        SUM(CustomerCOUNT) as TotalCustCount
    FROM CustomerCounts
)
SELECT cc.CustomerCategoryName,cc.CustomerCOUNT,tc.TotalCustCount,
    FORMAT((CAST(cc.CustomerCOUNT AS FLOAT) / tc.TotalCustCount) * 100,'N2') + '%' as DistributionFactor
FROM CustomerCounts cc
CROSS JOIN TotalCustomers tc
ORDER BY cc.CustomerCategoryName;