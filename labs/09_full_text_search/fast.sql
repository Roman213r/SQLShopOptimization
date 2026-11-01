EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, sku, name, price
FROM products
WHERE to_tsvector('simple', name) @@ to_tsquery('simple', 'Wave | Nova | Pulse')
ORDER BY ts_rank(
    to_tsvector('simple', name),
    to_tsquery('simple', 'Wave | Nova | Pulse')
) DESC
LIMIT 30;
