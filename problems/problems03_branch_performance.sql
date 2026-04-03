-- Q3 Branch Performance
branches(branch_id, branch_name, region)
-- accounts(account_id, branch_id, account_type)
-- transactions_3(transaction_id, account_id, amount, transaction_date)
-- Write a query that returns each region's top-performing branch by total transaction volume in 
-- the current year. If two branches in the same region are tied, return both.
-- Expected output columns: region, branch_name, total_volume

with acnt as (select a.account_id, b.branch_name, b.region from branches b
inner join accounts a on b.branch_id = a.branch_id)

SELECT z.region, z.branch_name, z.total_volume FROM
    (select c.region, c.branch_name, sum(t.amount) AS total_volume,
    RANK() Over(PARTITION BY c.region ORDER BY sum(t.amount) DESC) as rnk
    from acnt c
    inner join transactions_3 t on c.account_id=t.account_id
    where year(t.transaction_date) = 2024
    GROUP BY c.region, c.branch_name
    ) z
where z.rnk = 1
ORDER BY z.region



