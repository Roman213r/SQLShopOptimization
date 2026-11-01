EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    date_trunc('day', created_at) AS day,
    sum(total_amount) AS revenue,
    sum(sum(total_amount)) OVER (
        ORDER BY date_trunc('day', created_at)
    ) AS running_revenue
FROM orders
WHERE status IN ('paid', 'shipped')
  AND created_at >= now() - interval '30 days'
GROUP BY 1
ORDER BY 1;
