EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    p.id,
    p.sku,
    p.name,
    i.quantity,
    i.warehouse_id,
    c.name AS category
FROM inventory i
JOIN products p ON p.id = i.product_id
JOIN categories c ON c.id = p.category_id
WHERE i.quantity < 10
ORDER BY i.quantity ASC, p.name
LIMIT 50;
