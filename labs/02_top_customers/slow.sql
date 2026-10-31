EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.id,
    c.full_name,
    c.email,
    (
        SELECT coalesce(sum(o.total_amount), 0)
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.status IN ('paid', 'shipped')
          AND o.created_at >= date_trunc('month', now()) - interval '1 month'
          AND o.created_at <  date_trunc('month', now())
    ) AS revenue
FROM customers c
WHERE c.is_active
ORDER BY revenue DESC
LIMIT 20;
