-- Category name for which maximun subcategories are present
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

# Convert the orderdatetime column to datetime
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

-- Product Names with Order Quantity Exceeding 10 for the year 2022
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
SELECT 
    ROUND(AVG(DATEDIFF(s20.orderdate, s20.stockdate))) AS stock_period,
    sl.subcategoryname,
    pl.productname 
FROM 
    subcategory_lookup sl 
INNER JOIN
    product_lookup pl ON sl.ProductSubcategoryKey = pl.ProductSubcategoryKey
JOIN
    sales_2020 s20 ON pl.ProductKey = s20.ProductKey  -- Added the join condition here
GROUP BY 
    sl.subcategoryname, pl.productname  -- Corrected grouping by productname
ORDER BY 
    stock_period DESC;


-- Checking for null values in table

SELECT
    CASE WHEN SUM(CASE WHEN orderdate IS NULL THEN 1 ELSE 0 END) = 0 THEN 'No Null' ELSE 'Has Null' END AS orderdate,
    CASE WHEN SUM(CASE WHEN productkey IS NULL THEN 1 ELSE 0 END) = 0 THEN 'No Null' ELSE 'Has Null' END AS productkey,
    CASE WHEN SUM(CASE WHEN customerkey IS NULL THEN 1 ELSE 0 END) = 0 THEN 'No Null' ELSE 'Has Null' END AS customerkey
FROM 
    sales_2021;


-- TOP 5 CUSTOMERS WITH MAXIMUM PURCHASED QUANTITY ALONG WITH THEIR ANNUAL INCOME

SELECT 
    s21.CustomerKey,
    COUNT(*) AS item_count,
    cl.annualincome
FROM 
    customer_lookup cl 
INNER JOIN 
    sales_2021 s21 ON cl.CustomerKey = s21.CustomerKey
GROUP BY 
    s21.CustomerKey, cl.annualincome
ORDER BY 
    item_count DESC
LIMIT 5;


-- Names and prices of the most expensive and least expensive products 
(select productname, productprice as price from product_lookup
order by productprice desc
limit 1)
union 
(select productname, productprice as price from product_lookup
order by productprice 
limit 1);

-- Top Spending Customer by Product
with cte as(
select s22.customerkey, s22.OrderQuantity, pl.productprice
from sales_2022 s22
join product_lookup pl
on s22.ProductKey = pl.ProductKey)
select concat(cl.firstname, " ", LastName), cl.EmailAddress, round(sub.sales, 2) as spend
from customer_lookup cl
join (
select CustomerKey, sum(OrderQuantity * productprice) as sales
from cte group by CustomerKey) sub
on sub.CustomerKey = cl.CustomerKey
order by sub.sales desc
limit 5;

-- Most ordered subcategory name
select slp.subcategoryname, sum(s22.count) as total_count
from subcategory_lookup slp
join product_lookup pl
on pl.ProductSubcategoryKey = slp.ProductSubcategoryKey
inner join (
    select ProductKey, count(ProductKey) as count
    from sales_2022 
    group by ProductKey
    order by count desc
    limit 5
) s22
on s22.ProductKey = pl.ProductKey
group by slp.subcategoryname
order by total_count desc;





