EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.id,
    c.full_name,
    (
        SELECT o.created_at
        FROM orders o
        WHERE o.customer_id = c.id
        ORDER BY o.created_at DESC
        LIMIT 1
    ) AS last_order_at,
    (
        SELECT o.total_amount
        FROM orders o
        WHERE o.customer_id = c.id
        ORDER BY o.created_at DESC
        LIMIT 1
    ) AS last_order_amount
FROM customers c
WHERE c.is_active
  AND c.city = 'Київ'
LIMIT 100;
