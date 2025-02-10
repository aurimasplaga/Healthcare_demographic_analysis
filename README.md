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

Dashboard Development
Interactive Reports: Build dynamic dashboards that integrate SQL query results.
Visual Elements: Develop charts, graphs, and tables to display key insights like cost distribution by demographics and insurance trends.
Placeholder:

Include a sample screenshot of your Power BI dashboard here.

Key Visuals in the Dashboard
Cost Breakdown: Comparison of costs across different age groups, genders, and blood types.
Insurance Analysis: Visuals illustrating how different insurance providers are impacted by high-cost claims.
Facility Utilization: Charts comparing hospital and clinic billing for severe versus routine cases.
4. Insights & Findings
Main Insights
Demographic Impact: Patient age, gender, and blood type play significant roles in determining hospital costs and case severity.
High-Cost Groups: Older patients (60+) and males are identified as high-cost segments due to severe conditions and longer hospital stays.
Blood Type Trends: Common blood types (O+ and A+) drive the majority of cases, while rarer types (AB+, B-) incur higher costs per patient.
Insurance Provider Dynamics: Although UnitedHealthcare and Medicare cover most claims, Cigna is linked with the highest average claim amounts.
Facility Utilization: Hospitals are primarily responsible for handling severe cases, whereas clinics tend to manage routine and chronic conditions.
Placeholder:
Optionally, insert a summarized table or chart here that encapsulates the key insights.

5. Recommendations
Strategic Recommendations
Targeted Preventive Care: Implement programs focusing on high-risk groups, such as elderly patients and males.
Resource Optimization: Enhance hospital capacity for severe cases and bolster clinic support for chronic care management.
Streamlined Insurance Processes: Work closely with high-cost insurers like Cigna, and improve processes for Medicare and UnitedHealthcare.
Data-Driven Decisions: Develop an integrated reporting system using SQL and Power BI to continuously monitor high-risk demographics and optimize operational strategies.
6. Conclusion & Future Work
Project Summary
The analysis confirms that patient demographics significantly influence healthcare costs and insurance interactions.
Actionable insights from SQL queries and Power BI visualizations drive targeted recommendations for resource allocation and cost management.
Future Directions
Advanced Analytics: Explore predictive modeling techniques for forecasting high-cost claims.
Data Enrichment: Integrate additional data sources to provide more granular insights.
Dashboard Enhancements: Continue refining Power BI dashboards for real-time data integration and enhanced interactivity.
Appendices & Additional Resources
Detailed SQL Queries: View SQL Scripts
Power BI Report Files: Download PBIX
Data Cleaning Documentation: Review Documentation
