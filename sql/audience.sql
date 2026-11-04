-- AutoConnect T07 | Eligible audience (synthetic data only)
-- Fixed evaluation time: 2026-11-03 19:00:00
-- Inclusive inactivity cutoff: 2026-10-27 19:00:00
WITH
params AS (
  SELECT datetime('2026-11-03 19:00:00') AS reference_at,
         datetime('2026-11-03 19:00:00', '-7 days') AS inactivity_cutoff,
         datetime('2026-11-03 19:00:00', '-14 days') AS suppression_cutoff
),
last_activity AS (
  SELECT customer_id, MAX(occurred_at) AS last_browsing_at
  FROM browsing_events
  GROUP BY customer_id
),
latest_consent AS (
  SELECT customer_id, status, changed_at,
         ROW_NUMBER() OVER (
           PARTITION BY customer_id
           ORDER BY changed_at DESC, consent_history_id DESC
         ) AS rn
  FROM consent_history
  WHERE channel = 'email'
),
ranked_searches AS (
  SELECT s.*,
         ROW_NUMBER() OVER (
           PARTITION BY customer_id
           ORDER BY created_at DESC, search_id DESC
         ) AS rn
  FROM saved_searches s
  WHERE is_active = 1
),
qualified AS (
  SELECT c.customer_id, c.first_name,
         LOWER(TRIM(c.email)) AS email,
         s.search_id, s.vehicle_make, s.vehicle_model,
         a.last_browsing_at, s.created_at AS saved_search_created_at,
         ROW_NUMBER() OVER (
           PARTITION BY LOWER(TRIM(c.email))
           ORDER BY c.customer_id
         ) AS email_rank
  FROM customers c
  JOIN ranked_searches s ON s.customer_id = c.customer_id AND s.rn = 1
  LEFT JOIN last_activity a ON a.customer_id = c.customer_id
  JOIN consents co ON co.customer_id = c.customer_id
                  AND co.channel = 'email' AND co.status = 'opted_in'
  JOIN latest_consent lc ON lc.customer_id = c.customer_id
                        AND lc.rn = 1 AND lc.status = 'opted_in'
  CROSS JOIN params p
  WHERE c.email IS NOT NULL
    AND TRIM(c.email) <> ''
    AND TRIM(c.email) NOT GLOB '* *'
    AND TRIM(c.email) NOT GLOB '*@*@*'
    AND TRIM(c.email) GLOB '?*@?*.*?*'
    AND ( (a.last_browsing_at IS NOT NULL AND a.last_browsing_at <= p.inactivity_cutoff)
       OR (a.last_browsing_at IS NULL AND s.created_at <= p.inactivity_cutoff) )
    AND NOT EXISTS (
      SELECT 1 FROM campaign_events ce
      WHERE ce.customer_id = c.customer_id
        AND ce.campaign_id = 'SAVED_SEARCH_REENGAGEMENT'
        AND ce.event_type = 'sent'
        AND ce.occurred_at > p.suppression_cutoff
        AND ce.occurred_at <= p.reference_at
    )
)
SELECT customer_id, first_name, email, search_id, vehicle_make,
       vehicle_model, last_browsing_at, saved_search_created_at
FROM qualified
WHERE email_rank = 1
ORDER BY customer_id;
