-- Gender demographic medical condition severity total and percentages:

WITH GenderDemographics AS (
	SELECT
    	condition_severity,
        gender,
        COUNT(record_id) AS patient_count_separate
    FROM healthcare_dataset 
    GROUP BY 
    	gender, 
    	condition_severity
    ORDER BY 
    	patient_count_separate DESC
),
TotalPatientCount AS (
	SELECT 
        gender,
        COUNT(record_id) AS patient_count_total
    FROM healthcare_dataset
    GROUP BY 
   		gender
)
SELECT
    dem.gender,
    dem.condition_severity,
    dem.patient_count_separate,
    cnt.patient_count_total,
    ROUND((CAST(dem.patient_count_separate AS DECIMAL) / cnt.patient_count_total) * 100, 2) AS "percentage (%)"
FROM GenderDemographics AS dem
JOIN TotalPatientCount cnt ON
	dem.gender = cnt.gender
ORDER BY 
	dem.gender, 
	dem.condition_severity DESC;

-- Gender demographic average stay duration and average billing amount based on medical condition:

WITH AverageStay AS (
    SELECT
        gender,
        medical_condition,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration,
        COUNT(record_id) AS separate_count
    FROM healthcare_dataset
    GROUP BY 
        gender, medical_condition
    ORDER BY 
        gender, 
        average_stay_duration DESC
),
ConditionBillingAverage AS (
    SELECT
        gender,
        medical_condition,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount
    FROM healthcare_dataset
    GROUP BY
        gender, 
        medical_condition
)
SELECT 
    avst.gender,
    avst.medical_condition,
    avst.average_stay_duration,
    cbavg.average_billing_amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.medical_condition = cbavg.medical_condition
    AND avst.gender = cbavg.gender
ORDER BY 
    avst.gender, 
    cbavg.average_billing_amount DESC;

-- Gender Demographic average stay duration and average billing amount based on condition severity:

   WITH AverageStay AS (
    SELECT
        gender,
        condition_severity,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration,
        COUNT(record_id) AS separate_count
    FROM healthcare_dataset
    GROUP BY 
        gender, condition_severity
    ORDER BY 
        gender, average_stay_duration DESC
),
ConditionBillingAverage AS (
    SELECT
        gender,
        condition_severity,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount
    FROM healthcare_dataset
    GROUP BY
        gender, condition_severity
)
SELECT 
    avst.gender,
    avst.condition_severity,
    avst.average_stay_duration,
    cbavg.average_billing_amount
FROM AverageStay AS avst
INNER JOIN ConditionBillingAverage AS cbavg 
    ON avst.condition_severity = cbavg.condition_severity
    AND avst.gender = cbavg.gender
ORDER BY 
    avst.gender, 
    cbavg.average_billing_amount DESC;