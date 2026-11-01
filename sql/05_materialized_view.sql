DROP MATERIALIZED VIEW IF EXISTS mv_daily_sales;

CREATE MATERIALIZED VIEW mv_daily_sales AS
SELECT
    date_trunc('day', x.created_at) AS day,
    x.category_id,
    c.name AS category,
    count(*) AS orders_count,
    sum(x.units) AS units,
    sum(x.revenue) AS revenue
FROM (
    SELECT
        o.id,
        o.created_at,
        p.category_id,
        sum(oi.quantity) AS units,
        sum(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p ON p.id = oi.product_id
    WHERE o.status IN ('paid', 'shipped')
    GROUP BY o.id, o.created_at, p.category_id
) x
JOIN categories c ON c.id = x.category_id
GROUP BY 1, 2, 3;

CREATE UNIQUE INDEX idx_mv_daily_sales_day_cat
    ON mv_daily_sales (day, category_id);

ANALYZE mv_daily_sales;
