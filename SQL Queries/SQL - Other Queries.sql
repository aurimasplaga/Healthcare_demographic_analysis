-- Billing amount ordered by length of stay and billing amount:
SELECT 
	stay_duration,  -- Duration of stay in the hospital
	billing_amount, -- Total billing amount for the stay
	medical_condition,  -- Medical condition diagnosed
	condition_severity, -- Severity of the medical condition
	admission_type  -- Type of hospital admission (e.g., emergency, elective)
FROM healthcare_dataset
ORDER BY 
	stay_duration DESC,  -- Sorting by longest stay duration first
	billing_amount DESC;  -- Sorting by highest billing amount within same stay duration

-- Average billing amount based on medical condition and condition severity:
SELECT 
	medical_condition,  -- Medical condition diagnosed
	condition_severity,  -- Severity level of the condition
	ROUND(AVG(billing_amount), 2) AS average_billing_amount  -- Average billing amount for the condition and severity
FROM healthcare_dataset
GROUP BY 
	medical_condition, 
	condition_severity
ORDER BY 
	medical_condition,  -- Sorting alphabetically by medical condition
	condition_severity;  -- Sorting by severity level

-- Average length of stay for each medical condition and condition severity:
SELECT 
	medical_condition,  -- Medical condition diagnosed
	condition_severity,  -- Severity level of the condition
	ROUND(AVG(stay_duration), 2) AS average_stay_duration  -- Calculating the average stay duration
FROM healthcare_dataset
GROUP BY 
	medical_condition, 
	condition_severity
ORDER BY 
	medical_condition,  -- Sorting alphabetically by medical condition
	condition_severity;  -- Sorting by severity level

-- Billing amount sum and average categorized by admission type:
SELECT 
	admission_type,  -- Type of hospital admission (e.g., emergency, elective)
	SUM(billing_amount) AS billing_sum,  -- Total billing amount for each admission type
	ROUND(AVG(billing_amount), 2) AS billing_average  -- Average billing amount per admission type
FROM healthcare_dataset
GROUP BY 
	admission_type;

-- Insurance provider claim count, billing amount sum and average, and provider ratio:
WITH ProviderCount AS (
	SELECT
		COUNT(record_id) AS claim_count,  -- Number of claims per provider
		insurance_provider,  -- Name of the insurance provider
		SUM(Billing_amount) AS claim_billing_sum,  -- Total billing amount covered by each provider
		ROUND(AVG(billing_amount), 2) AS claim_average  -- Average billing amount per claim
	FROM healthcare_dataset
	GROUP BY 
		insurance_provider
)
SELECT
	insurance_provider,  -- Name of the insurance provider
	claim_count,  -- Total number of claims handled by the provider
	ROUND(claim_count / SUM(claim_count) OVER (), 4) AS provider_ratio,  -- Percentage of total claims handled by the provider
	claim_billing_sum,  -- Total billing amount processed by the provider
	claim_average  -- Average billing amount per claim for the provider
FROM ProviderCount
ORDER BY 
	provider_ratio DESC;  -- Sorting by highest claim share percentage

-- Hospital patient count and billing amount sum categorized by year:
WITH HospitalCount AS (
	SELECT 
		hospital,  -- Name of the hospital
		EXTRACT(YEAR FROM date_of_admission) AS record_year,  -- Extracting the year of admission
		COUNT(record_id) AS patient_count  -- Counting the number of patients per hospital and year
	FROM healthcare_dataset
	GROUP BY
		record_year,
		hospital
	ORDER BY
		record_year,  -- Sorting by year
		patient_count DESC  -- Sorting by hospital with the highest patient count in that year
),
BillingAmount AS (
	SELECT
		hospital,  -- Name of the hospital
		EXTRACT(YEAR FROM date_of_admission) AS record_year,  -- Extracting the year of admission
		SUM(billing_amount) AS billing_amount  -- Total billing amount per hospital and year
	FROM healthcare_dataset
	GROUP BY
		record_year,
		hospital
	ORDER BY
		record_year,  -- Sorting by year
		billing_amount DESC  -- Sorting by hospital with the highest billing amount in that year
)
SELECT
	hosp.hospital,  -- Hospital name
	hosp.record_year,  -- Year of admission
	patient_count,  -- Total patient count for the hospital in that year
	billing_amount  -- Total billing amount for the hospital in that year
FROM HospitalCount AS hosp
INNER JOIN BillingAmount AS billa 
	ON hosp.hospital = billa.hospital  -- Joining on hospital name
	AND hosp.record_year = billa.record_year  -- Ensuring records match for the same year
ORDER BY
	record_year,  -- Sorting by year
	patient_count DESC,  -- Sorting by highest patient count
	billing_amount DESC;  -- Sorting by highest billing amount in case of ties
