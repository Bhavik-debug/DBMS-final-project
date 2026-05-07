USE placement_portal_final;

-- 1. INNER JOIN: Retrieve all students who have applied for a job and their current status
SELECT s.first_name, s.last_name, j.job_title, c.company_name, a.status
FROM STUDENT s
INNER JOIN APPLICATION a ON s.student_id = a.student_id
INNER JOIN JOB_ROLE j ON a.job_id = j.job_id
INNER JOIN PLACEMENT_DRIVE pd ON j.drive_id = pd.drive_id
INNER JOIN COMPANY c ON pd.company_id = c.company_id;

-- 2. LEFT JOIN: List all departments and their students, even if a department has no students yet
SELECT d.dept_name, s.first_name, s.last_name
FROM DEPARTMENT d
LEFT JOIN STUDENT s ON d.dept_id = s.dept_id;

-- 3. RIGHT JOIN: List all job roles and the companies offering them, ensuring every company is shown even if it has no current drives
SELECT j.job_title, j.package, c.company_name
FROM JOB_ROLE j
RIGHT JOIN PLACEMENT_DRIVE pd ON j.drive_id = pd.drive_id
RIGHT JOIN COMPANY c ON pd.company_id = c.company_id;

-- 4. FULL OUTER JOIN (Simulated in MySQL via UNION): Students and Offers
SELECT s.first_name, o.offer_date
FROM STUDENT s
LEFT JOIN APPLICATION a ON s.student_id = a.student_id
LEFT JOIN OFFER_LETTER o ON a.application_id = o.application_id
UNION
SELECT s.first_name, o.offer_date
FROM STUDENT s
RIGHT JOIN APPLICATION a ON s.student_id = a.student_id
RIGHT JOIN OFFER_LETTER o ON a.application_id = o.application_id;

-- 5. SELF JOIN: Find students enrolled in the same year and department
SELECT s1.first_name AS Student1, s2.first_name AS Student2, s1.enrollment_year
FROM STUDENT s1
JOIN STUDENT s2 ON s1.dept_id = s2.dept_id AND s1.enrollment_year = s2.enrollment_year AND s1.student_id != s2.student_id;

-- 6. Nested Subquery: Find the student(s) with the highest CGPA
SELECT first_name, last_name, cgpa
FROM STUDENT
WHERE cgpa = (SELECT MAX(cgpa) FROM STUDENT);

-- 7. Correlated Subquery: Find students whose CGPA is above their department's average CGPA
SELECT s.first_name, s.cgpa, s.dept_id
FROM STUDENT s
WHERE s.cgpa > (SELECT AVG(cgpa) FROM STUDENT s2 WHERE s2.dept_id = s.dept_id);

-- 8. EXISTS: Find companies that have conducted at least one placement drive
SELECT company_name FROM COMPANY c
WHERE EXISTS (SELECT 1 FROM PLACEMENT_DRIVE pd WHERE pd.company_id = c.company_id);

-- 9. NOT EXISTS: Find students who have not applied for any jobs
SELECT first_name, last_name FROM STUDENT s
WHERE NOT EXISTS (SELECT 1 FROM APPLICATION a WHERE a.student_id = s.student_id);

-- 10. ANY/SOME: Find students whose CGPA is greater than ANY student in department 1
SELECT first_name, cgpa FROM STUDENT
WHERE cgpa > ANY (SELECT cgpa FROM STUDENT WHERE dept_id = 1) AND dept_id != 1;

-- 11. ALL: Find jobs with a package higher than ALL jobs offered by company ID 1
SELECT job_title, package FROM JOB_ROLE j
WHERE package > ALL (SELECT j2.package FROM JOB_ROLE j2 JOIN PLACEMENT_DRIVE pd ON j2.drive_id = pd.drive_id WHERE pd.company_id = 1);

-- 12. IN: Find students who applied for 'Software Engineer' or 'Data Analyst'
SELECT s.first_name FROM STUDENT s
WHERE s.student_id IN (
    SELECT a.student_id FROM APPLICATION a 
    JOIN JOB_ROLE j ON a.job_id = j.job_id 
    WHERE j.job_title IN ('Software Engineer', 'Data Analyst')
);

-- 13. NOT IN: Find departments with no unplaced students
SELECT dept_name FROM DEPARTMENT 
WHERE dept_id NOT IN (SELECT dept_id FROM STUDENT WHERE is_placed = FALSE);

-- 14. GROUP BY & HAVING: Departments with more than 5 placed students
SELECT dept_id, COUNT(*) as placed_count FROM STUDENT
WHERE is_placed = TRUE
GROUP BY dept_id
HAVING COUNT(*) > 5;

-- 15. Aggregate Analytics: Average, Min, Max Package per Company
SELECT c.company_name, AVG(j.package), MIN(j.package), MAX(j.package)
FROM COMPANY c
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
GROUP BY c.company_name;

-- 16. Window Function - RANK(): Rank students within their department based on CGPA
SELECT first_name, dept_id, cgpa,
RANK() OVER(PARTITION BY dept_id ORDER BY cgpa DESC) as dept_rank
FROM STUDENT;

