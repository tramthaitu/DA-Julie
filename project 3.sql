ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric;

/*1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE */
select productline,year_id,dealsize,
sum(priceeach) as revenue
from sales_dataset_rfm_prj
group by productline,year_id,dealsize

/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
select month_id,year_id,revenue,order_number
from(
select month_id,year_id, count(ordernumber) as order_number,
sum(priceeach) as revenue,
rank() over(partition by year_id order by sum(priceeach) desc) as rank2
from public.sales_dataset_rfm_prj
group  by month_id,year_id
order by year_id, sum(priceeach) desc) as a2
where rank2='1'
order by year_id

/*3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
select month_id,productline,
sum(priceeach) as revenue,
count(ordernumber)
from public.sales_dataset_rfm_prj
group by month_id,productline
having month_id='11'
order by count(ordernumber) desc

/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK  */
with rank2 as 
(
select year_id, productline, 
sum(priceeach) as revenue,
rank() over(partition by year_id order by sum(priceeach) desc) as rank1
from public.sales_dataset_rfm_prj
group by productline,year_id
)
select year_id, productline,revenue,rank1
from rank2 
where rank1='1'
order by year_id

/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23) */

CREATE TABLE segment_score
(
    segment Varchar,
    scores Varchar)
select *
from segment_score

select *
from public.sales_dataset_rfm_prj
with cte as
(
select customername,
current_date-max(orderdate) as R,
count(distinct ordernumber) as F,
ROUND(sum(priceeach),2) as M
from public.sales_dataset_rfm_prj
group by customername
)
, rfm_score as
(
select customername,
ntile(5) over(order by R desc) as R_score,
ntile(5) over(order by F) as F_score,
ntile(5) over(order by M) as M_score
from cte
)
, rfm_final as(
select customername,
cast(R_score as varchar)||cast(F_score as varchar)||cast(M_score as varchar) as rfm
from rfm_score)

select customername,segment
from(
select customername,segment
from rfm_final a join public.segment_score b on a.rfm=b.scores ) as e
group by segment,customername
having segment='Champions'
order by count(*)
