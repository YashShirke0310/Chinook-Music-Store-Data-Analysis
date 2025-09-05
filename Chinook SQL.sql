#AUTHOR= YASH SHIRKE
use chinook;

#Total Revenue
SELECT SUM(Total) AS TotalRevenue FROM Invoice;

#Average Order Value
SELECT AVG(Total) AS AverageInvoiceValue FROM Invoice;

#Top 5 Customers by Revenue
SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS Revenue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Revenue DESC
LIMIT 5;



 
 #1ST KPI
#JOIN Query – Get all track names with artist and genre
SELECT t.Name AS TrackName, ar.Name AS Artist, g.Name AS Genre
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
JOIN Genre g ON t.GenreId = g.GenreId;

#2ND KPI
#Subquery – Customers above average spend
SELECT FirstName, LastName, Total
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE Total > (SELECT AVG(Total) FROM Invoice);

#3RD KPI=Window Function – Rank tracks by price within genre 
SELECT t.Name, g.Name AS Genre,
       RANK() OVER (PARTITION BY g.Name ORDER BY t.UnitPrice DESC) AS PriceRank
FROM Track t
JOIN Genre g ON t.GenreId = g.GenreId;

#4TH KPI = Top-Selling Track by Revenue (JOIN + GROUP BY)
SELECT t.Name AS TrackName,
       SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY TotalRevenue DESC
LIMIT 5;

-- --------------------------------------------------

#5TH KPI = Artist with the Most Tracks (JOIN + GROUP BY)
SELECT ar.Name AS ArtistName,
       COUNT(t.TrackId) AS TrackCount
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
GROUP BY ar.ArtistId, ar.Name
ORDER BY TrackCount DESC
LIMIT 5;


#6TH KPICustomer=Lifetime Value (JOIN + AGGREGATION)
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       SUM(i.Total) AS LifetimeValue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY LifetimeValue DESC;

#7TH KPI =️ Revenue by Country (JOIN + GROUP BY)
SELECT c.Country,
       SUM(i.Total) AS TotalRevenue
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY TotalRevenue DESC;

#8THN KPI =  Average Items Per Invoice (WINDOW FUNCTION)
-- Part A: List of items per invoice
SELECT DISTINCT il.InvoiceId,
       COUNT(il.TrackId) OVER (PARTITION BY il.InvoiceId) AS ItemsPerInvoice
FROM InvoiceLine il;

# Part B: Overall Average items per invoice using subquery
SELECT AVG(ItemsPerInvoice) AS AvgItemsPerInvoice
FROM (
    SELECT DISTINCT il.InvoiceId,
           COUNT(il.TrackId) OVER (PARTITION BY il.InvoiceId) AS ItemsPerInvoice
    FROM InvoiceLine il
) AS Sub;


