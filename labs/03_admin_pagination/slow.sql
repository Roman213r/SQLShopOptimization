EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, customer_id, status, created_at, total_amount
FROM orders
WHERE status = 'paid'
ORDER BY created_at DESC, id DESC
LIMIT 50 OFFSET 40000;
