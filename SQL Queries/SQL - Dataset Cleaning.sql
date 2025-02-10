-- Finding duplicate values:

WITH RowNumber AS (
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY 
							name, 
							age, 
							gender, 
							blood_type, 
							medical_condition, 
							date_of_admission, 
							doctor, 
							hospital, 
							insurance_provider, 
							billing_amount, 
							room_number, 
							admission_type, 
							discharge_date, 
							medication, 
							test_results) AS rn
	FROM healthcare_dataset)
SELECT 
	*
FROM RowNumber 
WHERE rn > 1;

-- Removing duplicate values:

WITH RowNumber AS (
	SELECT 
		record_id,
		ROW_NUMBER() OVER (PARTITION BY 
							name, 
							age, 
							gender, 
							blood_type, 
							medical_condition, 
							date_of_admission, 
							doctor, hospital, 
							insurance_provider, 
							billing_amount, 
							room_number, 
							admission_type, 
							discharge_date, 
							medication, 
							test_results) AS rn
	FROM healthcare_dataset)
DELETE FROM healthcare_dataset
WHERE record_id IN (
			SELECT record_id 
			 FROM RowNumber 
			 WHERE rn > 1
);

-- Finding spelling/grammar mistakes:

SELECT 
	gender,
	COUNT(gender) AS count
FROM healthcare_dataset
GROUP BY gender
ORDER BY count DESC;

SELECT 
	medical_condition,
	COUNT(medical_condition) AS count
FROM healthcare_dataset
GROUP BY medical_condition
ORDER BY count DESC;

SELECT 
	insurance_provider,
	COUNT(insurance_provider) AS count
FROM healthcare_dataset
GROUP BY insurance_provider
ORDER BY count DESC;

SELECT 
	medication,
	COUNT(medication) AS count
FROM healthcare_dataset
GROUP BY medication
ORDER BY count DESC;

-- Fixing spelling/grammar mistakes:

UPDATE healthcare_dataset
SET gender = 'Male'
WHERE 
	gender = 'Mael';
	
UPDATE healthcare_dataset 
SET insurance_provider = 'Aetna'
WHERE 
	insurance_provider = 'Atena';

UPDATE healthcare_dataset 
SET medication = 'Penicillin'
WHERE 
	medication ILIKE '%penicillin%' OR 
	medication = 'Penicilin' OR 
	medication = 'Pencillin';

UPDATE healthcare_dataset 
SET medical_condition = 'Cancer'
WHERE 
	medical_condition ILIKE '%cancer%';


-- Fixing string value errors in patient name column:

UPDATE healthcare_dataset 
SET name = LOWER(name);

UPDATE healthcare_dataset
SET name = INITCAP(name);

ALTER TABLE healthcare_dataset 
RENAME name TO patient_name;

-- Standardising date columns for future use:

ALTER TABLE healthcare_dataset 
ALTER COLUMN date_of_admission TYPE DATE USING date_of_admission::date;

ALTER TABLE healthcare_dataset 
ALTER COLUMN discharge_date TYPE DATE USING discharge_date::date;

UPDATE healthcare_dataset 
SET date_of_admission = TO_DATE(date_of_admission, 'YYYY-MM-DD');

UPDATE healthcare_dataset 
SET discharge_date = TO_DATE(discharge_date , 'YYYY-MM-DD');

-- Altering billing_amount data type from float to integer:

ALTER TABLE healthcare_dataset 
ALTER COLUMN billing_amount TYPE INT USING billing_amount::INTEGER;

-- Dataset is now cleaned, can do further analysis.
