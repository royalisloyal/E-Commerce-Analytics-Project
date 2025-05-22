---E-Commerce-Analytics-Project-Intermidiate level
---Category table(Parent table-01)
Create table category(
category_id int primary key,
category_name varchar(25)
);

---Customer table(parent table-02)
create table customers(
customer_id int primary key,
first_name varchar(25),
last_name varchar(25),
state varchar(25),
address varchar(5) DEFAULT ('XXX')
);

---Sellers table(parent table-03)
Create table sellers(
seller_id int primary key,
seller_name varchar(25),
origin varchar(5)
);
---update column
ALTER TABLE sellers ALTER COLUMN origin TYPE varchar(20);

---Product table
Create table products(
product_id int primary key,
product_name varchar(55),
price decimal(10,2),  
cogs decimal(10,2),
category_id int,  ---FK
constraint product_fk_category foreign key (category_id) references category(category_id)
);

---Orders table
create table orders(
order_id int primary key,
order_date DATE,
customer_id int, ---fk
seller_id int, ---fk
product_id int, ---fk
order_status varchar(25),
constraint orders_fk_customers foreign key (customer_id) references customers(customer_id),
constraint orders_fk_sellers foreign key (seller_id) references sellers (seller_id),
constraint orders_fk_product foreign key (product_id) references products(product_id)
);

--- Order_items table
create table order_items(
order_item_id int primary key,
order_id int, ---fk
product_id int, ---fk
quantity int,
price_per_unit decimal(10,2),
constraint orders_items_fk_orders foreign key (order_id) references orders(order_id),
constraint orders_items_fk_products foreign key (product_id) references products(product_id)
);

---Payment table
Create table payments(
payment_id int primary key,
order_id int, ---fk
payment_date DATE,
payment_status varchar(30),
constraint payments_fk_orders foreign key (order_id) references orders(order_id)
);

---Shipping table
create table shippings(
shipping_id int primary key,
order_id int, ---fk
shipping_date DATE,
return_date DATE,
shipping_provider varchar (20),
delivery_status varchar(25),
constraint shippings_fk_orders foreign key (order_id) references orders(order_id)
);

---Inventory table
Create table inventory(
inventory_id int primary key,
product_id int, ---fk
stock int,
warehouse_id int,
last_stock_date DATE,
constraint inventory_fk_products foreign key (product_id) references products(product_id)
);


---Some modification----

Select distinct payment_status from payments;


select * from shippings
where return_date is not null;

---update my delivery status where return date is not null
UPDATE shippings
SET delivery_status = 'Returned'
WHERE return_date IS NOT NULL;


---(let's see the status in the payment table and the order table for the order_id = 5013)
select * from orders
where order_id = 5013;

select * from payments
where order_id = 5013;

--Update the order_status in the orders table for the specified order_id values:

UPDATE orders
SET order_status = 'Returned'
WHERE order_id IN (
    5013, 5018, 5028, 5040, 5049, 5054, 
    5058, 5063, 5066, 5082, 5086, 5089, 
    5101, 5109, 5122, 5128, 5142, 5148
);
--- Update the payment stauts in the payment table for specified order_id values:
Update payments
set payment_status = 'Refunded'
WHERE order_id IN (
    5013, 5018, 5028, 5040, 5049, 5054, 
    5058, 5063, 5066, 5082, 5086, 5089, 
    5101, 5109, 5122, 5128, 5142, 5148
);

select  from shippings where return_date is null;


select  * from order_items
order by quantity desc;


--- creating new column
alter table order_items
add column total_sale decimal (15,2);

--update price quantity* price per unit
update order_items
set total_sale = quantity * price_per_unit;

-- Shows top 10 customers by order count
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_orders DESC
LIMIT 10;


