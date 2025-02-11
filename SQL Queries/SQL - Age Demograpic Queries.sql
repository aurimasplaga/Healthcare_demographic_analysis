-- Age demographic classification:

SELECT
    count(record_id) AS patient_count, -- Counting total patients in each age group
    CASE 
        WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
        WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
        WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
        WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
        WHEN age >= 75 THEN 'Elderly (75+)'
        ELSE 'Uncategorised' -- Handles cases where age is NULL or out of expected range
    END AS age_demographics
FROM healthcare_dataset
GROUP BY 
    age_demographics -- Groups data by classified age groups
ORDER BY 
    patient_count DESC; -- Sorts by the largest patient group first

-- Age demographic count, total billing and average billing amount:

WITH AgeDemographics AS (
    SELECT
        COUNT(record_id) AS patient_count, -- Number of patients per age group
        CASE 
            WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
            WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
            WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
            WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
            WHEN age >= 75 THEN 'Elderly (75+)'
            ELSE 'Uncategorised'
        END AS age_demographics,
        SUM(billing_amount) AS total_billing, -- Summing total billing for each age group
        ROUND(AVG(billing_amount), 2) AS average_billing -- Calculating average billing per patient
    FROM healthcare_dataset 
    GROUP BY age_demographics
)
SELECT
    patient_count,
    age_demographics,
    total_billing,
    average_billing
FROM AgeDemographics
ORDER BY total_billing DESC; -- Sorting by highest total billing


-- Age demographic medical condition severity total and percentages:

WITH AgeDemographics AS (
    SELECT
        condition_severity, -- Severity level of medical conditions
        CASE 
            WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
            WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
            WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
            WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
            WHEN age >= 75 THEN 'Elderly (75+)'
            ELSE 'Uncategorised'
        END AS age_demographics,
        COUNT(record_id) AS patient_count_separate -- Counting patients for each severity level
    FROM healthcare_dataset 
    GROUP BY age_demographics, condition_severity
),
TotalPatientCount AS (
    SELECT 
        CASE 
            WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
            WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
            WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
            WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
            WHEN age >= 75 THEN 'Elderly (75+)'
            ELSE 'Uncategorised'
        END AS age_demographics,
        COUNT(record_id) AS patient_count_total -- Total patient count per age group
    FROM healthcare_dataset
    GROUP BY age_demographics
)
SELECT
    dem.age_demographics,
    dem.condition_severity,
    dem.patient_count_separate,
    cnt.patient_count_total,
    ROUND((CAST(dem.patient_count_separate AS DECIMAL) / cnt.patient_count_total) * 100, 2) AS "percentage (%)"
FROM AgeDemographics AS dem
JOIN TotalPatientCount cnt ON
    dem.age_demographics = cnt.age_demographics -- Joining to get total patients for percentage calculation
ORDER BY 
    dem.age_demographics, 
    dem.condition_severity DESC;


-- Age demographic average stay duration and average billing amount based on medical condition:

WITH AverageStay AS (
    SELECT
        CASE 
            WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
            WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
            WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
            WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
            WHEN age >= 75 THEN 'Elderly (75+)'
            ELSE 'Uncategorised'
        END AS age_demographics,
        medical_condition,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration, -- Average stay duration per condition
        COUNT(record_id) AS separate_count -- Count of patients per condition
    FROM proj.healthcare_dataset
    GROUP BY age_demographics, medical_condition
),
ConditionBillingAverage AS (
    SELECT
        CASE 
            WHEN age BETWEEN 18 AND 29 THEN 'Young Adults (18-29)'
            WHEN age BETWEEN 30 AND 44 THEN 'Early Adults (30-44)'
            WHEN age BETWEEN 45 AND 59 THEN 'Middle-age Adults (45-59)'
            WHEN age BETWEEN 60 AND 74 THEN 'Old Adults (60-74)'
            WHEN age >= 75 THEN 'Elderly (75+)'
            ELSE 'Uncategorised'
        END AS age_demographics,
        medical_condition,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount -- Average billing per condition
    FROM proj.healthcare_dataset
    GROUP BY age_demographics, medical_condition
)
SELECT 
    avst.age_demographics,
    avst.medical_condition,
    avst.average_stay_duration,
    cbavg.average_billing_amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.medical_condition = cbavg.medical_condition
    AND avst.age_demographics = cbavg.age_demographics -- Ensuring data is matched at both condition and age group levels
