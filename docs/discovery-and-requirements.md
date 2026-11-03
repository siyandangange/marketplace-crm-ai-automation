# AutoConnect — Business Discovery & Requirements

**Project:** AI-Powered CRM Lifecycle Automation  
**Industry:** Digital Vehicle Marketplace  
**Project type:** Independent portfolio case study  
**Status:** Hypothetical discovery and proposed requirements  
**Data:** Synthetic only

## 1. Business Context

AutoConnect is a fictional European vehicle marketplace connecting private vehicle buyers, sellers and commercial dealerships.

Customers can browse vehicle listings, save searches, contact sellers and receive relevant marketplace communications.

The CRM team is responsible for customer engagement, lifecycle marketing, personalisation and campaign performance.

This case study explores how CRM automation, customer data and AI-assisted workflows could improve marketing operations and customer engagement.

All business challenges and stakeholder needs described below are hypothetical assumptions, not findings from interviews with an existing company.

## 2. Business Problem

The fictional CRM team faces five potential challenges:

- Customer information and behavioural events are distributed across different systems.
- Campaign managers depend on technical specialists to prepare customer audiences.
- Customers with saved searches may become inactive without receiving relevant follow-up communications.
- Manual campaign preparation creates operational delays.
- Campaign performance information is not always easily translated into actionable recommendations.

**Problem statement:** How might AutoConnect reduce manual CRM campaign preparation while delivering relevant, consent-compliant customer journeys that improve engagement and conversion?

## 3. Hypothetical Stakeholder Analysis

| Stakeholder | Business interest | Proposed involvement |
|---|---|---|
| CRM Manager | Campaign effectiveness and operational efficiency | Business owner and approver |
| CRM Campaign Specialist | Audience creation and campaign execution | Primary user |
| Marketing Technology | Automation architecture and implementation | Technical delivery |
| Data Engineering | Data availability, reliability and integration | Data consultation |
| Analytics | KPIs, experimentation and performance measurement | Measurement design |
| Data Protection | Consent, privacy and compliance | Governance review |

These roles are illustrative and do not represent an actual company organisation chart.

## 4. Current-State Process (Assumed)

1. Marketing identifies a customer engagement opportunity.
2. A campaign manager requests customer segmentation from a technical colleague.
3. Technical colleagues prepare an audience extract.
4. Marketing reviews the audience and prepares campaign content.
5. A technical or CRM specialist configures the journey.
6. The campaign is approved and activated.
7. Campaign results are reviewed and reported.

**Potential friction:** Manual handovers, repetitive audience preparation, inconsistent validation and long campaign lead times.

These issues require validation in a real discovery exercise.

## 5. Proposed Future-State Process

1. The campaign manager submits a structured campaign request.
2. An AI-assisted workflow prepares a campaign brief and draft segmentation logic.
3. Approved SQL queries identify eligible customers using validated customer data.
4. Consent, suppression and frequency rules are applied.
5. The system prepares personalised campaign content.
6. The campaign manager reviews and approves the proposed audience and content.
7. The CRM automation platform executes the approved customer journey.
8. Engagement and conversion results are measured.

The prototype will demonstrate this process using synthetic data, SQLite, Brevo and n8n. AI-generated outputs must be reviewed before use.

## 6. Business Requirements

**BR-01 — Customer segmentation:** Identify customers with active saved vehicle searches who have been inactive for at least seven days.

**BR-02 — Marketing consent:** Exclude customers without valid email marketing consent.

**BR-03 — Campaign suppression:** Exclude customers recently contacted by the same re-engagement campaign.

**BR-04 — Personalisation:** Prepare messages reflecting a customer's saved vehicle preferences.

**BR-05 — CRM efficiency:** Reduce manual effort in preparing campaign briefs, audience logic and content drafts.

**BR-06 — Human approval:** Require campaign manager approval before campaign activation.

**BR-07 — Performance measurement:** Measure audience size, engagement and conversion using synthetic campaign data.

## 7. Technical Requirements

| ID | Requirement | Proposed technology |
|---|---|---|
| TR-01 | Store relational customer and behavioural data | SQLite |
| TR-02 | Execute customer segmentation queries | SQL |
| TR-03 | Generate reproducible fictional data | Python |
| TR-04 | Prepare automated customer communications | Brevo |
| TR-05 | Automate campaign preparation | n8n |
| TR-06 | Support API-based integration | REST APIs / Postman |
| TR-07 | Produce campaign performance analysis | SQL / Python |

## 8. User Story

**As a CRM Campaign Manager,** I want to identify customers who have not engaged with their saved vehicle searches for at least seven days, so that I can prepare relevant re-engagement campaigns without relying on manual audience extraction.

### Acceptance Criteria

- Customers must have at least one active saved search.
- Customers must have no recorded browsing activity within the previous seven days.
- Customers must have valid email marketing consent.
- Customers contacted by the same campaign within the previous 14 days must be excluded.
- Each eligible customer must appear only once in the final audience.
- The audience count must be available for review.
- AI-generated content and segmentation recommendations must be approved before campaign activation.
- Only approved test email addresses may receive messages during the prototype.

## 9. Proposed KPIs

| KPI | Definition |
|---|---|
| Eligible audience size | Number of unique customers meeting segmentation and consent rules |
| Campaign preparation time | Time required to prepare an approved campaign |
| Email click-through rate | Unique clickers divided by delivered emails |
| Re-engagement rate | Percentage of contacted customers returning within the measurement window |
| Seller enquiry conversion | Percentage of contacted customers submitting a seller enquiry |
| Automation success rate | Percentage of workflow executions completed successfully |

No performance improvements are claimed until measured.

## 10. Assumptions and Constraints

- All customer and campaign data is fictional.
- The prototype does not access production marketplace systems.
- SQLite represents the prototype data layer, not an assumed enterprise architecture.
- Brevo provides comparable marketing automation capabilities but is not Salesforce Marketing Cloud.
- AI assistance supports campaign preparation, not autonomous campaign approval.
- GDPR principles, consent controls and data minimisation are reflected in the design.
- Production deployment, scale testing and enterprise security certification are outside the initial prototype scope.

## 11. Prototype Success Criteria

The prototype is considered functional when:

1. The database schema executes successfully and relational integrity is verified.
2. Synthetic customer records cover eligible and excluded scenarios.
3. SQL produces an accurate, deduplicated and consent-compliant audience.
4. A personalised re-engagement communication can be demonstrated with an approved test recipient.
5. An n8n workflow generates a campaign brief, SQL suggestion and content draft.
6. Human approval is required before campaign activation.
7. Test results and implementation evidence are documented in GitHub.

## 12. Next Implementation Stage

Generate synthetic customer, saved-search, browsing, consent and campaign interaction records.

Use the resulting dataset to test the segmentation rules before integrating the audience with marketing automation and AI-assisted workflows.

---

**Disclaimer:** AutoConnect is an independent educational portfolio project. All operational challenges, requirements and organisational scenarios are hypothetical.
