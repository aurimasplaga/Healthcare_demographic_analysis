# 📊 Healthcare Demographics & Cost Analysis: Detailed Breakdown

###  ❓ Question Answered
**How do patient demographics (age, gender, and blood type) influence hospital costs and interactions with insurance providers?**

### 🎯 Project Goal
This project analyzes patient records and insurance claims using SQL and Power BI to uncover how demographics affect healthcare costs. The goal is to identify high-cost groups, optimize resource allocation, and provide actionable recommendations for hospitals and insurance providers.

### 📄 Project Overview
The project is divided into several key phases:
1. Data Collection & Preparation
2. Exploratory Data Analysis using SQL
3. Visualization with Power BI
4. Insights & Findings
5. Recommendations
6. Conclusion & Future Work

### 🛠 Technologies Used
- **SQL**: For data querying, aggregation, and analysis across various datasets (Employee, Product, Sales, etc.).
- **PostgreSQL**: The relational database used to store and manage the data for querying and analysis.
- **DBeaver**: The SQL client used to connect to and interact with the PostgreSQL database.
- **Excel**: For data manipulation and dataset cleaning.
- **Power BI**: For data visualization, creating dashboards, and presenting key insights.
- **GitHub**: For version control and project management.


---

# 1. Data Collection & Preparation

### Data Sources
- **Original Data Source:**  
  The initial dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/prasad22/healthcare-dataset), which provided a structured skeleton of patient and billing information.
- **Modifications Made:**  
  The original Kaggle dataset was not entirely realistic. To better reflect real-world scenarios, the dataset was modified using Python. This involved:
  - **Altering Data Values:** Adjusting patient demographics, billing amounts, and insurance details to mirror realistic distributions based on real life data.
  - **Restructuring the Data:** Retaining the original skeleton while changing the underlying data to improve accuracy and relevance.
  
### Data Cleaning & Transformation
- **Importing Data:**  
  Load the modified dataset from CSVs, Excel files, or directly from a database.
- **SQL-Based Data Cleaning:**  
  Use SQL queries to handle missing values, standardize formats, and filter out irrelevant entries.
- **Schema Development:**  
  Organize the cleaned data into a star schema, which optimizes the dataset for efficient querying and reporting.

> ![Star Schema Diagram](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Star%20Schema/Star_Schema.png)

---

## 2. Exploratory Data Analysis (EDA) Using SQL  

### 🔍 Initial Analysis  
- **Descriptive Statistics:** SQL queries were used to compute averages, medians, and distributions for key metrics such as patient age, billing amounts, and length of stay.  
- **Data Aggregation:** Grouped data by demographics (age, gender, blood type) to identify cost patterns and severity trends.  

### 📌 Example Query #1 
```sql
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
```

### Sample Query Results (Limit of 15)

| Blood Type | Condition              | Average Stay Duration  | Average Billing Amount    |
|------------|------------------------|---------|-----------|
| A-         | Traumatic Brain Injury  | 63.24   | 93227.43  |
| A-         | Sepsis                 | 69.91   | 88724.08  |
| A-         | Cancer                 | 46.39   | 42192.32  |
| A-         | Fractures              | 27.73   | 20154.01  |
| A-         | Obesity                | 20.14   | 7409.96   |
| A-         | Gallstones             | 14.12   | 6678.86   |
| A-         | Hypertension           | 17.52   | 4668.95   |
| A-         | Asthma                 | 12.82   | 4299.20   |
| A-         | Arthritis              | 11.92   | 2744.58   |
| A+         | Traumatic Brain Injury | 60.64   | 90359.21  |
| A+         | Sepsis                 | 69.77   | 90230.46  |
| A+         | Cancer                 | 46.11   | 42688.91  |
| A+         | Fractures              | 27.97   | 19836.77  |
| A+         | Gallstones             | 14.17   | 6471.25   |
| A+         | Obesity                | 18.29   | 6265.05   |

### 📌 Example Query #2

