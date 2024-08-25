
-- Firstly, I extracted the distribution of employees across different departments within the company.
/*SELECT 
	DISTINCT (Department),
	COUNT(id) AS Employee
FROM
    data.hr_employee
GROUP BY 
	Department
ORDER BY 
	COUNT(id) DESC; */

-------------------------------------------------------------------------------------------------------------------------------------

--I assessed the employees' distances from their homes in specific ranges and converted this data into an ETC format for future use.
/*
WITH DistanceCategorized AS (
    SELECT 
    id,
        CASE 
            WHEN DistanceFromHome BETWEEN 1 AND 10 THEN '1-10 / KM'
            WHEN DistanceFromHome BETWEEN 11 AND 20 THEN '11-20 / KM'
            WHEN DistanceFromHome BETWEEN 21 AND 30 THEN '21-30 / KM'
            ELSE '31+'
        END AS DistanceRange
    FROM 
        data.hr_employee
)
SELECT COUNT(DistanceRange) AS Employee,DistanceRange
FROM DistanceCategorized

GROUP BY DistanceRange*/

------------------------------------------------------------------------------------------------------------------------------------------

--Using the ETC format with the determined distance ranges, I compared the relationship between employees' distances from home and their overtime work.
/*
SELECT 
    dc.DistanceRange,
    COUNT(CASE WHEN hr.OverTime = 'Yes' THEN 1 END) AS OverTime,
    COUNT(CASE WHEN hr.OverTime = 'No' THEN 1 END) AS NoOverTime
FROM 
    DistanceCategorized dc
INNER JOIN 
    data.hr_employee hr ON dc.id = hr.id
GROUP BY 
    dc.DistanceRange
ORDER BY 
    dc.DistanceRange;*/

----------------------------------------------------------------------------------------------------------------------------------

--Created a new CTE that produces graduation fields of our employees and using the CTE in further for finding out relation between employees current department to their field in university

/*
USE data;
WITH Employee_Education AS(
SELECT DISTINCT(EducationField),COUNT(id) AS Employees
FROM data.hr_employee 
GROUP BY EducationField
)

SELECT 
	ee.*,
    COUNT(CASE WHEN hr.Department = 'Sales' THEN 1 END) AS Sales,
    COUNT(CASE WHEN hr.Department = 'Research & Development' THEN 1 END) AS ResearchDevelopment,
    COUNT(CASE WHEN hr.Department = 'Human Resources' THEN 1 END) AS HumanResources
FROM 
	Employee_Education ee 
 INNER JOIN
	hr_employee hr 
ON 
	ee.EducationField=hr.EducationField

GROUP BY EducationField
ORDER BY Employees DESC;*/ 


----------------------------------------------------------------------------------------------------------------------
--I created a new CTE for further inspection to see the roles of our current employees within their departments. This new CTE utilizes the query and the CTE we previously created.
/*
USE data;

WITH Employee_Job AS(
WITH Employee_Education AS(
SELECT DISTINCT(EducationField),COUNT(id) AS Employees
FROM data.hr_employee 
GROUP BY EducationField
)

SELECT 
	ee.*,
    COUNT(CASE WHEN hr.Department = 'Sales' THEN 1 END) AS Sales,
    COUNT(CASE WHEN hr.Department = 'Research & Development' THEN 1 END) AS ResearchDevelopment,
    COUNT(CASE WHEN hr.Department = 'Human Resources' THEN 1 END) AS HumanResources
FROM 
	Employee_Education ee 
INNER JOIN
	hr_employee hr 
ON 
	ee.EducationField=hr.EducationField

GROUP BY 
    EducationField
ORDER BY 
    Employees DESC
)
SELECT 
	ej.*,
    COUNT(CASE WHEN hr.JobRole ='Sales Executive' THEN 1 END) AS SalesExecutive,
    COUNT(CASE WHEN hr.JobRole ='Research Scientist' THEN 1 END) AS ResearchScientist,
    COUNT(CASE WHEN hr.JobRole ='Sales Representative' THEN 1 END) AS SalesRepresentative,
    COUNT(CASE WHEN hr.JobRole ='Laboratory Technician' THEN 1 END) AS LaboratoryTechnician,
    COUNT(CASE WHEN hr.JobRole ='Manufacturing Director' THEN 1 END) AS ManufacturingDirector,
    COUNT(CASE WHEN hr.JobRole ='Healthcare Representative' THEN 1 END) AS HealthcareRepesentative,
    COUNT(CASE WHEN hr.JobRole ='Manager' THEN 1 END) AS Manager,
    COUNT(CASE WHEN hr.JobRole ='Research Director' THEN 1 END) AS ResearchDirector,
    COUNT(CASE WHEN hr.JobRole ='Human Resources' THEN 1 END) AS HumanResources
FROM 
	Employee_Job ej 
INNER JOIN 
    hr_employee hr ON ej.EducationField=hr.EducationField
GROUP BY 
    hr.EducationField
*/ 