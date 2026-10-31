EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.id,
    c.full_name,
    c.email,
    sum(o.total_amount) AS revenue
FROM orders o
JOIN customers c ON c.id = o.customer_id
WHERE o.status IN ('paid', 'shipped')
  AND o.created_at >= date_trunc('month', now()) - interval '1 month'
  AND o.created_at <  date_trunc('month', now())
  AND c.is_active
GROUP BY c.id, c.full_name, c.email
ORDER BY revenue DESC
LIMIT 20;
