# Capstone2-JericMarcelin
Project Overview: This project models the retail sales process of AdventureWorks using a dimensional Data Lakehouse. Sales transactions between customers, employees, products, and territories are represented in a fact table. Dimension tables are sourced from MySQL, MongoDB Atlas, and CSV files, demonstrating a full ETL pipeline using PySpark Structured Streaming.

Data Sources:  The AdventureWorks data was given by our professor and was imported into MySQL by executing the SQL file in MySQL workbench. The data was imported into MySQL by executing the SQL file in MySQL Workbench. The employee and sales territory dimensions were exported from MySQL and saved as CSV files on the local file system. The product and product category dimensions were exported from MySQL as JSON files and uploaded to MongoDB Atlas to create a new database collection.

Strategy: The strategy was to implement an ETL pipeline using PySpark in a Jupyter Notebook. I planned to take data from the AdventureWorks database and convert some columns into different formats to show understanding. Then, I wanted to create a data lakehouse using a central fact table and supporting dimension tables. Finally, queries would be written to show the functionality of the new data lakehouse.

Process: 
The first step in the project was to extract different data types and implement them into the data lakehouse. This was done by using data originating from MongoDB Atlas, MySQL, and local CSV files.
- The date dimension was implemented directly into MySQL workbench. This was the format that was given by our professors.

The second step involved transforming the data by removing unnecessary columns, renaming conflicting columns, and adding surrogate keys using the ROW_NUMBER() window function.
The third step was to load the transformed dataframes into the adventureworks_dlh data lakehouse using the Bronze, Silver, and Gold streaming layers.
The resulting data was queried to demonstrate the functionality and business value of the new data lakehouse.

The resulting data was queried using SQL SELECT statements to demonstrate the functionality the new data lakehouse.  These queries joined the Gold fact table with dimension tables to analyze the total revenue by quarter across all years and total revenue, units sold, and orders broken down by product subcategory. 

