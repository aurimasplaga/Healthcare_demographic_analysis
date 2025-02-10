-- Blood demographic count, total billing and average billing amount:

SELECT
	count(record_id) AS patient_count,
	blood_type,
	SUM(billing_amount) AS total_billing,
	ROUND(AVG(billing_amount),2) AS average_billing
FROM healthcare_dataset
GROUP BY
	blood_type
ORDER BY 
	total_billing DESC;


-- Blood demographic medical condition severity total and percentages:

WITH BloodDemographics AS (
	SELECT
    	condition_severity,
        blood_type,
        COUNT(record_id) AS patient_count_separate
    FROM healthcare_dataset 
    GROUP BY 
    	blood_type, 
    	condition_severity
    ORDER BY 
    	patient_count_separate DESC
),
TotalPatientCount AS (
	SELECT 
        blood_type ,
        COUNT(record_id) AS patient_count_total
    FROM healthcare_dataset
    GROUP BY 
   		blood_type
)
SELECT
    dem.blood_type,
    dem.condition_severity,
    dem.patient_count_separate,
    cnt.patient_count_total,
    ROUND((CAST(dem.patient_count_separate AS DECIMAL) / cnt.patient_count_total) * 100, 2) AS "percentage (%)"
FROM BloodDemographics AS dem
JOIN TotalPatientCount cnt ON
	dem.blood_type = cnt.blood_type
ORDER BY 
	dem.blood_type, 
	dem.condition_severity DESC;

-- Blood demographic average stay duration and average billing amount based on medical condition:

WITH AverageStay AS (
    SELECT
        blood_type,
        medical_condition,
        ROUND(AVG(stay_duration), 2) AS average_stay_duration,
        COUNT(record_id) AS separate_count
    FROM healthcare_dataset
    GROUP BY 
        blood_type, 
        medical_condition
    ORDER BY 
        blood_type, 
        average_stay_duration DESC
),
ConditionBillingAverage AS (
    SELECT
        blood_type,
        medical_condition,
        ROUND(AVG(billing_amount), 2) AS average_billing_amount
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


