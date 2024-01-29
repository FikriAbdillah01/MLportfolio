use pizza_runner;

-- A. PIZZA METRICS

-- How many pizzas were ordered?
select count(*) as pizza_ordered from customer_orders;

-- How many unique customer orders were made?

select count(distinct order_id) as unique_customer_orders from customer_orders;

-- How many successful orders were delivered by each runner?

select ro.order_id,
pickup_time,
cancellation,
order_time
from runner_orders as ro
inner join customer_orders as co
on ro.order_id = co.order_id
where pickup_time <> 'null';

-- -- How many of each type of pizza was delivered?

select
co.pizza_id,
toppings,
sum(co.pizza_id) as delivered_pizzas
from 
customer_orders as co 
inner join runner_orders as ro on ro.order_id = co.order_id
inner join pizza_recipes as pr on pr.pizza_id = co.pizza_id
where pickup_time <> 'null'
group by co.pizza_id, toppings;

-- How many Vegetarian and Meatlovers were ordered by each customer?

select 
customer_id,
count(order_id) customer_vegmeat,
pizza_name
from customer_orders as co
inner join pizza_names as pn on co.pizza_id = pn.pizza_id
group by customer_id, pizza_name;

-- What was the maximum number of pizzas delivered in a single order?

select 
co.order_id,
pickup_time,
count(co.order_id) max_number_pizzas
from customer_orders as co
inner join runner_orders as ro on co.order_id = ro.order_id
where pickup_time <> 'null'
group by co.order_id, pickup_time
order by max_number_pizzas desc;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select
order_id,
(
exclusions <> 'null' and exclusions is not null and length(exclusions) > 0
and
extras <> 'null' and extras is not null and length (extras)>0
) changes,
count(pizza_id) ordered_pizzas
from customer_orders
group by 1,2;

--  What was the total volume of pizzas ordered for each hour of the day?

select 
count(pizza_id) ordered_pizzas, 
order_time, 
extract(hour from order_time) as time_in_hours 
from customer_orders group by order_time, time_in_hours;

-- What was the volume of orders for each day of the week?

select 
count(pizza_id) ordered_pizzas,
dayname(order_time) as days
from customer_orders
group by days; 

-- B. RUNNER AND CUSTOMER EXPERIENCES

-- How many runners sign up for each 1 week period? (i.e. week starts 2021-01-01)

select count(*) runners_sign_up, week(registration_date) as week_registred from runners group by week_registred;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select runner_id, round(avg(extract(minute from pickup_time)), 1) avg_time_minute from runner_orders where pickup_time <> 'null' group by runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
with preparing as(
select co.order_id, time_format(timediff(pickup_time, order_time),'%i:%s') preparation from customer_orders
as co
inner join runner_orders
as ro
on co.order_id = ro.order_id
where pickup_time <> 'null'
)
select order_id, avg(preparation) as prep_time_in_minute
from preparing
group by order_id;

-- What was the average distance travelled for each customer?
select customer_id, 
avg(cast(replace(distance, 'km', '') as decimal (3,1))) avg_distances 
from runner_orders as ro
inner join
customer_orders as co
on co.order_id = ro.order_id
where distance <> 'null'
group by customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
select * from runner_orders;
with durationss as (
select order_id,
cast(regexp_replace(duration, '[^0-9]','') as unsigned) new_duration from runner_orders
) 
select (max(new_duration) - min(new_duration)) difference_duration
from durationss
where new_duration <> 0;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

with runner_speed as(
select runner_id, order_id, cast(replace(distance, 'km','') as decimal(3,1)) order_distance, 
cast(regexp_replace(duration,'[^0-9]','') as unsigned) time_in_mins
from runner_orders where distance <> 'null'
)
select runner_id, order_id, avg(order_distance/time_in_mins) km_per_minute
from runner_speed
group by runner_id, order_id;

-- What is the successful delivery percentage for each runner?

with percentages_orders as(
select runner_id, 
sum(case 
	when pickup_time = 'null' then 0
else 1
end) as successful_order,
count(runner_id) as total_order
from runner_orders
group by
runner_id
)
select *, cast((successful_order/total_order)*100 as decimal(3,0)) percentage
from percentages_orders;

-- C. INGREDIENT OPTIMIZATION --

-- What are the standard ingredients for each pizza?

select * from pizza_recipes;


select *
from pizza_recipes
where find_in_set(, toppings);