-- ============================================================
-- Consumer Shopping Behavior Survey — Database Setup & Cleaning
-- Tool: MySQL 8
-- ============================================================

USE shopping_behavior_portfolio;

-- Table created via MySQL Workbench "Table Data Import Wizard"
-- from the raw CSV (original: 500 rows, 30 columns).
-- Import auto-generated column types and skipped malformed rows,
-- leaving 333 rows to start with.

ALTER TABLE consumer_shopping_behavior_survey
ADD PRIMARY KEY (Response_ID);


-- 1. CHECK MISSING VALUES — core demographic fields
-- ------------------------------------------------------------
SELECT 
    SUM(CASE WHEN Gender = '' OR Gender IS NULL THEN 1 ELSE 0 END) AS blank_gender,
    SUM(CASE WHEN Country_Region = '' OR Country_Region IS NULL THEN 1 ELSE 0 END) AS blank_country,
    SUM(CASE WHEN Occupation_Status = '' OR Occupation_Status IS NULL THEN 1 ELSE 0 END) AS blank_occupation,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS blank_age
FROM consumer_shopping_behavior_survey;


-- 2. CLEAN — remove rows missing core demographic fields
-- ------------------------------------------------------------
-- Decision: Gender, Country, and Occupation are used in nearly every
-- chart, so rows missing any of them were removed rather than filled in.

SET SQL_SAFE_UPDATES = 0;

DELETE FROM consumer_shopping_behavior_survey 
WHERE Gender = '' 
   OR Country_Region = ''
   OR Occupation_Status = '';

SET SQL_SAFE_UPDATES = 1;

-- Result: 333 → 293 rows remaining


-- 3. CHECK MISSING VALUES — behavioral / payment fields
-- ------------------------------------------------------------
SELECT 
    SUM(CASE WHEN Monthly_Income_Range = '' OR Monthly_Income_Range IS NULL THEN 1 ELSE 0 END) AS blank_income,
    SUM(CASE WHEN Shop_Most_Where = '' OR Shop_Most_Where IS NULL THEN 1 ELSE 0 END) AS blank_shop_where,
    SUM(CASE WHEN Best_Shopping_Mode = '' OR Best_Shopping_Mode IS NULL THEN 1 ELSE 0 END) AS blank_shopping_mode,
    SUM(CASE WHEN Online_Shopping_Frequency = '' OR Online_Shopping_Frequency IS NULL THEN 1 ELSE 0 END) AS blank_frequency,
    SUM(CASE WHEN Top_Spending_Category = '' OR Top_Spending_Category IS NULL THEN 1 ELSE 0 END) AS blank_category,
    SUM(CASE WHEN Preferred_Platform = '' OR Preferred_Platform IS NULL THEN 1 ELSE 0 END) AS blank_platform,
    SUM(CASE WHEN Primary_Device = '' OR Primary_Device IS NULL THEN 1 ELSE 0 END) AS blank_device,
    SUM(CASE WHEN Preferred_Payment_Method = '' OR Preferred_Payment_Method IS NULL THEN 1 ELSE 0 END) AS blank_payment,
    SUM(CASE WHEN Uses_BNPL_Installments = '' OR Uses_BNPL_Installments IS NULL THEN 1 ELSE 0 END) AS blank_bnpl,
    SUM(CASE WHEN Return_Frequency = '' OR Return_Frequency IS NULL THEN 1 ELSE 0 END) AS blank_return,
    SUM(CASE WHEN Avg_Monthly_Spend_NonEssentials = '' OR Avg_Monthly_Spend_NonEssentials IS NULL THEN 1 ELSE 0 END) AS blank_spend,
    SUM(CASE WHEN Reason_Prefer_Online = '' OR Reason_Prefer_Online IS NULL THEN 1 ELSE 0 END) AS blank_reason_online,
    SUM(CASE WHEN Reason_Prefer_InStore = '' OR Reason_Prefer_InStore IS NULL THEN 1 ELSE 0 END) AS blank_reason_instore,
    SUM(CASE WHEN Follows_Brands_On_Social = '' OR Follows_Brands_On_Social IS NULL THEN 1 ELSE 0 END) AS blank_follows_brands,
    SUM(CASE WHEN Makes_Shopping_List = '' OR Makes_Shopping_List IS NULL THEN 1 ELSE 0 END) AS blank_shopping_list
FROM consumer_shopping_behavior_survey;


-- 4. CLEAN — fill remaining blanks with 'Unknown'
-- ------------------------------------------------------------
-- Decision: these gaps affected ~32% of remaining rows. Deleting them
-- would have shrunk the dataset too far, so blanks were replaced with
-- 'Unknown' instead, preserving sample size.

SET SQL_SAFE_UPDATES = 0;

