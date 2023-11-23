--bai1
with cte as (
SELECT EXTRACT(year from transaction_date), product_id,
spend as curr_year_spend,
lag(spend) over(PARTITION BY product_id order by transaction_date) as prev_year_spend
FROM user_transactions
)
select *,
ROUND((curr_year_spend-prev_year_spend)/prev_year_spend *100.0,2) as yoy_rate
from cte
--bai2
with cte as (
select card_name, issued_amount,
rank() over(PARTITION BY card_name order by issue_year,issue_month ) as rank1
from monthly_cards_issued
)
select card_name, issued_amount
from cte 
where rank1=1
ORDER BY issued_amount DESC
--cách khác 
SELECT DISTINCT card_name,
  FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month)
  AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC
--bài3
with cte as(
SELECT user_id, spend, transaction_date,
RANK() over(PARTITION BY user_id order by transaction_date ) as rank1
FROM transactions
)
select user_id, spend,
transaction_date
from cte 
where rank1=3
order by transaction_date
--bai4
with cte as (
SELECT transaction_date, user_id, COUNT(product_id) as purchase_count,
RANK() over(PARTITION BY user_id ORDER BY transaction_date desc	) as rank1
FROM user_transactions
GROUP BY transaction_date, user_id
)
select transaction_date,user_id, purchase_count
from cte 
where rank1=1
order by transaction_date, purchase_count
--bai5
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count) OVER(
PARTITION BY user_id ORDER BY tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) 
FROM tweets
--ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 
--xác định rằng chỉ có 3 dòng gần nhất được sử dụng để tính toán trung bình.
--bài6
WITH cte AS (
SELECT transaction_id
  merchant_id, 
  credit_card_id, 
  amount, 
  transaction_timestamp as current_transaction,
  LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS previous_transaction
FROM transactions
)

SELECT COUNT(merchant_id) as payment_count
FROM cte
WHERE current_transaction-previous_transaction <= INTERVAL '10 minutes'
--bai7
with cte as(
SELECT category,product,
sum(spend) as total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as ranking
FROM product_spend
where EXTRACT(year from transaction_date )='2022'
group by category,product
)

SELECT category, product,total_spend
from cte 
where ranking <=2
order by category, ranking
--bai8
WITH cte AS (
  SELECT 
    a.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(b.song_id) DESC) AS artist_rank
  FROM artists a 
  INNER JOIN songs b 
   using(artist_id)
  INNER JOIN global_song_rank AS c 
    using(song_id)
  WHERE c.rank <= 10
  GROUP BY a.artist_name
)

SELECT artist_name, artist_rank
FROM cte 
WHERE artist_rank <= 5;









