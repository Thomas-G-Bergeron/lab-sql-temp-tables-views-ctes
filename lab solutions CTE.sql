-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.
use sakila;
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_info AS (
select r.customer_id, c.first_name, c.last_name, c.email, count(r.rental_id) as rental_count from rental as r
join customer as c on r.customer_id = c.customer_id 
group by r.customer_id);

select * from rental_info;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 

CREATE TEMPORARY TABLE rental_info AS (select * from rental_info);
ALTER TABLE rental_info
RENAME COLUMN customer_id to cust_id;

CREATE TEMPORARY TABLE  customer_payment AS (select customer_id, sum(amount) as total_payment from payment as p group by customer_id);

CREATE TEMPORARY TABLE total_paid AS (select * from rental_info as ri join customer_payment as cp on ri.cust_id = cp.customer_id);
ALTER TABLE total_paid
DROP COLUMN customer_id;

select * from total_paid;

-- The CTE should include the customer's name, email address, rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report,
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

select cust_id, first_name, last_name, email, rental_count, total_payment, total_payment/rental_count from total_paid;



