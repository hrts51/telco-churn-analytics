# Telco Customer Churn Analytics — Final Report

**Author:** Telco Churn Analytics Project
**Dataset:** IBM Telco Customer Churn (Kaggle)
**Analysis tools:** Python 3.14, pandas, matplotlib, seaborn, SQLite, Power BI (plan)
**Project folder:** `D:\telco-churn-analytics`

---

## 1. Problem Statement

Customer churn — when a subscriber cancels their service — is a primary revenue
risk for telecommunications companies. Acquiring a new customer typically costs
more than retaining an existing one, so understanding which customer and service
attributes are associated with churn can help prioritise retention investment.

**Objective:** Analyse patterns in the IBM Telco Customer Churn dataset to identify
which customer, service, and subscription attributes are most strongly associated
with churn; quantify the revenue exposure; and develop evidence-based retention
recommendations.

**Scope and constraints:** This analysis is descriptive and associative. It does not
establish causation, does not explain why any individual customer left, and does not
constitute a predictive model. All findings are specific to this dataset.

---

## 2. Dataset

**Source:** [IBM Telco Customer Churn on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
**File:** `data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv`
**Rows:** 7,043 customers
**Columns:** 21 original; 25 after cleaning (4 derived columns added)
**Churn label:** 1,869 churned (Yes) | 5,174 retained (No) | 26.5% overall churn rate

### Column summary

| Column | Type | Description |
|--------|------|-------------|
| customerID | Text | Unique identifier |
| gender | Text | Male / Female |
| SeniorCitizen | Integer | 0=No, 1=Yes |
| Partner, Dependents | Text | Yes / No |
| tenure | Integer | Months as a customer (0–72) |
| PhoneService, MultipleLines | Text | Phone service attributes |
| InternetService | Text | DSL / Fiber optic / No |
| OnlineSecurity … StreamingMovies | Text | Six internet add-on services |
| Contract | Text | Month-to-month / One year / Two year |
| PaperlessBilling | Text | Yes / No |
| PaymentMethod | Text | Four payment methods |
| MonthlyCharges | Float | Current monthly bill ($) |
| TotalCharges | Float | Cumulative billed amount ($) |
| Churn | Text | Yes / No |
| *(derived)* ChurnFlag | Integer | 1=churned, 0=retained |
| *(derived)* SeniorCitizenLabel | Text | No / Yes |
| *(derived)* CLV_Proxy | Float | MonthlyCharges × tenure |
| *(derived)* AddonCount | Integer | Count of add-ons set to "Yes" (0–6) |

---

## 3. Data Cleaning Decisions

Cleaning was performed in `notebooks/01_data_understanding.ipynb`. The original
DataFrame (`df`) was preserved; all changes were made to `df_clean`.

### Decision 1 — TotalCharges conversion
`TotalCharges` was stored as text in the raw file. 11 rows had blank/whitespace
values. All 11 had `tenure = 0`, confirming they are new customers who had not
yet been billed. These were filled with 0 (not dropped — they are valid customers).
All other rows converted to float without issues.

**Validation:** After cleaning, `TotalCharges` has 0 missing values and all 11
previously-blank rows show `TotalCharges = 0.0` with `tenure = 0`.

### Decision 2 — SeniorCitizenLabel
The original `SeniorCitizen` column uses 0/1 encoding. A readable `SeniorCitizenLabel`
column (No/Yes) was added for display, while the original numeric column was retained
for arithmetic.

### Decision 3 — Preserve original labels
Service columns such as "No internet service" and "No phone service" were preserved
as-is. These values carry analytical meaning (they distinguish customers without
the base service from those who have the base service but declined the add-on).

### Decision 4 — No rows dropped
All 7,043 customers were retained, including the 11 with tenure=0 and the 11 with
TotalCharges filled to 0.

**Clean file:** `data/clean/telco_clean.csv` — 7,043 rows, 25 columns, 0 missing values.

---

## 4. Methodology

### Analysis approach
1. **Descriptive statistics:** Count, churn rate, ARPU, and tenure summary for each
   categorical attribute (Notebooks 01, 02).
2. **Visualisation:** Distribution plots, bar charts, box plots, and cross-tabulation
   heatmaps to identify patterns (Notebooks 02, 03, 04).
3. **Financial quantification:** Revenue exposure, ARPU comparison, and historical
   billed value proxy (Notebook 03).
4. **Rule-based segmentation:** Transparent tenure and charge segments; a composite
   high-risk segment defined by business-interpretable rules (Notebook 04).
5. **SQL analysis:** 30 queries across 7 groups verifying Python results and providing
   a SQL-first analytical layer (sql/churn_analysis.sql).

### Tools and reproducibility
All code is in Jupyter notebooks (`.ipynb` files) executed against the `.venv` Python
3.14 environment. All queries run against `sql/telco_churn.db` (SQLite). Every
numeric finding in this report has been verified against both Python and SQL outputs.

---

## 5. Key Findings

All percentages are segment-level churn rates (churned ÷ segment total).

### 5.1 Contract type
| Contract | Customers | Churn Rate |
|----------|-----------|------------|
| Month-to-month | 3,875 | **42.7%** |
| One year | 1,473 | 11.3% |
| Two year | 1,695 | 2.8% |

Month-to-month churn is 15× the two-year rate. This group is also the largest,
so it drives the most absolute churn volume.

### 5.2 Tenure
| Tenure Bucket | Customers | Churn Rate |
|---------------|-----------|------------|
| 0–12 months | 2,186 | **47.4%** |
| 13–24 months | 1,024 | 28.7% |
| 25–36 months | 832 | 21.6% |
| 37–72 months | 3,001 | 11.9% |

Churn risk more than halves after the first year and continues declining.

### 5.3 Payment method
| Method | Customers | Churn Rate |
|--------|-----------|------------|
| Electronic check | 2,365 | **45.3%** |
| Mailed check | 1,612 | 19.1% |
| Bank transfer (automatic) | 1,544 | 16.7% |
| Credit card (automatic) | 1,522 | 15.2% |

Automatic payment customers churn at approximately one-third the rate of
electronic check users.

### 5.4 Internet service
| Service | Customers | Churn Rate |
|---------|-----------|------------|
| Fiber optic | 3,096 | **41.9%** |
| DSL | 2,421 | 19.0% |
| No internet | 1,526 | 7.4% |

Fiber Optic customers pay the most (~$91/month average) and churn the most.

### 5.5 Senior citizen status
| Status | Customers | Churn Rate |
|--------|-----------|------------|
| Senior (1) | 1,142 | **41.7%** |
| Non-senior (0) | 5,901 | 23.6% |

Seniors represent 16% of the base but 25% of churners.

### 5.6 Highest-risk combination
Month-to-month + Fiber Optic: 2,128 customers, **54.6% churn rate**.
This combination contains 28% of all churners despite being 30% of the base.

### 5.7 Rule-based high-risk segment
Definition: Month-to-month + tenure ≤ 12 months + MonthlyCharges ≥ $65
Size: 976 customers (13.9% of base)
Churn rate: **67.7%** (2.6× the base rate of 26.5%)
Monthly revenue in segment: $79,388

---

## 6. Financial Quantification

| Metric | Value |
|--------|-------|
| Total monthly revenue (all customers) | $456,117 |
| Monthly revenue from churned customers | $139,131 |
| Revenue share from churned | 30.5% |
| ARPU — retained customers | $61.27/month |
| ARPU — churned customers | $74.44/month |
| Average tenure — retained | 37.6 months |
| Average tenure — churned | 18.0 months |

**Key observation:** Churned customers paid $13.17 more per month than retained
ones, yet stayed half as long. Their shorter tenure means their total billed value
was lower despite higher monthly rates.

**CLV Proxy note:** `MonthlyCharges × tenure` is used as an approximate historical
revenue figure. It is *not* a prediction of future customer lifetime value.

---

## 7. Add-on Service Analysis

| Service | Retained adoption | Churned adoption |
|---------|-------------------|-----------------|
| OnlineSecurity | 29.9% | 15.9% |
| TechSupport | 29.5% | 15.6% |
| OnlineBackup | 29.8% | 24.0% |
| DeviceProtection | 29.5% | 23.4% |
| StreamingTV | 29.0% | 29.3% |
| StreamingMovies | 28.5% | 28.3% |

Security and support add-ons show the largest gaps between retained and churned
customers. Streaming services show minimal differences — suggesting they are not
meaningful retention factors. Average add-on count: 1.83 for retained vs 1.27
for churned.

---

## 8. Limitations

1. **No causal inference:** This is cross-sectional, observational data. Association
   does not imply that any attribute *caused* churn.

2. **No time dimension:** We cannot observe how churn rates or customer behaviour
   changed over time. Trend analysis is not possible.

3. **No exit reason data:** The dataset does not include why customers left — pricing
   complaints, service quality issues, competitor offers, or life events are all
   equally plausible explanations for the same data pattern.

4. **Confounding:** Attributes correlate with each other (e.g., Fiber Optic users
   are more likely to be on month-to-month contracts). The independent contribution
   of each factor cannot be isolated without a controlled model.

5. **No predictive validity:** Segment churn rates describe the past. They should
   not be used to score individual customers for intervention without further
   validation.

6. **Dataset provenance:** This is a synthetic/illustrative dataset from IBM. Its
   distributional properties may not match any real telecom's customer base.

---

## 9. Recommendations Summary

| # | Recommendation | Key Insight |
|---|---------------|-------------|
| R1 | Incentivise contract conversion in the first 12 months | Insights 01, 02, 06 |
| R2 | Investigate why Fiber Optic customers churn so heavily | Insights 03, 05 |
| R3 | Promote automatic payment enrollment | Insight 04 |
| R4 | Design add-on adoption programs for new customers | Insight 09 |
| R5 | Tailor support and billing for senior customers | Insight 08 |

See `report/insights_and_recommendations.md` for full detail on each recommendation,
including caveats and suggested validation approaches.

---

## 10. Project Deliverables

| Deliverable | Location | Status |
|-------------|----------|--------|
| Data understanding notebook | notebooks/01_data_understanding.ipynb | Complete |
| EDA notebook | notebooks/02_eda.ipynb | Complete |
| Financial analysis notebook | notebooks/03_behavior_financial_analysis.ipynb | Complete |
| Segmentation notebook | notebooks/04_segmentation_risk.ipynb | Complete |
| SQL queries (30 verified) | sql/churn_analysis.sql | Complete |
| SQLite database | sql/telco_churn.db | Complete |
| Power BI plan | powerbi/dashboard_plan.md | Complete |
| DAX measures | powerbi/dax_measures.md | Complete |
| Insights document | report/insights_and_recommendations.md | Complete |
| This report | report/final_report.md | Complete |
| Visualisations (16 charts) | images/*.png | Complete |

---

## 11. Reproduction Instructions

```powershell
# 1. Clone or copy the project folder to your machine
# 2. Download the raw CSV from Kaggle and place it at:
#    data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv

# 3. Create and activate the virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt

# 4. Run data understanding and cleaning notebook
jupyter nbconvert --to notebook --execute --inplace notebooks/01_data_understanding.ipynb

# 5. Run remaining notebooks in order
jupyter nbconvert --to notebook --execute --inplace notebooks/02_eda.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/03_behavior_financial_analysis.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/04_segmentation_risk.ipynb

# 6. Build the SQL database
python sql/load_db.py

# 7. Run SQL queries
#    Open sql/churn_analysis.sql in DB Browser for SQLite,
#    or run individual queries via Python:
python -c "import sqlite3; con=sqlite3.connect('sql/telco_churn.db'); ..."
```
