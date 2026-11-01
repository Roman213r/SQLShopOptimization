EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.customer_id, o.total_amount, o.created_at
FROM orders o
LEFT JOIN payments p
    ON p.order_id = o.id
   AND p.status = 'captured'
WHERE o.status = 'paid'
  AND p.order_id IS NULL
ORDER BY o.created_at DESC
LIMIT 50;
