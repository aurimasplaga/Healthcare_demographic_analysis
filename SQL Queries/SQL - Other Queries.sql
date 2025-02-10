-- Billing amount based ordered by length of stay and billing amount:

SELECT 
	stay_duration ,
	billing_amount,
	medical_condition,
	condition_severity,
	admission_type
FROM healthcare_dataset
ORDER BY 
	stay_duration DESC,
	billing_amount DESC;

-- Average billing amount based on condition and severity:

SELECT 
	medical_condition,
	condition_severity,
	ROUND(AVG(billing_amount),2) AS average_billing_amount
FROM healthcare_dataset
GROUP BY 
	medical_condition, 
	condition_severity
ORDER BY 
	medical_condition, 
	condition_severity;

-- Average length of stay for a condition and condition severity:

SELECT 
	medical_condition,
	condition_severity,
	ROUND(AVG(stay_duration),2) AS average_stay_duration
FROM healthcare_dataset
GROUP BY 
	medical_condition, 
	condition_severity
ORDER BY 
	medical_condition, 
	condition_severity;

-- Billing amount and billing average based on admission type:

SELECT 
	admission_type,
	SUM(billing_amount) AS billing_sum,
	ROUND(AVG(billing_amount),2) AS billing_average
FROM healthcare_dataset
GROUP BY 
	admission_type;

-- Insurance provider claim count, billing amount sum and average, provider ratio:

WITH ProviderCount AS (
SELECT
	COUNT(record_id) AS claim_count,
	insurance_provider,
	SUM(Billing_amount) AS claim_billing_sum,
	ROUND(AVG(billing_amount), 2) AS claim_average
FROM healthcare_dataset
GROUP BY 
	insurance_provider
)
SELECT
	insurance_provider,
	claim_count,
	ROUND(claim_count / SUM(claim_count) OVER (),4) AS provider_ratio,
	claim_billing_sum,
	claim_average
FROM ProviderCount
ORDER BY 
	provider_ratio DESC;

-- Hospital patient count and billing amount sum categorised by year:

WITH HospitalCount AS (
SELECT 
	hospital,
	EXTRACT(YEAR FROM date_of_admission) AS record_year,
	COUNT(record_id) AS patient_count
FROM healthcare_dataset
GROUP BY
	record_year,
	hospital
ORDER BY
	record_year,
	patient_count DESC
),
BillingAmount AS (
SELECT
	hospital,
	EXTRACT(YEAR FROM date_of_admission) AS record_year,
	SUM(billing_amount) AS billing_amount
FROM healthcare_dataset
GROUP BY
	record_year,
	hospital
ORDER BY
	record_year,
	billing_amount DESC
)
SELECT
	hosp.hospital,
	hosp.record_year,
	patient_count,
	billing_amount
FROM HospitalCount AS hosp
INNER JOIN BillingAmount AS billa ON
	hosp.hospital = billa.hospital
	AND hosp.record_year = billa.record_year
ORDER BY
	record_year,
	patient_count DESC,
	billing_amount DESC;

