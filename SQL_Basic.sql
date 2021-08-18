SELECT DISTINCT  state
FROM sql_store.customers;
-- Return all the products
-- name
-- unit price
-- new price(unit price*1.1)products
SELECT name,unit_price,(unit_price*1.1) as new_price
FROM products;
SELECT *
FROM customers
WHERE points>3000;
SELECT *
FROM customers
WHERE state in ("VA","TX","IL");
SELECT *
FROM customers
WHERE state  NOT in ("VA","TX","IL");
SELECT *
FROM products
WHERE quantity_in_stock in  (49,38,72);
SELECT *
FROM customers born
WHERE birth_date BETWEEN "1990-01-01" AND "2000-01-01";
SELECT *
FROM customers
WHERE address LIKE"%Trail%" OR 
	  address LIKE "%Avenue%" ;
SELECT *
FROM customers
WHERE phone LIKE "%9";
SELECT *
FROM customers
WHERE last_name REGEXP "field$|^mac|^rose";
SELECT *
FROM customers
WHERE last_name REGEXP "[a-z].e";
SELECT *
FROM customers
WHERE first_name LIKE "%Elka%" or
	  first_name LIKE "%Ambur%";
SELECT *
FROM customers
WHERE first_name REGEXP "Elka$|Ambur$";
SELECT *
FROM customers
WHERE last_name REGEXP "ey|on";
SELECT *
FROM customers
WHERE last_name REGEXP "^My|se";
SELECT *
FROM customers
WHERE last_name REGEXP "b[ru]";#br|bu
SELECT*
FROM orders
WHERE status=1;
SELECT*
FROM orders
WHERE shipped_date IS NULL AND shipper_id IS NULL;
SELECT *,quantity*unit_price as total_price
FROM order_items
WHERE order_id=2
ORDER BY total_price DESC;
SELECT *
FROM customers
order by points DESC
LIMIT 3;
SELECT oi.order_id,oi.product_id,oi.quantity,oi.unit_price
FROM order_items as oi
JOIN products as p on oi.product_id=p.product_id;
USE sql_inventory;
SELECT *
FROM sql_store.order_items as oi
JOIN sql_inventory.products as p on oi.product_id=p.product_id;
USE sql_hr;
SELECT e.employee_id,
	   e.first_name,
	   m.first_name as manager
FROM employees as e
JOIN employees as m 
	on e.reports_to=m.employee_id;
USE sql_store;
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name as status
FROM orders as o
JOIN customers as c 
	on o.customer_id=c.customer_id
JOIN order_statuses as os 
	on o.status=os.order_status_id;
USE sql_invoicing;
SELECT 
	p.payment_id,
    p.date,
    c.name,
    pm.name as payment_method,
    p.amount
FROM payments as p
JOIN clients as c
	on p.client_id=c.client_id
JOIN payment_methods as pm
	on p.payment_method=pm.payment_method_id;
USE sql_store;
SELECT 
	p.product_id,
    ot.quantity,
    p.name
FROM order_items as ot
RIGHT JOIN products as p
	on ot.product_id=p.product_id;
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    o.shipper_id,
    sh.name as shipper
FROM customers as c 
LEFT JOIN orders as o
	on c.customer_id=o.customer_id
LEFT JOIN shippers as sh
	on sh.shipper_id=o.shipper_id;
USE sql_store;
SELECT 
	o.order_date,
    o.order_id,
    c.first_name as customer,
    sh.name as shipper,
    os.name as shipper_name
FROM orders as o
JOIN customers as c
	on o.customer_id=c.customer_id
LEFT JOIN shippers as sh
	on o.shipper_id=sh.shipper_id
JOIN order_statuses as os
	on o.status=os.order_status_id;
USE sql_hr;
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name as manager
FROM employees as e
LEFT JOIN employees as m
	on e.reports_to=m.employee_id;
USE sql_invoicing;
SELECT 
	p.date,
    c.name,
    p.amount,
    pm.name as payment
FROM payments as p
JOIN clients as c
	USING(client_id)
JOIN payment_methods as pm
	on p.payment_method=pm.payment_method_id;
USE sql_store;
SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;#兩資料表之間同名的欄位會被自動結合在一起(和inner join一樣)
USE sql_store;
SELECT *
FROM products AS p
CROSS JOIN shippers as s;#P表裡的每個資料都會跟S表裡的資料結合
USE sql_store;
SELECT *
FROM products as p ,shippers as s;
SELECT name as full_name
FROM shippers as s
UNION
SELECT first_name
FROM customers;
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "BRONZE" AS type
FROM customers as c
WHERE points<2000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "GOLD" AS type
FROM customers as c
WHERE points>3000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "silver" AS type
FROM customers as c
WHERE points BETWEEN 2000 AND 3000
ORDER BY first_name ;
USE sql_store;
INSERT INTO products(
			name,
            quantity_in_stock,
            unit_price)
VALUES ("AMY",10,2.65),
		("ROGER",20,5.69),
        ("BOOKER",85,96.5);
CREATE TABLE  invoices_archive
SELECT 
	i.invoice_id,
    i.number,
    c.name,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices as i
JOIN clients as c 
ON i.client_id=c.client_id
WHERE payment_date IS NOT NULL;
UPDATE invoices 
SET 
	payment_total=invoice_total*0.5,
    payment_date=due_date
WHERE payment_date IS NULL;
USE sql_store;
UPDATE customers
SET
	points=points+50
WHERE birth_date<"1990-01-01";