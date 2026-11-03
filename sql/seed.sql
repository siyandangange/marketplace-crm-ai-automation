
-- AutoConnect | Synthetic Test Data
-- All customers, events and preferences are fictional.
-- Dates are relative to the day the script is executed.

-- Customers
INSERT INTO customers
(customer_id, first_name, last_name, email, created_at)
VALUES
(1, 'Lena', 'Weber', 'lena@example.com', date('now','-90 days')),
(2, 'Jonas', 'Fischer', 'jonas@example.com', date('now','-60 days')),
(3, 'Mia', 'Schneider', 'mia@example.com', date('now','-75 days')),
(4, 'Ben', 'Hoffmann', 'ben@example.com', date('now','-45 days')),
(5, 'Amira', 'Kaya', 'amira@example.com', date('now','-80 days')),
(6, 'Paul', 'Becker', 'paul@example.com', date('now','-55 days'));

-- Saved searches
INSERT INTO saved_searches
(search_id, customer_id, vehicle_make, vehicle_model,
 min_price, max_price, created_at, is_active)
VALUES
(101, 1, 'Volkswagen', 'Golf', 8000, 18000, date('now','-30 days'), 1),
(102, 2, 'BMW', '3 Series', 12000, 28000, date('now','-20 days'), 1),
(103, 3, 'Audi', 'A3', 10000, 22000, date('now','-25 days'), 1),
(104, 4, 'Toyota', 'Yaris', 6000, 14000, date('now','-20 days'), 1),
(105, 5, 'Mercedes-Benz', 'A-Class', 14000, 30000, date('now','-40 days'), 1),
(106, 6, 'Opel', 'Corsa', 5000, 12000, date('now','-15 days'), 0);

-- Browsing events
INSERT INTO browsing_events
(event_id, customer_id, event_type, occurred_at)
VALUES
(201, 1, 'vehicle_view', datetime('now','-10 days')),
(202, 2, 'vehicle_view', datetime('now','-1 day')),
(203, 3, 'vehicle_view', datetime('now','-14 days')),
(204, 4, 'vehicle_view', datetime('now','-20 days')),
(205, 5, 'vehicle_view', datetime('now','-20 days')),
(206, 6, 'vehicle_view', datetime('now','-12 days'));

-- Marketing consent
INSERT INTO consents
(consent_id, customer_id, channel, status, updated_at)
VALUES
(301, 1, 'email', 'opted_in', datetime('now','-40 days')),
(302, 2, 'email', 'opted_in', datetime('now','-30 days')),
(303, 3, 'email', 'opted_out', datetime('now','-5 days')),
(304, 4, 'email', 'opted_in', datetime('now','-30 days')),
(305, 5, 'email', 'opted_in', datetime('now','-30 days')),
(306, 6, 'email', 'opted_in', datetime('now','-30 days'));

-- Recent campaign contact: exclude Amira
INSERT INTO campaign_events
(campaign_event_id, customer_id, campaign_id,
 event_type, occurred_at)
VALUES
(401, 5, 'SAVED_SEARCH_REENGAGEMENT',
 'sent', datetime('now','-3 days'));
