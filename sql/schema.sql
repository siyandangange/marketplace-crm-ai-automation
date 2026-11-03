
-- AutoConnect | Customer Data Model
-- Database: SQLite
-- Purpose: Support customer segmentation and CRM lifecycle automation
-- All data used in this project is synthetic.

PRAGMA foreign_keys = ON;

-- 1. Customer profiles
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL,
    country TEXT DEFAULT 'Germany'
);

-- 2. Saved vehicle searches
CREATE TABLE IF NOT EXISTS saved_searches (
    search_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    vehicle_make TEXT NOT NULL,
    vehicle_model TEXT,
    min_price REAL,
    max_price REAL,
    created_at TEXT NOT NULL,
    is_active INTEGER NOT NULL DEFAULT 1
        CHECK (is_active IN (0, 1)),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 3. Customer browsing activity
CREATE TABLE IF NOT EXISTS browsing_events (
    event_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    event_type TEXT NOT NULL,
    occurred_at TEXT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 4. Marketing consent
CREATE TABLE IF NOT EXISTS consents (
    consent_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    channel TEXT NOT NULL,
    status TEXT NOT NULL
        CHECK (status IN ('opted_in', 'opted_out')),
    updated_at TEXT NOT NULL,
    UNIQUE (customer_id, channel),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 5. Campaign interactions
CREATE TABLE IF NOT EXISTS campaign_events (
    campaign_event_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    campaign_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    occurred_at TEXT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Indexes for faster customer segmentation
CREATE INDEX IF NOT EXISTS idx_saved_searches_customer
ON saved_searches(customer_id);

CREATE INDEX IF NOT EXISTS idx_browsing_events_customer_date
ON browsing_events(customer_id, occurred_at);

CREATE INDEX IF NOT EXISTS idx_campaign_events_customer_date
ON campaign_events(customer_id, occurred_at);

-- 6. Raw customer staging data
-- Deliberately allows missing and duplicate emails
-- for synthetic CRM data-quality testing.

CREATE TABLE IF NOT EXISTS raw_customer_staging (
    staging_id INTEGER PRIMARY KEY,
    source_customer_id TEXT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    country TEXT,
    imported_at TEXT NOT NULL,
    source_system TEXT NOT NULL
);
