-- =============================================================================
-- Telco Customer Churn Analysis — SQL Queries (SQLite)
-- Database: sql/telco_churn.db   Table: customers
-- Load: python sql/load_db.py    (or run setup cell in any notebook)
--
-- Column reference:
--   customerID       : unique customer identifier
--   gender           : Male / Female
--   SeniorCitizen    : 0 (No) / 1 (Yes)
--   SeniorCitizenLabel: No / Yes  (readable label)
--   Partner          : Yes / No
--   Dependents       : Yes / No
--   tenure           : months as a customer
--   PhoneService     : Yes / No
--   MultipleLines    : Yes / No / No phone service
--   InternetService  : DSL / Fiber optic / No
--   OnlineSecurity .. StreamingMovies : Yes / No / No internet service
--   Contract         : Month-to-month / One year / Two year
--   PaperlessBilling : Yes / No
--   PaymentMethod    : Electronic check / Mailed check /
--                      Bank transfer (automatic) / Credit card (automatic)
--   MonthlyCharges   : monthly bill in USD
--   TotalCharges     : cumulative billed amount (zero for tenure=0 customers)
--   Churn            : Yes / No
--   ChurnFlag        : 1 (churned) / 0 (retained)  — added during cleaning
--   CLV_Proxy        : MonthlyCharges * tenure  — approximate historical revenue
--   AddonCount       : count of internet add-ons set to "Yes" (0–6)
--
-- Metric definitions:
--   Churn rate  = SUM(ChurnFlag) / COUNT(*)  for a given segment
--   ARPU        = AVG(MonthlyCharges)
--   Revenue exposure = SUM(MonthlyCharges) for churned customers
-- =============================================================================


-- =============================================================================
-- GROUP A: OVERALL BASELINE
-- =============================================================================

-- Query 01: Total customers, churned count, and overall churn rate
-- This is the reference denominator for all subsequent comparisons.
SELECT
    COUNT(*)                                          AS total_customers,
    SUM(ChurnFlag)                                    AS total_churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*), 4)         AS churn_rate,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 2)   AS churn_rate_pct
FROM customers;


-- Query 02: Total and churned monthly revenue (overall financial exposure)
-- MonthlyCharges represents the recurring monthly bill.
-- Revenue exposure = what the company was earning from customers who left.
SELECT
    ROUND(SUM(MonthlyCharges), 2)                                        AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN ChurnFlag = 1 THEN MonthlyCharges ELSE 0 END), 2) AS churned_monthly_revenue,
    ROUND(
        SUM(CASE WHEN ChurnFlag = 1 THEN MonthlyCharges ELSE 0 END)
        / SUM(MonthlyCharges), 4
    )                                                                     AS revenue_share_churned
FROM customers;


-- Query 03: Average monthly charges (ARPU) by churn label
-- Churned customers tend to have higher ARPU than retained ones.
SELECT
    Churn,
    COUNT(*)                              AS customers,
    ROUND(AVG(MonthlyCharges), 2)         AS avg_monthly_charges,
    ROUND(MIN(MonthlyCharges), 2)         AS min_monthly_charges,
    ROUND(MAX(MonthlyCharges), 2)         AS max_monthly_charges
FROM customers
GROUP BY Churn
ORDER BY avg_monthly_charges DESC;


-- Query 04: Average tenure by churn label
-- Churned customers have shorter average tenure — they left before accumulating
-- the full relationship value that long-tenured customers represent.
SELECT
    Churn,
    COUNT(*)                   AS customers,
    ROUND(AVG(tenure), 1)      AS avg_tenure_months,
    MIN(tenure)                AS min_tenure,
    MAX(tenure)                AS max_tenure
FROM customers
GROUP BY Churn
ORDER BY avg_tenure_months DESC;


-- =============================================================================
-- GROUP B: CHURN BY KEY CATEGORICAL SEGMENTS
-- =============================================================================

-- Query 05: Churn by contract type
-- Contract type is typically the strongest single predictor of churn.
-- Month-to-month customers face no switching cost.
SELECT
    Contract,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*), 4)       AS churn_rate,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate DESC;


-- Query 06: Churn by internet service type
-- Fiber Optic customers pay more and churn more.
SELECT
    InternetService,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- Query 07: Churn by payment method
-- Electronic check is a manual payment method with the highest churn rate.
-- Automatic methods (bank transfer, credit card) are associated with lower churn.
SELECT
    PaymentMethod,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- Query 08: Churn by senior citizen status
