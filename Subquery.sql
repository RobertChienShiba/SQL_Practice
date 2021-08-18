USE sql_store;
UPDATE orders
SET comments="GOLD CUSTOMER"
WHERE customer_id in(
					SELECT customer_id
                    FROM customers
                    WHERE points>3000);
USE sql_invoicing;
DELETE FROM invoices
WHERE client_id=(
				SELECT client_id
                FROM clients
                WHERE name="MyWorks"
                );
USE sql_invoicing;
SELECT
	"First half of 2019"as date_range,
    sum(invoice_total) as total_sales,
    sum(payment_total)as total_payments,
    sum(invoice_total-payment_total)as what_we_except
FROM invoices
WHERE invoice_date BETWEEN "2019-01-01" AND "2019-06-30"
UNION
SELECT
	"Second half of 2019" as date_range,
    sum(invoice_total) as total_sales,
    sum(payment_total)as total_payments,
    sum(invoice_total-payment_total)as what_we_except
FROM invoices
WHERE invoice_date>"2019-07-01"
UNION
SELECT
	"Total of 2019" as date_range,
    sum(invoice_total) as total_sales,
    sum(payment_total)as total_payments,
    sum(invoice_total-payment_total)as what_we_except
FROM invoices;
select
	p.date,
    pm.name,
    p.amount as total_amount
from payments as p
join payment_methods as pm
on p.payment_method=pm.payment_method_id
ORDER by date ;
USE sql_store;
select
    customer_id,
    first_name,
    last_name,
    state,
    (select
	sum(quantity*unit_price) as total
from orders 
join order_items using(order_id)
where order_id in(
select
	order_id
from customers
join orders using(customer_id)
where state="VA"
group by order_id))as total
#=================================
from customers
join orders using(customer_id)
group by state 
having state="VA" and total>100;
##上題另解(比較好)
select
	customer_id,
    first_name,
    last_name,
    state,
    sum(quantity*unit_price)as total 
from customers as c
join orders as o 
using(customer_id)
join order_items as ot
using(order_id)
where state="VA"
group by customer_id with rollup
having total>100;
use sql_invoicing;
select
	pm.name as payment_method,
    sum(amount)as total
from payments as p
join payment_methods as pm
on p.payment_method=pm.payment_method_id
group by pm.name with rollup;
use sql_hr;
select *
from employees
where salary>(
select
	avg(salary)
    from employees
    );
USE sql_invoicing;
select*
from clients
where client_id not in (
				select distinct client_id
				from invoices
				);
USE sql_store;
select
	customer_id,
    first_name,
    last_name
from customers 
join orders
using(customer_id)
join order_items
using(order_id)
where product_id = 3 ;
select 
	distinct customer_id,
    first_name,
    last_name
from customers
where customer_id in(
select customer_id
from orders
where order_id in(select order_id
from order_items
where product_id=3
));
use sql_hr;
select *
from employees as e
where salary>(
select AVG(salary)
from employees
where office_id=e.office_id);
use sql_invoicing;
select *
from invoices as i
where invoice_total>(
select avg(invoice_total)
from invoices 
where client_id=i.client_id
);
use sql_store;
select *
from products as p
where product_id not in (
select product_id
from order_items
where product_id=p.product_id
);
select *
from products as p
where not exists (
select product_id
from order_items
where product_id=p.product_id
);
use sql_invoicing;
select 
	invoice_id,
    invoice_total,
    (select avg(invoice_total)
    from invoices)as invoice_avg,
    invoice_total-(select invoice_avg
    ) as invoice_diff
from invoices;
use sql_invoicing;
select
	client_id,
    name,
    sum(invoice_total)as total_sales,
    (select avg(invoice_total)
    from invoices) as average,
    (select sum(invoice_total)-average)as diff    
from invoices
right join clients
using (client_id)
group by client_id;
#===============================================================
use sql_invoicing;
select
	c.client_id,
	c.name,
    (select sum(invoice_total)
    from invoices
    where client_id=c.client_id) as total_sales,
    (select avg(invoice_total)
    from invoices) as average,
	(select total_sales-average) as diff
from clients as c;