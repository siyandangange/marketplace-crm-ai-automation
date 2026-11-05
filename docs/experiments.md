# AutoConnect — T23 A/B Testing and AMPscript Design

**Status:** Experiment design and illustrative code completed; **not executed**.  
**Use case:** Saved-search re-engagement for a fictional European vehicle marketplace.  
**Environment:** Conceptual Salesforce Marketing Cloud Engagement (SFMC) mapping. AutoConnect's operational prototype uses SQLite, n8n, Ollama and a separate inactive Brevo test journey.

## 1. Business question and hypothesis

**Question:** Does vehicle-specific personalisation improve engagement compared with a generic saved-search re-engagement email?

**Hypothesis:** Including the customer's saved vehicle make and model in the subject line and email body increases **unique click-through rate (unique CTR)** relative to a generic message.

The comparison deliberately tests a **personalisation package** (subject line **and** body), so any observed difference could not be attributed to the subject line alone. A subsequent test could isolate subject-line personalisation.

## 2. Experimental variants

| Component | A — Generic control | B — Vehicle-personalised treatment |
| --- | --- | --- |
| Subject | Still looking for your next car? | Still looking for a Volkswagen Golf? |
| Preview | Your saved search is waiting. | Continue exploring your saved Volkswagen Golf search. |
| Greeting | Hi Lena, | Hi Lena, |
| Body | Your saved search is waiting. Come back and explore vehicles that interest you. | Your Volkswagen Golf saved search is waiting. Come back and continue exploring. |
| CTA | View my saved search | View my saved search |

The vehicle and recipient shown are **fictional examples**. Both variants use the same CTA, layout, sender identity, and proposed send window to limit confounding. Neither version asserts that specific vehicles are currently available.

## 3. Audience and experimental assignment

1. Start from the existing deterministic SQL eligibility logic in `sql/audience.sql`: active saved search, inactivity threshold, current/latest email opt-in, valid unique email, and 14-day same-campaign suppression.
2. Recheck consent and suppression before any real send; the n8n AI assistant currently does **not** perform this integrated verification.
3. Randomly assign eligible **unique recipients** to A or B with a reproducible seed or persisted allocation. Keep each recipient in exactly one variant; do not rerandomize on every run.
4. The existing synthetic SQL result contains **35 eligible contacts** at its fixed reference timestamp. A near-even illustrative split is **18 in A / 17 in B**. This is an allocation example, **not an executed assignment**.
5. Track variant ID, campaign ID, assignment time, send status, unique clicks and downstream events using privacy-appropriate identifiers.

**Sample-size caveat:** 35 recipients are far too few to make dependable statistical claims about modest differences in engagement or enquiries. For a real experiment, perform power/sample-size planning using a measured baseline and a minimum detectable effect, or report results as exploratory only.

## 4. Metrics and evaluation

**Primary KPI:** Unique click-through rate = unique recipients who click / delivered emails × 100, calculated separately for A and B.

**Secondary KPIs:**
- Delivery rate = delivered / attempted sends × 100.
- Return-visit rate = unique recipients returning within the prespecified seven-day window / delivered × 100.
- Seller-enquiry rate = unique recipients submitting an enquiry within the same window / delivered × 100.
- Unsubscribe rate = unique recipients unsubscribing / delivered × 100; monitor as a guardrail.

Define click uniqueness, attribution, bot-click handling, reporting window, exclusions, and missing-event handling before launch. Avoid treating opens as a primary outcome because privacy-related open tracking can be unreliable.

**Analysis plan:** Compare A versus B unique CTR using absolute percentage-point difference and a confidence interval appropriate for the sample; report raw numerators and denominators. Examine return visits and seller enquiries descriptively. Do not declare a winner based on a tiny sample or an arbitrary threshold. A true incremental business impact estimate would need an appropriate no-message holdout or other causal design; this A/B comparison tests creative approaches, not sending versus not sending.

## 5. Illustrative AMPscript for Salesforce Marketing Cloud Engagement

In an SFMC sendable Data Extension, the following fields could be supplied for personalisation:

| Field | Example value | Purpose |
| --- | --- | --- |
| SubscriberKey | SYNTH-001 | Unique subscriber identifier |
| EmailAddress | lena@example.com | Fictional placeholder; never send to example.com |
| FirstName | Lena | Greeting |
| VehicleMake | Volkswagen | Saved-search make |
| VehicleModel | Golf | Saved-search model |
| Variant | B | Persisted experimental assignment |

