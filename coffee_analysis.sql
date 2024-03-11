-- Create Database
CREATE DATABASE IF NOT EXISTS coffee_data;

-- Import Tables using Table Data Import Wizard
-- Data consists of coffee production, supply and distribution

-- --------- Data Understanding --------- --
DESCRIBE 
	coffee_data.psd_coffee;

-- Check for missing values in the Arabica Production column
SELECT 
	COUNT(*) AS Missing_Arabica_Production
FROM 
	coffee_data.psd_coffee
WHERE 
	`Arabica Production` IS NULL;

-- Total number of countries
SELECT 
	COUNT(DISTINCT(Country)) 
FROM 
	coffee_data.psd_coffee;

-- Beggining Year to End Year
SELECT 
	MIN(Year) 
FROM 
	coffee_data.psd_coffee;
-- 1960

SELECT 
	MAX(Year)
FROM 
	coffee_data.psd_coffee;
-- 2023

-- Total Distribution from 1960 - 2023
SELECT 
	SUM(`Total Distribution`) 
FROM 
    coffee_data.psd_coffee;
-- 12,140,676

-- Total Supply from 1960 - 2023
SELECT 
	SUM(`Total Supply`) 
FROM 
	coffee_data.psd_coffee;
-- 12,140,675

-- Total Domestic Consumption from 1960 - 2023
SELECT 
	SUM(`Domestic Consumption`) 
FROM 
	coffee_data.psd_coffee;
-- 4,048,980

-- Total Imports from 1960 - 2023
SELECT 
	SUM(`Imports`) 
FROM 
	coffee_data.psd_coffee;
-- 2,588,808

-- Total Exports from 1960 - 2023
SELECT 
	SUM(`Exports`) 
FROM 
	coffee_data.psd_coffee;
-- 5,388,152

-- Total Production from 1960 - 2023
SELECT 
	SUM(`Production`) 
FROM 
	coffee_data.psd_coffee;
-- 6,801,095

-- Country with the most coffee production  from 1960 - 2023
SELECT 
	Country, 
    SUM(Production) AS Production 
FROM 
	coffee_data.psd_coffee
GROUP BY 
	Country
ORDER BY 
	Production DESC
LIMIT 1;
-- Brazil -- 2,221,150

-- Country with the most coffee distribution  from 1960 - 2023
SELECT 
	Country, 
    SUM(`Total Distribution`) AS Distribution 
FROM 
	coffee_data.psd_coffee
GROUP BY 
	Country
ORDER BY 
	Distribution DESC;
-- Brazil -- 3,520,234

-- Aggregate production by year
SELECT 
	Year, 
	SUM(`Arabica Production`) AS Total_Arabica_Production
FROM 
	coffee_data.psd_coffee
GROUP BY 
	Year
ORDER BY 
	Year;

-- Aggregate production by country
SELECT 
	Country, 
	SUM(`Arabica Production`) AS Total_Arabica_Production
FROM 
	coffee_data.psd_coffee
GROUP BY 
	Country
ORDER BY 
	Total_Arabica_Production DESC;

-- Net change in Stock
SELECT 
    Year, 
    SUM(`Beginning Stocks` - `Ending Stocks`) AS NetChangeInStocks
FROM 
    coffee_data.psd_coffee
GROUP BY 
    Year
ORDER BY 
    NetChangeInStocks DESC;
    
-- Statistical Measure
SELECT 
    AVG(Production) AS MeanProduction,
    STDDEV(Production) AS StdDevProduction
FROM 
	coffee_data.psd_coffee;

-- Average Coffee production in each country
SELECT 
    Country,
    AVG(Production) AS AverageProduction
FROM 
    coffee_data.psd_coffee
GROUP BY 
    Country;
    
-- Yearly Change in Coffee Production:

SELECT 
    Year,
    SUM(Production) AS TotalCoffeeProduction,
    LAG(SUM(Production)) OVER (ORDER BY Year) AS PrevYearTotalCoffeeProduction,
    (SUM(Production) - LAG(SUM(Production)) OVER (ORDER BY Year)) AS YearlyChange
FROM 
    coffee_data.psd_coffee
GROUP BY 
    Year
ORDER BY 
    Year;
    
-- Exports and Imports

SELECT 
    Country,
    SUM(Exports) AS TotalExports,
    SUM(Imports) AS TotalImports
FROM 
    coffee_data.psd_coffee
GROUP BY 
    Country
ORDER BY 
    TotalExports DESC, TotalImports DESC;
    
-- Countries that do not import coffee

SELECT 
	Country,
    SUM(Imports) AS TotalImports
FROM     
	coffee_data.psd_coffee
GROUP BY 
    Country
HAVING
	SUM(Imports) = 0;

-- Countries that do not export coffee

SELECT 
	Country,
    SUM(Exports) AS TotalImports
FROM     
	coffee_data.psd_coffee
GROUP BY 
    Country
HAVING
	SUM(Exports) = 0;
    
-- Correlation Analysis between Coffee Production and Consumption

SELECT 
    Country,
    (
        COUNT(*) * SUM(Production * `Domestic Consumption`) - SUM(Production) * SUM(`Domestic Consumption`)
    ) / SQRT(
        (COUNT(*) * SUM(Production * Production) - SUM(Production) * SUM(Production)) *
        (COUNT(*) * SUM(`Domestic Consumption` * `Domestic Consumption`) - SUM(`Domestic Consumption`) * SUM(`Domestic Consumption`))
    ) AS CorrelationCoefficient
FROM 
	coffee_data.psd_coffee
GROUP BY 
    Country;
    
