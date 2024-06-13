
-- Use the adventure_workbook schema
use adventure_workbook;

-- Rename tables
RENAME TABLE `adventureworks customer lookup` TO `customer_lookup`;
Rename table`adventureworks product categories lookup` to `category_lookup`;
Rename table`adventureworks product lookup` to `product_lookup`;
Rename table`adventureworks product subcategories lookup` to `subcategory_lookup`;
Rename table`adventureworks returns data` to `return_data`;
Rename table`adventureworks sales data 2020` to `sales_2020`;
Rename table`adventureworks sales data 2021` to `sales_2021`;
Rename table`adventureworks sales data 2022` to `sales_2022`;

show tables;
