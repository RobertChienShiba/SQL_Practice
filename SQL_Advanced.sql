use sql_invoicing;
create view client_balance as
select 
	client_id,
    name,
    sum(invoice_total)-sum(payment_total) as balance
from clients
join invoices
using (client_id)
group by client_id;
use sql_invoicing;
delimiter $$ 
create procedure get_invoices_with_balance ()
BEGIN
	select *
	from invoices
    where invoice_total-payment_total>0;
END$$
delimiter ;
use sql_invoicing;
call get_invoices_with_balance()
DROP procedure if exists get_clients_by_state
delimiter $$
create procedure get_clients_by_state 
(state char(2))
begin
	select *
    from clients as c
    where c.state=state;
end$$
delimiter ;
USE sql_invoicing;
call get_clients_by_state("CA");
use sql_invoicing;
drop procedure if exists get_invoices_by_client
delimiter $$
create procedure get_invoices_by_client 
(client_id int)
begin
	select*
    from invoices as i
    where i.client_id=client_id;
end$$
delimiter ;
use sql_invoicing;
 -- call  get_invoice_by_state(null); 
DROP procedure if exists get_clients_by_state;
CALL get_clients_by_state(null); 
use sql_invoicing;   
select 
	client_id,
    name,
    get_risk_factor_for_client(client_id)as risk_factor
from clients ;
use sql_invoicing;
delimiter $$
drop trigger if exists payment_after_delete;
create trigger  payment_after_delete
after delete on payments
for each row
begin
	update invoices
	set payment_total=payment_total-old.amount
	where invoice_id=old.invoice_id;
    
	insert into payments_audit
    values(old.client_id,old.date,old.amount,"Delete",now());
end $$
delimiter ;
use sql_invoicing;
delete 
from payments
where payment_id=5;
USE sql_invoicing; 
CREATE TABLE payments_audit
(
	client_id 		INT 			NOT NULL, 
    date 			DATE 			NOT NULL,
    amount 			DECIMAL(9, 2) 	NOT NULL,
    action_type 	VARCHAR(50) 	NOT NULL,
    action_date 	DATETIME 		NOT NULL
);
#show triggers
use sql_invoicing;
delimiter $$
drop trigger if exists payment_after_insert;

create trigger payment_after_insert
	after insert on payments
    for each row
begin
	update invoices
    set payment_total=payment_total+new.amount
    where invoice_id=new.invoice_id;
    
    insert into payments_audit
    values(new.client_id,new.date,new.amount,"Insert",now());
end$$
delimiter ;
insert into payments
values (default,5,3,"2019-01-01",10,1);
delete from payments
where payment_id=10;
use sql_store;
start transaction;

insert into orders (customer_id,order_date,status)
values (1,"2019-01-01",1);

insert into order_items
values(last_insert_id(),1,1,1);
commit;
use sql_store;
start transaction;
update customers
set points=points+10
where customer_id=1;
commit;
use sql_store;
set transaction isolation level serializable;
start transaction;
select *
from customers
where state="VA";
commit;
use sql_store;
start transaction;
update customer
set state="VA"
where customer_id=1;
update orders
set status=1
where order_id=1;
commit;
update products
set properties='
{
	"dimension":[1,2,3],
    "weight":10,
    "manufacturer":{"name":"sony"}
}
'
where product_id=1;
update products
set properties=JSON_OBJECT("weight",10,
"dimensions",JSON_ARRAY(1,2,3),
"manufacturer",JSON_OBJECT("name","sony"))
where product_id=1;
select product_id,properties->"$.weight"as weight
from products
where product_id=1;
select product_id,properties->>"$.manufacturer.name"
from products
where properties->>"$.manufacturer.name"="sony";
update products
set properties=JSON_set(
	properties,
    "$.weight",20,
    "$.age",10)
where product_id=1;
update products
set properties=JSON_remove(
	properties,
    "$.age"
    )
where product_id=1;
use sql_blog;
explain select customer_id from customers where state="CA";
CREATE INDEX IDX_STATE ON CUSTOMERS(state);
explain select points from customers where points>1000;
create index idx_points on customers(points);
show index in customers;
show index in orders;
create fulltext index idx_title_body on posts(title,body);
select * ,match(title,body)against('react redux')as relation 
from posts
where match(title,body)against('react -redux 'in boolean mode); #or match(title,body)against('react redux')>0.5
#where match(title,body)against('"handling"'in boolean mode)
use sql_store;
create index idx_state_point on customers(state,points);
explain select customer_id from customers
where state="CA" and points>1000;
#show index in customers
explain select customer_id 
from customers
#use index(idx_lastname_state) 
where state="CA" and last_name like "A%";
#create index idx_state_lastname on customers(state,last_name);
#show index in customers
explain select customer_id 
from customers
#use index(idx_lastname_state) 
where state="CA" or last_name like "A%";
#-->
create index idx_points on customers(points);
explain select customer_id 
from customers
where state="CA" 
union 
select customer_id 
from customers
where points>1000;
explain select customer_id 
from customers
#order by state;
order by state desc,points desc
-- (a,b)
-- a
-- a,b
-- a desc,b desc
-- 1:web/desktop application