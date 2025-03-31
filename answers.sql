-- answers.sql

-- Question 1: Achieving 1NF (First Normal Form)
-- Create a new table OrderProducts in 1NF
CREATE TABLE OrderProducts (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

-- Insert data from ProductDetail into OrderProducts, splitting the Products
INSERT INTO OrderProducts (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, SUBSTRING_INDEX(Products, ',', n) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3
) AS numbers
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

-- Note: The above INSERT statement assumes a maximum of 3 products per order.
-- For a more dynamic solution, you would typically use procedural code or a series of queries
-- to split the comma-separated values.

-- To view the result in 1NF:
-- SELECT * FROM OrderProducts;

-- Question 2: Achieving 2NF (Second Normal Form)
-- Create a new table Orders without the partial dependency
CREATE TABLE Orders2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert order information into the Orders2NF table
INSERT INTO Orders2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a new table OrderItems with the full dependency on the primary key
CREATE TABLE OrderItems2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders2NF(OrderID)
);

-- Insert order item details into the OrderItems2NF table
INSERT INTO OrderItems2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- To view the tables in 2NF:
-- SELECT * FROM Orders2NF;
-- SELECT * FROM OrderItems2NF;
