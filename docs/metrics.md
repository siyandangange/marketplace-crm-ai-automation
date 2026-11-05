# AutoConnect — Campaign Measurement and KPI Model (T20)

**Status:** Completed KPI design and simulated example; **no live campaign was sent**.  
**Scenario:** Saved-search re-engagement email for a fictional vehicle marketplace.  
**Data classification:** Synthetic audience and entirely hypothetical performance counts.

## 1. Objective and measurement approach

Evaluate whether a saved-search re-engagement campaign encourages eligible, previously inactive customers to return to the marketplace and make a seller enquiry. The SQL-selected audience of **35** is based on the existing synthetic audience-selection exercise. All delivery, click, return-visit, and enquiry numbers below are **illustrative assumptions**, not events observed in Brevo, n8n, Salesforce Marketing Cloud, or a live marketplace.

The campaign would require consent and suppression checks before any real send. The AI campaign assistant drafts proposals for human review; it does not execute audience eligibility checks or activate campaigns.

## 2. Simulated campaign funnel

| Funnel stage | Illustrative count | Definition |
| --- | ---: | --- |
| Eligible contacts | 35 | Contacts selected by the synthetic audience SQL |
| Emails delivered | 33 | Hypothetical messages accepted for delivery |
| Unique clickers | 8 | Hypothetical distinct recipients who clicked |
| Return visitors | 5 | Hypothetical distinct recipients who returned to the marketplace |
| Seller enquiries | 2 | Hypothetical distinct recipients who submitted an enquiry |

**Illustrative assumptions:** 35 send attempts to the 35 eligible contacts; 33 delivered and 2 not delivered. Clickers, visitors and enquirers are treated as distinct people within each metric. The numbers do **not** establish individual-level attribution or that every return visitor clicked the email.

## 3. KPI definitions and formulas

| KPI | Formula | Simulated result | Interpretation |
| --- | --- | ---: | --- |
| Audience eligibility rate | Eligible contacts / all synthetic contacts × 100 | 35 / 80 = **43.8%** | Share selected by the audience query; not a campaign performance rate |
| Delivery rate | Delivered / attempted sends × 100 | 33 / 35 = **94.3%** | Illustrative email delivery performance |
| Unique click-through rate (unique CTR) | Unique clickers / delivered × 100 | 8 / 33 = **24.2%** | Illustrative recipient engagement with the email |
| Return-visit rate (delivered basis) | Unique return visitors / delivered × 100 | 5 / 33 = **15.2%** | Illustrative return to the marketplace |
| Seller-enquiry rate (delivered basis) | Unique enquirers / delivered × 100 | 2 / 33 = **6.1%** | Illustrative downstream conversion |
| Click-to-enquiry ratio | Unique enquirers / unique clickers × 100 | 2 / 8 = **25.0%** | Descriptive funnel ratio only; requires user-level linkage before interpreting as conversion |

Rates are rounded to one decimal place. The click-to-enquiry ratio is not a verified click-to-conversion rate without event-level attribution.

## 4. Hypothetical baseline versus proposed scenario

To illustrate how a campaign manager could discuss improvement, assume a **comparison period with the same 35 eligible contacts**. This baseline is **invented for planning**, not measured historical performance.

| KPI (denominator: 35 eligible contacts) | Hypothetical baseline | Proposed simulated scenario | Difference |
| --- | ---: | ---: | ---: |
| Unique return visitors | 3 | 5 | +2 visitors |
| Return-visit rate | 8.6% (3/35) | 14.3% (5/35) | +5.7 percentage points |
| Unique seller enquirers | 1 | 2 | +1 enquirer |
| Seller-enquiry rate | 2.9% (1/35) | 5.7% (2/35) | +2.9 percentage points |

**Important:** These are not observed uplifts, causal effects, forecasts, or A/B-test findings. A valid evaluation would require actual pre-campaign measurements or a randomized holdout, comparable time windows, consistent definitions, and enough observations for meaningful inference. The 35-contact sample is too small to support reliable claims of incremental impact.

## 5. Implementation plan for a real measurement pipeline

1. **Audience snapshot:** Record the eligibility-query version, snapshot time, contact identifiers, consent status, and suppression checks in a secure system. Do not publish personal data.
2. **Campaign tracking:** Record attempted sends, delivery/bounce events, unique clicks, campaign ID, and timestamps from the sending platform.
3. **Marketplace tracking:** Record authenticated or consent-compliant return sessions and seller-enquiry events with appropriate campaign attribution.
4. **Attribution window:** Define a window (for example, seven days after send) *before* measurement; deduplicate events by recipient and event type.
5. **Reporting:** Calculate rates with explicit denominators, compare against a measured baseline or randomized holdout, and flag missing data.
6. **Governance:** Apply consent, unsubscribe, retention, access-control, and data-minimization requirements before operational use.

## 6. Limitations and honest portfolio claims

- **No live campaign send:** The Brevo activity was an editor test using a user-controlled address; the journey is inactive.
- **No observed campaign performance:** The 33 deliveries, 8 clickers, 5 visitors, and 2 enquiries are simulated, not sourced from platform logs.
- **No end-to-end attribution:** SQLite, n8n, Brevo, and marketplace event tracking are not connected into a production measurement pipeline.
- **No verified incremental lift:** Baseline and proposed figures are hypothetical, with no experimental control group.
- **Audience safeguards:** The SQL audience query and separate SQL tests demonstrate eligibility-rule design. The AI assistant itself does not independently execute the audience query or verify eligibility.
- **Marketing Cloud relevance:** In Salesforce Marketing Cloud Engagement, a SQL Query Activity could populate an eligible-audience Data Extension, and tracking extracts or reporting could support email KPIs. This project does **not** claim an SFMC deployment.

**Portfolio-ready description:** “Designed a campaign measurement framework for a synthetic 35-contact re-engagement audience, defining delivery, engagement, return-visit and seller-enquiry KPIs, with a clearly simulated funnel and hypothetical baseline comparison.”
