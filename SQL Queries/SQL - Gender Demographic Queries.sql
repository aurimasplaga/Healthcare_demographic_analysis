-- Gender demographic medical condition severity total and percentages:
WITH GenderDemographics AS (
	SELECT
    	condition_severity,
        gender,
        COUNT(record_id) AS patient_count_separate  -- Count of patients per gender and condition severity
    FROM healthcare_dataset 
    GROUP BY 
    	gender, 
    	condition_severity
    ORDER BY 
    	patient_count_separate DESC  -- Ordering by highest patient count for severity
),
TotalPatientCount AS (
	SELECT 
        gender,
        COUNT(record_id) AS patient_count_total  -- Total number of patients per gender
    FROM healthcare_dataset
    GROUP BY gender
)
SELECT
    dem.gender,
    dem.condition_severity,
    dem.patient_count_separate,  -- Patients for specific condition severity per gender
    cnt.patient_count_total,  -- Total patients for that gender
    ROUND((CAST(dem.patient_count_separate AS DECIMAL) / cnt.patient_count_total) * 100, 2) AS "percentage (%)"  -- Percentage of total
FROM GenderDemographics AS dem
JOIN TotalPatientCount cnt 
    ON dem.gender = cnt.gender  -- Joining to get total patient count for each gender
ORDER BY 
    dem.gender, 
    dem.condition_severity DESC;  -- Sorting by gender and then by condition severity

-- Gender demographic average stay duration and average billing amount based on medical condition:
WITH AverageStay AS (
    SELECT
        gender,
        medical_condition,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration,  -- Calculating average stay duration per gender and condition
        COUNT(record_id) AS separate_count  -- Counting the number of cases per gender and condition
    FROM healthcare_dataset
    GROUP BY gender, medical_condition
    ORDER BY 
        gender, 
        average_stay_duration DESC  -- Sorting by gender and highest stay duration
),
ConditionBillingAverage AS (
    SELECT
        gender,
        medical_condition,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount  -- Calculating average billing per gender and condition
    FROM healthcare_dataset
    GROUP BY gender, medical_condition
)
SELECT 
    avst.gender,
    avst.medical_condition,
    avst.average_stay_duration,  -- Fetching average stay duration
    cbavg.average_billing_amount  -- Fetching average billing amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.medical_condition = cbavg.medical_condition
    AND avst.gender = cbavg.gender  -- Joining on gender and medical condition
ORDER BY 
    avst.gender, 
    cbavg.average_billing_amount DESC;  -- Sorting by gender and highest billing amount

-- Gender demographic average stay duration and average billing amount based on condition severity:
WITH AverageStay AS (
    SELECT
        gender,
        condition_severity,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration,  -- Average stay duration per gender and condition severity
        COUNT(record_id) AS separate_count  -- Counting occurrences for each severity level
    FROM healthcare_dataset
    GROUP BY gender, condition_severity
    ORDER BY 
        gender, average_stay_duration DESC  -- Sorting by gender and highest stay duration
),
ConditionBillingAverage AS (
    SELECT
        gender,
        condition_severity,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount  -- Average billing per gender and condition severity
    FROM healthcare_dataset
    GROUP BY gender, condition_severity
)
SELECT 
    avst.gender,
    avst.condition_severity,
    avst.average_stay_duration,  -- Retrieving average stay duration
    cbavg.average_billing_amount  -- Retrieving average billing amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.condition_severity = cbavg.condition_severity
    AND avst.gender = cbavg.gender  -- Joining on gender and condition severity
ORDER BY 
    avst.gender, 
    cbavg.average_billing_amount DESC;  -- Sorting by gender and highest billing amount
