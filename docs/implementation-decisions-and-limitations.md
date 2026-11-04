# AutoConnect — Implementation Decisions, Assumptions & Limitations

**Project:** AI-Powered CRM Lifecycle Automation  
**Type:** Independent educational portfolio prototype for a fictional European vehicle marketplace  
**Version:** 1.0 — SQL phase (T01–T09)  
**Recorded:** 04 November 2026  
**Status:** Documentation of implemented work; Brevo and later AI/integration work pending  
**Data:** Entirely synthetic

## 1. Purpose and evidence standard

This document separates **implemented and tested functionality**, **business or technical assumptions**, **known limitations**, and **production considerations**. It is not a production-readiness assessment. All business problems, stakeholders and customer scenarios are hypothetical.

The source of truth for the approved journey rules is [`journey-specification.md`](journey-specification.md). The implementation is in [`../sql/schema.sql`](../sql/schema.sql), [`../sql/audience.sql`](../sql/audience.sql), [`../sql/test_queries.sql`](../sql/test_queries.sql), and the Python scripts in [`../python/`](../python/).

## 2. Scope and current status

| Area | Implemented and evidenced | Not yet implemented |
|---|---|---|
| Business analysis | Fictional business case, requirements and approved MVP journey | Validation with real business stakeholders |
| CRM data | Seven-table SQLite schema, Mermaid ERD, local database | Production CRM ingestion, identity resolution and operational monitoring |
| Synthetic fixtures | 80 customers and related behavioural/consent/campaign data; 15 staging records | Representative production-scale or real-world distributions |
| Audience segmentation | SQL selection, inactivity, consent, suppression, active-search and deduplication logic | Live CRM sync, operational scheduling and dynamic campaign reference time |
| Testing | 13 SQL checks passed on the generated fixtures | Comprehensive mutation, load, security and integration testing |
| Export | 35-row synthetic CSV with five fields | A live, approved, sendable contact list |
| Journey and AI | Journey rules and proposed architecture documented | Brevo configuration/test send; n8n and AI-assisted orchestration |

## 3. Business assumptions and agreed MVP rules

| Decision | Prototype rule | Rationale and qualification |
|---|---|---|
| Reference time | `2026-11-03 19:00:00` | Fixed to make the same tests reproducible; not a live campaign clock |
| Inactivity | Latest browsing event on or before `2026-10-27 19:00:00` | Inclusive seven-day cutoff; business hypothesis, not an empirically optimised interval |
| No browsing history | Eligible if the selected active saved search was created at least seven days before reference time | Prevents automatic exclusion of customers with no recorded browsing events |
| Saved search | At least one active saved search; choose most recent active search, breaking ties by search ID | Ensures one deterministic personalisation context per customer |
| Consent | Current email opt-in **and** latest recorded email consent history opted in | A conservative prototype control; discrepancies should be quarantined/reconciled in production |
| Suppression | No `sent` event for `SAVED_SEARCH_REENGAGEMENT` in the previous 14 days through reference time | Campaign-specific frequency policy; does not cover every other marketing communication |
| Deduplication | One result per normalised email (`LOWER(TRIM(email))`), selecting lowest customer ID | Deterministic but not full customer identity resolution |
| Email validity | Basic nonempty, whitespace and SQLite `GLOB` checks | Syntactic screening only, not full email verification or deliverability validation |
| KPI window | Seven days after a hypothetical send for return visit/seller enquiry | Proposed measurement convention; no real uplift or conversion measured |
| Approval | Human review before any campaign execution | No autonomous messaging to real people |

## 4. Technical design decisions

### SQLite and Python

SQLite was selected for a local, lightweight and reproducible prototype. Python runs the deterministic fixture generator and exports the SQL audience. The generator builds a dedicated `output/t05/autoconnect_t05.db`; the older `autoconnect.db` is not the T07–T09 test database. SQLite foreign-key enforcement must be enabled on each relevant connection. Text timestamps are stored in consistent `YYYY-MM-DD HH:MM:SS` form; time-zone conversion and clock drift are not implemented.

### Seven-table CRM model

`customers`, `saved_searches`, `browsing_events`, `consents`, `consent_history`, `campaign_events`, and `raw_customer_staging` represent the fictional customer lifecycle. The staging table is deliberately separate from validated customers, permitting duplicates, blanks and malformed emails without weakening the main table's uniqueness and non-null constraints. The database does **not** automatically clean or merge staging records into customers.

### Consent handling

`consents` stores the current state and `consent_history` stores changes. The audience SQL requires both current and latest historical email status to be opted in. The prototype does not implement automatic synchronisation, an enterprise preference centre, legal-basis determination, or consent provenance verification.

### Personalisation and campaign fields

T09 exports only `customer_id`, `first_name`, `email`, `vehicle_make`, `vehicle_model`. This is a **synthetic portfolio export**, not an authorised live contact list. The full T07 SQL additionally retains selected search ID and activity timestamps for review, but these are deliberately omitted from the campaign CSV. No claim of matching vehicle inventory is made.

