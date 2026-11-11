# Telecom Customer Churn Analytics Dashboard — Power BI Handover

## 1. Project Overview
Built a four-page interactive Power BI dashboard using the IBM Telco Customer Churn dataset (7,043 customers).

**Objective:** Analyse customer churn, identify high-risk customer segments, quantify revenue at risk, and understand how subscription services relate to customer retention.

## 2. Four Dashboard Pages

**Page 1 — Executive Summary**
- KPIs: Total Customers (7,043), Churned Customers (1,869), Churn Rate (26.5%), Monthly Revenue Lost (~$139K).
- Additional high-risk customer KPIs.
- Churn analysis by contract, tenure, internet service and payment method.
- Customer retention vs churn donut chart.
- Contract and Internet Service slicers.
- Key business insights and data limitations.

**Page 2 — Churn Drivers Analysis**
- Churn rate analysis by gender, senior citizen status, paperless billing, partner, dependents, contract, payment method and individual add-on services.
- Interactive Contract, Internet Service and Gender slicers.
- Helps identify customer characteristics associated with higher churn.

**Page 3 — Customer Risk & Revenue Analysis**
- High-risk customer count: 1,001.
- High-risk churn rate: 66.4%.
- Monthly revenue in high-risk segment: approximately $81K.
- High-risk customers analysed across contract types.
- Contract × Internet Service churn-rate comparison.
- Customer-level details table including customer ID, contract, internet service, payment method, tenure, monthly charges and churn status.
- Tenure Segment and Charge Segment slicers.

**Page 4 — Financial & Subscription Analysis**
- KPIs: Total Monthly Revenue (~$456K), Monthly Revenue Lost (~$139K), Churned ARPU ($74.4), Retained ARPU ($61.3).
- Revenue loss by contract, internet service and payment method.
- Average monthly charges by churn status and contract.
- Individual adoption rates for six add-on services, comparing churned vs retained customers:
  1. Online Security
  2. Online Backup
  3. Device Protection
  4. Tech Support
  5. Streaming TV
  6. Streaming Movies

## 3. What Is Unique About This Dashboard?

1. **High-risk customer identification:** Created a custom HighRisk calculated column using tenure ≤ 12 months and MonthlyCharges ≥ $65, across all contract types.

2. **Revenue exposure analysis:** Goes beyond churn percentages to quantify monthly revenue lost and revenue associated with the high-risk segment.

3. **Customer-level drill-down:** Includes a detailed table to inspect individual high-risk customers rather than showing only aggregated charts.

4. **Contract and Internet Service comparison:** Combines both dimensions to identify where churn risk is concentrated.

5. **Six individual add-on adoption comparisons:** Instead of relying only on average add-on count, compares adoption rates for six services between churned and retained customers.

6. **Interactive analysis:** Uses slicers across pages to explore customer segments and investigate how churn and revenue metrics change.

## 4. Main Calculated Fields and Measures

Calculated columns:
- ChurnFlag
- CLV_Proxy
- AddonCount
- TenureSegment
- ChargeSegment
- HighRisk

Important measures:
- Total Customers
- Churned Customers
- Retained Customers
- Churn Rate
- Total Monthly Revenue
- Monthly Revenue Lost
- Churned Customer ARPU
- Retained Customer ARPU
- High-Risk Segment Customers
- High-Risk Churn Rate
- Monthly Revenue in High-Risk Segment
- Six add-on adoption measures and a dynamic adoption-rate measure.

## 5. Key Business Findings

- Overall customer churn rate is approximately 26.5%.
- Month-to-month customers have substantially higher churn than one-year and two-year customers.
- Customers with short tenure and high monthly charges form a particularly high-risk segment.
- High-risk segment churn rate is approximately 66.4%.
- Monthly revenue lost due to churn is approximately $139K.
- Fiber optic customers contribute the largest share of monthly revenue loss.
- Churned customers have higher average monthly charges ($74.4) than retained customers ($61.3).
- Add-on adoption differs by service and churn status.

## 6. Important Methodology Note

The HighRisk definition currently used is:

HighRisk = 1 when:
- tenure ≤ 12 months
- MonthlyCharges ≥ $65

The definition deliberately does not require a Month-to-month contract, allowing high-risk customers across all three contract types to be compared.

**Data limitation:** The analysis identifies associations, not causation. The dataset does not record the specific reasons why individual customers discontinued their services.

## 7. Current Status

All four dashboard pages have been built. The dashboard includes interactive slicers, KPIs, charts, customer-level details, business insights and data limitation notes. The six individual add-on adoption comparison chart has also been implemented on Page 4.
