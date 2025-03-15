-- Task 1: Import the database (assumes mintclassicsDB.sql exists)
-- Source: Task Guide

-- Task 2: Explore the database structure

-- View all tables
SHOW TABLES;

-- Describe each table
DESC warehouses;
DESC products;
DESC productlines;
DESC orders;
DESC orderdetails;
DESC customers;
DESC payments;
DESC employees;
DESC offices;

-- Task 3: Identify relevant tables for warehouse closure decision

-- Count total products stored in each warehouse
SELECT warehouseCode, COUNT(*) AS total_products 
FROM products 
GROUP BY warehouseCode;

-- Identify products with low sales volume (potential candidates for reduction)
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS total_sold 
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productCode
ORDER BY total_sold ASC;

-- Task 4: Analyze sales patterns and inventory

-- Identify best-selling products
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS total_sold
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productCode
ORDER BY total_sold DESC
LIMIT 10;

-- Check average sales per warehouse
SELECT p.warehouseCode, SUM(od.quantityOrdered) AS total_sold
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.warehouseCode;

-- What-if scenario: Reduce quantity on hand by 5%
SELECT productCode, productName, quantityInStock, 
       quantityInStock * 0.95 AS reduced_stock
FROM products;

-- Task 5: Recommendations

-- Identify warehouses with lowest inventory & sales impact
SELECT p.warehouseCode, SUM(p.quantityInStock) AS total_inventory, 
       SUM(od.quantityOrdered) AS total_sold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.warehouseCode
ORDER BY total_inventory ASC, total_sold ASC;

-- Identify customers with high purchase volume (ensure they are not affected)
SELECT c.customerNumber, c.customerName, SUM(od.quantityOrdered) AS total_purchased
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber
ORDER BY total_purchased DESC;
