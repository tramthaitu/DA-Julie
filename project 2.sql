1./*Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)*/
select
    EXTRACT(MONTH FROM delivered_at) AS month,
    EXTRACT(YEAR FROM delivered_at) AS year,
    COUNT(DISTINCT id) AS total_customers,
    COUNT(CASE WHEN status = 'Complete' THEN 1 END) AS completed_orders
    from bigquery-public-data.thelook_ecommerce.order_items
    where delivered_at between '2019-01-01' AND '2022-04-30'
    group by 1,2
    order by 2,1
Nhân xét: 
  Vào năm 2019 thì hầu hết các tháng đều có tổng lượng khách hàng và đơn hàng hoàn thành ít.
  Các năm 2020,2021,2022 thì lượng khách hàng và tổng đơn hàng đều tăng. Nhìn chung thì lượng đơn hàng hoàn thành 
  so với tổng đơn khách đặt thì chỉ có khoảng 2/3 đơn hàng là giao thành công.
2./*Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022). Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)*/

select
    EXTRACT(MONTH FROM delivered_at) AS month,
    EXTRACT(YEAR FROM delivered_at) AS year,
    COUNT(DISTINCT id) AS total_customers,
    --ROUND(SUM(sale_price), 2) AS total_order_value,
    --COUNT(CASE WHEN status = 'Complete' THEN 1 END) AS completed_orders,
    ROUND((ROUND(SUM(sale_price), 2))/(COUNT(CASE WHEN status = 'Complete' THEN 1 END)),2) as avg_order_value
    from bigquery-public-data.thelook_ecommerce.order_items
    where delivered_at between '2019-01-01' AND '2022-04-30'
    group by 1,2
    order by 2,1
Nhân xét: 
Năm 2019 tháng 1,2 có giá trị đơn hàng trung bình chênh lệch nhiều hơn so với các tháng còn lại 
Năm 2020,2021,2022 thì lượng khách hàng ngày càng tăng nhưng giá trị đơn hàng trung bình đơn hàng lại không có sự
biến động loanh quanh 70-90$. 

3./*Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
Hint: Sử dụng UNION các KH tuổi trẻ nhất với các KH tuổi trẻ nhất 
tìm các KH tuổi trẻ nhất và gán tag ‘youngest’  
tìm các KH tuổi trẻ nhất và gán tag ‘oldest’ 
Insight là gì? (Trẻ nhất là bao nhiêu tuổi, số lượng bao nhiêu? Lớn nhất là bao nhiêu tuổi, số lượng bao nhiêu) */

with gia_tre AS
(
(SELECT 
    first_name,
    last_name,
    gender,
    age,
    'youngest' AS tag
FROM 
    bigquery-public-data.thelook_ecommerce.users
WHERE 
    age IN (
        SELECT 
            MIN(age)
        FROM 
            bigquery-public-data.thelook_ecommerce.users
        GROUP BY 
            gender
    )
)
UNION ALL

(SELECT 
    first_name,
    last_name,
    gender,
    age,
    'oldest' AS tag
FROM 
    bigquery-public-data.thelook_ecommerce.users
WHERE 
    age IN (
        SELECT 
            MAX(age)
        FROM 
            bigquery-public-data.thelook_ecommerce.users
        GROUP BY 
            gender
    )
ORDER BY 
    gender, age
)) 
select 
(select Count(*) from gia_tre where tag='youngest') as nguoi_tre,
(select count(*) from gia_tre where tag='oldest') as nguoi_gia
from gia_tre
Nhận xét: Người trẻ nhất có số tuổi là 12, có 1704 người 
Người già nhất có số tuổi là 70, có 1690 người 

4./*Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
Hint: Sử dụng hàm dense_rank()*/

WITH rank1 AS (
    SELECT 
    cast(format_date('%Y-%m',a.delivered_at) as string) as month_year,
        --extract(month from delivered_at) AS month,
        --extract('year' from delivered_at) AS year,
        a.product_id,
        b.name,
        round(SUM(a.sale_price),2) AS sales,
        round(SUM(b.cost),2) AS cost,
        round(SUM(a.sale_price - b.cost),2) AS profit,
        DENSE_RANK() OVER (PARTITION BY cast(format_date('%Y-%m',a.delivered_at) as string) ORDER BY round(SUM(sale_price - cost),2) DESC) AS rank_per_month
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items as a join bigquery-public-data.thelook_ecommerce.products as b
        on a.product_id=b.id

    GROUP BY cast(format_date('%Y-%m',a.delivered_at) as string),a.delivered_at,
         product_id,name
)

SELECT 
    --cast(format_date('%Y-%m',a.delivered_at) as string)AS month_year,
    month_year,
    product_id,
    name,
    sales,
    cost,
    profit,
    rank_per_month
FROM 
    rank1
WHERE 
    rank_per_month <= 5
ORDER BY 
    month_year, rank_per_month;
5./*Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue */

SELECT 
    DATE(delivered_at) AS dates,
    category AS product_categories,
    ROUND(SUM(sale_price), 2) AS revenue
FROM 
    bigquery-public-data.thelook_ecommerce.order_items as a join bigquery-public-data.thelook_ecommerce.products as b
        on a.product_id=b.id
WHERE 
    delivered_at >= '2022-01-15' AND delivered_at <= '2022-04-15'
GROUP BY 
    dates, product_categories
ORDER BY 
    dates, revenue DESC;
---------------------------------------------------------------------------------------------------------------
1.
    with cte as 
(
SELECT 
    EXTRACT(MONTH FROM oi.delivered_at) AS Month,
    EXTRACT(YEAR FROM oi.delivered_at) AS Year,
    p.category AS Product_category,
    ROUND(SUM(oi.sale_price), 2) AS TPV,
    COUNT(DISTINCT oi.order_id) AS TPO,
    ROUND((((SUM(oi.sale_price) - LAG(SUM(oi.sale_price)) OVER (PARTITION BY p.category ORDER BY EXTRACT(MONTH FROM oi.delivered_at))) / LAG(SUM(oi.sale_price)) OVER (PARTITION BY p.category ORDER BY EXTRACT(MONTH FROM oi.delivered_at))))*100, 2) AS Revenue_growth,
    ROUND(((COUNT(DISTINCT oi.order_id) - LAG(COUNT(DISTINCT oi.order_id)) OVER (PARTITION BY p.category ORDER BY EXTRACT(MONTH FROM oi.delivered_at))) / LAG(COUNT(DISTINCT oi.order_id)) OVER (PARTITION BY p.category ORDER BY EXTRACT(MONTH FROM oi.delivered_at)))*100,2) AS Order_growth,
    ROUND(SUM(p.cost), 2) AS Total_cost,
    ROUND(SUM(oi.sale_price - p.cost), 2) AS Total_profit,
    ROUND(SUM(oi.sale_price - p.cost) / SUM(p.cost) * 100, 2) AS Profit_to_cost_ratio
FROM 
    bigquery-public-data.thelook_ecommerce.orders o
JOIN 
    bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
JOIN 
    bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
GROUP BY 
    Year, Month, category,oi.delivered_at
ORDER BY 
    Year, Month, category,oi.delivered_at
)

select *
from cte 
where month is not null

2. Tạo retention cohort analysis.
    



