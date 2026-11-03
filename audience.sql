
-- AutoConnect | Eligible Audience Segmentation
-- SQLite prototype
-- Reference date: 2026-11-03
-- All data is synthetic.

WITH last_activity AS (
    SELECT
        customer_id,
        MAX(occurred_at) AS last_active_at
    FROM browsing_events
    GROUP BY customer_id
)

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.email,
    s.vehicle_make,
    s.vehicle_model,
    a.last_active_at
FROM customers c

JOIN saved_searches s
    ON c.customer_id = s.customer_id

JOIN last_activity a
    ON c.customer_id = a.customer_id

JOIN consents co
    ON c.customer_id = co.customer_id

WHERE
    s.is_active = 1

    AND co.channel = 'email'
    AND co.status = 'opted_in'

    AND a.last_active_at <= datetime('2026-11-03', '-7 days')

ORDER BY c.customer_id;
