EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.id,
    c.full_name,
    c.email,
    r.revenue
FROM (
    SELECT customer_id, sum(total_amount) AS revenue
    FROM orders
    WHERE status IN ('paid', 'shipped')
      AND created_at >= date_trunc('month', now()) - interval '1 month'
      AND created_at <  date_trunc('month', now())
    GROUP BY customer_id
) r
JOIN customers c ON c.id = r.customer_id
WHERE c.is_active
ORDER BY r.revenue DESC
LIMIT 20;