UPDATE consumer_shopping_behavior_survey
SET Monthly_Income_Range = 'Unknown' WHERE Monthly_Income_Range = '' OR Monthly_Income_Range IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Shop_Most_Where = 'Unknown' WHERE Shop_Most_Where = '' OR Shop_Most_Where IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Best_Shopping_Mode = 'Unknown' WHERE Best_Shopping_Mode = '' OR Best_Shopping_Mode IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Online_Shopping_Frequency = 'Unknown' WHERE Online_Shopping_Frequency = '' OR Online_Shopping_Frequency IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Top_Spending_Category = 'Unknown' WHERE Top_Spending_Category = '' OR Top_Spending_Category IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Preferred_Platform = 'Unknown' WHERE Preferred_Platform = '' OR Preferred_Platform IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Primary_Device = 'Unknown' WHERE Primary_Device = '' OR Primary_Device IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Preferred_Payment_Method = 'Unknown' WHERE Preferred_Payment_Method = '' OR Preferred_Payment_Method IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Uses_BNPL_Installments = 'Unknown' WHERE Uses_BNPL_Installments = '' OR Uses_BNPL_Installments IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Return_Frequency = 'Unknown' WHERE Return_Frequency = '' OR Return_Frequency IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Avg_Monthly_Spend_NonEssentials = 'Unknown' WHERE Avg_Monthly_Spend_NonEssentials = '' OR Avg_Monthly_Spend_NonEssentials IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Reason_Prefer_Online = 'Unknown' WHERE Reason_Prefer_Online = '' OR Reason_Prefer_Online IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Reason_Prefer_InStore = 'Unknown' WHERE Reason_Prefer_InStore = '' OR Reason_Prefer_InStore IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Follows_Brands_On_Social = 'Unknown' WHERE Follows_Brands_On_Social = '' OR Follows_Brands_On_Social IS NULL;

UPDATE consumer_shopping_behavior_survey
SET Makes_Shopping_List = 'Unknown' WHERE Makes_Shopping_List = '' OR Makes_Shopping_List IS NULL;

SET SQL_SAFE_UPDATES = 1;


-- 5. NOTE ON NUMERIC SCORE COLUMNS
-- ------------------------------------------------------------
-- Two numeric columns (Price_Comparison_Frequency, Impulse_Purchase_Frequency)
-- also had missing values (15 and 7 rows respectively, no overlap — 22 unique
-- rows out of 293). Since these are numeric 1-5 scores, they were NOT filled
-- with a placeholder like 'Unknown' (which would break the column's numeric
-- type). Instead, these were left as NULL, which is standard practice for
-- numeric survey data — BI tools exclude NULLs from averages/counts
-- automatically rather than skewing results with fabricated values.

SELECT
    SUM(CASE WHEN Price_Comparison_Frequency IS NULL THEN 1 ELSE 0 END) AS null_price_comparison,
    SUM(CASE WHEN Impulse_Purchase_Frequency IS NULL THEN 1 ELSE 0 END) AS null_impulse_purchase
FROM consumer_shopping_behavior_survey;


-- 6. FINAL VERIFICATION
-- ------------------------------------------------------------
SELECT COUNT(*) AS final_row_count FROM consumer_shopping_behavior_survey;
-- Expected: 293 rows, fully clean

SELECT 
    SUM(CASE WHEN Monthly_Income_Range = '' OR Monthly_Income_Range IS NULL THEN 1 ELSE 0 END) AS blank_income,
    SUM(CASE WHEN Shop_Most_Where = '' OR Shop_Most_Where IS NULL THEN 1 ELSE 0 END) AS blank_shop_where,
    SUM(CASE WHEN Preferred_Payment_Method = '' OR Preferred_Payment_Method IS NULL THEN 1 ELSE 0 END) AS blank_payment,
    SUM(CASE WHEN Uses_BNPL_Installments = '' OR Uses_BNPL_Installments IS NULL THEN 1 ELSE 0 END) AS blank_bnpl,
    SUM(CASE WHEN Return_Frequency = '' OR Return_Frequency IS NULL THEN 1 ELSE 0 END) AS blank_return,
    SUM(CASE WHEN Avg_Monthly_Spend_NonEssentials = '' OR Avg_Monthly_Spend_NonEssentials IS NULL THEN 1 ELSE 0 END) AS blank_spend,
    SUM(CASE WHEN Reason_Prefer_Online = '' OR Reason_Prefer_Online IS NULL THEN 1 ELSE 0 END) AS blank_reason_online,
    SUM(CASE WHEN Reason_Prefer_InStore = '' OR Reason_Prefer_InStore IS NULL THEN 1 ELSE 0 END) AS blank_reason_instore,
    SUM(CASE WHEN Follows_Brands_On_Social = '' OR Follows_Brands_On_Social IS NULL THEN 1 ELSE 0 END) AS blank_follows_brands,
    SUM(CASE WHEN Makes_Shopping_List = '' OR Makes_Shopping_List IS NULL THEN 1 ELSE 0 END) AS blank_shopping_list
FROM consumer_shopping_behavior_survey;
