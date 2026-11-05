# AutoConnect — AI Campaign Operations Assistant Specification

**Phase:** 05 — AI Agent  
**Task:** T14  
**Status:** Design specification with Phase 05 implementation evidence (T14–T18 prototype)  
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

**Design target:** PENDING_REVIEW after deterministic eligibility validation; BLOCKED for invalid requests. **Current prototype:** proposal-level validation gates review, while actual audience eligibility is not independently verified by the n8n assistant.

## 6. Deterministic Validation

The intended production-oriented design requires validation of:

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

After proposal-level validation in the implemented prototype, the draft campaign package is routed to a human reviewer. Full audience eligibility validation is a separate, unimplemented integration.

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

This document defines the intended design. The original specification above includes design targets beyond the tested implementation. The implementation below records only what has been demonstrated.

### Implemented workflow (5 November 2026)

**n8n workflow:** `AutoConnect | AI Campaign Operations Assistant | TEST`  
**Execution environment:** Self-hosted n8n in Docker; Ollama on the local Windows host, accessed from n8n using `host.docker.internal`; `qwen2.5:3b` chat model.

Observed workflow path:

1. **On form submission:** collects campaign name, objective, target audience, channel and tone.
2. **AI Agent + Ollama Chat Model:** produces an unapproved campaign proposal with brief, email subject/preview/body, risks and assumptions. The draft refers to the existing `sql/audience.sql` as the audience-selection reference rather than executing model-generated SQL.
3. **Code in JavaScript:** processes the proposal for structured downstream checks.
4. **Check Proposal Validation (If):** routes proposals meeting the configured proposal checks to human review; the false branch is a non-send path.
5. **Human Review Form (next form page):** shows the proposal and collects required reviewer name, approval decision and review comments. The form explicitly warns that review does not activate or send a campaign.
6. **If:** routes the reviewer decision to separate **Edit Fields** outcomes. The approval branch records `review_status: DRAFT_APPROVED`, `human_approval: true`; the rejection branch records `review_status: DRAFT_REJECTED`, `human_approval: false`. Both preserve `audience_eligibility_verified: false`, `campaign_approved: false` and `campaign_sent: false`.

### Observed tests and evidence

- Form submission, local AI generation and proposal routing executed successfully in n8n screenshots.
- The review page rendered the generated proposal with required reviewer name, decision and comments, and a **draft-only** notice.
- **Approve Draft** test reached the approval outcome, explicitly stating approval was **for planning only**; customer eligibility remained unverified.
- **Reject Draft** test reached the rejection outcome; no campaign was activated or sent.
- The screenshots show execution success for the respective branches; they do not establish a live SQL audience verification, a Brevo campaign send, or complete coverage of every invalid-input scenario.

### Deviations from original T14–T18 acceptance criteria

| Item | Demonstrated | Remaining limitation |
|---|---|---|
| T14 | Inputs, outputs, guardrails and approval requirements documented | Specification remains aspirational in parts |
| T15 | Structured campaign request submitted to n8n form | No external CRM request source |
| T16 | Local AI produces campaign brief and email draft; references existing audience SQL | Generated text requires editorial review; no autonomous SQL execution |
| T17 | JavaScript/proposal-level validation and branch routing shown | No integrated, deterministic customer-by-customer consent, inactivity, email deduplication or suppression recheck within n8n |
| T18 | Human form and both Approve Draft / Reject Draft outcomes tested | REQUEST_REVISION path not demonstrated; approval is of draft planning only |

### Architecture and safety boundaries

The SQLite audience query (`sql/audience.sql`) is the reference for deterministic eligibility; the AI is not the source of truth. The prototype does **not** connect the n8n assistant to SQLite or Brevo for live eligibility checks, campaign activation or delivery. The earlier 35-record audience is a fixed-time synthetic SQL test result, not a freshly verified sendable audience. No MCP server or dynamic brand-context retrieval is implemented; any future MCP integration should be documented as proposed, not deployed.

**Next evidence step:** Export the n8n workflow JSON without credentials or secrets and add screenshots for form, validation, approval and rejection to the repository. A revision branch and true audience verification are follow-up enhancements, not prerequisites for documenting this limited prototype.