## 5. Test evidence and precise interpretation

**T05 — Generator:** 80 customers, 80 saved searches, 65 browsing events, 80 current consent rows, 90 consent history rows, 5 campaign events and 15 staging records. Foreign-key and consent-consistency assertions passed. The scenario manifest independently declares 35 expected eligible fixtures.

**T07 — Segmentation:** The query returned 35 customer IDs, matching the expected IDs in the scenario manifest. Included five exactly-seven-day boundary customers and ten eligible customers with no browsing history.

**T08 — Exclusion tests:** 13/13 checks passed against the generated SQLite database. Checks cover audience size, opted-out exclusion, recent same-campaign sends, inactive saved searches, recent browsing, boundary inclusion, no-browsing cases, unique IDs/emails, presence of duplicate and malformed staging fixtures, absence of staging-only addresses from the audience, and current-versus-latest consent consistency.

**Important testing limitation:** Staging duplicate and malformed-email checks establish that such **fixtures exist**, not that a complete cleansing or ingestion process was exercised. The staging-only exclusion check establishes that addresses found only in staging do not appear in the audience. Since the 80 validated customer emails are already unique and syntactically valid, the current fixture run does not independently prove the audience query would reject every possible malformed or duplicate record inserted into `customers`. Additional adversarial/negative tests are needed.

**T09 — Export:** Local execution produced `output/t09/eligible_audience.csv`, 35 rows and five columns. Checks passed for unique customer IDs, unique normalised emails and `@example.com` domain. The script and synthetic CSV are published in GitHub.

**No claim of campaign effectiveness:** No real emails, customer return visits, seller enquiries, lift, click-through or conversion outcomes have been observed.

## 6. Prototype versus production

| Dimension | This prototype | Production consideration |
|---|---|---|
| Source data | Deterministic, fictional SQLite fixtures | Governed CRM/event pipelines, freshness checks and source lineage |
| Customer identity | Customer ID plus normalised-email dedup | Identity resolution, merge rules, household/shared-email handling, auditability |
| Data validation | Basic email pattern and synthetic fixtures | Stronger syntax checks, deliverability handling, invalid-record quarantine, monitored data contracts |
| Consent | Two SQLite tables and deterministic eligibility | Verified consent capture, legal review, revocation propagation, preference centre, retention and audit controls |
| Frequency | Same-campaign 14-day suppression | Global/channel caps, concurrent journey collision checks, transactional vs marketing distinctions |
| Time | Fixed timestamp, text dates | Time-zone-aware timestamps, DST, late-arriving events, scheduled re-evaluation |
| Campaign audience | Five-field CSV of `example.com` records | Approved, access-controlled audience transfer, suppression recheck immediately before send |
| Messaging | No fictional addresses contacted | Brevo tests **only to owned, approved addresses**, with test evidence |
| Security | No credentials or real customer records in public repo | Secrets management, RBAC, privacy assessment, encryption, retention, incident handling |
| Operations | Manual local commands | Automated deployment, observability, retry/error handling, alerting and rollback |
| Scale | 80 customer fixtures | Performance, indexing and load tests at realistic volumes |
| AI | Proposed future capability | Human approval, model evaluation, grounding, minimum evidence thresholds, drift and failure handling |

## 7. Risks and follow-up work

1. **Data quality:** Build a staging-to-validated-customer transformation with explicit rejection and duplicate-resolution rules; add mutation tests for bad records in the main tables.
2. **Consent:** Test missing, conflicting, outdated and simultaneous consent events; verify exclusion when history and current status disagree.
3. **Campaign safety:** Recheck eligibility immediately before a permitted test send and enforce global frequency limits where applicable.
4. **Data time semantics:** Move from fixed local timestamps to time-zone-aware operational scheduling for a future production design.
5. **Experimentation:** Compare a rules-based baseline against proposed intent-based segmentation with a defined control group, minimum data thresholds and downstream outcome metrics; do not treat engagement alone as business value.
6. **AI and integrations:** Treat n8n, API integrations and AI-assisted campaign preparation as planned until implemented and evidenced. Require human review of generated SQL and content.
7. **Documentation maintenance:** Update the README progress table and the data-model status to reflect completed T01–T09; preserve evidence links and clearly label future work.

## 8. Next milestone and safety gate

**T10–T13:** Set up Brevo test attributes and a controlled saved-search re-engagement journey. Do **not** import the 35 `example.com` addresses as sendable contacts. Prepare a separate list using only email addresses owned and approved by the project owner; document mappings, journey configuration, consent/frequency checks and an authorised test send. Account limitations may require a documented simulation rather than claiming an unsupported live automation.

**Later phases:** n8n orchestration, API work, AI-assisted drafts and evaluation remain outside the completed T01–T09 scope.

---

**Portfolio disclaimer:** AutoConnect is an independent educational project for a fictional marketplace. Its scenarios, stakeholders, datasets and test outcomes are synthetic. The work is not evidence of deployment to a real customer environment.
