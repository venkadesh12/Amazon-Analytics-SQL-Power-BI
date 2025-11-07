use amazon;

#retrieve all customers from a specific city? 
select name,city from customers where city="north kyle" ;

#fetch all products under the "fruits" category? 
select productname,category from products where category="fruits";

#write ddl statements to recreate the customers table with the following constraints: 
#1.customerid as the primary key? 
alter table customers change column customer_id customer_id varchar(100) primary key;

#2.ensure age cannot be null and must be greater than 18? 
alter table customers change column age age int not null;
alter table customers add  check (age>=18);                                                        

#3.add a unique constraint for name? 
alter table customers add constraint  unique (name);                                                       

#task5  insert 3 new rows into the products table using insert statements? 
insert into products values("wurid-1244-2nbb64-43","however fruit","fruits","sub-fruits-1",324,897,"98h-gdr-t567-89");
insert into products values("13rfdr345yhhrf","evrer green fruit","fruits","sub-fruits-1",2345,5432,"23fvd355mmgk443");
insert into products values("wurid-1244-2nbb64-400","however fruit","fruits","sub-fruits-1",324,897,"98098hjki-dr-t567-89");

#task6  update the stock quantity of a product where productid matches a specific id? 
set sql_safe_updates =0;
update products set stockquantity=999 where product_id= "d79d1b95-ecdf-4810-aea0-45e9bd10627d";

#task7 delete a supplier from the suppliers table where their city matches a specific values 
delete from suppliers where city="schneidermouth";

#task8
#add a check constraint to ensure that ratings in the reviews table are between 1 and 5? 
select * from reviews;
alter table reviews add constraint check (rating between 1 and 5);

#add a default constraint for the primemember column in the customers table (default value: "no")? */
select * from customers;
alter table customers modify column primemember varchar(100)  default "no";

#task9
#where clause to find orders placed after 2024-01-01? 
select * from orders;
select * from orders where orderdate > "2024-01-01";

#having clause to list products with average ratings greater than 4? 

select p.productname,round(avg(r.rating),1) as avg_rating from products as p
join reviews as r on (p.product_id=r.productid) group by p.productname 
having avg(r.rating) > 4;

#group by and order by clauses to rank products by total sales? 
select p.productname,sum(o.unitprice) as total_sales from products as p
join order_details as o on (p.product_id=o.productid)
group by productname order by total_sales desc;

#task10 
#1.calculate each customer's total spending? 
select distinct(c.customer_id),sum(o.orderamount) as total_spending from customers as c
join orders as o on (c.customer_id=o.customerid)
group by c.customer_id  order by total_spending desc;

# 2. rank customers based on their spending? 
select distinct name,sum(o.orderamount) as total_spending,
rank() over(order by sum(o.orderamount)desc) as ranking
from customers as c join orders as o on (c.customer_id=o.customerid)
group by c.customer_id ,name order by total_spending desc;

# 3. identify customers who have spent more than ₹5,000? 
select c.customer_id,name, sum(o.orderamount) as total_spending
from customers as c join orders as o on (c.customer_id=o.customerid)
where o.orderamount > 5000 group by c.customer_id,name order by total_spending;

# task11
#1.join the orders and orderdetails tables to calculate total revenue per order? 
select o.customerid,od.order_id,sum(o.orderamount) as total_revenue from orders as o
join order_details as od on (o.order_id=od.order_id)
group by o.customerid,od.order_id order by total_revenue desc;

# 2. identify customers who placed the most orders in a specific time period. 
select c.customer_id,c.name,count(o.order_id) as totalorders from customers as c
join orders as o on (c.customer_id=o.customerid)
group by c.customer_id, c.name order by totalorders desc limit 1;

# 3. find the supplier with the most products in stock? 
select s.suppliers_id,s.suppliername,sum(p.stockquantity) over() as stock 
from products as p join suppliers as s on p.supplierid=s.suppliers_id
order by stock desc limit 1;                                                                             

# task12 separate product categories and subcategories into a new table? 
create view new_table as(select category as c,subcategory as s from products);
select*from new_table;

# task13 identify the top 3 products based on sales revenue? 
select p.productname, sum(o.quantity*o.unitprice) as revenue from products as p
join order_details as o on (p.product_id=o.productid)
group by p.productname order by revenue desc limit 3;

# find customers who haven’t placed any orders yet? 
select name as non_ordered_customer
from customers as c left join orders as o
on (c.customer_id=o.customerid) where o.order_id is null  group by name;

# task14 which cities have the highest concentration of prime members? 
select city, count(*) as prime_members from customers
where primemember="yes" group by city order by prime_members desc ;

# what are the top 3 most frequently ordered categories? 
select category, count(o.order_id) as most_order_by_category from products as p
join order_details as o on (p.product_id=o.productid)
group by category order by most_order_by_category desc ;