# Telco Customer Churn: Insights and Recommendations

**Dataset:** IBM Telco Customer Churn (7,043 customers)
**Analysis period:** Cross-sectional snapshot (no time series)
**Overall churn rate:** 26.5% (1,869 of 7,043 customers)

**Important limitation:** All findings below describe statistical associations in a
single cross-sectional dataset. They do not establish causation, and they do not
explain why any individual customer left. Segment churn rates reflect historical
patterns in this dataset; they are not predictions of future behaviour.

---

## Verified business insights

### Insight 01 — Contract type is the strongest single differentiator
Month-to-month customers churn at 42.7%, compared to 11.3% for one-year and 2.8%
for two-year contracts. The 15-to-1 ratio between month-to-month and two-year churn
rates is the most striking finding in the data. Month-to-month is also the largest
contract group (3,875 customers, 55% of the base), so it drives the most absolute
churn volume.

**Evidence:** SQL Query 05; Notebook 02 Section 2.

### Insight 02 — New customers churn at nearly twice the base rate
Customers in their first 12 months churn at 47.4%, almost double the overall 26.5%.
By contrast, customers past 36 months churn at under 12%. The first year is the
critical retention window.

**Evidence:** SQL Query 12; Notebook 02 Section 3.

### Insight 03 — Fiber Optic customers churn at 41.9% despite paying the most
Fiber Optic customers have the highest average monthly charges (~$91) but churn
at 41.9% — more than double the DSL rate of 19.0%. Customers with no internet
service churn at only 7.4%. This is a significant gap. It could reflect unmet
expectations at the premium tier, competitive pressure, or pricing sensitivity —
but the data alone cannot distinguish between these explanations.

**Evidence:** SQL Query 06; Notebook 02 Section 5.

### Insight 04 — Electronic check is associated with the highest churn rate among payment methods
Electronic check users churn at 45.3%, versus an average of 16.0% for the two
automatic payment methods (bank transfer and credit card automatic). The electronic
check group is also the largest (2,365 customers). Customers on automatic payments
have demonstrated a higher level of commitment to the payment relationship.

**Evidence:** SQL Query 07; Notebook 02 Section 4.

### Insight 05 — The highest-risk combination churns at 54.6%
Month-to-month contract + Fiber Optic internet service is the single highest-churn
combination: 2,128 customers, 54.6% churn rate. This combination alone contains
28% of all churners (1,160 of 1,869) despite being only 30% of the base.

**Evidence:** SQL Query 21; Notebook 02 Section 10.

### Insight 06 — The rule-based high-risk segment (MTM + new + high-spend) churns at 67.7%
Customers who are simultaneously on a month-to-month contract, within their first
12 months, and paying $65 or more per month churn at 67.7% — 2.6 times the base
rate. There are 976 such customers representing $79,388/month in revenue.

**Evidence:** SQL Query 26; Notebook 04 Section 4.

### Insight 07 — Churned customers pay more per month but stay far less time
Average ARPU for churned customers: $74.44/month. Average ARPU for retained: $61.27.
Churned customers pay $13.17 more per month on average, yet leave after 18 months
on average versus 37.6 months for retained customers. This means their total billed
value is lower despite paying more per month — a double loss.

**Evidence:** SQL Query 03/04; Notebook 03 Section 3/4.

### Insight 08 — Senior citizens churn at 41.7% vs 23.6% for non-seniors
Senior citizens (16% of the base, 1,142 customers) have a churn rate 1.8x the
non-senior rate. They are more likely to use electronic check payment and less
likely to adopt add-ons — both factors also associated with higher churn. The
interaction effects cannot be separated from the data alone.

**Evidence:** SQL Query 08; Notebook 02 Section 6.

### Insight 09 — Customers with zero add-ons on month-to-month contracts churn at 38.4%
Among month-to-month customers with no internet add-ons, the churn rate is 38.4%.
Retained customers average 1.83 add-ons vs 1.27 for churned customers — a 44%
difference. Add-on adoption is associated with lower churn, possibly because
customers who invest in multiple services have higher switching costs.

**Evidence:** SQL Query 19/27; Notebook 03 Sections 5/6.

### Insight 10 — $139,131/month in recurring revenue left with churned customers
The 1,869 churned customers were generating $139,131 per month in revenue —
30.5% of the total base's $456,117 monthly revenue. Even partially recovering
this through improved retention would have material financial impact. This figure
is a floor: it excludes the revenue those customers would have generated in future
months had they stayed.

**Evidence:** SQL Query 02; Notebook 03 Section 2.

---

## Recommendations

### Recommendation 01 — Priority: Improve early-tenure contract conversion
**Finding it addresses:** Insights 01, 02, 06.
Customers in their first 12 months on month-to-month contracts are the highest-risk
group. Offering a meaningful incentive to convert to a 12-month contract — a price
lock, a service bundle at current rate, or a loyalty bonus at the 6-month mark —
could reduce churn in the most vulnerable window. Any intervention should be
evaluated against control groups to test whether it actually reduces churn or
merely reaches customers who would have stayed anyway.

### Recommendation 02 — Priority: Investigate the Fiber Optic churn gap
**Finding it addresses:** Insights 03, 05.
Fiber Optic customers pay the most and churn the most. This warrants investigation
beyond what this dataset can answer: Are Fiber customers leaving because of
service quality issues? Competitive price pressure? Billing shock after a
promotional period ends? Conduct exit surveys or combine this data with service
quality metrics before designing a response. The goal is to understand *why*
before spending on retention.

### Recommendation 03 — Promote automatic payment enrollment
**Finding it addresses:** Insight 04.
Electronic check users churn at 45.3% vs 16.0% for automatic payment customers.
Making it easy and incentivised to switch to bank transfer or credit card automatic
payments could reduce churn — and also reduces payment friction and failed-payment
risk. Even a small discount for autopay enrollment could be cost-effective if it
shifts customers from the 45% churn tier to the 16% tier.
Caveat: The association may be partly driven by selection (customers who set up
autopay may already be more committed); a randomised test would clarify.

### Recommendation 04 — Design add-on adoption programs for new customers
**Finding it addresses:** Insight 09.
Retained customers adopt significantly more add-ons than churned ones. Targeted
promotions for OnlineSecurity, TechSupport, and OnlineBackup during onboarding
(months 1–6) could increase product embeddedness. Free trials or bundle discounts
are common mechanisms. Track whether add-on uptake actually reduces subsequent
churn in a test cohort before broad rollout.

### Recommendation 05 — Tailor support and billing for senior customers
**Finding it addresses:** Insight 08.
Senior citizens churn at 41.7% and are over-represented in electronic check
payments. Specific actions: (1) offer dedicated phone-based billing support,
(2) simplify the payment method switch process, (3) consider whether digital-first
communications are appropriate for this segment. The effectiveness of any change
requires measurement — do not assume reduced friction automatically reduces churn.

---

## What this analysis cannot answer

- **Why** customers left — the dataset has no exit survey or reason codes.
- **Whether** interventions would work — no A/B test data exists.
- **Future churn** — this is a snapshot, not a longitudinal panel; churn rates
  may change as the market evolves.
- **Individual prediction** — segment-level rates do not reliably predict whether
  a specific customer will churn.
- **Interaction effects** — the multi-way combinations show high churn rates, but
  without a controlled model it is not possible to isolate the independent
  contribution of each factor.
