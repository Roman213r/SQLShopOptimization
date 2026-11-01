EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.name AS category,
    count(*) AS orders_count,
    sum(x.units) AS units,
    sum(x.revenue) AS revenue
FROM (
    SELECT
        o.id,
        p.category_id,
        sum(oi.quantity) AS units,
        sum(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p ON p.id = oi.product_id
    WHERE o.created_at >= date_trunc('month', now()) - interval '1 month'
      AND o.created_at <  date_trunc('month', now())
      AND o.status IN ('paid', 'shipped')
    GROUP BY o.id, p.category_id
) x
JOIN categories c ON c.id = x.category_id
GROUP BY c.name
ORDER BY revenue DESC;
