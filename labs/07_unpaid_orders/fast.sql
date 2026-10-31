EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.customer_id, o.total_amount, o.created_at
FROM orders o
WHERE o.status = 'paid'
  AND NOT EXISTS (
      SELECT 1
      FROM payments p
      WHERE p.order_id = o.id
        AND p.status = 'captured'
  )
ORDER BY o.created_at DESC
LIMIT 50;
