-- AutoConnect T08 | Exclusion and deduplication checks
-- Requires TEMP VIEW eligible_audience, created from sql/audience.sql by the run command.
-- Synthetic data only. Fixed reference timestamp: 2026-11-03 19:00:00.
WITH checks AS (
  SELECT '01 expected audience size' AS test,
         (SELECT COUNT(*) FROM eligible_audience) = 35 AS passed,
         CAST((SELECT COUNT(*) FROM eligible_audience) AS TEXT) || ' eligible' AS detail
  UNION ALL
  SELECT '02 opted-out contacts excluded',
         NOT EXISTS (SELECT 1 FROM eligible_audience a JOIN consents c ON c.customer_id=a.customer_id WHERE c.channel='email' AND c.status='opted_out'),
         'No opted-out customer in audience'
  UNION ALL
  SELECT '03 recent same-campaign sends excluded',
         NOT EXISTS (SELECT 1 FROM eligible_audience a JOIN campaign_events ce ON ce.customer_id=a.customer_id WHERE ce.campaign_id='SAVED_SEARCH_REENGAGEMENT' AND ce.event_type='sent' AND ce.occurred_at > '2026-10-20 19:00:00' AND ce.occurred_at <= '2026-11-03 19:00:00'),
         'No send in 14-day suppression window'
  UNION ALL
  SELECT '04 inactive searches excluded',
         NOT EXISTS (SELECT 1 FROM eligible_audience a WHERE NOT EXISTS (SELECT 1 FROM saved_searches s WHERE s.customer_id=a.customer_id AND s.is_active=1)),
         'Every selected customer has an active search'
  UNION ALL
  SELECT '05 recently active contacts excluded',
         NOT EXISTS (SELECT 1 FROM eligible_audience a JOIN browsing_events b ON b.customer_id=a.customer_id WHERE b.occurred_at > '2026-10-27 19:00:00'),
         'No browsing activity newer than cutoff'
  UNION ALL
  SELECT '06 boundary customers included',
         (SELECT COUNT(*) FROM eligible_audience WHERE customer_id BETWEEN 76 AND 80)=5,
         'All five seven-day boundary fixtures included'
  UNION ALL
  SELECT '07 no-browsing eligible customers included',
         (SELECT COUNT(*) FROM eligible_audience WHERE customer_id BETWEEN 57 AND 66)=10,
         'All ten eligible no-browsing fixtures included'
  UNION ALL
  SELECT '08 recent no-browsing searches excluded',
         (SELECT COUNT(*) FROM eligible_audience WHERE customer_id BETWEEN 67 AND 71)=0,
         'All five recent no-browsing fixtures excluded'
  UNION ALL
  SELECT '09 unique customer and normalized email',
         (SELECT COUNT(*) FROM eligible_audience)=(SELECT COUNT(DISTINCT customer_id) FROM eligible_audience)
         AND (SELECT COUNT(*) FROM eligible_audience)=(SELECT COUNT(DISTINCT LOWER(TRIM(email))) FROM eligible_audience),
         'No repeated customer ID or normalized email'
  UNION ALL
  SELECT '10 staging duplicates present for testing',
         EXISTS (SELECT 1 FROM raw_customer_staging WHERE email IS NOT NULL AND TRIM(email)<>'' GROUP BY LOWER(TRIM(email)) HAVING COUNT(*)>1),
         'Source staging contains normalized duplicate email fixtures'
  UNION ALL
  SELECT '11 staging invalid emails present for testing',
         EXISTS (SELECT 1 FROM raw_customer_staging WHERE email IS NULL OR TRIM(email)='' OR TRIM(email) NOT GLOB '?*@?*.*?*' OR TRIM(email) GLOB '*@*@*'),
         'Source staging contains missing or malformed email fixtures'
  UNION ALL
  SELECT '12 staging-only emails not exported',
         NOT EXISTS (
           SELECT 1 FROM eligible_audience a
           JOIN raw_customer_staging s ON LOWER(TRIM(a.email))=LOWER(TRIM(s.email))
           WHERE NOT EXISTS (
             SELECT 1 FROM customers c
             WHERE LOWER(TRIM(c.email))=LOWER(TRIM(s.email))
           )
         ),
         'No email found exclusively in staging appears in the audience'
  UNION ALL
  SELECT '13 current and latest consent agree',
         NOT EXISTS (
           SELECT 1 FROM eligible_audience a
           JOIN consents c ON c.customer_id=a.customer_id AND c.channel='email'
           WHERE c.status <> (SELECT h.status FROM consent_history h WHERE h.customer_id=a.customer_id AND h.channel='email' ORDER BY h.changed_at DESC,h.consent_history_id DESC LIMIT 1)
         ),
         'Latest consent history matches current opted-in status'
)
SELECT CASE WHEN passed THEN 'PASS' ELSE 'FAIL' END AS result, test, detail
FROM checks ORDER BY test;