-- 17. Window Function - DENSE_RANK(): Rank companies based on maximum package offered
SELECT c.company_name, MAX(j.package) as max_pkg,
DENSE_RANK() OVER(ORDER BY MAX(j.package) DESC) as pkg_rank
FROM COMPANY c
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
GROUP BY c.company_name;

-- 18. Window Function - ROW_NUMBER(): Assign row numbers to interview rounds for a job
SELECT job_id, round_type, 
ROW_NUMBER() OVER(PARTITION BY job_id ORDER BY round_number) as round_seq
FROM INTERVIEW_ROUND;

-- 19. CTE (Common Table Expression): Find companies offering above average salary
WITH AvgSalary AS (SELECT AVG(package) as avg_pkg FROM JOB_ROLE)
SELECT j.job_title, j.package, c.company_name
FROM JOB_ROLE j
JOIN PLACEMENT_DRIVE pd ON j.drive_id = pd.drive_id
JOIN COMPANY c ON pd.company_id = c.company_id
CROSS JOIN AvgSalary a
WHERE j.package > a.avg_pkg;

-- 20. Derived Tables: Find the highest paying job in each drive
SELECT d.drive_id, d.max_pkg, j.job_title
FROM (SELECT drive_id, MAX(package) as max_pkg FROM JOB_ROLE GROUP BY drive_id) d
JOIN JOB_ROLE j ON d.drive_id = j.drive_id AND d.max_pkg = j.package;

-- 21. UNION: Combine names of Students and Recruiters
SELECT first_name as Person_Name, 'Student' as Role FROM STUDENT
UNION
SELECT name as Person_Name, 'Recruiter' as Role FROM RECRUITER;

-- 22. EXCEPT/MINUS (Simulated in MySQL via NOT IN): Jobs with no applicants
SELECT job_id, job_title FROM JOB_ROLE
WHERE job_id NOT IN (SELECT DISTINCT job_id FROM APPLICATION);

-- 23. Top hiring companies (by number of accepted offers)
SELECT c.company_name, COUNT(o.offer_id) as hires
FROM COMPANY c
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
JOIN APPLICATION a ON j.job_id = a.job_id
JOIN OFFER_LETTER o ON a.application_id = o.application_id
WHERE o.acceptance_status = 'Accepted'
GROUP BY c.company_name
ORDER BY hires DESC
LIMIT 5;

-- 24. Highest package branch-wise
SELECT d.dept_name, MAX(j.package) as highest_package
FROM DEPARTMENT d
JOIN STUDENT s ON d.dept_id = s.dept_id
JOIN APPLICATION a ON s.student_id = a.student_id
JOIN JOB_ROLE j ON a.job_id = j.job_id
JOIN OFFER_LETTER o ON a.application_id = o.application_id
WHERE o.acceptance_status = 'Accepted'
GROUP BY d.dept_name;

-- 25. Students rejected in all companies they applied to
SELECT s.first_name, s.last_name
FROM STUDENT s
JOIN APPLICATION a ON s.student_id = a.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING SUM(CASE WHEN a.status != 'Rejected' THEN 1 ELSE 0 END) = 0;

-- 26. Most demanded skills
SELECT sm.skill_name, COUNT(ss.student_id) as skill_count
FROM SKILL_MASTER sm
JOIN STUDENT_SKILL ss ON sm.skill_id = ss.skill_id
GROUP BY sm.skill_name
ORDER BY skill_count DESC
LIMIT 5;

-- 27. Students eligible for multiple upcoming drives (using the View)
SELECT student_id, first_name, COUNT(DISTINCT job_id) as eligible_jobs
FROM Eligible_Students_View
GROUP BY student_id, first_name
HAVING COUNT(DISTINCT job_id) > 1;

-- 28. Average salary trends per department
SELECT d.dept_name, AVG(j.package) as avg_package
FROM DEPARTMENT d
JOIN STUDENT s ON d.dept_id = s.dept_id
JOIN APPLICATION a ON s.student_id = a.student_id
JOIN JOB_ROLE j ON a.job_id = j.job_id
JOIN OFFER_LETTER o ON a.application_id = o.application_id
WHERE o.acceptance_status = 'Accepted'
GROUP BY d.dept_name;

-- 29. Recruiters hiring from multiple branches
SELECT r.name, COUNT(DISTINCT s.dept_id) as branches_hired_from
FROM RECRUITER r
JOIN COMPANY c ON r.company_id = c.company_id
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
JOIN APPLICATION a ON j.job_id = a.job_id
JOIN STUDENT s ON a.student_id = s.student_id
JOIN OFFER_LETTER o ON a.application_id = o.application_id
WHERE o.acceptance_status = 'Accepted'
GROUP BY r.name
HAVING COUNT(DISTINCT s.dept_id) > 1;

-- 30. Complex Query: Company-wise hiring analytics (Total applied, selected, max package)
SELECT 
    c.company_name,
    COUNT(a.application_id) as total_applied,
    SUM(CASE WHEN a.status = 'Selected' THEN 1 ELSE 0 END) as total_selected,
    MAX(j.package) as top_package_offered
FROM COMPANY c
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
LEFT JOIN APPLICATION a ON j.job_id = a.job_id
GROUP BY c.company_name;
