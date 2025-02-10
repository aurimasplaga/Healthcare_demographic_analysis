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

> 
> ![Star Schema Diagram](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Star%20Schema/Star_Schema.png)

---

## 2. Exploratory Data Analysis (EDA) Using SQL

### Initial Analysis
- **Descriptive Statistics:** Run SQL queries to calculate averages, medians, and distributions (e.g., patient age, billing amounts).
- **Data Aggregation:** Group data by demographics (age, gender, blood type) to understand cost patterns and severity levels.

### Sample SQL Query
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

## 3. Visualization with Power BI

### Dynamic Dashboard with Bookmarks

This Power BI dashboard uses bookmarks to allow users to switch between different demographic analyses (Age, Gender, Blood Type). Instead of having multiple separate dashboards, users can navigate seamlessly through a single interactive report.

### Key Views:
- **Cost by Age Group**  
  [Age Dashboard](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Age%20Dashboard.png)

- **Cost by Gender**  
  [Gender Dashboard](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Gender%20Dashboard.png)

- **Cost by Blood Type**  
  [Blood Type Dashboard](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Blood%20Type%20Dashboard.png) 

**Visual Elements:**  
- Develop charts, graphs, and tables to display key insights like cost distribution by demographics and insurance trends.

> **Placeholder:**  
> ![Power BI Dashboard Screenshot](https://github.com/aurimasplaga/Healthcare_demographic_analysis/blob/main/Dashboards/Billing%20Dashboard.png)  
> *Include a sample screenshot of your Power BI dashboard here.*

### Key Visuals in the Dashboard

- **Cost Breakdown:**  
  Comparison of costs across different age groups, genders, and blood types.

- **Insurance Analysis:**  
  Visuals illustrating how different insurance providers are impacted by high-cost claims.

- **Facility Utilization:**  
  Charts comparing hospital and clinic billing for severe versus routine cases.

---

## 4. Insights & Findings

### Main Insights


- **Demographics & Costs:**
  - Older patients (60+) and males drive higher healthcare costs due to severe conditions, longer hospital stays, and higher billing amounts.
- **Chronic vs. Acute Conditions:**
  - Chronic diseases (arthritis, obesity) are more common in females and younger adults, while acute conditions (sepsis, TBI, cancer) dominate males and older patients.
- **Blood Type & Resource Utilization:**
  - O+ and A+ patients consume the most resources due to their prevalence, while rare blood types (AB+, B-) incur the highest costs per patient.
- **Severity & Billing Impact:**
  - Severe conditions consistently lead to higher costs, especially for elderly patients, males, and rare blood types (B-, AB-).
- **Insurance & High-Cost Claims:**
  - UnitedHealthcare & Medicare cover nearly 50% of all claims, while only 4% exceed $50K, yet these account for a major share of total billing.
- **Billing Trends:**
  7.5% of claims exceed $100K, mostly linked to elderly patients and severe conditions, while 63% of claims remain under $10K, reflecting lower-cost treatments.

---

## 5. Recommendations

### Strategic Recommendations

- **Preventive Care & High-Cost Group Focus:**
  - Implement injury prevention for young adults, chronic disease screenings for older adults, and targeted programs for high-cost groups (elderly, males, rare blood types).
- **Resource Allocation by Blood Type & Severity:**
  - Prioritize O+ and A+ patients, develop specialized care units for severe conditions, and allocate preventive care for lower-cost cases.
- **Cost Management & Facility Optimization:**
  - Collaborate with high-cost insurers to reduce claims, expand hospital resources for severe cases, and strengthen clinic support for chronic care.
- **Strategic Facility Utilization:**
  - Shift routine cases to clinics, increase hospital capacity for emergencies, and launch community outreach programs to optimize healthcare access.

---

## 6. Conclusion & Future Work

### Project Summary

## 6. Conclusion & Future Work

### Project Summary
The analysis confirms that patient demographics—including age, gender, and blood type—significantly impact healthcare costs, condition severity, and insurance claims. Insights from SQL queries and Power BI dashboards highlight key trends in high-cost groups, facility utilization, and billing distributions, leading to data-driven recommendations for optimizing healthcare resources.


### Future Directions
- **Enhanced Predictive Analytics:** Implement risk prediction models to forecast high-cost claims and severe cases based on demographic trends.
- **Expanded Data Integration:** Incorporate additional variables such as hospital location, medical history, and treatment outcomes for deeper insights.
- **Real-Time Dashboards:** Improve Power BI dashboards with live data integration to enable real-time monitoring of patient trends and resource allocation.
- **Policy & Cost Optimization:** Work closely with insurance providers and healthcare administrators to implement cost-saving strategies based on high-risk patient groups.

By leveraging data analytics, strategic planning, and continuous improvement, this project provides a strong foundation for reducing healthcare costs, improving patient care, and enhancing operational efficiency.
