use dannys_diner;
set search_path = dannys_diner;

CREATE TABLE sales (
costumer_id VARCHAR(1),
order_date Date,
product_id INTEGER);

insert into sales 
(costumer_id, order_date, product_id)
values
('A', '2021-01-01','1'),
('A', '2021-01-01', '2'),
('A', '2021-01-07', '2'),
('A', '2021-01-10', '3'),
('A', '2021-01-11', '3'),
('A', '2021-01-11', '3'),
('B', '2021-01-01', '2'),
('B', '2021-01-02', '2'),
('B', '2021-01-04', '1'),
('B', '2021-01-11', '1'),
('B', '2021-01-16', '3'),
('B', '2021-02-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-07', '3'),
('B', '2021-01-09', '3');

create table menu(
product_id integer,
product_name varchar(5),
price integer
);

insert into menu (
product_id, product_name, price)
values
('1', 'sushi','10'),
('2', 'curry', '15'),
('3', 'ramen', '20');

create table members (
costumer_id varchar(1),
join_date date
);

insert into members
(costumer_id, join_date)
values
('A', '2021-01-07'),
('B', '2021-01-09'),
('C', '2021-01-06');