```sql
-- Hospital patient count and billing amount sum categorized by year:
WITH HospitalCount AS (
	SELECT 
		hospital, 
		EXTRACT(YEAR FROM date_of_admission) AS record_year, 
		COUNT(record_id) AS patient_count  -
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
INNER JOIN BillingAmount AS billa 
	ON hosp.hospital = billa.hospital  -- Joining on hospital name
	AND hosp.record_year = billa.record_year  -- Ensuring records match for the same year
ORDER BY
	record_year,  
	patient_count DESC,  
	billing_amount DESC;  
```

### Sample Query Results (Limit of 10)
| Hospital Name                   | Year | Patients | Revenue ($) |
|----------------------------------|------|----------|------------|
| Evercare Specialty Hospital     | 2022 | 777      | 23,317,616 |
| Pinecrest Regional Hospital     | 2022 | 769      | 21,317,165 |
| Greenwood General Hospital      | 2022 | 768      | 24,616,551 |
| Highland Care Clinic            | 2022 | 768      | 20,651,065 |
| Maplewood General Hospital      | 2022 | 762      | 23,237,966 |
| Starlight Health Clinic         | 2022 | 761      | 22,320,217 |
| Summit Health Center            | 2022 | 760      | 19,120,911 |
| Brightview Medical Center       | 2022 | 741      | 20,664,129 |
| Lakeside Memorial Hospital      | 2022 | 699      | 19,281,327 |
| River Valley Medical Center     | 2022 | 697      | 20,011,015 |

### 📌 Example Query #3
```sql
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
        SUM(billing_amount) AS total_billing, 
        ROUND(AVG(billing_amount), 2) AS average_billing 
    FROM healthcare_dataset 
    GROUP BY age_demographics
)
SELECT
    patient_count,
    age_demographics,
    total_billing,
    average_billing
FROM AgeDemographics
ORDER BY total_billing DESC;
```

### Sample Query Results
| Patients | Age Group            | Total Billing ($) | Avg. Billing per Patient ($) |
|----------|----------------------|------------------:|----------------------------:|
| 8,672    | Elderly (75+)        | 322,030,265      | 37,134.49                   |
| 10,256   | Old Adults (60-74)   | 297,428,082      | 29,000.40                   |
| 11,714   | Middle-age Adults (45-59) | 246,257,420  | 21,022.49                   |
| 11,008   | Early Adults (30-44) | 200,533,972      | 18,217.11                   |
| 7,338    | Young Adults (18-29) | 166,407,011      | 22,677.43                   |


