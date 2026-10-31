EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, sku, name, price
FROM products
WHERE name ILIKE '%Wave%'
ORDER BY price
LIMIT 30;
