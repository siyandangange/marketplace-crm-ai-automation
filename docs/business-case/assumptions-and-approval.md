# AutoConnect — Assumptions Register & Approval Record

**Project:** AI-Powered CRM Lifecycle Automation for a Fictional Vehicle Marketplace  
**Business Case:** Version 1.0  
**Business Case Date:** 03 November 2026  
**Approval Date:** 03 November 2026  
**Approver:** Project owner (independent portfolio project)  
**Decision:** Conditionally approved — subject to documenting the consolidated assumptions register  
**Affiliation:** Independent educational portfolio project; not affiliated with mobile.de

## 1. Purpose

This document records the assumptions underpinning the AutoConnect MVP and the project owner's approval decision.

The assumptions are hypotheses for a fictional marketplace, not verified findings about an actual company's systems, customers, processes or performance.

## 2. Business Assumptions

| ID | Assumption | Validation approach |
|---|---|---|
| BA-01 | Customer behavioural and consent information may be distributed across systems. | Represent separate customer, browsing and consent datasets in the prototype. |
| BA-02 | CRM campaign preparation may involve manual audience selection and technical handovers. | Document a hypothetical current-state process and demonstrate an automated alternative. |
| BA-03 | Customers with dormant saved searches may benefit from relevant re-engagement communications. | Implement a saved-search re-engagement journey and define future engagement metrics. |
| BA-04 | CRM campaign managers require visibility and approval before campaign activation. | Include a human approval checkpoint in the prototype. |

## 3. Data and Technical Assumptions

| ID | Assumption | Validation approach |
|---|---|---|
| TA-01 | Customer profiles can be linked to saved searches and browsing events using a unique customer identifier. | Test primary and foreign key relationships in SQLite. |
| TA-02 | Browsing events can represent customer activity for the MVP. | Calculate inactivity from the latest recorded browsing event. |
| TA-03 | Current email marketing consent can be represented in a dedicated consent table. | Test opted-in and opted-out customer scenarios. |
| TA-04 | Synthetic customer records are sufficient to validate segmentation and workflow logic. | Generate 50–100 fictional customers covering inclusion and exclusion cases. |
| TA-05 | SQLite is sufficient for the local prototype, but does not represent the assumed production architecture of any company. | Execute and test the schema, seed data and SQL queries locally. |
| TA-06 | Brevo can demonstrate comparable email journey capabilities without Salesforce Marketing Cloud access. | Configure and test a Brevo journey using owned test email addresses. |
| TA-07 | n8n can orchestrate AI-assisted campaign preparation and approval. | Build and test an n8n workflow with human review. |

## 4. Privacy and Governance Assumptions

| ID | Assumption | Control |
|---|---|---|
| GA-01 | No real marketplace customer data is required. | Use synthetic data only. |
| GA-02 | Marketing communications require appropriate consent and suppression checks. | Apply deterministic SQL eligibility rules before preparing test audiences. |
| GA-03 | AI-generated SQL and campaign content require human review. | Prevent autonomous campaign activation. |
| GA-04 | Public GitHub documentation must not expose credentials or sensitive data. | Exclude local database files, keep secrets out of Git and review screenshots. |
| GA-05 | Portfolio demonstrations must not imply affiliation with an actual marketplace. | Use fictional branding and an independence disclaimer. |

## 5. Approval Record

**Decision:** Business Case V1.0 conditionally approved.

**Approved by:** Project owner  
**Date:** 03 November 2026  
**Conditions:** Add the consolidated assumptions register and retain clear distinctions between hypothetical business problems, implemented functionality and future work.

**Approval scope:** Independent AutoConnect MVP covering synthetic customer data, SQL audience segmentation, one re-engagement journey, an AI campaign operations assistant, human approval and prototype testing.

**Not approved:** Production deployment, use of real marketplace customer data, autonomous customer messaging or claims of affiliation with mobile.de.

**Approval status:** Conditional approval recorded; documentation condition pending verification.

## 6. Next Gate

Proceed to T02 — Define MVP journey, success metrics, consent policy and exclusion rules.

T01 may be marked Completed once this assumptions and approval record is committed to GitHub and reviewed against the approved business case.
