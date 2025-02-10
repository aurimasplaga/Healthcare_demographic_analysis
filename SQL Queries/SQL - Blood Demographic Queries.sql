-- Blood demographic count, total billing and average billing amount:

SELECT
    COUNT(record_id) AS patient_count, -- Number of patients per blood type
    blood_type, -- Blood type classification
    SUM(billing_amount) AS total_billing, -- Total billing per blood type
    ROUND(AVG(billing_amount), 2) AS average_billing -- Average billing per patient in each blood type
FROM healthcare_dataset
GROUP BY 
    blood_type
ORDER BY 
    total_billing DESC; -- Sorting by highest total billing

-- Blood demographic medical condition severity total and percentages:

WITH BloodDemographics AS (
    SELECT
        condition_severity, -- Severity level of conditions
        blood_type,
        COUNT(record_id) AS patient_count_separate -- Count per severity level
    FROM healthcare_dataset 
    GROUP BY 
        blood_type, 
        condition_severity
),
TotalPatientCount AS (
    SELECT 
        blood_type,
        COUNT(record_id) AS patient_count_total -- Total patients per blood type
    FROM healthcare_dataset
    GROUP BY 
        blood_type
)
SELECT
    dem.blood_type,
    dem.condition_severity,
    dem.patient_count_separate,
    cnt.patient_count_total,
    ROUND((CAST(dem.patient_count_separate AS DECIMAL) / cnt.patient_count_total) * 100, 2) AS "percentage (%)" -- Percentage calculation
FROM BloodDemographics AS dem
JOIN TotalPatientCount cnt 
    ON dem.blood_type = cnt.blood_type
ORDER BY 
    dem.blood_type, 
    dem.condition_severity DESC;

-- Blood demographic average stay duration and average billing amount based on medical condition:

WITH AverageStay AS (
    SELECT
        blood_type,
        medical_condition,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration, -- Average duration of hospital stay
        COUNT(record_id) AS separate_count -- Number of cases for each blood type and condition
    FROM healthcare_dataset
    GROUP BY 
        blood_type, 
        medical_condition
),
ConditionBillingAverage AS (
    SELECT
        blood_type,
        medical_condition,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount -- Average billing for each condition
    FROM healthcare_dataset
    GROUP BY
        blood_type, 
        medical_condition
)
SELECT 
    avst.blood_type,
    avst.medical_condition,
    avst.average_stay_duration,
    cbavg.average_billing_amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.medical_condition = cbavg.medical_condition
    AND avst.blood_type = cbavg.blood_type
ORDER BY 
    avst.blood_type, 
    cbavg.average_billing_amount DESC;

