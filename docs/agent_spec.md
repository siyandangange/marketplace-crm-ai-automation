# AutoConnect — AI Campaign Operations Assistant Specification

**Phase:** 05 — AI Agent  
**Task:** T14  
**Status:** Design specification  
**Platform:** n8n (self-hosted/local)  
**Project:** Independent educational CRM automation prototype

## 1. Business Objective

Reduce manual CRM campaign preparation by assisting CRM managers with campaign briefs, segmentation recommendations, email drafts, validation reporting and approval coordination.

The assistant supports the existing AutoConnect saved-search re-engagement journey.

It does not independently select customers, approve campaign eligibility or send marketing communications.

## 2. Existing System Context

- **Phase 03 — SQL/SQLite:** Identifies eligible customers using active saved searches, at least seven days of inactivity, consent, deduplication and 14-day same-campaign suppression.
- **Phase 04 — Brevo:** Contains a configured, inactive saved-search re-engagement workflow and a successfully tested personalised email.
- **Phase 05 — n8n:** Coordinates campaign preparation, AI-generated drafts, validation and human review.

The SQL-to-Brevo integration has not yet been implemented.

## 3. Workflow Trigger

A CRM manager submits a structured campaign request through an n8n Form Trigger.

Required inputs:

- Campaign name
- Business objective
- Target audience description
- Communication channel
- Requested tone

The workflow also uses an approved audience summary and eligibility rules from the existing SQL prototype.

The initial implementation uses synthetic test data only.

## 4. AI Responsibilities

The AI assistant may:

1. Generate a structured campaign brief.
2. Suggest SQL segmentation logic for review.
3. Draft an email subject line, preview text and body.
4. Summarise assumptions, missing information and potential campaign risks.
5. Explain validation findings in language suitable for CRM manager review.

All generated content must be labelled **DRAFT — NOT APPROVED**.

## 5. Structured Outputs

The assistant should produce:

- Campaign identifier and name
- Campaign objective
- Audience description
- Validated audience count, when supplied by the SQL process
- Draft campaign brief
- Suggested SQL logic
- Draft subject line
- Draft preview text
- Draft email body
- Assumptions and warnings
- Validation status
- Approval status

Initial approval status: **PENDING_REVIEW** only after deterministic validation passes. Invalid requests must be marked **BLOCKED**.

## 6. Deterministic Validation

The n8n workflow must validate:

- Required campaign inputs are present.
- Audience eligibility comes from the approved SQL process.
- Consent requirements are satisfied.
- The 14-day same-campaign suppression rule is respected.
- Duplicate or invalid recipient records are blocked.
- Only approved, user-controlled test addresses may be used for delivery testing.

The AI model must not determine whether consent or suppression rules pass.

Where validated audience data is unavailable, the workflow must fail closed rather than assume eligibility.

AI-generated SQL is advisory and must never execute automatically.

## 7. Human Approval

After successful validation, the campaign package is routed to a CRM manager for review.

Available decisions:

- **APPROVE:** Accept the draft campaign package.
- **REJECT:** Stop the workflow.
- **REQUEST_REVISION:** Return the draft for changes and another review.

Approval must be recorded with a timestamp and decision status.

Approval does not automatically activate a Brevo workflow or authorise live email sending.

## 8. Safety and Data Boundaries

- Use synthetic customer data only.
- Do not send emails to fictional example.com addresses.
- Do not expose API keys or credentials in workflow exports.
- Do not allow the AI to override consent or eligibility checks.
- Do not automatically execute AI-generated SQL.
- Do not activate Brevo or send marketing emails through this agent.
- Keep the existing Brevo journey inactive during Phase 05.
- Record errors, validation failures and approval decisions for testing.

## 9. T14–T18 Acceptance Criteria

| Task | Acceptance criterion |
|---|---|
| T14 | Agent inputs, outputs, guardrails and approval rules documented |
| T15 | n8n accepts a structured campaign request |
| T16 | AI generates a campaign brief, SQL suggestion and email draft, clearly marked unapproved |
| T17 | Deterministic checks block invalid, unconsented or suppressed cases |
| T18 | Human approval, rejection and revision paths demonstrated without automatic campaign sending |

## 10. Current Implementation Status

This document defines the intended design. The n8n workflow, AI integration, validation and approval mechanism have not yet been implemented or tested.

**Next task:** T15 — Build the n8n campaign request trigger.
