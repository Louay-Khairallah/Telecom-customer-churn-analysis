-- All rates exclude Customer Status = 'Joined', matching the cleaned analysis.

-- Overall churn rate
SELECT
    COUNT(*) AS eligible_customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telecom_customer_churn_cleaned
WHERE "Customer Status" IN ('Stayed', 'Churned');

-- Churn by contract type
SELECT
    Contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telecom_customer_churn_cleaned
WHERE "Customer Status" IN ('Stayed', 'Churned')
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Churn by tenure bands
SELECT
    CASE
        WHEN "Tenure in Months" <= 6 THEN '0-6'
        WHEN "Tenure in Months" <= 12 THEN '7-12'
        WHEN "Tenure in Months" <= 24 THEN '13-24'
        WHEN "Tenure in Months" <= 48 THEN '25-48'
        WHEN "Tenure in Months" <= 72 THEN '49-72'
        ELSE '73+'
    END AS tenure_band,
    COUNT(*) AS customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telecom_customer_churn_cleaned
WHERE "Customer Status" IN ('Stayed', 'Churned')
GROUP BY tenure_band
ORDER BY MIN("Tenure in Months");

-- Churn by internet type
SELECT
    COALESCE(NULLIF("Internet Type", ''), 'No Internet') AS internet_type,
    COUNT(*) AS customers,
    SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN "Customer Status" = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telecom_customer_churn_cleaned
WHERE "Customer Status" IN ('Stayed', 'Churned')
GROUP BY internet_type
ORDER BY churn_rate_pct DESC;
