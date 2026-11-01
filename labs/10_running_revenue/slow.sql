EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    d.day,
    d.revenue,
    (
        SELECT sum(d2.revenue)
        FROM (
            SELECT date_trunc('day', created_at) AS day,
                   sum(total_amount) AS revenue
            FROM orders
            WHERE status IN ('paid', 'shipped')
              AND created_at >= now() - interval '30 days'
            GROUP BY 1
        ) d2
        WHERE d2.day <= d.day
    ) AS running_revenue
FROM (
    SELECT date_trunc('day', created_at) AS day,
           sum(total_amount) AS revenue
    FROM orders
    WHERE status IN ('paid', 'shipped')
      AND created_at >= now() - interval '30 days'
    GROUP BY 1
) d
ORDER BY d.day;
