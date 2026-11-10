# Power BI Dashboard Plan — Telco Customer Churn

## Data source
File: `data/clean/telco_clean.csv`
Rows: 7,043 | Columns: 25 (including derived fields ChurnFlag, CLV_Proxy, AddonCount)

Load via: Home → Get Data → Text/CSV → browse to `data/clean/telco_clean.csv`
Confirm date format and decimal separator settings match your locale.

---

## Setup steps in Power BI Desktop

1. Load `data/clean/telco_clean.csv` via Get Data → Text/CSV.
2. In Power Query Editor, verify:
   - `MonthlyCharges` and `TotalCharges` are type Decimal Number
   - `tenure`, `SeniorCitizen`, `ChurnFlag`, `AddonCount` are type Whole Number
   - All other columns are type Text
3. Close & Apply.
4. Create the DAX measures listed in `powerbi/dax_measures.md`.
5. Build the four report pages described below.

---

## Report pages

### Page 1: Executive Summary
**Purpose:** One-screen overview for leadership. No detail — just the headline numbers and trend.

**Visuals:**
- KPI card: Total Customers (7,043)
- KPI card: Churned Customers (1,869)
- KPI card: Churn Rate (26.5%)
- KPI card: Monthly Revenue at Risk ($139,130)
- Bar chart: Churn rate by Contract (Month-to-month / One year / Two year)
- Donut chart: Retained vs Churned customer count
- Slicer: Contract type (multi-select)
- Slicer: InternetService

**Key insight callout:** "Month-to-month customers churn at 42.7% vs 2.8% for two-year contracts."

---

### Page 2: Churn Drivers
**Purpose:** Analyst view — which attributes are most strongly associated with churn?

**Visuals:**
- Clustered bar: Churn rate by PaymentMethod
- Clustered bar: Churn rate by InternetService
- Grouped bar: Churn rate by SeniorCitizenLabel
- Matrix: Contract × InternetService with churn rate values and conditional formatting
- Stacked bar: Churn mix by TenureBucket (New / Growing / Loyal)
- Slicer: Contract type
- Slicer: InternetService

**Tooltip page:** Hover on any bar → shows segment count + churn count

---

### Page 3: Financial and Subscription Analysis
**Purpose:** Revenue exposure, ARPU comparison, and add-on adoption.

**Visuals:**
- KPI card: Total Monthly Revenue ($456,206)
- KPI card: Monthly Revenue Lost to Churn ($139,130 — 30.5% of base)
- KPI card: Churned Customer ARPU ($74.44/month)
- KPI card: Retained Customer ARPU ($61.27/month)
- Bar chart: Monthly revenue lost by Contract
- Box plot (or violin): MonthlyCharges distribution by Churn label
  (Use a custom visual if box plot isn't native in your version)
- Clustered bar: Add-on adoption rate — Retained vs Churned (6 services)
- Slicer: Contract type
- Slicer: InternetService

---

### Page 4: Segments and High-Risk Customers
**Purpose:** Identify and characterise the highest-risk customer groups.

**Visuals:**
- KPI card: High-Risk Segment Customers (count, using HighRisk measure)
- KPI card: High-Risk Churn Rate
- KPI card: Monthly Revenue in High-Risk Segment
- Bubble/scatter: TenureSegment (x) × Contract (y) — size = customers, color = churn rate
  (Use a scatter chart with Tenure on axis and Contract as legend, or a matrix with heatmap)
- Bar chart: Top combinations by churn rate (Contract + InternetService)
- Table: High-risk customer list with columns:
  customerID, Contract, tenure, MonthlyCharges, InternetService, PaymentMethod, Churn
  (Filtered to HighRisk = 1, sorted by MonthlyCharges desc)
- Slicer: TenureSegment
- Slicer: ChargeSegment

---

## Calculated columns (add in Power Query or DAX)

These replicate the Python-derived columns. If loading from `telco_clean.csv` they are
already present. If rebuilding from raw, add them in Power Query:

| Column | Formula |
|--------|---------|
| ChurnFlag | if [Churn] = "Yes" then 1 else 0 |
| CLV_Proxy | [MonthlyCharges] * [tenure] |
| AddonCount | count of Yes across 6 add-on columns |
| TenureSegment | SWITCH on tenure: <=12 → "New", <=36 → "Growing", else "Loyal" |
| ChargeSegment | SWITCH on MonthlyCharges: <=35 → "Low", <=65 → "Mid", else "High" |
| HighRisk | 1 if Month-to-month AND tenure<=12 AND MonthlyCharges>=65 else 0 |

---

## Design guidelines

- Color: Blue (#5b9bd5) = Retained, Orange (#ed7d31) = Churned. Use consistently.
- Font: Segoe UI or Calibri, minimum 11pt for labels.
- Always show segment count (n=) alongside a rate — rate without size is misleading.
- Avoid pie charts with more than 3 slices; prefer horizontal bars.
- Include a "Data as of" text box referencing the IBM Telco dataset (Nov 2026 snapshot).
- Add a Limitations text box on the Executive Summary page:
  "These findings are associations, not causal relationships. This dataset does not
  record why individual customers left."
