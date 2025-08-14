CREATE TABLE ProductCategory(
	CategoryID SERIAL PRIMARY KEY,
	CategoryName varchar(50) UNIQUE NOT NULL
);

COPY ProductCategory(CategoryName)
FROM 'D:/DA-BA/Project July/ProductCategory.csv'
DELIMITER ','
CSV HEADER;

------------------------------------------------------------------------------------
-- | Tình huống                   | Lệnh nên dùng                                  |
-- | ---------------------------- | ---------------------------------------------- |
-- | Muốn xóa một vài dòng        | `DELETE FROM ... WHERE ...`                    |
-- | Muốn xóa toàn bộ và giữ ID   | `DELETE FROM ...;`                             |
-- | Muốn xóa toàn bộ và reset ID | `TRUNCATE TABLE ... RESTART IDENTITY;`         |
-- | Có quan hệ khóa ngoại        | `TRUNCATE TABLE ... RESTART IDENTITY CASCADE;` |

--Kiểm tra tên sequence 
SELECT pg_get_serial_sequence('productcategory', 'categoryid');
DELETE FROM ProductCategory;
--Reset ID
ALTER SEQUENCE productcategory_categoryid_seq RESTART WITH 1;

SELECT * FROM ProductCategory

CREATE TABLE ProductSubCategory(
	SubCategoryID SERIAL PRIMARY KEY,
	SubCategoryName varchar(50) UNIQUE NOT NULL,
	CategoryID int NOT NULL,
	FOREIGN KEY (CategoryID) REFERENCES ProductCategory(CategoryID) ON DELETE CASCADE
);
--Tạo bảng tam
CREATE TABLE TempSubCategory (
    SubCategoryName VARCHAR(100),
    CategoryName VARCHAR(100)
)

COPY TempSubCategory(SubCategoryName, CategoryName)
FROM 'D:\DA-BA\Project July\ProductSubCategory.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO ProductSubCategory(SubCategoryName, CategoryID)
SELECT t.SubCategoryName, c.CategoryID
FROM TempSubCategory t
JOIN ProductCategory c ON t.CategoryName = c.CategoryName;

DROP TABLE TempSubCategory;

SELECT * FROM ProductSubCategory 
------------------------------------------------------------------------------------

CREATE TABLE Products(
	ProductID varchar(20) PRIMARY KEY,
	ProductName text NOT NULL,
	SubCategoryID int NOT NULL,
	FOREIGN KEY (SubCategoryID) REFERENCES ProductSubCategory(SubCategoryID) ON DELETE CASCADE
);
--Tạo bảng tam
CREATE TABLE TempProduct (
    ProductID VARCHAR(100),
    ProductName VARCHAR(100)
)
ALTER TABLE tempproduct
ALTER COLUMN productname TYPE VARCHAR(255);

COPY TempProduct(ProductID, ProductName)
FROM 'D:\DA-BA\Project July\Product.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Products(ProductID, ProductName, SubCategoryID)
SELECT t.ProductID, t.ProductName, p.SubCategoryID
FROM TempProduct t
JOIN ProductSubCategory p ON t.SubCategoryName = p.SubCategoryName;

select * from tempproduct

DROP TABLE IF EXISTS TempProduct;

CREATE TEMP TABLE TempProduct (
    ProductID VARCHAR(100),
    ProductName VARCHAR(255),
    SubCategoryName VARCHAR(100)
);

COPY TempProduct(ProductID, ProductName, SubCategoryName)
FROM 'D:/DA-BA/Project July/Product.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Products(ProductID, ProductName, SubCategoryID)
SELECT t.ProductID, t.ProductName, p.SubCategoryID
FROM TempProduct t
JOIN ProductSubCategory p ON t.SubCategoryName = p.SubCategoryName;

SELECT * FROM Products

DROP TABLE TempProduct
------------------------------------------------------------------------------------

CREATE TABLE Customers(
	CustomerID varchar(20) PRIMARY KEY,
	CustomerName varchar(50),
	Segment varchar(50)
);

COPY Customers(CustomerID, CustomerName, Segment)
FROM 'D:/DA-BA/Project July/Customer.csv'
DELIMITER ','
CSV HEADER;

------------------------------------------------------------------------------------

CREATE TABLE Geography(
	PostalCode int PRIMARY KEY,
	Country varchar(30),
	City varchar(30),
	"State" varchar(30),
	Region varchar(30)
);
ALTER TABLE Geography RENAME COLUMN "State" TO state;

COPY Geography(PostalCode, Country, City, "State", Region)
FROM 'D:/DA-BA/Project July/Geography.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM Geography

------------------------------------------------------------------------------------

CREATE TABLE Orders(
	OrderID varchar(20) PRIMARY KEY,
	OrderDate Date,
	ShipDate Date,
	ShipMode varchar(30),
	CustomerID varchar(20) REFERENCES Customers(CustomerID),
	PostalCode int REFERENCES Geography(PostalCode)
);

COPY Orders(OrderID, OrderDate, ShipDate, ShipMode, CustomerID, PostalCode)
FROM 'D:/DA-BA/Project July/Order.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM Orders
------------------------------------------------------------------------------------

CREATE TABLE OrderDetails(
	OrderDetailID SERIAL PRIMARY KEY,
	OrderID varchar(20) REFERENCES Orders(OrderID) ON DELETE RESTRICT,
	ProductID varchar(20) REFERENCES Products(ProductID) ON DELETE RESTRICT,
	Sales numeric,
	Quantity int,
	Discount numeric(4,2),
	Profit numeric
);

COPY OrderDetails(OrderID, ProductID, Sales, Quantity, Discount, Profit)
FROM 'D:/DA-BA/Project July/OrderDetails.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM OrderDetails






