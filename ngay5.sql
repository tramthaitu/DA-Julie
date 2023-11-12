--bài 1 
select DISTINCT CITY
FROM STATION
WHERE ID %2=0
--BÀI 2
SELECT COUNT(CITY)- COUNT(DISTINCT CITY)
FROM STATION
--  BÀI 3
  select 
ceiling(avg(Salary)-avg(replace(salary,'0','')))
from EMPLOYEES
-- BÀI 4
-- bước 1: Phân tích yêu cầu
-- 1. output(trường gốc/phái sinh) mean (phái sinh)= tổng items/số lượng đơn hàng
-- 2. input 
-- 3. điều kiện lọc theo trường nào (gốc/phái sinh)
-- cast ép kiểu dữ liệu. Cú pháp CAST(value AS data_type). 
--VD CAST(\'123\' AS integer) - Chuyển đổi chuỗi \'123\' thành số nguyên.
--   CAST(\'3.14\' AS decimal) - Chuyển đổi chuỗi \'3.14\' thành số thập phân.
--  CAST(123 AS char) - Chuyển đổi số nguyên 123 thành chuỗi ký tự.
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences)as decimal),1) as mean
FROM items_per_order
-- bài 5
-- bước 1: phân tích yêu cầu 
-- 1. output (gốc/phái sinh): candidate_id
-- input candidate_id, skill
-- điều kiện lọc: chỉ lấy ứng viên có 3 kỹ năng 'Python','Tableau','PostgreSQL')
SELECT DISTINCT candidate_id
from candidates
where skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id 
having count(skill) =3 -- điều kiện có đủ 3 skills
-- bài 6
--1 output: user_id (gốc)	, days_between (phái sinh: biết công thức tính)
-- input: posts 
-- điều kiện lọc lấy khoảng thời gian giũa lần đăng đầu tiên với lần đăng tiếp theo 
SELECT user_id,
date (MAX(post_date))- date (min(post_date)) as days_between
FROM posts
where post_date >= '2021-01-01' and post_date <= '2022-01-01'
GROUP BY user_id
having count(post_id) >= 2
-- bài 7
--output: card_name (gốc), difference (phái sinh)
--input : 
--điều kiện lọc: 
SELECT card_name,
MAX(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-min(issued_amount) DESC
-- bài 8
SELECT manufacturer, 
count(drug) as drug_count,
abs(sum(cogs-total_sales)) as total_loss --|total_sales-cogs| thiệt hại
FROM pharmacy_sales
where 	cogs> total_sales
GROUP BY manufacturer
order by abs(sum(cogs-total_sales)) DESC
-- bài 9
elect id,movie ,description,rating 
from Cinema
where id %2 !=0 and description !='boring'
order by rating DESC
-- bài 10
select teacher_id,
COUNT(distinct(subject_id)) as cnt 
from Teacher
GROUP BY teacher_id
-- BÀI 11
SELECT user_id ,
COUNT(follower_id ) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id
-- BÀI 12 
SELECT class 
FROM Courses 
GROUP BY class
HAVING COUNT(student) >=5
--- NAY EM BẬN HỌC TRÊN TRƯỜNG NÊN NỘP TRỄ ẠAA
