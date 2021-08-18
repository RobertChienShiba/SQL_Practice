create database if not exists sql_store2;
use sql_store2;
#drop table if exists customer
create table  if not exists customer
(
	customer_id int primary key auto_increment,
    first_name varchar(50) not null ,
    points int not null default 0,
    email varchar(255) not null unique
);
use sql_store2;
alter table customer
#add column  last_name varchar(50) not null after first_name,
add city varchar(50) not null,
modify column first_name varchar(55) default "",
drop points;
use sql_store2;
drop table if exists orders; 
create table orders
(	order_id int primary key,
	customer_id int not null,
    foreign key fk_orders_customers (customer_id)
		references customer(customer_id)
        on update cascade
        on delete no action
);
alter table orders
#drop foreign key orders_ibfk_1
add foreign key fk_orders_customers(customer_id)
	references customers(customer_id)
    on update cascade
    on delete no action;
-- 1:web/desktop application
#create user moon_app identified by "1234";
grant select,insert,delete,update,execute
on sql_store.*
to moon_app;
-- 2:admin 
grant all
on *.*
to moon_app;
show grants for moon_app;
revoke create view
on sql_store.*
from moon_app;
drop user moon_app