-- SeniorCitizen = 1 is a minority of the base (~16%) but churns at a higher rate.
SELECT
    SeniorCitizenLabel   AS senior_citizen,
    COUNT(*)             AS customers,
    SUM(ChurnFlag)       AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM customers
GROUP BY SeniorCitizenLabel
ORDER BY churn_rate_pct DESC;


-- Query 09: Churn by gender
-- Gender is expected to have minimal association with churn in this dataset.
SELECT
    gender,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY gender;


-- Query 10: Churn by paperless billing
-- Customers on paperless billing may be more digitally engaged but also more
-- likely to notice billing changes and cancel easily.
SELECT
    PaperlessBilling,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY PaperlessBilling
ORDER BY churn_rate_pct DESC;


-- Query 11: Churn by partner and dependents
-- Customers with partners or dependents may have more stable living arrangements
-- and therefore be less likely to change their service provider.
SELECT
    Partner,
    Dependents,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY Partner, Dependents
ORDER BY churn_rate_pct DESC;


-- =============================================================================
-- GROUP C: TENURE AND CHARGE BUCKETS (CTE-BASED)
-- =============================================================================

-- Query 12: Churn by annual tenure bucket using a CTE
-- A CTE (Common Table Expression) creates a named intermediate result.
-- Here it assigns each customer a 12-month tenure bucket before aggregating.
WITH tenure_bucketed AS (
    SELECT
        *,
        CASE
            WHEN tenure BETWEEN 0  AND 12 THEN '01. 0-12 mo'
            WHEN tenure BETWEEN 13 AND 24 THEN '02. 13-24 mo'
            WHEN tenure BETWEEN 25 AND 36 THEN '03. 25-36 mo'
            WHEN tenure BETWEEN 37 AND 48 THEN '04. 37-48 mo'
            WHEN tenure BETWEEN 49 AND 60 THEN '05. 49-60 mo'
            ELSE                               '06. 61-72 mo'
        END AS tenure_bucket
    FROM customers
)
SELECT
    tenure_bucket,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM tenure_bucketed
GROUP BY tenure_bucket
ORDER BY tenure_bucket;


-- Query 13: Churn by monthly charge tier (CASE-based segments)
-- Segments are defined by natural breaks in the MonthlyCharges distribution:
--   Low: $0-$35  (phone-only or basic plans)
--   Mid: $35-$65 (bundled plans)
--   High: $65+   (Fiber Optic bundles with add-ons)
SELECT
    CASE
        WHEN MonthlyCharges <= 35  THEN '1. Low ($0-35)'
        WHEN MonthlyCharges <= 65  THEN '2. Mid ($35-65)'
        ELSE                            '3. High ($65+)'
    END AS charge_tier,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM customers
GROUP BY charge_tier
ORDER BY charge_tier;


-- Query 14: Churn by tenure segment (3-level strategic segmentation)
-- New (0-12 mo), Growing (13-36 mo), Loyal (37-72 mo)
SELECT
    CASE
        WHEN tenure <= 12 THEN '1. New (0-12 mo)'
        WHEN tenure <= 36 THEN '2. Growing (13-36 mo)'
        ELSE                   '3. Loyal (37-72 mo)'
    END AS tenure_segment,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2)                     AS avg_total_charges
FROM customers
GROUP BY tenure_segment
ORDER BY tenure_segment;


-- =============================================================================
-- GROUP D: REVENUE AND FINANCIAL ANALYSIS
-- =============================================================================

-- Query 15: Revenue exposure by contract type
-- Which contract type drives the most absolute revenue loss from churn?
-- (Note: Month-to-month is both larger and higher-churn, so it dominates.)
SELECT
    Contract,
    COUNT(*)                                                AS total_customers,
    SUM(ChurnFlag)                                          AS churned_customers,
    ROUND(SUM(CASE WHEN ChurnFlag=1 THEN MonthlyCharges ELSE 0 END), 2)
                                                            AS monthly_revenue_lost,
    ROUND(AVG(CASE WHEN ChurnFlag=1 THEN MonthlyCharges END), 2)
                                                            AS avg_arpu_churned
FROM customers
GROUP BY Contract
ORDER BY monthly_revenue_lost DESC;


-- Query 16: Revenue exposure by internet service type
SELECT
    InternetService,
    SUM(ChurnFlag)                                          AS churned_customers,
    ROUND(SUM(CASE WHEN ChurnFlag=1 THEN MonthlyCharges ELSE 0 END), 2)
                                                            AS monthly_revenue_lost,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1)        AS churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY monthly_revenue_lost DESC;


