# DAX Measures — Telco Churn Dashboard

Create these measures in a dedicated table called `_Measures` (create an empty table
via Modeling → New Table → `_Measures = {0}`, then add all measures to it).

---

## Baseline counts and rates

```dax
-- Total number of customers
Total Customers =
COUNTROWS( customers )

-- Number of churned customers
Churned Customers =
CALCULATE(
    COUNTROWS( customers ),
    customers[Churn] = "Yes"
)

-- Overall churn rate (as a decimal; format as % in the visual)
Churn Rate =
DIVIDE(
    [Churned Customers],
    [Total Customers],
    0
)
```

---

## Revenue measures

```dax
-- Total monthly revenue across all visible customers
Total Monthly Revenue =
SUM( customers[MonthlyCharges] )

-- Monthly revenue from churned customers only (revenue at risk)
Churned Monthly Revenue =
CALCULATE(
    SUM( customers[MonthlyCharges] ),
    customers[Churn] = "Yes"
)

-- Revenue at risk as a share of total
Revenue Share Churned =
DIVIDE(
    [Churned Monthly Revenue],
    [Total Monthly Revenue],
    0
)

-- Average monthly charges (ARPU) for currently visible customers
ARPU =
AVERAGEX(
    customers,
    customers[MonthlyCharges]
)

-- ARPU split: retained customers
ARPU Retained =
CALCULATE(
    AVERAGE( customers[MonthlyCharges] ),
    customers[Churn] = "No"
)

-- ARPU split: churned customers
ARPU Churned =
CALCULATE(
    AVERAGE( customers[MonthlyCharges] ),
    customers[Churn] = "Yes"
)

-- ARPU gap (how much more churned customers paid per month)
ARPU Gap (Churned - Retained) =
[ARPU Churned] - [ARPU Retained]
```

---

## Tenure and CLV proxy

```dax
-- Average tenure in months
Avg Tenure =
AVERAGE( customers[tenure] )

-- Avg tenure for retained customers
Avg Tenure Retained =
CALCULATE(
    AVERAGE( customers[tenure] ),
    customers[Churn] = "No"
)

-- Avg tenure for churned customers
Avg Tenure Churned =
CALCULATE(
    AVERAGE( customers[tenure] ),
    customers[Churn] = "Yes"
)

-- Average CLV proxy (MonthlyCharges * tenure)
-- This is approximate historical revenue, NOT a predicted future value.
Avg CLV Proxy =
AVERAGE( customers[CLV_Proxy] )

-- Total historical billed value across all customers
Total Billed (TotalCharges) =
SUM( customers[TotalCharges] )
```

---

## Segmentation measures

```dax
-- High-risk segment: Month-to-month + new + high-spend
-- Definition: same as Python notebook 04 and SQL Query 26
High Risk Customers =
CALCULATE(
    COUNTROWS( customers ),
    customers[Contract] = "Month-to-month",
    customers[tenure] <= 12,
    customers[MonthlyCharges] >= 65
)

-- Churn rate within the high-risk segment
High Risk Churn Rate =
DIVIDE(
    CALCULATE(
        [Churned Customers],
        customers[Contract] = "Month-to-month",
        customers[tenure] <= 12,
        customers[MonthlyCharges] >= 65
    ),
    [High Risk Customers],
    0
)

-- Monthly revenue within the high-risk segment
High Risk Monthly Revenue =
CALCULATE(
    SUM( customers[MonthlyCharges] ),
    customers[Contract] = "Month-to-month",
    customers[tenure] <= 12,
    customers[MonthlyCharges] >= 65
)
```

---

## Usage notes

- All measures use the **implicit filter context** from slicers and visuals.
  When a slicer selects "Month-to-month", `Total Customers` automatically
  counts only month-to-month customers. No additional CALCULATE is needed.

- **Churn Rate** will adapt to any slicer selection. Use it on card visuals,
  bar charts, and matrix cells alike.

- For the matrix on Page 2 (Contract × InternetService), place
  `Contract` on Rows, `InternetService` on Columns, and `Churn Rate`
  as Values. Apply conditional formatting → Color scale (white → red)
  to create a heatmap effect.

- **Metric consistency:** All measures use the same definition as the Python
  notebooks and SQL queries:
  - Churn rate = churned ÷ total (not churned ÷ retained)
  - ARPU = average MonthlyCharges (not TotalCharges ÷ tenure)
  - Revenue exposure = SUM(MonthlyCharges) for Churn="Yes"
