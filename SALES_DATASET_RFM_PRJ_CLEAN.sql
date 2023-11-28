/*
1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
2.Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH,
ORDERLINENUMBER, SALES, ORDERDATE.
3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
4.Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, 
chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó INSERT)
5.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
6. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách)
( Không chạy câu lệnh trước khi bài được review)
Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN */

select *
from public.sales_dataset_rfm_prj
--1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric  USING (trim(ordernumber)::numeric );

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric  USING (trim(quantityordered)::numeric );

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric  USING (trim(priceeach)::numeric );

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE numeric  USING (trim(orderlinenumber)::numeric );

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric  USING (trim(sales)::numeric );

alter table sales_dataset_rfm_prj
alter column orderdate type date

alter table sales_dataset_rfm_prj
alter column orderdate type date

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric 

--2.Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH,
--ORDERLINENUMBER, SALES, ORDERDATE.

select *
from public.sales_dataset_rfm_prj
where ORDERNUMBER is null and QUANTITYORDERED is null and PRICEEACH is null and
ORDERLINENUMBER is null and SALES is null and ORDERDATE is null

--3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME .
select *
from public.sales_dataset_rfm_prj;

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255);

UPDATE public.sales_dataset_rfm_prj
SET
    CONTACTLASTNAME = SUBSTRING(CONTACTFULLNAME, 1, POSITION('-' IN CONTACTFULLNAME) - 1),
    CONTACTFIRSTNAME = SUBSTRING(CONTACTFULLNAME, POSITION('-' IN CONTACTFULLNAME) + 1);
	
--4.Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, 
--chữ cái tiếp theo viết thường.
UPDATE public.sales_dataset_rfm_prj
SET 
    CONTACTLASTNAME = UPPER(SUBSTRING(CONTACTLASTNAME FROM 1 FOR 1)) || LOWER(SUBSTRING(CONTACTLASTNAME FROM 2)),
    CONTACTFIRSTNAME = UPPER(SUBSTRING(CONTACTFIRSTNAME FROM 1 FOR 1)) || LOWER(SUBSTRING(CONTACTFIRSTNAME FROM 2));
select *
from public.sales_dataset_rfm_prj

--5.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID numeric,
ADD COLUMN MONTH_ID numeric,
ADD COLUMN YEAR_ID numeric;

UPDATE public.sales_dataset_rfm_prj
SET 
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

select QTR_ID,MONTH_ID,YEAR_ID
from public.sales_dataset_rfm_prj

--6.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó 
---cách 1
with min_max_value as(
SELECT Q1-1.5*IQR AS min_value,
Q3+1.5*IQR as max_value
from (
select 
percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) -percentile_cont(0.25) WITHIN GROUP (ORDER BY  QUANTITYORDERED) as IQR
from public.sales_dataset_rfm_prj) as a)

select * from sales_dataset_rfm_prj
where QUANTITYORDERED< (select min_value from min_max_value)
or QUANTITYORDERED>(select max_value from min_max_value)

--cách 2 
select avg(QUANTITYORDERED),
stddev(QUANTITYORDERED) 
from public.sales_dataset_rfm_prj

with cte as
(
select orderdate,
QUANTITYORDERED,
(select avg(QUANTITYORDERED)
from sales_dataset_rfm_prj) as avg,
(select stddev(QUANTITYORDERED)
from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj)

,outlier_value as(
select orderdate,ordernumber, (QUANTITYORDERED-avg)/stddev as z_score
from cte
where abs((QUANTITYORDERED-avg)/stddev )>3)


DELETE FROM public.sales_dataset_rfm_prj
WHERE QUANTITYORDERED IN (SELECT  users from outlier_value);




