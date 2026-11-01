EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, sku, name, price
FROM products
WHERE lower(name) LIKE '%wave%'
   OR lower(name) LIKE '%nova%'
   OR lower(name) LIKE '%pulse%'
ORDER BY name
LIMIT 30;
