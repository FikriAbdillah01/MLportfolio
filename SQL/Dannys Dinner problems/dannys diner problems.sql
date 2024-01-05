use dannys_diner;

-- -- 1. What is the total amount each customer spent at the restaurant?

select 
costumer_id,
sum(price) as total_price
from sales
as s
inner join menu 
as m 
on s.product_id = m.product_id
group by 
costumer_id;

-- 2. How many days has each customer visited the restaurant?

select costumer_id, order_date, count(distinct order_date) as total_visited from sales group by costumer_id, order_date;

-- 3. What was the first item from the menu purchased by each customer?

select costumer_id, order_date, product_name,
rank() over(partition by costumer_id order by order_date asc) as first_menu,
row_number () over (partition by costumer_id order by order_date asc) as ranking
from menu
as m
inner join sales
as s
on m.product_id = s.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select product_name, count(product_name) total_sold_product
from menu
as m
inner join sales
as s
on m.product_id = s.product_id
group by product_name
order by total_sold_product desc;

-- 5. Which item was the most popular for each customer?

select product_name,
costumer_id,
count(order_date) orders,
rank() over(partition by costumer_id order by count(order_date) asc) popularity
from menu
as m
inner join sales
as s
on m.product_id = s.product_id
group by product_name, costumer_id;

-- 6. Which item was purchased first by the customer after they became a member?
with membership as (
select s.costumer_id, product_name, order_date, join_date, (order_date - join_date) as day_after_be_member, rank() over(partition by s.costumer_id order by (order_date - join_date) asc) as shortest_time 
from sales
as s
inner join members
as m
on s.costumer_id = m.costumer_id
inner join menu 
as n
on s.product_id = n.product_id
where join_date < order_date

) select * 
from membership
where shortest_time = 1;

--  7. Which item was purchased just before the customer became a member?

with membership as (
select s.costumer_id, 
product_name, 
order_date, 
join_date, 
(join_date - order_date) as day_before_be_member, 
rank() over(partition by s.costumer_id order by (join_date - order_date) asc) as shortest_time 
from sales
as s
inner join members
as m
on s.costumer_id = m.costumer_id
inner join menu 
as n
on s.product_id = n.product_id
where join_date > order_date

) select * 
from membership;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select
costumer_id,
sum(case when
product_name = 'sushi'
then
price *10*2
else
price *10
end) points
from
sales
as s
inner join
menu
as
m
on
s.product_id = m.product_id
group by
costumer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi
-- how many points do customer A and B have at the end of January?

with get_points as(
select 
s.costumer_id,
sum(case
	when order_date between join_date and date_add(m.join_date, interval 6 day) then price*2*10 
    when product_name = 'sushi' then price *2*10
    else price *10
    end
    )
as points
from
sales as s
inner join
members as m
on
m.costumer_id = s.costumer_id
inner join
menu as n
on
n.product_id = s.product_id
where date(date_format(order_date, '%Y-01-30'))
group by costumer_id
)
select * 
from get_points
where costumer_id =  'A' or costumer_id = 'B';

