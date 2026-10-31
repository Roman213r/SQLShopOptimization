EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.customer_id, o.total_amount, o.created_at
FROM orders o
WHERE o.status = 'paid'
  AND o.id NOT IN (
      SELECT p.order_id
      FROM payments p
      WHERE p.status = 'captured'
  )
ORDER BY o.created_at DESC
LIMIT 50;
