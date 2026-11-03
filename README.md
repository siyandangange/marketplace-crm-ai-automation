# AutoConnect — AI-Powered CRM Lifecycle Automation

## Project Overview

AutoConnect is an independent CRM engineering portfolio project developed around a fictional European digital vehicle marketplace.

The project explores how customer data, SQL segmentation, marketing automation and AI-assisted workflows can improve customer lifecycle engagement while reducing manual CRM campaign preparation.

The prototype focuses on identifying customers with inactive saved vehicle searches, preparing consent-compliant audiences and supporting personalised re-engagement campaigns.

**Project type:** Independent portfolio case study  
**Industry:** Digital Vehicle Marketplace  
**Development status:** In progress  
**Data:** Synthetic only

## Business Problem

The fictional AutoConnect marketplace faces several hypothetical CRM challenges:

- Customer profiles, behavioural events and marketing consent information may be distributed across different systems.
- Campaign managers may depend on technical specialists to prepare customer audiences.
- Customers with saved vehicle searches may become inactive without receiving relevant follow-up communications.
- Manual campaign preparation and validation may create operational delays.
- Campaign performance information may not always translate into actionable recommendations.

**Business objective:** Demonstrate how structured customer data, automated segmentation and AI-assisted campaign preparation could improve CRM operational efficiency and customer engagement.

These challenges are fictional assumptions and do not represent findings about any real organisation.

## Proposed Solution

AutoConnect is designed around five core capabilities.

### 1. Customer Data Modelling

Develop a relational CRM data model covering:

- Customer profiles
- Saved vehicle searches
- Browsing behaviour
- Marketing consent
- Campaign interactions

### 2. SQL Audience Segmentation

Use SQL to identify customers who:

- Have at least one active saved vehicle search.
- Have been inactive for seven or more days.
- Have valid email marketing consent.
- Have not recently received the same re-engagement campaign.
- Meet email validity and deduplication requirements.

Customers without browsing history may qualify when their active saved search is at least seven days old, subject to the remaining eligibility rules.

### 3. CRM Lifecycle Automation

Design and demonstrate a saved-search re-engagement journey using Brevo.

The proposed journey includes audience preparation, personalised email content, consent validation, campaign suppression and human approval.

### 4. AI-Assisted Campaign Operations

Develop an n8n workflow to support CRM campaign preparation.

Planned capabilities include:

- Structured campaign requests
- AI-generated campaign briefs
- Draft SQL segmentation recommendations
- Personalised email content drafts
- Validation checks and human approval

AI-generated outputs will require human review before use.

### 5. CRM Performance Measurement

Use synthetic campaign interaction data to demonstrate reporting and analysis of:

- Eligible audience size
- Campaign preparation time
- Email click-through rate
- Customer re-engagement rate
- Seller enquiry conversion
- Automation success rate

Performance improvements will not be claimed without supporting evidence.

## MVP Customer Journey

**Journey:** Saved-Search Re-engagement

The MVP focuses on customers who have saved vehicle searches but have not recently interacted with the marketplace.

The proposed workflow is:

1. Identify customers with active saved searches.
2. Evaluate inactivity using SQL.
3. Apply consent, suppression and deduplication rules.
4. Generate an eligible audience for review.
5. Prepare personalised re-engagement content.
6. Require campaign manager approval.
7. Configure and test the journey using approved test email addresses.
8. Record campaign interactions and evaluate performance.

For reproducible SQL testing, the approved reference timestamp is **03 November 2026 at 19:00**.

Customer return visits and seller enquiries will be evaluated within a seven-day measurement window following campaign send.

## Technology Stack

| Technology | Purpose |
|---|---|
| SQL / SQLite | Relational customer data modelling, audience segmentation and validation |
| Python | Synthetic data generation, testing and analysis |
| Brevo | Email marketing and lifecycle journey demonstration |
| n8n | AI-assisted campaign operations and workflow orchestration |
| REST APIs / Postman | Integration development and API testing |
| GitHub | Version control, documentation and portfolio evidence |

Salesforce Marketing Cloud capabilities will be mapped conceptually where relevant. The project does not claim a live Salesforce Marketing Cloud implementation.

## Project Status

**Current phase: Data Preparation, SQL Segmentation & Validation**

The business requirements and MVP journey have been approved. Implementation is progressing through data modelling, synthetic data preparation and SQL-based audience segmentation.

### Implementation Progress

| ID | Activity | Status |
|---|---|---|
| T01 | Business Case & Assumptions | Completed and approved |
| T02 | MVP Journey Specification | Completed and approved |
| T03 | Repository & Documentation | Established; documentation updates in progress |
| T04 | CRM Data Model | Schema created; formal verification pending |
| T05 | Synthetic Customer Data | Initial six records created; expansion to 50–100 customers pending |
| T06 | SQLite Environment | Configured and tested locally |
| T07 | SQL Audience Segmentation | Initial query drafted; execution and validation pending |

### Next Implementation Steps

1. Finalise repository documentation and verify the CRM data model.
2. Expand the synthetic dataset to 50–100 customers covering eligibility, consent and data-quality scenarios.
3. Execute and validate SQL audience segmentation.
4. Implement exclusion and deduplication tests.
5. Prepare an eligible audience export.
6. Configure the Brevo re-engagement journey.
7. Develop and test the n8n AI campaign assistant.
8. Document results, limitations and implementation evidence.

## Documentation

- [Business Case](docs/business-case/README.md)
- [Assumptions & Approval Record](docs/business-case/assumptions-and-approval.md)
- [Business Discovery & Requirements](docs/discovery-and-requirements.md)
- [MVP Journey Specification](docs/journey-specification.md)
- [Local SQLite Setup](docs/setup.md)

## Project Governance & Data Privacy

AutoConnect follows these prototype governance principles:

- Use synthetic customer and behavioural data only.
- Do not access real marketplace customer records.
- Apply consent, suppression and deduplication controls before campaign testing.
- Restrict email delivery to explicitly approved, owned test addresses.
- Require human review of AI-generated SQL and campaign content.
- Exclude credentials, secrets and local database files from public GitHub commits.
- Document implemented functionality separately from planned or simulated capabilities.


## Portfolio Disclaimer

AutoConnect is an independent educational portfolio project developed around a fictional European digital vehicle marketplace.

All customer data, business scenarios, stakeholder requirements and operational challenges are hypothetical and created solely for learning, technical experimentation and portfolio demonstration.

The project is not affiliated with, sponsored by or endorsed by any real organisation.

This repository documents a prototype under development, not a production CRM implementation.
