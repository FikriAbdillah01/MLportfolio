select * from sales;

-- 1. What is the total amount each customer spent at the restaurant?

select costumer_id, sum(price) as total_price from sales as s inner join menu as m on s.product_id = m.product_id group by costumer_id;

-- 2. How many days has each customer visited the restaurant?

select 
costumer_id, 
count(distinct order_date) as visited_date 
from sales 
group by costumer_id;

-- 3. What was the first item from the menu purchased by each customer?

select 
costumer_id, order_date, product_name,
rank() over (partition by costumer_id order by order_date asc) as ranking,
row_number() over (partition by costumer_id order by order_date asc) as RN
from sales as s 
inner join menu as n on s.product_id = n.product_id;

-- we can use another way of query

with ctm as (
	select costumer_id, order_date, product_name,
    rank() over (partition by costumer_id order by order_date asc) as ranking,
    row_number() over (partition by costumer_id order by order_date asc) as RN
    from sales as s
    inner join menu as m on s.product_id = m.product_id
    )
select
costumer_id,
product_name
from ctm
where ranking = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select
product_name,
count(order_date) as orders
from sales as s
inner join menu as m on s.product_id = m.product_id
group by product_name;

-- 5. Which item was the most popular for each customer?
with popular as (
	select
	product_name,
	costumer_id,
	count(order_date) as orders,
	row_number () over (partition by costumer_id order by count(order_date) desc) as popularity
	from sales as s
	inner join menu as m on s.product_id = m.product_id
	group by costumer_id, product_name
)
select 
costumer_id, 
product_name
from popular
where popularity =  1;


-- 6. Which item was purchased first by the customer after they became a member?

with membership as(
	select 
	s.costumer_id,
	join_date,
	product_name,
	order_date,
	(order_date - join_date) as days_after_join,
	rank () over (partition by s.costumer_id order by (order_date - join_date) asc) as ranking
	from members as m
	inner join sales as s on m.costumer_id = s.costumer_id
	inner join menu as n on n.product_id = s.product_id
	where order_date >= join_date
)
select *
from membership 
where ranking = 1;

-- 7. Which item was purchased just before the customer became a member?

with interest as (
	select 
    s.costumer_id,
    join_date,
    order_date,
    product_name,
    (join_date - order_date) as days_before_join,
    rank () over (partition by s.costumer_id order by (join_date - order_date) desc) as ranking
    from members as m
    inner join sales as s on s.costumer_id = m.costumer_id
    inner join menu as n on s.product_id = n.product_id
    where order_date <= join_date
    )
select 
costumer_id,
days_before_join, 
product_name
from interest
where ranking = 1;
    
-- 8. What is the total items and amount spent for each member before they became a member?

with spending as (
	select
    s.costumer_id,
    sum(price) as amount_spent,
    count(product_name) as total_product
    from sales as s
    inner join members as mem on mem.costumer_id = s.costumer_id
    inner join menu as n on n.product_id = s.product_id
    where order_date < join_date
    group by s.costumer_id)
select *
from spending;
    

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select 
costumer_id,
sum(case 
when product_name = 'sushi' then price * 10 * 2
else price * 10 
end) as points
from menu as m
inner join sales as s on s.product_id = m.product_id
group by costumer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi
-- how many points do customer A and B have at the end of January?

select 
s.costumer_id,
case
	when order_date between mem.join_date and date_add(mem.join_date, interval 6 day) then price * 2 * 10
	when product_name =  'sushi' then price * 10 * 2
	else price * 10
end as points,
mem.join_date,
order_date
from menu as n
inner join sales as s on s.product_id = n.product_id
inner join members as mem on mem.costumer_id = s.costumer_id
where order_date < date(date_format(order_date, '%Y-01-30'))
group by s.costumer_id;