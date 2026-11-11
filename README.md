# Telco Customer Churn Analytics

## Project objective

Analyse which customer, service, and subscription patterns are associated with churn
in the IBM Telco Customer Churn dataset. Quantify financial exposure and develop
evidence-based retention recommendations.

**Scope:** Descriptive and associative analysis only. Findings are associations, not
causal relationships. This dataset does not identify why any individual customer left.

---

## Dataset

**Source:** [IBM Telco Customer Churn on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

Place the downloaded file at:

```
data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv
```

The raw CSV is excluded from Git (see `.gitignore`). Download it from Kaggle to
reproduce the analysis. The cleaned version (`data/clean/telco_clean.csv`) is
included in the repository.

**Dataset facts:**
- 7,043 customers, 21 original columns
- 1,869 churned | 5,174 retained | 26.5% overall churn rate
- One cross-sectional snapshot (no time series)

---

## Project structure

```
telco-churn-analytics/
├── data/
│   ├── raw/          ← original Kaggle CSV (Git-ignored)
│   └── clean/        ← telco_clean.csv (25 columns, 7,043 rows)
├── notebooks/
│   ├── 01_data_understanding.ipynb   ← load, inspect, clean data
│   ├── 02_eda.ipynb                  ← exploratory analysis and charts
│   ├── 03_behavior_financial_analysis.ipynb  ← ARPU, CLV proxy, revenue exposure
│   └── 04_segmentation_risk.ipynb    ← rule-based segments, high-risk profile
├── sql/
│   ├── churn_analysis.sql            ← 30 verified SQLite queries (7 groups)
│   ├── load_db.py                    ← script to build telco_churn.db from CSV
│   └── telco_churn.db                ← SQLite database (auto-generated)
├── powerbi/
│   ├── dashboard_plan.md             ← 4-page dashboard design spec
│   └── dax_measures.md               ← all DAX measures with definitions
├── report/
│   ├── final_report.md               ← full written report
│   └── insights_and_recommendations.md  ← 10 insights + 5 recommendations
├── images/                           ← 16 PNG charts from notebooks
├── requirements.txt
└── README.md
```

---

## Environment setup

Requires Python 3.14+ and Git.

```powershell
# From the project root
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

---

## Reproduction steps

```powershell
# 1. Download raw CSV to data/raw/ (see Dataset section above)

# 2. Run notebooks in order (each can also be opened in JupyterLab)
jupyter nbconvert --to notebook --execute --inplace notebooks/01_data_understanding.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/02_eda.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/03_behavior_financial_analysis.ipynb
jupyter nbconvert --to notebook --execute --inplace notebooks/04_segmentation_risk.ipynb

# 3. Build the SQLite database
python sql/load_db.py

# 4. Open sql/churn_analysis.sql in DB Browser for SQLite,
#    or in any SQLite-compatible tool
```

---

## Metric definitions

| Metric | Definition | Used in |
|--------|-----------|---------|
| Churn rate | Churned customers ÷ all customers in segment | All analyses |
| ARPU | Average MonthlyCharges | Notebooks 02, 03; SQL Q03 |
| Revenue exposure | SUM(MonthlyCharges) for Churn="Yes" | Notebook 03; SQL Q02 |
| CLV Proxy | MonthlyCharges × tenure | Notebook 03; SQL Q17 |
| Historical billed value | TotalCharges (as recorded in dataset) | Notebooks 03; SQL Q17 |
| AddonCount | Count of 6 add-on columns set to "Yes" | Notebooks 03, 04; SQL Q19 |
| HighRisk flag | MTM + tenure ≤ 12 mo + MonthlyCharges ≥ $65 | Notebook 04; SQL Q26 |

**CLV Proxy note:** `MonthlyCharges × tenure` is an approximation of historical
revenue. It is *not* a prediction of future lifetime value.

---

## Key findings (summary)

| Finding | Rate |
|---------|------|
| Overall churn rate | 26.5% |
| Month-to-month churn rate | 42.7% |
| Two-year contract churn rate | 2.8% |
| First-year (0–12 mo) churn rate | 47.4% |
| Electronic check churn rate | 45.3% |
| Fiber Optic churn rate | 41.9% |
| Month-to-month + Fiber Optic | 54.6% |
| High-risk segment (MTM+new+high-spend) | 67.7% |
| Monthly revenue from churned customers | $139,131 (30.5% of total) |

---

## Power BI dashboard

**File:** `powerbi/telco_churn_dashboard.pbix`
Open this file directly in Power BI Desktop — the data connection points to
`data/clean/telco_clean.csv` in this project folder.

### Four dashboard pages

| Page | Content |
|------|---------|
| Executive Summary | 6 KPIs, churn by contract/tenure/internet/payment, donut chart, slicers |
| Churn Drivers Analysis | 13 charts across all demographic and service attributes, 3 slicers |
| Customer Risk & Revenue | High-risk segment KPIs, revenue exposure, 8-column customer table, slicers |
| Financial & Subscription | Revenue KPIs, add-on adoption by churn, ARPU comparison, payment analysis |

### If the data connection breaks after moving the project folder

1. Open the `.pbix` file in Power BI Desktop
2. Go to **Home → Transform data → Data source settings**
3. Click **Change Source**
4. Browse to the new location of `data/clean/telco_clean.csv`
5. Click **OK → Close & Apply**

### Documentation
- `powerbi/dashboard_plan.md` — full layout and visual specifications
- `powerbi/dax_measures.md` — all DAX measures with formulas and usage notes

---

## Limitations

- Cross-sectional data: no time-series or trend analysis
- No exit reason data: cannot explain *why* customers left
- Associations are not causal relationships
- Dataset is synthetic/illustrative (IBM); may not generalise to real telecom data
- No predictive model; segment rates describe past patterns, not future individuals

---

## Git history

| Commit | Description |
|--------|-------------|
| Initial | Set up project, clean source data |
| 2nd | Complete EDA notebook with 8 charts |
| 3rd | Add notebooks 03 (financial) and 04 (segmentation) |
| 4th | Add 30 verified SQL queries and SQLite database |
| 5th | Add Power BI dashboard plan and DAX measures |
| 6th | Add insights, recommendations, and final report |
| 7th | Add completed Power BI dashboard (.pbix) |
