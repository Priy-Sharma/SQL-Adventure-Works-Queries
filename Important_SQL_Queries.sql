-- category name for which maximum subcategories are present
SELECT cl.ProductCategoryKey, cl.categoryname, COUNT(sl.ProductSubcategoryKey) AS subcategory_count
FROM category_lookup cl
JOIN subcategory_lookup sl ON cl.ProductCategoryKey = sl.ProductCategoryKey
GROUP BY cl.ProductCategoryKey, cl.categoryname
ORDER BY subcategory_count DESC ;

-- Category and Subcategory Distribution:
SELECT cl.categoryname, sl.subcategoryname, COUNT(DISTINCT pl.productkey) AS product_count
FROM product_lookup pl
JOIN subcategory_lookup sl ON pl.ProductSubcategoryKey = sl.ProductSubcategoryKey
JOIN category_lookup cl ON sl.ProductCategoryKey = cl.ProductCategoryKey
GROUP BY cl.categoryname, sl.subcategoryname
ORDER BY cl.categoryname, product_count DESC;

-- Top 5 Subcategories with Most Products
SELECT pl.ProductSubcategoryKey, COUNT(DISTINCT pl.productkey) AS product_count
FROM product_lookup pl
GROUP BY pl.ProductSubcategoryKey
ORDER BY product_count DESC
LIMIT 5;

-- Datatyoe conversion of column 'OrderDate' to Datetime
alter table sales_2022 modify column OrderDate  Datetime;
alter table sales_2021 modify column OrderDate  Datetime;
alter table sales_2020 modify column OrderDate  Datetime;

-- Quarterly Sales Analysis by Year for 2020, 2021, and 2022
SELECT 
    quart,
    SUM(CASE WHEN year = 2022 THEN total_sales ELSE 0 END) AS total_sales_2022,
    SUM(CASE WHEN year = 2021 THEN total_sales ELSE 0 END) AS total_sales_2021,
    SUM(CASE WHEN year = 2020 THEN total_sales ELSE 0 END) AS total_sales_2020
FROM (
    SELECT 
        QUARTER(s22.orderdate) AS quart,
        YEAR(s22.orderdate) AS year,
        ROUND(SUM(pl.productprice * s22.orderquantity)) AS total_sales
    FROM 
        sales_2022 s22
    RIGHT JOIN 
        product_lookup pl ON s22.ProductKey = pl.ProductKey
    GROUP BY 
        quart, year

    UNION ALL

    SELECT 
        QUARTER(s21.orderdate) AS quart,
        YEAR(s21.orderdate) AS year,
        ROUND(SUM(pl.productprice * s21.orderquantity)) AS total_sales
    FROM 
        sales_2021 s21
    RIGHT JOIN 
        product_lookup pl ON s21.ProductKey = pl.ProductKey
    GROUP BY 
        quart, year

    UNION ALL

    SELECT 
        QUARTER(s20.orderdate) AS quart,
        YEAR(s20.orderdate) AS year,
        ROUND(SUM(pl.productprice * s20.orderquantity)) AS total_sales
    FROM 
        sales_2020 s20
    RIGHT JOIN 
        product_lookup pl ON s20.ProductKey = pl.ProductKey
    GROUP BY 
        quart, year
) AS subquery
GROUP BY 
    quart
order by 
quart desc;


-- Average order value for the subcategory for the year 2021

select truncate(AVG(pl.productprice), 2) as average_order_value, pl.ProductSubcategoryKey
 from product_lookup pl
where pl.ProductKey in
( select s21.productkey from sales_2021 s21 )
group by pl.ProductSubcategoryKey
order by average_order_value desc;

-- Product Names with Order Quantity Exceeding 3 for the year 2022
select 
pl.productname, pl.productprice, sub.order_quantity  
from 
product_lookup pl
join ( 
select s22.ProductKey, 
sum(s22.orderquantity) as order_quantity
from 
sales_2022 s22
group by
 s22.productkey
having  
sum(s22.orderquantity) >= 10
) as sub
on
 pl.ProductKey = sub.productkey ;

-- Average stock period of products
select round(AVG(datediff(s20.orderdate, s20.stockdate))) as stock_period, sl.subcategoryname, pl.productname 
from subcategory_lookup sl 
inner join
product_lookup pl on sl.ProductSubcategoryKey = pl.ProductSubcategoryKey
join
sales_2020 s20
group by sl.subcategoryname , pl.ProductName
order by stock_period desc;

-- Checking for null values in table
select
case when count(*) = 0 then 'No Null' else 'Has Null' end as orderdate,
case when count(*) = 0 then 'No Null' else 'Has Null' end as productkey,
case when count(*) = 0 then 'No Null' else 'Has Null' end as customerkey
from sales_2021 s21
where orderdate is null 
or productkey is null
or customerkey is null ;

-- Check the age group that maximum products in 2021

SELECT s21.CustomerKey, COUNT(*) AS count, cl.annualincome 
FROM customer_lookup cl 
INNER JOIN sales_2021 s21 
ON cl.CustomerKey = s21.CustomerKey
GROUP BY s21.CustomerKey, cl.annualincome
ORDER BY count DESC;
