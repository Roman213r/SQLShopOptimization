EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.id,
    c.full_name,
    o.created_at AS last_order_at,
    o.total_amount AS last_order_amount
FROM customers c
LEFT JOIN LATERAL (
    SELECT created_at, total_amount
    FROM orders
    WHERE customer_id = c.id
    ORDER BY created_at DESC
    LIMIT 1
) o ON TRUE
WHERE c.is_active
  AND c.city = 'Київ'
LIMIT 100;