[All SQL queries used for aggregating data can be found here.](https://github.com/aurimasplaga/Healthcare_demographic_analysis/tree/main/SQL%20Queries)

## 3. Visualization with Power BI

### Dynamic Dashboard with Bookmarks

This Power BI dashboard uses bookmarks to allow users to switch between different demographic analyses (Age, Gender, Blood Type). Instead of having multiple separate dashboards, users can navigate seamlessly through a single interactive report.

### Key Views:
Each demographic-specific dashboard provides insights into healthcare billing patterns, helping identify trends across different groups.

- **[Age Demographics](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Age%20Dashboard.png)**  
  *Breakdown of total medical costs and insurance coverage by age group.*

- **[Blood Type Demographics](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Blood%20Type%20Dashboard.png)**  
  *Analysis of billing trends based on blood type.*

- **[Gender Demographics](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Gender%20Dashboard.png)**  
  *Comparison of healthcare costs and insurance claims by gender.*

---

### **Insurance Provider Billings & Hospital Costs**
This Power BI dashboard provides an interactive view of **healthcare billing data**, focusing on **insurance provider distribution and top billing hospitals/clinics**.  

The visuals include:  
✅ **Card KPIs** summarizing total costs  
📊 **Bar and column charts** for provider billing analysis  
📈 **Histogram and scatter point charts** to highlight spending patterns  

> ![Power BI Dashboard Screenshot](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Billing%20Dashboard.png)



### Example Visuals
Below are example visuals showcasing demographic differences based on various condition attributes.
- **Age Group-wise Condition Severity Distribution:**
![Condition Severity By Age Group](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Condition%20Severity%20By%20Age%20Group.png)

- **Gender-Based Condition Type Distribution:**  
![Condition Type Based on Gender](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Condition%20Type%20Based%20on%20Gender.png)

- **Age Group-wise Admission Type Breakdown:**  
![Admission Type By Age Group](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Admission%20Type%20By%20Age%20Group.png)

[Interactive Dashboard template can be downloaded here](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Template/Healthcare_Demographic_Analysis.pbit)

---
## 4. Insights & Findings

### Main Insights

- **Demographics & Costs:**  
  - Older adults (60+) and males drive **higher healthcare costs** due to severe conditions, longer hospital stays, and higher billing amounts.  

- **Chronic vs. Acute Conditions:**  
  - Chronic diseases (arthritis, obesity) are more prevalent in **females and younger adults**, while acute conditions (sepsis, TBI, cancer) dominate **males and older patients**.  

- **Blood Type & Resource Utilization:**  
  - O+ and A+ patients consume the most resources due to their **higher prevalence**, while rare blood types (AB+, B-) incur **the highest costs per patient**.  

- **Severity & Billing Impact:**  
  - Severe conditions consistently lead to **higher costs**, especially for **elderly patients, males, and rare blood types (B-, AB-)**.  

- **Insurance & High-Cost Claims:**  
  - **UnitedHealthcare & Medicare** cover nearly **50% of all claims**, while only **4% of claims exceed $50K**, yet they account for a **major share of total billing**.  

- **Billing Trends:**  
  - **7.5% of claims exceed $100K**, primarily linked to **elderly patients and severe conditions**, while **63% of claims are under $10K**, reflecting lower-cost treatments.  

---

## 5. Recommendations

### Strategic Recommendations

- **Preventive Care & High-Cost Group Focus:**  
  - Implement **injury prevention** programs for young adults.  
  - Expand **chronic disease screenings** for older adults.  
  - Develop **targeted programs** for high-cost groups (elderly, males, rare blood types).  

- **Resource Allocation by Blood Type & Severity:**  
  - Prioritize **O+ and A+ patients** in resource planning.  
  - Establish **specialized care units** for severe conditions.  
  - Increase **preventive care efforts** for lower-cost cases.  

- **Cost Management & Facility Optimization:**  
  - Collaborate with **high-cost insurers** to reduce claims.  
  - Expand **hospital resources** for severe cases.  
  - Strengthen **clinic support** for chronic disease management.  

- **Strategic Facility Utilization:**  
  - Shift **routine cases to clinics** to ease hospital burden.  
  - Increase **hospital capacity** for emergencies.  
  - Launch **community outreach programs** to optimize healthcare access.  

---

## 6. Conclusion & Future Work

### Project Summary
The analysis confirms that **patient demographics**—including age, gender, and blood type—significantly impact **healthcare costs, condition severity, and insurance claims**.  

Insights from **SQL queries and Power BI dashboards** reveal key trends in **high-cost groups, facility utilization, and billing distributions**, leading to **data-driven recommendations** for optimizing healthcare resources.  

### Future Directions

- **Enhanced Predictive Analytics:**  
  - Implement **risk prediction models** to forecast **high-cost claims** and **severe cases** based on demographic trends.  

- **Expanded Data Integration:**  
  - Incorporate **hospital location, medical history, and treatment outcomes** for deeper insights.  

- **Real-Time Dashboards:**  
  - Integrate **live data** in Power BI to enable **real-time monitoring** of patient trends and resource allocation.  

- **Policy & Cost Optimization:**  
  - Work with **insurance providers** and **healthcare administrators** to implement **cost-saving strategies** for high-risk patient groups.  

By leveraging **data analytics, strategic planning, and continuous improvement**, this project provides a foundation for **reducing healthcare costs, improving patient care, and enhancing operational efficiency**.

