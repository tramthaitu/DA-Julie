-- Bài 1
select NAME
from CITY
Where POPULATION >120000 and COUNTRYCODE ='USA'
-- Bài 2
select *
FROM CITY
WHERE COUNTRYCODE ='JPN'
-- Bài 3
select CITY,STATE
FROM STATION
-- BÀI 4
select distinct CITY
FROM STATION 
where CITY like 'A%' or CITY LIKE 'E%'OR CITY LIKE'I%' OR CITY LIKE'O%' OR CITY LIKE'U%'
-- Bài 5
select distinct CITY 
from STATION 
where CITY LIKE '%A'OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'
-- BÀI 6
select DISTINCT CITY 
FROM STATION 
where CITY not like 'A%' and CITY not LIKE 'E%'and CITY not LIKE'I%' and CITY not LIKE'O%' and CITY not LIKE'U%'
-- bài 7
select name 
from Employee
order by name ASC
-- bài 8
select name 
from Employee
where salary > 2000 and months <10
-- bài 9
select product_id 
from Products
where low_fats ='Y' and recyclable ='Y'
-- bài 10
select name
from Customer
where referee_id != 2 or referee_id is null
-- bài 11 
select name,population,area
from World
where area >= 3000000 or  population >= 25000000
-- bài 12
elect distinct author_id as id
from Views
where  article_id >1
order by author_id ASC
-- bài 13 
SELECT part,assembly_step
FROM parts_assembly
where finish_date is NULL
-- bài 14
select *
from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000
-- bài 15
select advertising_channel
from uber_advertising
where money_spent > 100000 and year =2019
