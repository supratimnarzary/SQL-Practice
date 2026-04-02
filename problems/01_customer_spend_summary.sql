-- =============================================
-- Problem 01: Customer Spend Summary
-- Difficulty: Intermediate
-- Topics: INNER JOIN, GROUP BY, HAVING, Aggregations
-- Date Attempted: 2026-04-01
-- =============================================
--
-- QUESTION:
-- You have two tables:
--   customers(customer_id, name, segment)
--   transactions(transaction_id, customer_id, amount, transaction_date)
--
-- Write a SQL query that returns the total spend and number of
-- transactions for each customer segment, but only include segments
-- where the average transaction amount exceeds $500.
-- Order by total spend descending.
--
-- Expected output columns: segment, total_spend, transaction_count, avg_transaction
--
-- =============================================
-- MY SOLUTION:
-- =============================================
-- Approach 1

SELECT
    c.segment,
    SUM(t.amount)           AS total_spend,
    COUNT(t.transaction_id) AS transaction_count,
    AVG(t.amount)           AS avg_transaction
FROM customers c
INNER JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.segment
HAVING AVG(t.amount) > 500
ORDER BY total_spend DESC;

-- Approach 2 (using CTE)

WITH segment_stats AS (
    SELECT
        c.segment,
        SUM(t.amount)           AS total_spend,
        COUNT(t.transaction_id) AS transaction_count,
        AVG(t.amount)           AS avg_transaction
    FROM customers c
    INNER JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.segment
)
SELECT *
FROM segment_stats
WHERE avg_transaction > 500
ORDER BY total_spend DESC;