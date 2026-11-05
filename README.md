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

A local n8n/Ollama prototype supports AI-assisted campaign proposal preparation and human draft review.

Demonstrated capabilities include:

- Structured campaign requests
- AI-generated campaign briefs
- Reference to the established deterministic SQL audience query (no AI-generated SQL execution)
- Personalised email content drafts
- Proposal-level validation checks and human approval/rejection of draft planning materials

AI-generated outputs require human review. Approval of a draft does not verify audience eligibility or authorize campaign activation.

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
| n8n | AI-assisted campaign proposal preparation, validation routing and human review |
| Ollama / qwen2.5:3b | Local language model for unapproved campaign draft generation |
| REST APIs / Postman | Integration development and API testing |
| GitHub | Version control, documentation and portfolio evidence |

Salesforce Marketing Cloud capabilities will be mapped conceptually where relevant. The project does not claim a live Salesforce Marketing Cloud implementation.

## Project Status

**Current phase:** Phase 05 — AI-assisted campaign operations and documentation (prototype implemented; evidence packaging ongoing).

The SQL baseline, Brevo editor test and n8n human draft-review workflow have been demonstrated. The components are **not** an integrated, live campaign-delivery system.

### Implementation Progress

| ID | Activity | Current evidence-based status |
|---|---|---|
| T01–T03 | Business case, journey requirements and repository | Completed |
| T04–T06 | SQLite schema, 80 synthetic customers and local environment | Completed |
| T07–T09 | Deterministic audience query, 13 SQL checks and synthetic export | Completed; 35 eligible synthetic records at fixed reference time |
| T10–T13 | Brevo test journey, attributes, personalised editor email | Configured; editor test email delivered; live journey execution not tested |
| T14 | Agent design, inputs/outputs and guardrails | Documented |
| T15 | n8n structured campaign request | Tested |
| T16 | Local Ollama AI draft campaign proposal | Tested; existing `sql/audience.sql` referenced rather than model SQL executed |
| T17 | JavaScript proposal validation and routing | Demonstrated at proposal level; customer-by-customer eligibility not integrated |
| T18 | Human draft review | Approve Draft and Reject Draft paths tested; revision path not demonstrated |

### Implementation boundaries

- SQL eligibility logic is implemented and tested separately, not executed by the n8n agent.
- The Brevo journey remains inactive. An editor test email is **not** proof of live journey execution.
- Human draft approval does **not** set `audience_eligibility_verified`, `campaign_approved` or `campaign_sent` to true.
- No automatic SQL execution, live campaign sending, dynamic MCP brand-context integration or production CRM integration is claimed.
- Evidence screenshots and a sanitized n8n workflow export still need to be committed.

### Next Steps

1. Add sanitized n8n workflow JSON and screenshots for T15–T18.
2. Verify the proposal-validation failure branch with explicit negative tests.
3. Consider a REQUEST_REVISION branch and future deterministic SQL-to-n8n integration.
4. Refresh portfolio evidence and review the project as an interview-ready case study.

## Documentation

- [Business Case](docs/business-case/README.md)
- [Assumptions & Approval Record](docs/business-case/assumptions-and-approval.md)
- [Business Discovery & Requirements](docs/discovery-and-requirements.md)
- [MVP Journey Specification](docs/journey-specification.md)
- [CRM Data Model](docs/data-model.md)
- [Local SQLite Setup](docs/setup.md)
- [Implementation Decisions & Limitations](docs/implementation-decisions-and-limitations.md)
- [Phase 04 — Brevo Journey Implementation](docs/brevo-journey-implementation.md)
- [Phase 05 — AI Agent Specification & Tested Human Review](docs/agent_spec.md)

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
