EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, customer_id, status, created_at, total_amount
FROM orders
WHERE status = 'paid'
  AND (created_at, id) < (now() - interval '30 days', 999999999)
ORDER BY created_at DESC, id DESC
LIMIT 50;
