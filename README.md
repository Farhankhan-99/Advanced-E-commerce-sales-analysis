# E-commerce Advanced Sales Analysis
Advanced e-commerce sales analysis using SQL and Power BI to drive data-driven business decisions. This project leverages PostgreSQL for comprehensive data exploration and transformation, combined with interactive Power BI dashboards to uncover actionable insights on customer segmentation, product performance, and revenue optimization.

---

## 📊 Overview
This project provides an end-to-end analysis of e-commerce sales data spanning multiple years. Using PostgreSQL for robust data processing and Power BI Desktop for dynamic visualizations, it delivers strategic insights into customer behavior, product trends, regional performance, and forecasting capabilities to empower data-driven decision-making.

---

## 💼 Business Questions

### **Exploratory Data Analysis (EDA)**
1. What are all the available countries in our customer database and what unique product categories exist in inventory?
2. What is the timeframe of available sales data and who are the youngest and oldest customers?
3. What are the key business metrics: total sales, quantity sold, average price, total orders, and customer counts?
4. How many customers exist by country and gender distribution?
5. What is the product distribution across categories and average cost per category?
6. How is total revenue distributed across product categories and customer segments?
7. What is the distribution of sold items across different countries?
8. Which are the top 5 revenue-generating products and bottom 5 underperforming products?
9. Who are the top 10 customers by revenue and top 3 customers with fewest orders placed?

### **Advanced Analytics**
10. How have sales, customer counts, and quantities changed over time on a monthly and yearly basis?
11. What are the cumulative sales trends with running totals and moving average prices over time?
12. How does each product's current year sales compare to its historical average and previous year performance?
13. What percentage contribution does each product category make to overall sales revenue?
14. How are products segmented across different cost ranges and what is the distribution?
15. How can customers be classified into VIP, Regular, and New segments based on spending and tenure?
16. What are customer-level KPIs including recency, average order value, lifetime value, and monthly spending patterns?
17. What are product-level KPIs including recency, average order revenue, total customers served, and revenue performance segments?

---

## 🔍 Key Analysis & Insights

- **Dimensional Exploration:** Identified unique countries, product categories, subcategories, and customer demographics across the database
- **Temporal Analysis:** Analyzed 3 years of sales data (2022-2024) with identification of oldest and youngest customers
- **Performance Metrics:** Calculated total sales ($29.3M), total orders (18K), quantities sold (60K), and average pricing
- **Customer Analytics:** Segmented 18K+ customers into VIP (12+ months history, >$5000 spend), Regular (12+ months, ≤$5000), and New (<12 months)
- **Product Performance Ranking:** Identified top 5 revenue-generating products and bottom 5 underperformers requiring attention
- **Revenue Distribution:** Bikes category dominates with 96.5% contribution, followed by Accessories at 2.4%
- **Geographic Insights:** North America leads regional sales with $10.4M, followed by South ($7.1M) and East/West ($5.9M each)
- **Year-over-Year Analysis:** Tracked product performance changes with comparative metrics showing -56% YOY decline
- **Cumulative Metrics:** Implemented running totals and moving average price analysis for trend identification
- **Cost Segmentation:** Distributed products across price brackets (Below $100, $100-500, $500-1000, Above $1000)
- **Customer Behavioral Patterns:** Analyzed order frequency, lifetime value, recency, and average order values
- **Product Lifecycle Metrics:** Tracked product lifespan, recency since last sale, and monthly revenue patterns

---
## 📈 Power BI Dashboard Insights

**Dashboard 1: Sales Overview**
- Total revenue of $29.3M generated from 18K orders with 60K units sold across 3 years
- Year-over-year performance shows -56% decline, indicating need for strategic intervention
- Male customers dominate with 74.3% of sales vs 25.7% female customers
- Bikes category accounts for 96.5% of revenue with Road Bikes (51.3%) as top subcategory
- Age group 40-50 years represents the highest revenue segment ($5.7M), followed by 30-40 ($5.7M)
- UPI payment method preferred by 47.7% customers, followed by Card (32.1%) and COD (20.2%)
- North America region leads with $10.4M sales, Standard shipping mode accounts for 15M in orders
- Monthly sales trends show seasonal patterns with peaks in mid-year periods

**Dashboard 2: Sales Forecasting**
- 15-day sales forecast model predicting revenue trends ranging from 28K to 55K daily
- California emerges as top state with $2.9M sales, followed by Texas ($2.5M) and New York ($1.9M)
- Historical trend analysis from 2022-2024 shows growth trajectory with forecasted stabilization
- Top 10 states contribute significantly with Michigan at $0.9M marking the entry threshold

---

## 🛠️ Technologies
**Database:** PostgreSQL | **Visualization:** Power BI Desktop | **Language:** SQL

---

## 📧 Contact
**Farhan Khan**  
📧 Email: farhanriyaz9005@gmail.com  
💼 LinkedIn: [www.linkedin.com/in/farhankhan999](https://www.linkedin.com/in/farhankhan999)
