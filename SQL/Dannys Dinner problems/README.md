# Introduction

---

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

# Problem

---

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

- sales
- menu
- members

You can inspect the entity relationship diagram and example data below. 


<p align = center>
<img width = 600 height = 300 src = 'dannys diagram.png'>
</p>


# Case Study Questions

---

1. What is the total amount each customer spent at the restaurant?

```sql
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
```

2. How many days has each customer visited the restaurant?

```sql
select costumer_id, order_date, count(distinct order_date) as total_visited 
from sales 
group by costumer_id, order_date;
```

3. What was the first item from the menu purchased by each customer?

```sql
select costumer_id, order_date, product_name,
rank() over(partition by costumer_id order by order_date asc) as first_menu,
row_number () over (partition by costumer_id order by order_date asc) as ranking
from menu
as m
inner join sales
as s
on m.product_id = s.product_id;
```

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
select product_name, count(product_name) total_sold_product
from menu
as m
inner join sales
as s
on m.product_id = s.product_id
group by product_name
order by total_sold_product desc;
```

5. Which item was the most popular for each customer?

```sql
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
```

6. Which item was purchased first by the customer after they became a member?

```sql
with membership as 
(
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
) 
select * 
from membership
where shortest_time = 1;

```

7. Which item was purchased just before the customer became a member?

```sql
with membership as 
(
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
) 
select * 
from membership;
```

8. What is the total items and amount spent for each member before they became a member?

```sql

```

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql

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
```

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January?

```sql
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

```