-- ==================================================================================
-- Checking bronze.crm_cust_info
-- ===================================================================================
-- Check for Nulls or Duplicates in Primary key
-- Expectation : No Result

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;	

-- Check for unwanted Spaces 
-- Expectation : No Result
SELECT cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname 
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for Standardization and Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

-- ==================================================================================
-- Checking bronze.crm_prd_info
-- ===================================================================================
--Quality Checks
-- Check For NULLs or Duplicate in primary key
-- Expectation: No Results

SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted Spaces 
-- Expectation : No Result
SELECT prd_nm 
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Numbers
-- Expectation : NO Results

SELECT prd_cost 
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for Standardization and Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;


-- Check for Invalid Dates

SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ==================================================================================
-- Checking bronze.crm_sales_details
-- ===================================================================================
-- Check for Invalid dates

SELECT
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

SELECT
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

SELECT
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for invalid order dates

SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check data Consistency with Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM 
	bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price;
-- ==================================================================================
-- Checking bronze.erp_cust_az12
-- ===================================================================================
-- Identify OUT OF RANGE Dates

SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();


-- Data Standardization and Consistancy
SELECT  DISTINCT gen
FROM bronze.erp_cust_az12;
-- ==================================================================================
-- Checking bronze.erp_loc_a101
-- ===================================================================================
-- Data standardization and Consistency
SELECT	DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;
-- ==================================================================================
-- Checking bronze.erp_px_cat_g1v2
-- ===================================================================================
-- Check for unwanted spaces

SELECT * FROM bronze.erp_px_cat_g1v2
WHERE  cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);


-- Data Standarization and Consistancy
SELECT cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2;