-- Query 17: CLV proxy for churned vs retained customers
-- CLV_Proxy = MonthlyCharges * tenure (approximate historical revenue).
-- This is NOT a prediction of future value. The column was added during cleaning.
-- Retained customers have higher CLV because they stayed longer.
SELECT
    Churn,
    COUNT(*)                              AS customers,
    ROUND(AVG(CLV_Proxy), 2)              AS avg_clv_proxy,
    ROUND(MIN(CLV_Proxy), 2)              AS min_clv_proxy,
    ROUND(MAX(CLV_Proxy), 2)              AS max_clv_proxy,
    ROUND(SUM(CLV_Proxy), 2)              AS total_clv_proxy
FROM customers
GROUP BY Churn;


-- Query 18: Average total billed value by contract type and churn
SELECT
    Contract,
    Churn,
    COUNT(*)                              AS customers,
    ROUND(AVG(TotalCharges), 2)           AS avg_total_charges,
    ROUND(AVG(tenure), 1)                 AS avg_tenure_months
FROM customers
GROUP BY Contract, Churn
ORDER BY Contract, Churn;


-- =============================================================================
-- GROUP E: ADD-ON AND SERVICE ADOPTION
-- =============================================================================

-- Query 19: Churn by number of internet add-ons
-- Customers with more add-ons are more embedded in the product.
-- AddonCount = number of these services set to "Yes":
-- OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport,
-- StreamingTV, StreamingMovies
SELECT
    AddonCount,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM customers
GROUP BY AddonCount
ORDER BY AddonCount;


-- Query 20: Adoption rate of each add-on service by churn label
-- For each service, what % of churned vs retained customers subscribed?
SELECT
    'OnlineSecurity'  AS service,
    ROUND(AVG(CASE WHEN Churn='No'  AND OnlineSecurity='Yes'  THEN 1.0 ELSE 0 END) * 100, 1) AS retained_pct,
    ROUND(AVG(CASE WHEN Churn='Yes' AND OnlineSecurity='Yes'  THEN 1.0 ELSE 0 END) * 100, 1) AS churned_pct
FROM customers
UNION ALL
SELECT 'OnlineBackup',
    ROUND(AVG(CASE WHEN Churn='No'  AND OnlineBackup='Yes'    THEN 1.0 ELSE 0 END) * 100, 1),
    ROUND(AVG(CASE WHEN Churn='Yes' AND OnlineBackup='Yes'    THEN 1.0 ELSE 0 END) * 100, 1)
FROM customers
UNION ALL
SELECT 'DeviceProtection',
    ROUND(AVG(CASE WHEN Churn='No'  AND DeviceProtection='Yes' THEN 1.0 ELSE 0 END) * 100, 1),
    ROUND(AVG(CASE WHEN Churn='Yes' AND DeviceProtection='Yes' THEN 1.0 ELSE 0 END) * 100, 1)
FROM customers
UNION ALL
SELECT 'TechSupport',
    ROUND(AVG(CASE WHEN Churn='No'  AND TechSupport='Yes'     THEN 1.0 ELSE 0 END) * 100, 1),
    ROUND(AVG(CASE WHEN Churn='Yes' AND TechSupport='Yes'     THEN 1.0 ELSE 0 END) * 100, 1)
FROM customers
UNION ALL
SELECT 'StreamingTV',
    ROUND(AVG(CASE WHEN Churn='No'  AND StreamingTV='Yes'     THEN 1.0 ELSE 0 END) * 100, 1),
    ROUND(AVG(CASE WHEN Churn='Yes' AND StreamingTV='Yes'     THEN 1.0 ELSE 0 END) * 100, 1)
FROM customers
UNION ALL
SELECT 'StreamingMovies',
    ROUND(AVG(CASE WHEN Churn='No'  AND StreamingMovies='Yes' THEN 1.0 ELSE 0 END) * 100, 1),
    ROUND(AVG(CASE WHEN Churn='Yes' AND StreamingMovies='Yes' THEN 1.0 ELSE 0 END) * 100, 1)
FROM customers;


-- =============================================================================
-- GROUP F: HIGH-RISK COMBINATIONS AND WINDOW FUNCTIONS
-- =============================================================================

-- Query 21: Cross-tab — contract x internet service churn rate
-- Shows the interaction between two key predictors.
-- Month-to-month + Fiber Optic is the highest-risk combination.
SELECT
    Contract,
    InternetService,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM customers
GROUP BY Contract, InternetService
ORDER BY churn_rate_pct DESC;


