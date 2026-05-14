-- ================================
-- CREATE DATABASE
-- ================================

CREATE DATABASE dw_movierental_tala;

USE dw_movierental_tala;

-- ================================
-- DIM_DATE
-- ================================

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_number INT,
    month_number INT,
    month_name VARCHAR(20),
    quarter_number INT,
    year_number INT
);

-- ================================
-- DIM_CUSTOMER
-- ================================

CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    active_status VARCHAR(10),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- ================================
-- DIM_FILM
-- ================================

CREATE TABLE dim_film (
    film_key INT AUTO_INCREMENT PRIMARY KEY,
    film_id INT,
    title VARCHAR(255),
    category_name VARCHAR(50),
    language_name VARCHAR(50),
    rental_rate DECIMAL(5,2),
    rental_duration INT,
    release_year INT
);

-- ================================
-- DIM_STORE
-- ================================

CREATE TABLE dim_store (
    store_key INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT,
    city VARCHAR(50),
    country VARCHAR(50),
    manager_name VARCHAR(100)
);

-- ================================
-- DIM_STAFF
-- ================================

CREATE TABLE dim_staff (
    staff_key INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT,
    full_name VARCHAR(100),
    store_id INT
);

-- ================================
-- FACT_RENTAL
-- ================================

CREATE TABLE fact_rental (
    rental_key INT AUTO_INCREMENT PRIMARY KEY,
    date_key INT,
    customer_key INT,
    film_key INT,
    store_key INT,
    staff_key INT,
    rental_count INT,
    rental_duration INT,
    late_return_days INT,

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (film_key) REFERENCES dim_film(film_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (staff_key) REFERENCES dim_staff(staff_key)
);

-- ================================
-- FACT_PAYMENT
-- ================================

CREATE TABLE fact_payment (
    payment_key INT AUTO_INCREMENT PRIMARY KEY,
    date_key INT,
    customer_key INT,
    film_key INT,
    store_key INT,
    staff_key INT,
    payment_amount DECIMAL(10,2),
    payment_count INT,

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (film_key) REFERENCES dim_film(film_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (staff_key) REFERENCES dim_staff(staff_key)
);

-- ================================
-- FACT_FILM_PERFORMANCE
-- ================================

CREATE TABLE fact_film_performance (
    performance_key INT AUTO_INCREMENT PRIMARY KEY,
    date_key INT,
    film_key INT,
    store_key INT,
    total_rentals INT,
    total_revenue DECIMAL(10,2),
    average_rental_duration DECIMAL(5,2),

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (film_key) REFERENCES dim_film(film_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key)
);

-- ================================
-- SAMPLE INSERTS
-- ================================

INSERT INTO dim_date
VALUES
(20250101,'2025-01-01',1,1,'January',1,2025);

INSERT INTO dim_customer
(customer_id, full_name, email, active_status, city, country)
VALUES
(1,'John Smith','john@example.com','Active','New York','USA');

INSERT INTO dim_film
(film_id, title, category_name, language_name, rental_rate, rental_duration, release_year)
VALUES
(1,'Zorro Ark','Action','English',2.99,5,2006);

INSERT INTO dim_store
(store_id, city, country, manager_name)
VALUES
(1,'Woodridge','Canada','Mike Johnson');

INSERT INTO dim_staff
(staff_id, full_name, store_id)
VALUES
(1,'Anna Brown',1);

-- ================================
-- FACT INSERTS
-- ================================

INSERT INTO fact_rental
(date_key, customer_key, film_key, store_key, staff_key,
 rental_count, rental_duration, late_return_days)
VALUES
(20250101,1,1,1,1,1,5,1);

INSERT INTO fact_payment
(date_key, customer_key, film_key, store_key, staff_key,
 payment_amount, payment_count)
VALUES
(20250101,1,1,1,1,4.99,1);

INSERT INTO fact_film_performance
(date_key, film_key, store_key,
 total_rentals, total_revenue, average_rental_duration)
VALUES
(20250101,1,1,15,120.50,4.2);

-- ================================
-- ANALYTICAL QUERIES
-- ================================

-- Top rented movies

SELECT
    f.title,
    SUM(r.rental_count) AS total_rentals
FROM fact_rental r
JOIN dim_film f
ON r.film_key = f.film_key
GROUP BY f.title
ORDER BY total_rentals DESC;

-- Rentals per store

SELECT
    s.city,
    SUM(r.rental_count) AS rentals
FROM fact_rental r
JOIN dim_store s
ON r.store_key = s.store_key
GROUP BY s.city
ORDER BY rentals DESC;

-- Top countries by rentals

SELECT
    c.country,
    SUM(r.rental_count) AS total_rentals
FROM fact_rental r
JOIN dim_customer c
ON r.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_rentals DESC;

-- Revenue by film

SELECT
    f.title,
    SUM(p.payment_amount) AS revenue
FROM fact_payment p
JOIN dim_film f
ON p.film_key = f.film_key
GROUP BY f.title
ORDER BY revenue DESC;

-- Store revenue

SELECT
    s.city,
    SUM(p.payment_amount) AS total_revenue
FROM fact_payment p
JOIN dim_store s
ON p.store_key = s.store_key
GROUP BY s.city
ORDER BY total_revenue DESC;