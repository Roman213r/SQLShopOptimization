CREATE MATERIALIZED VIEW IF NOT EXISTS mv_daily_sales AS
SELECT
    date_trunc('day', o.created_at) AS day,
    p.category_id,
    c.name AS category,
    count(DISTINCT o.id) AS orders_count,
    sum(oi.quantity) AS units,
    sum(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
JOIN categories c ON c.id = p.category_id
WHERE o.status IN ('paid', 'shipped')
GROUP BY 1, 2, 3;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_daily_sales_day_cat
    ON mv_daily_sales (day, category_id);

ANALYZE mv_daily_sales;