-- Query 22: Top 15 highest-churn combinations (3-way: contract x internet x payment)
-- Minimum 50 customers required to avoid spurious rates in tiny cells.
SELECT
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
GROUP BY Contract, InternetService, PaymentMethod
HAVING COUNT(*) >= 50
ORDER BY churn_rate_pct DESC
LIMIT 15;


-- Query 23: Running total of churned customers ordered by TotalCharges
-- This window function accumulates churned customers as we move from the
-- highest-value to lowest-value customer. Useful for understanding which
-- value tier most churners fall into.
-- Note: SQLite supports window functions from version 3.25+.
SELECT
    customerID,
    Churn,
    ROUND(TotalCharges, 2)   AS total_charges,
    SUM(ChurnFlag) OVER (
        ORDER BY TotalCharges DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                        AS running_churned_count,
    COUNT(*) OVER (
        ORDER BY TotalCharges DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                        AS running_total_customers
FROM customers
ORDER BY TotalCharges DESC
LIMIT 50;


-- Query 24: Rank customers by monthly charges within each contract type
-- RANK() assigns position 1 to the highest-paying customer in each group.
-- This can help identify the most financially significant at-risk customers.
SELECT
    customerID,
    Contract,
    ROUND(MonthlyCharges, 2) AS monthly_charges,
    Churn,
    RANK() OVER (
        PARTITION BY Contract
        ORDER BY MonthlyCharges DESC
    ) AS rank_in_contract
FROM customers
WHERE ChurnFlag = 1
ORDER BY Contract, rank_in_contract
LIMIT 30;


-- Query 25: Percentage contribution of each contract type to total churn
-- Uses a subquery to get the total churned count, then expresses each group
-- as a share of the whole.
SELECT
    Contract,
    SUM(ChurnFlag)                                              AS churned,
    ROUND(
        1.0 * SUM(ChurnFlag)
        / (SELECT SUM(ChurnFlag) FROM customers) * 100, 1
    )                                                           AS pct_of_all_churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1)            AS churn_rate_within_group
FROM customers
GROUP BY Contract
ORDER BY churned DESC;


-- =============================================================================
-- GROUP G: ADDITIONAL ANALYSIS QUERIES
-- =============================================================================

-- Query 26: High-risk segment definition and metrics
-- Rule: Month-to-month + tenure <= 12 months + MonthlyCharges >= $65
-- This is the same rule-based segment defined in notebook 04.
SELECT
    COUNT(*)                                        AS segment_customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(SUM(MonthlyCharges), 2)                   AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN ChurnFlag=1 THEN MonthlyCharges ELSE 0 END), 2)
                                                    AS monthly_revenue_at_risk,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges,
    ROUND(AVG(tenure), 1)                           AS avg_tenure_months
FROM customers
WHERE Contract = 'Month-to-month'
  AND tenure <= 12
  AND MonthlyCharges >= 65;


-- Query 27: Month-to-month customers with no add-ons (maximum vulnerability)
-- No add-ons means no product stickiness beyond the core plan.
SELECT
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM customers
WHERE Contract = 'Month-to-month'
  AND AddonCount = 0;


-- Query 28: Electronic check users on month-to-month contracts
-- Combining the two highest individual churn-rate factors.
SELECT
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct,
    ROUND(AVG(tenure), 1)                           AS avg_tenure,
    ROUND(AVG(MonthlyCharges), 2)                   AS avg_monthly_charges
FROM customers
WHERE PaymentMethod = 'Electronic check'
  AND Contract = 'Month-to-month';


-- Query 29: New customers (tenure <= 6 months) by internet service
-- Very early-tenure customers are the most volatile. Breaking them down
-- by internet service shows whether Fiber Optic new customers are even
-- riskier than the overall new-customer segment.
SELECT
    InternetService,
    COUNT(*)                                        AS customers,
    SUM(ChurnFlag)                                  AS churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1) AS churn_rate_pct
FROM customers
WHERE tenure <= 6
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- Query 30: Summary reconciliation check
-- Verify that Python and SQL produce identical headline numbers.
-- Expected: total_customers=7043, total_churned=1869, churn_rate_pct=26.5
SELECT
    COUNT(*)                                              AS total_customers,
    SUM(ChurnFlag)                                        AS total_churned,
    ROUND(1.0 * SUM(ChurnFlag) / COUNT(*) * 100, 1)      AS churn_rate_pct,
    ROUND(SUM(MonthlyCharges), 2)                         AS total_monthly_revenue,
    ROUND(AVG(tenure), 2)                                 AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2)                         AS avg_monthly_charges,
    ROUND(SUM(TotalCharges), 2)                           AS total_billed_all_time
FROM customers;
