# AutoConnect — MVP Journey Specification

**Project:** AI-Powered CRM Lifecycle Automation  
**Journey:** Saved-Search Re-engagement  
**Version:** 1.0  
**Date:** 03 November 2026  
**Status:** Approved by project owner — 03 November 2026
**Project type:** Independent portfolio prototype  
**Data:** Synthetic only

## 1. Journey Objective

Re-engage customers of a fictional vehicle marketplace who have active saved vehicle searches but have not recently interacted with the marketplace.

The journey will demonstrate SQL-based segmentation, consent management, campaign suppression, personalisation, human approval and performance measurement.

## 2. Target Audience

Customers with at least one active saved vehicle search who meet the agreed inactivity and marketing eligibility rules.

## 3. Eligibility Rules

| ID | Rule | Expected behaviour |
|---|---|---|
| EL-01 | Active saved search | Customer must have at least one active saved search. |
| EL-02 | Inactivity | Customer's latest browsing event must be at least seven days old. |
| EL-03 | No browsing history | Customer qualifies when their active saved search is at least seven days old, subject to all other rules. |
| EL-04 | Marketing consent | Customer must have current, valid email marketing opt-in. |
| EL-05 | Valid email | Customer must have a non-empty, syntactically valid email address. |
| EL-06 | Unique audience | Each eligible customer must appear once in the final audience. |

**Inactivity calculation:** For the prototype, eligibility is evaluated against a fixed reference timestamp, `2026-11-03 19:00:00`, for reproducible testing. Customers with browsing events qualify when their latest event is on or before `2026-10-27 19:00:00`.

Customers without browsing events are assessed using the creation timestamp of their active saved search.

This reference timestamp is a prototype testing assumption, not a live campaign schedule.

## 4. Exclusion and Suppression Rules

| ID | Exclusion | Expected behaviour |
|---|---|---|
| EX-01 | Opted out | Exclude customers whose latest recorded email marketing consent is opted out. |
| EX-02 | Missing consent | Exclude customers without an affirmative email marketing opt-in record. |
| EX-03 | Invalid email | Exclude missing, malformed or otherwise invalid test email addresses. |
| EX-04 | Recent campaign contact | Exclude customers sent the same re-engagement campaign within the previous 14 days. |
| EX-05 | Duplicate customer records | Prevent repeated campaign contact to the same normalised email address. |
| EX-06 | Inactive saved searches | Exclude customers without an active saved search. |

Where multiple consent records exist, the latest consent record determines eligibility. Ambiguous consent records must be excluded until resolved.

Where a customer has multiple active saved searches, select one deterministically for personalisation.

## 5. Journey Flow

1. CRM Campaign Manager submits a campaign request.
2. SQL identifies potentially eligible customers.
3. Eligibility, consent, suppression and deduplication checks are applied.
4. The eligible audience count is prepared for review.
5. Personalised email content is prepared using the selected saved search.
6. Campaign Manager reviews and approves the audience and content.
7. The approved test journey is configured in Brevo.
8. Only explicitly approved, owned test email addresses may receive messages.
9. Campaign interactions and test outcomes are recorded.
10. KPI results and limitations are documented.

No autonomous live customer messaging is permitted.

## 6. Personalisation

The email may use the customer's first name, saved vehicle make and saved vehicle model.

Example: A customer who saved a Volkswagen Golf search may receive a message referring to that preference.

The prototype must not invent matching vehicle inventory or claim that new listings exist without a supporting data source.

## 7. Success Metrics

| KPI | Definition |
|---|---|
| Eligible audience size | Number of unique eligible customers after all exclusion rules. |
| Campaign preparation time | Time from structured campaign request to approved campaign configuration. |
| Email click-through rate | Unique clickers divided by delivered emails. |
| Re-engagement rate | Percentage of contacted customers who return to the marketplace within seven days of the campaign send. |
| Seller enquiry conversion | Percentage of contacted customers who submit a seller enquiry within seven days of the campaign send. |
| Automation success rate | Successful workflow executions divided by total attempted executions. |

The seven-day measurement window is a proposed MVP convention requiring approval. All outcomes must be labelled as simulated unless measured through owned test accounts.

## 8. Test Scenarios

The synthetic dataset must support at least:

- Eligible customer with an active saved search and inactivity of seven or more days.
- Recently active customer who must be excluded.
- Customer with opted-out or missing consent.
- Customer with duplicate email records or multiple saved searches.
- Customer contacted by the same campaign within the previous 14 days.
- Customer with no browsing history and an active saved search at least seven days old.
- Customer with an invalid email address.

## 9. Approval and Governance

The CRM Campaign Manager is the hypothetical business approver.

For this independent portfolio prototype, the project owner approves the specification and any controlled test execution.

AI-generated SQL, campaign briefs and email copy require human review. Consent and exclusion checks must be deterministic.

No real marketplace customer information will be used.

## 10. Acceptance Criteria

T02 is complete when:

- Journey objective and target audience are documented.
- Eligibility and inactivity rules are agreed.
- Consent, suppression and deduplication rules are documented.
- Success metrics and measurement windows are agreed.
- Human approval requirements are documented.
- Project-owner approval of this specification is recorded.

**Approval record:** Approved by the project owner on 03 November 2026. Approved decisions include the fixed SQL testing reference timestamp of 2026-11-03 19:00:00, 
a seven-day KPI measurement window after campaign send, and eligibility for customers without browsing history when their active saved search is at least seven days old,
subject to all other exclusions. Approval applies to the independent synthetic-data prototype only.

---

**Disclaimer:** AutoConnect is a fictional marketplace and independent educational portfolio project.