**Important:** The code below is an **illustrative SFMC AMPscript example**, not code deployed or executed in SFMC. Field names must match the actual send context. AMPscript does not replace eligibility, unsubscribe, or suppression controls.

### Variant B — Personalised subject and body

Place this AMPscript block at the start of the email's HTML content to define safe fallback values:

```ampscript
%%[
VAR @firstName, @vehicleMake, @vehicleModel, @vehicleLabel, @subjectText
SET @firstName = Trim(AttributeValue("FirstName"))
SET @vehicleMake = Trim(AttributeValue("VehicleMake"))
SET @vehicleModel = Trim(AttributeValue("VehicleModel"))

IF Empty(@firstName) THEN
  SET @firstName = "there"
ENDIF

IF NOT Empty(@vehicleMake) AND NOT Empty(@vehicleModel) THEN
  SET @vehicleLabel = Concat(@vehicleMake, " ", @vehicleModel)
ELSEIF NOT Empty(@vehicleMake) THEN
  SET @vehicleLabel = @vehicleMake
ELSE
  SET @vehicleLabel = ""
ENDIF

IF NOT Empty(@vehicleLabel) THEN
  SET @subjectText = Concat("Still looking for a ", @vehicleLabel, "?")
ELSE
  SET @subjectText = "Still looking for your next car?"
ENDIF
]%%
```

**Subject field (illustrative AMPscript expression):**

```ampscript
%%[
VAR @make, @model
SET @make = Trim(AttributeValue("VehicleMake"))
SET @model = Trim(AttributeValue("VehicleModel"))
IF NOT Empty(@make) AND NOT Empty(@model) THEN
]%%Still looking for a %%=v(@make)=%% %%=v(@model)=%%?%%[
ELSE
]%%Still looking for your next car?%%[
ENDIF
]%%
```

**HTML body fragment:**

```html
<p>Hi %%=v(@firstName)=%%,</p>
%%[ IF NOT Empty(@vehicleLabel) THEN ]%%
<p>Your saved search for a %%=v(@vehicleLabel)=%% is waiting.
Come back and continue exploring.</p>
%%[ ELSE ]%%
<p>Your saved search is waiting. Come back and continue exploring.</p>
%%[ ENDIF ]%%
<p><a href="https://autoconnect.example/saved-searches">View my saved search</a></p>
```

The link above is a **non-operational illustrative URL**, not a live destination. For a real deployment, use an approved authenticated destination, appropriate link tracking, and a valid unsubscribe mechanism. HTML-encode untrusted personalisation values as appropriate for the rendering context.

### Variant A — Generic control

**Subject:** `Still looking for your next car?`

**Body:**

```html
<p>Hi %%=v(@firstName)=%%,</p>
<p>Your saved search is waiting. Come back and explore vehicles that interest you.</p>
<p><a href="https://autoconnect.example/saved-searches">View my saved search</a></p>
```

The shared greeting variable must be initialised in the message's content before use. The same fallback greeting logic can be applied in both variants.

## 6. SFMC architecture mapping (conceptual only)

- **Contact Builder / Data Extensions:** Store customer attributes, consent references, audience snapshot and experimental variant assignment.
- **Automation Studio / SQL Query Activity:** Build a sendable eligible-audience Data Extension using reviewed SQL adapted to SFMC's SQL dialect and data model. The existing SQLite SQL cannot be assumed to run unchanged in SFMC.
- **Content Builder / AMPscript:** Create generic and vehicle-personalised email variants with safe fallbacks.
- **Journey Builder or an appropriate SFMC testing capability:** Orchestrate the controlled send and variant selection, depending on available product features and configuration.
- **Tracking/reporting:** Join delivery, unique click, return-visit and seller-enquiry data through governed identifiers and defined attribution windows.

These are **platform mappings**, not evidence of an implemented Salesforce Marketing Cloud journey.

## 7. Acceptance evidence and limitations

**Completed for T23:** Test hypothesis, A/B creative variants, allocation design, KPI definitions, interpretation guardrails, and illustrative AMPscript with missing-field fallbacks.

**Not completed:** Actual SFMC configuration, sendable Data Extension, randomized assignment execution, real email send, tracking extraction, observed experiment results, statistical inference or validated AMPscript rendering in an SFMC account.

**Portfolio-ready summary:** “Designed a Salesforce Marketing Cloud-aligned A/B experiment for a saved-search re-engagement journey, including audience allocation, click-through and downstream conversion measurement, and illustrative AMPscript personalisation with fallback handling.”
