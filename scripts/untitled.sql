-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?

SELECT COUNT(npi)
FROM prescriber
EXCEPT
SELECT npi
FROM prescription;

--25050. Why is this query counting all the npi's in prescriber and not excluding npi's in prescription?

SELECT COUNT(npi)
FROM prescriber
WHERE npi NOT IN
	(SELECT npi
	FROM prescription);
--This query took way too long to load. I don't know if it would have worked or not.


SELECT npi
FROM prescriber
EXCEPT
SELECT npi
FROM prescription;

--ANSWER: 4458


-- 2.


--     a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.

SELECT generic_name, COUNT(generic_name) as num_presc
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING (npi)
WHERE prescriber.specialty_description='Family Practice'
GROUP BY generic_name
ORDER BY num_presc DESC
LIMIT 5;

--ANSWER:"METFORMIN HCL"
-- "ALBUTEROL SULFATE"
-- "LEVOTHYROXINE SODIUM"
-- "POTASSIUM CHLORIDE"
-- "DILTIAZEM HCL"



--     b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.

SELECT generic_name, COUNT(generic_name) as num_presc
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING (npi)
WHERE prescriber.specialty_description='Cardiology'
GROUP BY generic_name
ORDER BY num_presc DESC
LIMIT 5;

-- ANSWER: "DILTIAZEM HCL"
-- "POTASSIUM CHLORIDE"
-- "NITROGLYCERIN"
-- "WARFARIN SODIUM"
-- "DIGOXIN"



--     c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.



SELECT generic_name, COUNT(generic_name) as num_presc
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING (npi)
WHERE prescriber.specialty_description='Cardiology'
	OR prescriber.specialty_description='Family Practice'
GROUP BY generic_name
ORDER BY num_presc DESC
LIMIT 5;


-- ANSWER: "DILTIAZEM HCL"
-- "POTASSIUM CHLORIDE"
-- "METFORMIN HCL"
-- "ALBUTEROL SULFATE"
-- "LEVOTHYROXINE SODIUM"




-- 3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.


--     a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.

SELECT npi, SUM(total_claim_count) AS num_claims, nppes_provider_city
FROM prescription
LEFT JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'NASHVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY num_claims DESC
LIMIT 5;



    
--     b. Now, report the same for Memphis.

SELECT npi, SUM(total_claim_count) AS num_claims, nppes_provider_city
FROM prescription
LEFT JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'MEMPHIS'
GROUP BY npi, nppes_provider_city
ORDER BY num_claims DESC
LIMIT 5;

    
--     c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

SELECT npi, SUM(total_claim_count) AS num_claims, nppes_provider_city
FROM prescription
LEFT JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'MEMPHIS'
	OR nppes_provider_city= 'NASHVILLE'
	OR nppes_provider_city= 'KNOXVILLE'
	OR nppes_provider_city= 'CHATTANOOGA'
GROUP BY npi, nppes_provider_city
ORDER BY num_claims DESC
LIMIT 5;


-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

SELECT *
FROM overdose_deaths
ORDER BY fipscounty;

SELECT 
FROM overdose_deaths
GROUP BY fipscounty
ORDER BY AVG(overdose_deaths) DESC;


SELECT AVG(overdose_deaths)
FROM overdose_deaths;

SELECT *
FROM overdose_deaths
ORDER BY overdose_deaths DESC;



SELECT *
FROM 


-- 5.
--     a. Write a query that finds the total population of Tennessee.
    
--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.
