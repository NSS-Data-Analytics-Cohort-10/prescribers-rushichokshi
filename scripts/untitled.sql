-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

SELECT npi, SUM(total_claim_count) AS sum_total_claim_count
FROM prescriber
INNER JOIN prescription
USING(npi)
GROUP BY npi
ORDER BY sum_total_claim_count DESC
LIMIT 10;

SELECT npi, SUM(total_claim_count) AS sum_claims
FROM prescription
LEFT JOIN prescriber
USING (npi)
GROUP BY npi
ORDER BY sum_claims DESC



    
--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT npi, nppes_provider_last_org_name, nppes_provider_first_name, specialty_description,SUM(total_claim_count) AS sum_claims
FROM prescriber
INNER JOIN prescription
USING (npi)
GROUP BY npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
ORDER BY sum_claims DESC;

--ANSWER: Bruce Pendley


-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT specialty_description, SUM(total_claim_count)
FROM prescriber
INNER JOIN prescription
USING (npi)
GROUP BY specialty_description
ORDER BY SUM(total_claim_count) DESC;

--ANSWER: Family Practice



--     b. Which specialty had the most total number of claims for opioids?

SELECT specialty_description, COUNT(opioid_drug_flag = 'y') AS opioid_count
FROM prescriber
LEFT JOIN prescription
USING (npi)
LEFT JOIN drug
USING (drug_name)
GROUP BY specialty_description
ORDER BY COUNT(opioid_drug_flag) DESC

SELECT COUNT(total_claim_count) as opioid_claim_count, opioid_drug_flag, prescriber.specialty_description
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING (npi)
WHERE opioid_drug_flag ='Y'
GROUP BY opioid_drug_flag, prescriber.specialty_description
ORDER BY opioid_claim_count DESC;

--ANSWER: Nurse Practitioner

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?


SELECT generic_name, SUM(total_drug_cost) AS total_cost
FROM prescription
LEFT JOIN drug
USING (drug_name)
GROUP BY generic_name
ORDER BY total_cost DESC;


--ANSWER: INSULIN GLARGINE,HUM.REC.ANLOG


--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**


SELECT generic_name, ROUND(SUM(total_drug_cost)/SUM(total_day_supply),2) AS daily_cost
FROM prescription
LEFT JOIN drug
 USING (drug_name)
GROUP BY generic_name
ORDER BY daily_cost DESC;

--ANSWER: C1 ESTERASE INHIBITOR



-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name,
CASE WHEN opioid_drug_flag='Y' THEN 'opioid'
	WHEN antibiotic_drug_flag='Y' THEN 'antibiotic'
	ELSE 'neither'
	END AS drug_type
FROM drug;


--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.


SELECT SUM(total_drug_cost) AS money,
	CASE WHEN opioid_drug_flag ='Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
FROM drug
INNER JOIN prescription
USING (drug_name)
WHERE
	CASE WHEN opioid_drug_flag ='Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END<>'neither'
GROUP BY 
	CASE WHEN opioid_drug_flag ='Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
 	ELSE 'neither' END;
	
-- ANSWER: 38435121.26	"antibiotic"; 105080626.37	"opioid"



-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.


SELECT COUNT(DISTINCT cbsa)
FROM cbsa
WHERE cbsaname LIKE '%TN%';

--ANSWER: 10


--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

SELECT *
FROM cbsa

SELECT COUNT(*)
FROM cbsa

SELECT *
FROM population

SELECT COUNT(*)
FROM population

SELECT *
FROM fips_county

SELECT cbsaname, fipscounty, SUM(population) as sum_pop
FROM cbsa
LEFT JOIN population
USING (fipscounty)
GROUP BY cbsaname
ORDER BY cbsaname;





SELECT DISTINCT (cbsaname) AS distinct_cbsaname, SUM(population) AS sum_population
FROM CBSA
INNER JOIN fips_county
USING (fipscounty)
INNER JOIN population
USING (fipscounty)
GROUP BY distinct_cbsaname
order BY distinct_cbsaname DESC

SELECT cbsaname, SUM(population) AS sum_population
FROM CBSA
INNER JOIN fips_county
USING (fipscounty)
INNER JOIN population
USING (fipscounty)
GROUP BY cbsaname
order BY cbsaname DESC


--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT fips_county.county, SUM(population.population) AS population
FROM fips_county
INNER JOIN population
USING (fipscounty)
GROUP BY fips_county.county
ORDER BY population DESC;

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.


SELECT total_claim_count, drug_name
FROM prescription
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;
--Answer Oxcodone 4538



--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT drug_name , total_claim_count, opioid_drug_flag
FROM prescription
INNER JOIN drug
USING (drug_name)
WHERE total_claim_count > 3000 
	AND opioid_drug_flag ='Y'


--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.



--BONUS


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
	FROM prescription)
LIMIT 10;
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


SELECT county, ROUND(AVG(overdose_deaths),2) AS avg_od
FROM overdose_deaths
LEFT JOIN zip_fips
USING (fipscounty)
GROUP BY fipscounty
HAVING AVG(overdose_deaths)>
	(SELECT AVG(overdose_deaths)
	FROM overdose_deaths)
ORDER BY avg_od DESC;

SELECT fipscounty, ROUND(AVG(overdose_deaths),2) AS avg_od
FROM overdose_deaths
GROUP BY fipscounty
HAVING AVG(overdose_deaths)>
	(SELECT AVG(overdose_deaths)
	FROM overdose_deaths)
ORDER BY avg_od DESC;


SELECT fipscounty
FROM overdose_deaths
LEFT JOIN fips_county
USING (fipscounty)
GROUP BY fipscounty

SELECT *
FROM overdose_deaths

SELECT *
FROM fips_county
ORDER BY fipscounty


-- 5.
--     a. Write a query that finds the total population of Tennessee.
    
--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.
