EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT *
FROM orders
WHERE customer_id = 1842
  AND created_at >= now() - interval '90 days'
ORDER BY created_at DESC;
