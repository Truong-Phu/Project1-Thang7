--Doanh thu theo danh muc con
SELECT c.CategoryName, sc.SubCategoryName, SUM(od.Sales)
FROM OrderDetails od JOIN Products p ON p.ProductID=od.ProductID
JOIN ProductSubCategory sc ON sc.SubCategoryID=p.SubCategoryID
JOIN ProductCategory c ON c.CategoryID=sc.CategoryID
GROUP BY c.CategoryName, sc.SubCategoryName
ORDER BY SUM(od.Sales)

--Doanh thu theo thoi gian
SELECT 
    EXTRACT(DAY FROM o.OrderDate) AS Ngay,
    EXTRACT(MONTH FROM o.OrderDate) AS Thang,
    -- EXTRACT(YEAR FROM o.OrderDate) AS Nam,
    SUM(od.Sales) AS DoanhThu
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY Ngay, Thang
ORDER BY SUM(od.Sales)

--Top 5 khach hang 
SELECT c.CustomerName, SUM(od.Sales) 
FROM OrderDetails od JOIN Orders o ON o.OrderID=od.OrderID
JOIN Customers c ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerName
ORDER BY SUM(od.Sales) DESC
LIMIT 5

--top 5 san pham
SELECT p.ProductName, SUM(od.Sales) 
FROM OrderDetails od JOIN Products p ON p.ProductID=od.ProductID
JOIN Orders o ON o.OrderID=od.OrderID
-- WHERE EXTRACT(DAY FROM o.OrderDate) = 15
GROUP BY p.ProductName 
ORDER BY SUM(od.Sales) DESC 

--Loi nhuan segment
SELECT c.Segment, SUM(od.Profit)
FROM OrderDetails od JOIN Orders o ON o.OrderID=od.OrderID
JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY c.Segment


--Doanh thu theo segment
SELECT c.Segment, SUM(od.Sales)
FROM OrderDetails od JOIN Orders o ON o.OrderID=od.OrderID
JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY c.Segment

--Doanh thu loi nhuan ship mode
SELECT o.ShipMode, SUM(od.Sales), SUM(od.Profit) 
FROM OrderDetails od JOIN Orders o ON o.OrderID=od.OrderID 
GROUP BY  o.ShipMode

--Doanh thu loi nhuan theo doanh muc
SELECT c.CategoryName, sc.SubCategoryName, SUM(od.Sales), SUM(od.Profit) 
FROM OrderDetails od JOIN Products p ON p.ProductID=od.ProductID
JOIN ProductSubCategory sc ON sc.SubCategoryID=p.SubCategoryID
JOIN ProductCategory c ON c.CategoryID=sc.CategoryID
GROUP BY c.CategoryName, sc.SubCategoryName

--Tong doanh thu
SELECT SUM(Sales) FROM OrderDetails

--Tong loi nhuan
SELECT SUM(Profit) FROM OrderDetails

--Tong don hang
SELECT Count(*) FROM Orders
SELECT COUNT(DISTINCT OrderID) FROM OrderDetails;

--Tong khach hang
SELECT COUNT(CustomerID) FROM Customers WHERE unique