# SQL-Adventure-Works-Queries
<h3><b> Project Summary: Product Category and Sales Analysis </b></h3>
The Entity Relationship (ER) Diagram for the tables is as follows: </br>


![Screenshot (1706)](https://github.com/Priy-Sharma/SQL-Adventure-Works-Queries/assets/161149109/d247b0d5-2874-4402-9602-6f1f13c21fac)


<p>This script delves into product categories, subcategories, sales data, and customer information within a product database. It aims to provide valuable insights for product management, marketing, and customer segmentation.</p>
<h3><b>Key functionalities include:</b></h3>
<ul>
  <li>Product Category and Subcategory Analysis:</li>
  <p>Identifies the category with the most subcategories, aiding in understanding product organization and potential areas for diversification.
    
Explores the distribution of products across categories and subcategories, revealing any imbalances or areas of product concentration.

Pinpoints the top 5 subcategories housing the highest number of products, highlighting areas of strong product focus or potential demand.</p>
<li><b>Sales Analysis by Year and Quarter:</b></li>
<p>Calculates quarterly sales totals for the years 2020, 2021, and 2022, enabling year-over-year and quarterly comparisons.
  
Employs a right join with product data to ensure all categories are included in the analysis, even if they have no sales in a particular quarter.
</p>
<li><b>Average Order Value and High-Quantity Products:</b></li>
<p>Determines the average order value for each subcategory in 2021, providing insights into product pricing and customer spending patterns.
  
Identifies products (2022 data) with order quantities exceeding a specified threshold (here, 10), potentially indicating popular items or areas for inventory management.</p>
<li><b>Stock Period and Null Value Checks:</b></li>
<p>Calculates the average stock period (time between product stocking and sale) for each product in 2020, offering insights into inventory turnover.
Verifies the presence of null values in key columns (order date, product key, customer key) of the 2021 sales data for data quality control.</p>
<li><b>Customer Analysis:</b></li>
<p>Identifies the customer age group (based on annual income) that purchased the most products in 2021, providing valuable information for customer segmentation and targeted marketing efforts.</p>
</ul>

<h3><b>Overall, this script provides a comprehensive overview of product categories, subcategories, sales performance, and customer data. The insights gleaned can be used to optimize product offerings, sales strategies, and customer targeting.</b></h3>
