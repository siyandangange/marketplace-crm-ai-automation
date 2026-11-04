Proposed T14 specification

Agent name: AutoConnect AI Campaign Operations Assistant

Objective: Reduce manual CRM campaign preparation by generating draft campaign materials and coordinating validation and human approval.

Inputs
- Campaign name and objective
- Target audience description
- Approved eligibility rules
- Validated audience summary from SQL
- Communication channel and tone
AI-generated outputs
- Campaign brief
- Suggested SQL segmentation logic, clearly marked unapproved
- Email subject, preview text and body
- Assumptions and potential issues
Guardrails
- AI cannot approve customer eligibility.
- AI cannot override consent or suppression rules.
- AI-generated SQL cannot execute automatically.
- Invalid or unconsented cases must be blocked by deterministic checks.
- No automatic campaign sending.
- Only synthetic data and approved test addresses may be used.
Approval rules

Validated drafts proceed to human review. The CRM manager can approve, reject or request revision. Approval produces an approved campaign package, not permission for n8n to activate Brevo automatically.
