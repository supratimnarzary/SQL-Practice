--Problem 2 — Dormant Customers
--customers_2(customer_id, name, signup_date)
--transactions_2(transaction_id, customer_id, transaction_date, amount)
--A customer is considered dormant if they have made no transactions in the last 90 days, but had at least one transaction before that. Return all dormant customers and their last transaction date.
--Expected output columns: customer_id, name, last_transaction_date

==============================================

--solution 1:

WITH ranked AS (
    SELECT
        customer_id,
        transaction_date,
        Row_number() OVER (PARTITION BY customer_id ORDER BY transaction_date Desc) AS rnk
    FROM transactions_2
)
select c.customer_id, c.name, r.transaction_date AS last_transaction_date from customers_2 c
Inner Join ranked r on
c.customer_id = r.customer_id
where r.rnk = 1
And r.transaction_date < Date_sub(curdate(), interval 90 day)
order by r.transaction_date desc;

--solution 2:

SELECT c.customer_id, c.name, max(t.transaction_date) AS last_transaction_date
FROM customers_2 c INNER JOIN transactions_2 t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
HAVING max(t.transaction_date) < Date_sub(curdate(), interval 90 day);

--solution 3:

with dormant as (select customer_id, max(transaction_date) as last_transaction_date from transactions_2
group by customer_id
having max(transaction_date) < date_sub(curdate(), interval 90 day))

select c.customer_id, c.name, d.last_transaction_date from customers_2 c
inner join dormant d on c.customer_id = d.customer_id
order by d.last_transaction_date desc;

