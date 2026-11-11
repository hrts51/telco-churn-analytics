# Telecom Customer Churn Analytics — Complete Project Documentation

**Author:** Ankit Kumar
**Dataset:** IBM Telco Customer Churn (Kaggle)
**Tools:** Python 3.14 · pandas · Matplotlib · Seaborn · SQLite · Power BI Desktop · Git
**Repository:** https://github.com/hrts51/telco-churn-analytics

---

## Table of Contents

1. [Project Objective](#1-project-objective)
2. [Dataset Description](#2-dataset-description)
3. [Project Structure](#3-project-structure)
4. [Environment Setup](#4-environment-setup)
5. [Data Cleaning](#5-data-cleaning)
6. [Exploratory Data Analysis](#6-exploratory-data-analysis)
7. [Financial and Behavior Analysis](#7-financial-and-behavior-analysis)
8. [Segmentation and Risk Analysis](#8-segmentation-and-risk-analysis)
9. [SQL Analysis](#9-sql-analysis)
10. [Power BI Dashboard](#10-power-bi-dashboard)
11. [Key Findings](#11-key-findings)
12. [Business Insights](#12-business-insights)
13. [Recommendations](#13-recommendations)
14. [Limitations](#14-limitations)
15. [What Makes This Project Unique](#15-what-makes-this-project-unique)
16. [Reproduction Steps](#16-reproduction-steps)
17. [Metric Definitions](#17-metric-definitions)
18. [Git History](#18-git-history)

---

## 1. Project Objective

Customer churn — when a subscriber cancels their telecom service — is a primary
revenue risk. Acquiring a new customer typically costs significantly more than
retaining an existing one, so understanding which customer and service attributes
are associated with churn helps prioritise retention investment.

**Primary objective:**
Analyse patterns in the IBM Telco Customer Churn dataset to identify which customer,
service, and subscription attributes are most strongly associated with churn; quantify
the monthly revenue exposure; and develop evidence-based retention recommendations.

**Scope and constraints:**
- Descriptive and associative analysis only
- Does not establish causation
- Does not explain why any individual customer left
- Does not constitute a predictive model
- All findings are specific to this dataset

---

## 2. Dataset Description

**Source:** IBM Telco Customer Churn dataset
**URL:** https://www.kaggle.com/datasets/blastchar/telco-customer-churn
**Raw file:** `data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv`
**Clean file:** `data/clean/telco_clean.csv`

**Size:**
- 7,043 customers (rows)
- 21 original columns
- 25 columns after cleaning (4 derived columns added)
- 1,869 churned customers (Yes)
- 5,174 retained customers (No)
- Overall churn rate: 26.5%

### Original columns

| Column | Type | Description |
|--------|------|-------------|
| customerID | Text | Unique customer identifier |
| gender | Text | Male / Female |
| SeniorCitizen | Integer | 0 = Not senior, 1 = Senior |
| Partner | Text | Has a partner: Yes / No |
| Dependents | Text | Has dependents: Yes / No |
| tenure | Integer | Months as a customer (0–72) |
| PhoneService | Text | Has phone service: Yes / No |
| MultipleLines | Text | Yes / No / No phone service |
| InternetService | Text | DSL / Fiber optic / No |
| OnlineSecurity | Text | Yes / No / No internet service |
| OnlineBackup | Text | Yes / No / No internet service |
| DeviceProtection | Text | Yes / No / No internet service |
| TechSupport | Text | Yes / No / No internet service |
| StreamingTV | Text | Yes / No / No internet service |
| StreamingMovies | Text | Yes / No / No internet service |
| Contract | Text | Month-to-month / One year / Two year |
| PaperlessBilling | Text | Yes / No |
| PaymentMethod | Text | Electronic check / Mailed check / Bank transfer (automatic) / Credit card (automatic) |
| MonthlyCharges | Float | Current monthly bill in USD |
| TotalCharges | Text (raw) / Float (clean) | Cumulative billed amount in USD |
| Churn | Text | Yes = churned / No = retained |

### Derived columns added during cleaning

| Column | Type | Formula | Purpose |
|--------|------|---------|---------|
| SeniorCitizenLabel | Text | Map 0→"No", 1→"Yes" | Readable display label |
| ChurnFlag | Integer | 1 if Churn="Yes" else 0 | Numeric flag for arithmetic |
| CLV_Proxy | Float | MonthlyCharges × tenure | Approximate historical revenue |
| AddonCount | Integer | Count of 6 add-on columns = "Yes" | Product embeddedness measure |

---

## 3. Project Structure

```
telco-churn-analytics/
│
├── data/
│   ├── raw/
│   │   └── WA_Fn-UseC_-Telco-Customer-Churn.csv   ← Git-ignored; download from Kaggle
│   └── clean/
│       └── telco_clean.csv                          ← 7,043 rows, 25 columns, 0 nulls
│
├── notebooks/
│   ├── 01_data_understanding.ipynb                  ← load, inspect, clean, save
│   ├── 02_eda.ipynb                                 ← exploratory analysis, 8 charts
│   ├── 03_behavior_financial_analysis.ipynb         ← ARPU, CLV proxy, revenue, add-ons
│   └── 04_segmentation_risk.ipynb                   ← segments, high-risk profile
│
├── sql/
│   ├── churn_analysis.sql                           ← 30 verified SQLite queries
│   ├── load_db.py                                   ← builds telco_churn.db from CSV
│   └── telco_churn.db                               ← auto-generated; rebuild anytime
│
├── powerbi/
│   ├── telco_churn_dashboard.pbix                   ← Power BI dashboard (4 pages)
│   ├── dashboard_handover.md                        ← full dashboard documentation
│   ├── dashboard_plan.md                            ← original design specification
│   └── dax_measures.md                              ← all DAX formulas
│
├── report/
│   ├── project_documentation.md                     ← this document
│   ├── final_report.md                              ← written analysis report
│   └── insights_and_recommendations.md              ← 10 insights + 5 recommendations
│
├── images/                                          ← 16 PNG charts from notebooks
│   ├── 02_01_churn_by_contract.png
│   ├── 02_02_churn_by_tenure.png
│   ├── 02_03_churn_by_payment.png
│   ├── 02_04_churn_by_internet.png
│   ├── 02_05_churn_binary_features.png
│   ├── 02_06_monthly_charges_vs_churn.png
│   ├── 02_07_correlation_heatmap.png
│   ├── 02_08_churn_heatmap_contract_internet.png
│   ├── 03_01_arpu_analysis.png
│   ├── 03_02_clv_proxy.png
│   ├── 03_03_addon_count_vs_churn.png
│   ├── 03_04_addon_adoption_comparison.png
│   ├── 03_05_revenue_exposure_by_contract.png
│   ├── 04_01_segment_risk_map.png
│   ├── 04_02_high_risk_profile.png
│   └── 04_03_top_churn_combinations.png
│
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 4. Environment Setup

**Requirements:**
- Python 3.14+
- Git 2.50+
- Power BI Desktop (for the dashboard)

**Setup steps:**

```powershell
# Clone the repository
git clone https://github.com/hrts51/telco-churn-analytics.git
cd telco-churn-analytics

# Create virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# Install all dependencies
python -m pip install -r requirements.txt
```

**Key packages installed:**

| Package | Version | Purpose |
|---------|---------|---------|
| pandas | 3.1.1 | Data manipulation |
| numpy | 2.5.4 | Numerical operations |
| matplotlib | 3.11.2 | Visualisation |
| seaborn | 0.13.2 | Statistical charts |
| jupyter | 1.1.1 | Notebook environment |
| ipykernel | 7.4.0 | Jupyter kernel |

---

## 5. Data Cleaning

**Notebook:** `notebooks/01_data_understanding.ipynb`

The raw data was loaded into `df`. All cleaning was applied to a separate copy `df_clean`
so the original was always preserved for comparison.

### What was inspected first

```
Raw shape:   7,043 rows × 21 columns
Duplicate customerIDs: 0
Churned: 1,869  |  Retained: 5,174  |  Churn rate: 26.5%
TotalCharges blank values: 11
```

### Cleaning decision 1 — TotalCharges conversion

**Problem:** `TotalCharges` was stored as a text column in the raw CSV. 11 rows
contained blank or whitespace values instead of a number.

**Investigation:** Every one of the 11 blank rows had `tenure = 0`, meaning these
customers had just signed up and had not yet been billed for a full month.

**Decision:** Convert `TotalCharges` to float. Fill the 11 confirmed zero-tenure
blanks with `0.0`. Do not drop any rows — these are valid, real customers.

**Validation code run:**
```python
assert unexpected_invalid.sum() == 0      # no surprise non-numeric values
assert df_clean.loc[blank_charges, "tenure"].eq(0).all()  # all blanks are tenure=0
```

**Result:** 0 missing values in `TotalCharges` after cleaning.

### Cleaning decision 2 — SeniorCitizenLabel

**Problem:** `SeniorCitizen` uses 0/1 encoding, which is not readable in charts.

**Decision:** Add `SeniorCitizenLabel` (No/Yes) alongside the original numeric
column. Keep the original for arithmetic; use the label for display.

### Cleaning decision 3 — Preserve original service labels

**Decision:** "No internet service" and "No phone service" labels were kept as-is.
These values carry analytical meaning — a customer who has no internet service
is fundamentally different from one who has internet but chose not to add security.
Replacing these with blanks or a generic "No" would lose that distinction.

### Cleaning decision 4 — No rows dropped

All 7,043 customers were retained. No rows were removed for any reason.

### Clean file output

```
Saved: data/clean/telco_clean.csv
Shape: 7,043 rows × 25 columns
Missing TotalCharges: 0
Unique customerIDs: 7,043 (verified)
```

---

## 6. Exploratory Data Analysis

**Notebook:** `notebooks/02_eda.ipynb`
**Charts produced:** 8 (saved to `images/02_*.png`)

The EDA notebook uses a parent-directory search to locate the clean CSV regardless
of where the Jupyter kernel starts:

```python
project_root = next(
    folder
    for folder in [Path.cwd(), *Path.cwd().parents]
    if (folder / "data" / "clean" / "telco_clean.csv").exists()
)
```

A `ChurnFlag` column (1=churned, 0=retained) is added at load time for arithmetic.

### Sections covered

**Section 2 — Churn by contract type**
Group counts, churned counts, and churn rate per contract.
Chart: dual view — rate bar + stacked volume bar.

**Section 3 — Churn by tenure**
Annual tenure buckets (0–12, 13–24, 25–36, 37–48, 49–60, 61–72 months).
Chart: rate by bucket + overlapping histogram by churn label.

**Section 4 — Churn by payment method**
Four payment methods compared.
Chart: horizontal bar with count annotations.

**Section 5 — Churn by internet service**
Three service types compared alongside average monthly charges.
Chart: dual bar — churn rate + average charges.

**Section 6 — Churn by senior citizen status**
Senior vs non-senior rate and share of base.

**Section 7 — Churn by binary features**
Partner, Dependents, PaperlessBilling, PhoneService.
Chart: 4-panel grid with overall average reference line.

**Section 8 — MonthlyCharges distribution**
Split by churn label.
Chart: overlapping histogram + box plot.

**Section 9 — Correlation matrix**
Pearson correlation for tenure, MonthlyCharges, TotalCharges, ChurnFlag.
Explicit note: TotalCharges is mechanically correlated; ChurnFlag correlation
is point-biserial.

**Section 10 — Cross-tab heatmap**
Contract × InternetService — churn rate with cell counts annotated.

**Section 11 — EDA findings summary**
Computed and printed in-notebook for quick reference.

---

## 7. Financial and Behavior Analysis

**Notebook:** `notebooks/03_behavior_financial_analysis.ipynb`
**Charts produced:** 5 (saved to `images/03_*.png`)

### Key metric definitions used

| Metric | Definition |
|--------|-----------|
| ARPU | AVG(MonthlyCharges) for a segment |
| Revenue exposure | SUM(MonthlyCharges) for churned customers |
| Historical Billed Value | TotalCharges as recorded in the dataset |
| CLV Proxy | MonthlyCharges × tenure — approximation only, not a prediction |

### Sections covered

**Section 2 — Revenue exposure**
Total monthly revenue, monthly revenue from churned customers, percentage share.

**Section 3 — ARPU analysis**
Mean, median, std for MonthlyCharges by churn label.
ARPU by contract type × churn.

**Section 4 — Historical billed value (CLV proxy)**
TotalCharges and CLV_Proxy compared by churn label.
Key finding: churned customers paid more per month but left earlier.

**Section 5 — Service add-on adoption**
AddonCount computed (Yes=1 across 6 services).
Churn rate by number of add-ons.

**Section 6 — Individual add-on adoption rates**
Per-service adoption rate for churned vs retained.

**Section 7 — Revenue exposure by contract**
Monthly revenue lost broken down by contract type.

**Section 8 — Financial summary**
Printed summary of all financial metrics.

---

## 8. Segmentation and Risk Analysis

**Notebook:** `notebooks/04_segmentation_risk.ipynb`
**Charts produced:** 3 (saved to `images/04_*.png`)

### Tenure segments (3-level)

| Segment | Range | Rationale |
|---------|-------|-----------|
| New | 0–12 months | Trial phase; highest churn risk |
| Growing | 13–36 months | Past first year; still forming habits |
| Loyal | 37–72 months | Established relationship |

### Charge segments (3-level)

| Segment | Range | Typical customer |
|---------|-------|-----------------|
| Low | $0–$35 | Phone-only or no-internet plans |
| Mid | $35–$65 | Bundled plans |
| High | $65–$120 | Fiber Optic with add-ons |

### High-risk segment definition

**Rule:**
```
HighRisk = 1  when:
  Contract = "Month-to-month"   (Python/SQL version)
  AND tenure <= 12 months
  AND MonthlyCharges >= $65
```

**Power BI version (broadened by design):**
```
HighRisk = 1  when:
  tenure <= 12 months
  AND MonthlyCharges >= $65
  (Contract condition removed — applies across all contract types)
```

**Why two definitions?**
The Python/SQL version was the original analytical definition used in notebooks.
During Power BI development, the definition was deliberately broadened to allow
comparison of high-risk customers across all contract types. Both are documented
and consistent within their respective layers.

### Python/SQL high-risk segment results

| Metric | Value |
|--------|-------|
| Customers in segment | 976 (13.9% of base) |
| Churn rate | 67.7% |
| Relative risk vs base | 2.6× |
| Monthly revenue in segment | $79,388 |

### Power BI high-risk segment results (broadened definition)

| Metric | Value |
|--------|-------|
| Customers in segment | 1,001 |
| Churn rate | 66.4% |
| Monthly revenue in segment | ~$81K |

### Top combinations by churn rate (min 50 customers)

The 3-way cross-tab (Contract × InternetService × PaymentMethod) with a minimum
cell size of 50 customers identified the highest-risk combinations. The top result
is Month-to-month + Fiber Optic + Electronic check at the highest churn rate.

---

## 9. SQL Analysis

**File:** `sql/churn_analysis.sql`
**Database:** `sql/telco_churn.db` (SQLite)
**Loader:** `sql/load_db.py`
**Total queries:** 30 (all verified)

### Building the database

```powershell
python sql/load_db.py
```

This reads `data/clean/telco_clean.csv`, adds ChurnFlag, CLV_Proxy, and AddonCount
columns, and loads everything into the `customers` table in `sql/telco_churn.db`.

### Query groups

| Group | Queries | Coverage |
|-------|---------|----------|
| A — Overall baseline | Q01–Q04 | Total customers, revenue, ARPU, tenure |
| B — Categorical segments | Q05–Q11 | Contract, internet, payment, senior, gender, billing, partner |
| C — Tenure and charge buckets | Q12–Q14 | CTE-based annual buckets, CASE charge tiers, strategic segments |
| D — Revenue and financial | Q15–Q18 | Revenue by contract/internet, CLV proxy, total billed value |
| E — Add-on adoption | Q19–Q20 | Churn by add-on count, per-service adoption rates |
| F — High-risk and window functions | Q21–Q25 | Cross-tabs, top combinations, RANK, running totals, % of total churn |
| G — Additional analysis | Q26–Q30 | High-risk segment, MTM no add-ons, e-check+MTM, new customers, reconciliation |

### Reconciliation query (Q30)

Every analysis was verified against this baseline:

```sql
SELECT
    COUNT(*)                                              AS total_customers,
    SUM(ChurnFlag)                                        AS total_churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1)      AS churn_rate_pct,
    ROUND(SUM(MonthlyCharges), 2)                         AS total_monthly_revenue,
    ROUND(AVG(tenure), 2)                                 AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2)                         AS avg_monthly_charges,
    ROUND(SUM(TotalCharges), 2)                           AS total_billed_all_time
FROM customers;
```

**Expected output:** total_customers=7043, total_churned=1869, churn_rate_pct=26.5

All 30 queries execute without errors and all headline numbers match Python outputs.

---

## 10. Power BI Dashboard

**File:** `powerbi/telco_churn_dashboard.pbix`
**Data source:** `data/clean/telco_clean.csv`
**Pages:** 4
**DAX measures:** 15+
**Calculated columns:** 6

### Calculated columns (DAX)

```dax
ChurnFlag =
IF('telco_clean'[Churn] = "Yes", 1, 0)

CLV_Proxy =
'telco_clean'[MonthlyCharges] * 'telco_clean'[tenure]

AddonCount =
(IF([OnlineSecurity]="Yes",1,0) + IF([OnlineBackup]="Yes",1,0) +
 IF([DeviceProtection]="Yes",1,0) + IF([TechSupport]="Yes",1,0) +
 IF([StreamingTV]="Yes",1,0) + IF([StreamingMovies]="Yes",1,0))

TenureSegment =
IF('telco_clean'[tenure] <= 12, "New",
   IF('telco_clean'[tenure] <= 36, "Growing", "Loyal"))

ChargeSegment =
IF('telco_clean'[MonthlyCharges] <= 35, "Low",
   IF('telco_clean'[MonthlyCharges] <= 65, "Mid", "High"))

HighRisk =
IF('telco_clean'[tenure] <= 12 && 'telco_clean'[MonthlyCharges] >= 65, 1, 0)
```

### Core DAX measures

```dax
Total Customers = DISTINCTCOUNT('telco_clean'[customerID])

Churned Customers =
CALCULATE([Total Customers], 'telco_clean'[ChurnFlag] = 1)

Churn Rate = DIVIDE([Churned Customers], [Total Customers], 0)

Total Monthly Revenue = SUM('telco_clean'[MonthlyCharges])

Monthly Revenue Lost =
CALCULATE(SUM('telco_clean'[MonthlyCharges]), 'telco_clean'[ChurnFlag] = 1)

Churned Customer ARPU = DIVIDE([Monthly Revenue Lost], [Churned Customers], 0)

Retained Customer ARPU =
DIVIDE(
    CALCULATE(SUM('telco_clean'[MonthlyCharges]), 'telco_clean'[ChurnFlag] = 0),
    [Total Customers] - [Churned Customers],
    0
)

High-Risk Segment Customers =
CALCULATE([Total Customers], 'telco_clean'[HighRisk] = 1)

High-Risk Churn Rate =
DIVIDE(
    CALCULATE([Churned Customers], 'telco_clean'[HighRisk] = 1),
    [High-Risk Segment Customers],
    0
)

Monthly Revenue in High-Risk Segment =
CALCULATE(SUM('telco_clean'[MonthlyCharges]), 'telco_clean'[HighRisk] = 1)
```

### Page 1 — Executive Summary

**KPI cards:** Total Customers (7,043) · Churned Customers (1,869) · Churn Rate (26.5%) ·
Monthly Revenue Lost (~$139K) · High-Risk Customers (1,001) · High-Risk Churn Rate (66.4%)

**Charts:**
- Churn Rate by Contract Type
- Churn Rate by Customer Tenure
- Churn Rate by Internet Service
- Churn Rate by Payment Method
- Customer Retention vs Churn (donut)

**Slicers:** Contract · InternetService

**Text:** Key Business Insight · Data Limitations · Data Source

---

### Page 2 — Churn Drivers Analysis

**13 charts:**
1. Churn Rate by Gender
2. Churn Rate by Senior Citizen Status
3. Churn Rate by Paperless Billing
4. Churn Rate by Device Protection
5. Churn Rate by Customer Tenure
6. Churn Rate by Partner Status
7. Churn Rate by Online Security
8. Churn Rate by Online Backup
9. Churn Rate by Payment Method
10. Churn Rate by Dependents
11. Churn Rate by Tech Support
12. Churn Rate by Multiple Lines
13. Churn Rate by Contract Type

**Slicers:** Contract · InternetService · Gender

---

### Page 3 — Customer Risk & Revenue Analysis

**KPI cards:** High-Risk Customers (1,001) · High-Risk Churn Rate (66.4%) ·
Monthly Revenue at Risk (~$81K) · Total Monthly Revenue Lost (~$139K)

**Charts:**
- High-Risk Customers by Contract
- High-Risk Customer Share by Contract
- High-Risk Revenue Exposure by Contract
- Actual Churn Rate by Contract
- Churn Rate by Contract & Internet Service (clustered bar)

**Customer-level table (filtered to HighRisk = 1):**
customerID · Contract · InternetService · PaymentMethod · tenure · MonthlyCharges · Churn · HighRisk

**Slicers:** TenureSegment · ChargeSegment

**Text:** High-Risk definition explanation

---

### Page 4 — Financial & Subscription Analysis

**KPI cards:** Total Monthly Revenue (~$456K) · Monthly Revenue Lost (~$139K) ·
Churned Customer ARPU ($74.44) · Retained Customer ARPU ($61.27)

**Charts:**
1. Monthly Revenue Lost by Contract
2. Monthly Revenue Lost by Internet Service
3. Monthly Revenue by Payment Method
4. Average Monthly Charges by Churn Status
5. Average Monthly Charges by Contract
6. Average Add-on Services by Churn Status
7. Add-on Service Adoption Rate — Churned vs Retained (all 6 services)

**Slicers:** Contract · InternetService

**Text:** Key Business Insights · Data Limitation

---

## 11. Key Findings

All churn rates are segment-level: churned ÷ total customers in that segment.

### Contract type

| Contract | Customers | Churned | Churn Rate |
|----------|-----------|---------|------------|
| Month-to-month | 3,875 | 1,655 | 42.7% |
| One year | 1,473 | 166 | 11.3% |
| Two year | 1,695 | 48 | 2.8% |

Month-to-month churn is 15× the two-year rate.

### Tenure

| Bucket | Customers | Churn Rate |
|--------|-----------|------------|
| 0–12 months | 2,186 | 47.4% |
| 13–24 months | 1,024 | 28.7% |
| 25–36 months | 832 | 21.6% |
| 37–48 months | 676 | 14.9% |
| 49–60 months | 586 | 11.3% |
| 61–72 months | 739 | 6.6% |

### Payment method

| Method | Customers | Churn Rate |
|--------|-----------|------------|
| Electronic check | 2,365 | 45.3% |
| Mailed check | 1,612 | 19.1% |
| Bank transfer (automatic) | 1,544 | 16.7% |
| Credit card (automatic) | 1,522 | 15.2% |

### Internet service

| Service | Customers | Churn Rate | Avg Monthly Charges |
|---------|-----------|------------|---------------------|
| Fiber optic | 3,096 | 41.9% | ~$91 |
| DSL | 2,421 | 19.0% | ~$58 |
| No internet | 1,526 | 7.4% | ~$21 |

### Senior citizen status

| Status | Customers | Churn Rate |
|--------|-----------|------------|
| Senior (1) | 1,142 | 41.7% |
| Non-senior (0) | 5,901 | 23.6% |

### Add-on adoption

| Service | Retained | Churned | Gap |
|---------|----------|---------|-----|
| OnlineSecurity | 29.9% | 15.9% | +14.0% |
| TechSupport | 29.5% | 15.6% | +13.9% |
| OnlineBackup | 29.8% | 24.0% | +5.8% |
| DeviceProtection | 29.5% | 23.4% | +6.1% |
| StreamingTV | 29.0% | 29.3% | -0.3% |
| StreamingMovies | 28.5% | 28.3% | +0.2% |

### Financial summary

| Metric | Value |
|--------|-------|
| Total monthly revenue | $456,117 |
| Monthly revenue from churned customers | $139,131 |
| Revenue share from churned | 30.5% |
| ARPU — retained | $61.27/month |
| ARPU — churned | $74.44/month |
| ARPU gap | +$13.17/month (churned pay more) |
| Avg tenure — retained | 37.6 months |
| Avg tenure — churned | 18.0 months |

---

## 12. Business Insights

All findings are associations. They do not establish causation.

| # | Insight | Key Numbers |
|---|---------|-------------|
| 01 | Contract type is the strongest single differentiator | MTM: 42.7% vs Two-year: 2.8% — 15× difference |
| 02 | First year is the critical retention window | 0–12 mo: 47.4% vs 61–72 mo: 6.6% |
| 03 | Fiber Optic customers churn most despite paying most | 41.9% churn at ~$91/month avg |
| 04 | Electronic check associated with highest churn | 45.3% vs 15–16% for automatic methods |
| 05 | Highest-risk combination: MTM + Fiber Optic | 2,128 customers, 54.6% churn rate |
| 06 | Rule-based high-risk segment churns at 67.7% | 976 customers, 2.6× the base rate |
| 07 | Churned customers pay more but stay half as long | $74.44/mo vs $61.27/mo; 18 mo vs 37.6 mo |
| 08 | Senior citizens churn at 1.8× the non-senior rate | 41.7% vs 23.6% |
| 09 | Add-on adoption is associated with lower churn | 1.83 avg add-ons retained vs 1.27 churned |
| 10 | $139K/month in recurring revenue left with churned customers | 30.5% of total monthly base |

---

## 13. Recommendations

| # | Recommendation | Addresses |
|---|---------------|-----------|
| R1 | Incentivise contract conversion in the first 12 months — price lock, bundle discount, or loyalty bonus | Insights 01, 02, 06 |
| R2 | Investigate the Fiber Optic churn gap with exit surveys or service quality data before designing a response | Insights 03, 05 |
| R3 | Promote automatic payment enrollment — reduces churn and payment friction | Insight 04 |
| R4 | Design add-on adoption programs for new customers — focus on OnlineSecurity and TechSupport which show the largest retention gaps | Insight 09 |
| R5 | Tailor support and billing for senior customers — simplify payment switching, offer phone-based support | Insight 08 |

**Important:** Each recommendation includes a caveat — the association in this data
does not guarantee the intervention will work. A/B testing is required before broad rollout.

---

## 14. Limitations

1. **No causal inference** — Cross-sectional observational data. Association ≠ causation.

2. **No time dimension** — Single snapshot. Cannot observe trends or how churn rates
   changed over time.

3. **No exit reason data** — The dataset does not include why customers left. Pricing
   complaints, service quality, competitor offers, and life events are all equally
   plausible explanations.

4. **Confounding** — Attributes correlate with each other (Fiber Optic users are more
   likely to be on month-to-month contracts). Independent contributions cannot be
   isolated without a controlled model.

5. **No predictive validity** — Segment churn rates describe the past. They should
   not be used to score individual customers without further validation.

6. **Synthetic dataset** — This is an illustrative dataset from IBM. Its distributions
   may not match a real telecom company's customer base.

---

## 15. What Makes This Project Unique

Most Telco churn portfolio projects on the internet follow the same pattern:
load CSV → plot a few charts → train logistic regression → print accuracy. This
project is different in several ways.

**1. Business-driven rule-based segmentation**
Instead of relying on a model score, a transparent high-risk segment was defined
using rules any stakeholder can understand and audit. The definition is documented,
justified, and deliberately updated during Power BI development with the reasoning
recorded.

**2. Revenue exposure quantification**
The project goes beyond churn rate to answer: how much money is at risk?
$139,131/month, $81K in the high-risk segment alone. These are the numbers a
CFO cares about, not a 26.5% rate.

**3. Consistent metric definitions across three tools**
Every number in Python, SQL, and Power BI traces back to the same cleaned CSV
with the same definitions. Query 30 in SQL explicitly reconciles against Python.

**4. Honest analytical caveats throughout**
Every notebook, every SQL file, every Power BI page, and this documentation all
carry the same caveat: associations, not causation. This is rare in portfolio
projects and is what professional data work requires.

**5. CLV proxy labelled correctly**
MonthlyCharges × tenure is labelled as a historical billed-value approximation,
not a prediction. The difference matters.

**6. SQL goes beyond GROUP BY**
CTEs, window functions (RANK, running totals), multi-way cross-tabs with minimum
cell size filters, and a reconciliation query. 30 queries across 7 analytical groups.

**7. Customer-level drill-down in Power BI**
Page 3 includes a filtered table of individual high-risk customers — not just
aggregated charts. A retention team could use this directly.

---

## 16. Reproduction Steps

```powershell
# Step 1 — Clone the repository
git clone https://github.com/hrts51/telco-churn-analytics.git
cd telco-churn-analytics

# Step 2 — Download the raw dataset from Kaggle
# URL: https://www.kaggle.com/datasets/blastchar/telco-customer-churn
# Save to: data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv

# Step 3 — Set up the Python environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt

# Step 4 — Run notebooks in order
jupyter nbconvert --to notebook --execute --inplace notebooks/01_data_understanding.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/02_eda.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/03_behavior_financial_analysis.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/04_segmentation_risk.ipynb

# Step 5 — Build the SQLite database
python sql/load_db.py

# Step 6 — Run SQL queries
# Option A: DB Browser for SQLite — open sql/telco_churn.db, paste from churn_analysis.sql
# Option B: Python
python -c "
import sqlite3
con = sqlite3.connect('sql/telco_churn.db')
cur = con.cursor()
cur.execute('SELECT COUNT(*), SUM(ChurnFlag), ROUND(1.0*SUM(ChurnFlag)/COUNT(*)*100,1) FROM customers')
print(cur.fetchone())
con.close()
"

# Step 7 — Open the Power BI dashboard
# Open powerbi/telco_churn_dashboard.pbix in Power BI Desktop
# If the data connection breaks: Home → Transform data → Data source settings → Change Source
# Point to: data/clean/telco_clean.csv
```

---

## 17. Metric Definitions

| Metric | Definition | Source |
|--------|-----------|--------|
| Churn rate | Churned customers ÷ all customers in segment | All layers |
| ARPU | AVG(MonthlyCharges) for a segment | NB 02, 03; SQL Q03; PBI Page 4 |
| Revenue exposure | SUM(MonthlyCharges) for Churn="Yes" | NB 03; SQL Q02; PBI Page 4 |
| CLV Proxy | MonthlyCharges × tenure — historical approximation only | NB 03; SQL Q17; PBI col |
| Historical billed value | TotalCharges as recorded in the dataset | NB 03; SQL Q17 |
| AddonCount | Count of 6 add-on columns set to "Yes" (0–6) | NB 03, 04; SQL Q19; PBI col |
| HighRisk (Python/SQL) | MTM + tenure ≤ 12 mo + MonthlyCharges ≥ $65 | NB 04; SQL Q26 |
| HighRisk (Power BI) | tenure ≤ 12 mo + MonthlyCharges ≥ $65 (all contracts) | PBI Page 3 |
| TenureSegment | New (0–12) / Growing (13–36) / Loyal (37–72) | NB 04; SQL Q14; PBI col |
| ChargeSegment | Low ($0–35) / Mid ($35–65) / High ($65+) | NB 04; SQL Q13; PBI col |

---

## 18. Git History

| # | Commit hash | Description |
|---|-------------|-------------|
| 1 | b5acffa | Set up churn analysis project and clean source data |
| 2 | 9407db3 | Complete EDA notebook with 8 charts and verified findings |
| 3 | 5317f2e | Add notebooks 03 (financial analysis) and 04 (segmentation/risk) |
| 4 | c4dca8c | Add 30 verified SQL queries and SQLite database loader |
| 5 | f4b54e2 | Add Power BI dashboard plan and DAX measures documentation |
| 6 | 5640ac4 | Add 10 insights, 5 recommendations, final report, and updated README |
| 7 | bc2f9e9 | Update README with Power BI dashboard file reference and instructions |
| 8 | a305483 | Add completed Power BI dashboard (telco_churn_dashboard.pbix) |
| 9 | 6aa5386 | Exclude auto-generated SQLite DB from tracking; rebuild with load_db.py |
| 10 | 0c243e7 | Add dashboard handover document and update README with final dashboard details |

---

*End of documentation.*
