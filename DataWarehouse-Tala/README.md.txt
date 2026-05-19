# Movie Rental Data Warehouse

## Project Description

This project presents a dimensional Data Warehouse solution for a Movie Rental business using the Sakila OLTP database.

The project transforms transactional rental and payment data into a Star Schema model to support analytical reporting and business intelligence.

The implemented solution includes:

- Star Schema Design
- ETL Process using Python and Pandas
- Dimension Tables
- Fact Tables
- Analytical SQL Queries
- Data Visualizations using Matplotlib

---

# Technologies Used

- MySQL
- Python
- Pandas
- SQLAlchemy
- Matplotlib
- Jupyter Notebook

---

# Data Warehouse Schema

## Dimension Tables

- dim_customer
- dim_film
- dim_store
- dim_staff
- dim_date

## Fact Tables

- fact_payment
- fact_rental

---

# Analytical Reports

The project includes analytical reports such as:

- Top Customers by Spending
- Top Rented Movies
- General Business Statistics

---

# ETL Process

The ETL pipeline includes:

1. Extracting data from Sakila OLTP database
2. Transforming and cleaning data
3. Generating surrogate keys
4. Loading dimension tables
5. Loading fact tables

---

# Visualizations

The project generates charts using Matplotlib for business analysis and reporting.

---

# Author

Tala Shilleh

Database 2 — An-Najah National University