select round(5.33); #四捨五入小數第一位#5#可加參數決定要四捨五入到第幾位
select truncate(5.7345,2);#73
select ceiling(5.1);#6
select floor(5.1);#5
select rand();#隨機0-1
select trim("      sky");#刪除左右空白
select left("kindergarden",4);#保留最左邊四個#right為右邊
select substring("kindergarden",3,5);#擷取第三個後五個
select locate("n","kindergarden");#找尋字母n
select replace("kindergraden","garten","garden");#替換字串
use sql_store;
select concat(first_name," ",last_name)as full_name
from customers;
select*
from orders
where year(order_date)>=extract(year from now());
select 
concat(first_name," ",last_name) as full_name,
ifnull(phone,"Unknown") as phone
#coalesce(phone,points,"Unknown")
from customers;
select
	product_id,
    name,
    count(product_id) as orders,
    if(count(product_id)>1,"Many times","Once")as frequency
from products
join order_items
using(product_id)
group by product_id;
select*
from(
select
	product_id,
    name,
	(select 
    count(product_id)
    from order_items 
    where product_id=p.product_id)as orders,
    if((select orders)>1,"Many times","Once")as frequency
from products as p) as result
where orders>0;
select
	concat(first_name," ",last_name)as customer,
    points,
    (CASE
		WHEN points>3000 then "GOLD"
        WHEN points between 2000 and 3000 then "SILVER"
        ELSE "BRONZE"
	END) AS category
from customers
order by points DESC