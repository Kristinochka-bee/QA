-- show databases; -- отобразит все базы данных
 use `qa32e_readonly`;
describe customers; -- вывод свойства таблицы
SELECT city,phone FROM offices ORDER BY phone DESC;
SELECT COUNT(lastName) FROM employees ;

-- 1. Prepare a list of offices sorted by country, state, city.
SELECT country, state, city FROM offices ORDER BY country ASC;
SELECT country, state, city FROM offices ORDER BY state ASC;
SELECT country, state, city FROM offices ORDER BY city ASC;

-- 2 How many employees are there in the company?
SELECT count(firstName) FROM employees;

-- 3 What is the total of payments received?
SELECT SUM(amount) FROM payments WHERE amount > 10000; 

-- 4 List the product lines that contain 'Cars'.
SELECT * FROM products WHERE productLine like '%Cars';

-- 5 Report total payments for October 28, 2004.
SELECT SUM(amount) FROM payments WHERE paymentDate = '2004-10-28';

-- 6 Report those payments greater than $100,000.
SELECT amount FROM payments WHERE amount > 100000;

-- 7 List the products in each product line.
SELECT p.productName,
	   p.productLine
FROM products p
INNER JOIN productlines p2 
ON p2.productLine = p.productLine;

-- 8 How many products in each product line.
SELECT count(p.productName),
	   p.productLine
FROM products p
INNER JOIN productlines p2 
ON p2.productLine = p.productLine;


-- 1 How many products in each product line?
use `qa32e_readonly`;

SELECT sum(p.productName) as product_qty,
		p.productLine 
FROM products p 
JOIN productlines p2 
ON p2.productLine = p.productLine 
GROUP BY p.productLine ;


-- 2 What is the minimum payment received?
SELECT min(amount) as min_payment,
		p.customerNumber 
FROM payments p 
JOIN customers c 
ON c.customerNumber = p.customerNumber 
GROUP BY customerNumber 
ORDER BY min_payment;

-- 3 List all payments greater than twice the average payment.
SELECT *
FROM payments 
WHERE amount > (SELECT avg(amount) * 2  FROM payments)

-- 4 What is the average percentage markup of the MSRP on buyPrice? //products table
SELECT avg((MSRP / buyPrice) )
FROM products ;

-- 5 How many distinct products does ClassicModels sell?
SELECT count(productCode)
FROM products p
JOIN productlines p2  
ON p.productLine = p2.productLine 
WHERE p2.productLine like 'Classic%';

-- 6 Report the name and city of customers who don't have sales representatives?
SELECT contactFirstName, contactLastName -- , e.employeeNumber, e.firstName, e.lastName  
FROM customers c 
-- LEFT JOIN employees e 
-- ON e.employeeNumber = c.salesRepEmployeeNumber 
WHERE  c.salesRepEmployeeNumber IS NULL

-- 7 What are the names of executives with VP or Manager in their title? Use the CONCAT function 
-- to combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT_WS(" ", e.firstName, e.lastName),
		jobTitle
FROM employees e
WHERE ((jobTitle like  'VP%' )or (jobTitle like '%Manager%'));


-- 8 Which orders have a value greater than $5,000?
SELECT orderNumber , 
sum(quantityOrdered * priceEach)
FROM orderdetails  
GROUP BY orderNumber
having sum(quantityOrdered * priceEach) > 5000;


 use `qa32e_readonly`;
-- 1 Report the account representative for each customer.

SELECT c.customerNumber, CONCAT(contactFirstName," ",contactLastName)
from customers c 
JOIN payments p 
ON c.customerNumber = p.customerNumber 
GROUP BY c.customerNumber; -- исключает дублирование 


-- 2 Report total payments for Atelier graphique
use `qa32e_readonly`;
SELECT  c.customerName ,
		sum(p.amount )
FROM payments p 
JOIN customers c
ON c.customerNumber = p.customerNumber 
WHERE c.customerName = 'Atelier graphique'
GROUP BY c.customerName ;

-- 3 Report the total payments by date
 use `qa32e_readonly`;
SELECT  p.paymentDate,
		sum(p.amount )
FROM payments p
GROUP BY p.paymentDate ;

-- 4 Report the products that have not been sold.
SELECT * 
FROM products 
where not exists ( SELECT * FROM orderdetails WHERE products.productCode = orderdetails.productCode );

-- 5 List the amount paid by each customer
 use `qa32e_readonly`;
SELECT  c.customerName ,
		sum(p.amount) as amount_paid
FROM payments p
JOIN customers c 
ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber
ORDER BY amount_paid DESC;


-- 6 How many orders have been placed by Herkku Gifts?
SELECT  c.customerName ,
		count(orderNumber) 
FROM orders o 
JOIN customers c 
ON c.customerNumber  = o.customerNumber  
WHERE customerName  = 'Herkku Gifts';


-- 7 Who are the employees in Boston?
SELECT CONCAT_WS (" ",e.firstName, e.lastName),
		o.city 
FROM employees e 
JOIN offices o 
ON o.officeCode = e.officeCode 
WHERE o.city = 'Boston';


-- 8 Report those payments greater than $100,000. Sort the report so the customer who made the highest payments appears first.
SELECT *
FROM customers c 
JOIN payments p 
ON p.customerNumber = c.customerNumber 
WHERE p.amount > 100000
GROUP BY p.customerNumber
ORDER BY p.amount DESC;


-- 9 List the value of 'On Hold' orders
SELECT 
  o.orderNumber,
  (o2.quantityOrdered * o2.priceEach) as value,
  o.status 
 FROM orders o
 INNER JOIN orderdetails o2 
 ON o.orderNumber = o2.orderNumber 
 WHERE o.status = "On hold"
 GROUP BY o2.orderNumber ;


-- 10 Report the number of orders 'ON Hold' for each customer
 use `qa32e_readonly`;
SELECT  c.customerName ,
		count(orderNumber) 
FROM orders o 
JOIN customers c 
ON c.customerNumber  = o.customerNumber  
WHERE o.status  = 'On Hold'
GROUP BY orderNumber;

-- 1 List products sold by order date
SELECT p.productName, o.orderDate 
	FROM products p ,orders o , orderdetails d
 WHERE d.productCode = p.productCode 
 and o.orderNumber = d.orderNumber
 and o.status NOT LIKE 'On Hold';