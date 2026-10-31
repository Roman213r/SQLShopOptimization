EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT DISTINCT ON (c.id)
    c.id,
    c.full_name,
    o.created_at AS last_order_at,
    o.total_amount AS last_order_amount
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE c.is_active
  AND c.city = 'Київ'
ORDER BY c.id, o.created_at DESC
LIMIT 100;
