USE placement_portal_final;

-- View 1: Eligible_Students_View (Cross Join logic to see who can apply to what)
CREATE OR REPLACE VIEW Eligible_Students_View AS
SELECT 
    s.student_id, s.first_name, s.last_name, s.dept_id, s.cgpa,
    j.job_id, j.job_title, c.company_name, j.package
FROM STUDENT s
CROSS JOIN JOB_ROLE j
JOIN PLACEMENT_DRIVE pd ON j.drive_id = pd.drive_id
JOIN COMPANY c ON pd.company_id = c.company_id
WHERE Check_Eligibility(s.student_id, j.job_id) = TRUE
AND pd.status IN ('Upcoming', 'Ongoing')
AND pd.registration_deadline >= CURDATE();

-- View 2: Placement_Analytics_View
CREATE OR REPLACE VIEW Placement_Analytics_View AS
SELECT 
    d.dept_name,
    COUNT(s.student_id) AS total_students,
    SUM(CASE WHEN s.is_placed = TRUE THEN 1 ELSE 0 END) AS placed_students,
    Calculate_Placement_Percentage(d.dept_id, YEAR(CURDATE())) AS placement_percentage,
    Get_Highest_Package(d.dept_id) AS highest_package_lpa,
    AVG(s.cgpa) AS average_cgpa
FROM DEPARTMENT d
LEFT JOIN STUDENT s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.dept_name;

-- View 3: Company_Statistics_View
CREATE OR REPLACE VIEW Company_Statistics_View AS
SELECT 
    c.company_name,
    pd.drive_date,
    COUNT(DISTINCT a.application_id) AS total_applications,
    SUM(CASE WHEN a.status = 'Selected' THEN 1 ELSE 0 END) AS total_offers_given,
    MAX(j.package) AS max_package_offered
FROM COMPANY c
JOIN PLACEMENT_DRIVE pd ON c.company_id = pd.company_id
JOIN JOB_ROLE j ON pd.drive_id = j.drive_id
LEFT JOIN APPLICATION a ON j.job_id = a.job_id
GROUP BY c.company_id, c.company_name, pd.drive_date;

-- View 4: Student_Performance_View
CREATE OR REPLACE VIEW Student_Performance_View AS
SELECT 
    s.student_id, 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    d.dept_name,
    s.cgpa,
    s.is_placed,
    COUNT(a.application_id) AS total_applications,
    SUM(CASE WHEN a.status = 'Rejected' THEN 1 ELSE 0 END) AS total_rejections,
    SUM(CASE WHEN a.status = 'Selected' THEN 1 ELSE 0 END) AS total_selections
FROM STUDENT s
JOIN DEPARTMENT d ON s.dept_id = d.dept_id
LEFT JOIN APPLICATION a ON s.student_id = a.student_id
GROUP BY s.student_id;

-- View 5: Interview_Progress_View
CREATE OR REPLACE VIEW Interview_Progress_View AS
SELECT 
    a.application_id,
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.company_name,
    j.job_title,
    ir.round_number,
    ir.round_type,
    res.status AS result_status
FROM APPLICATION a
JOIN STUDENT s ON a.student_id = s.student_id
JOIN JOB_ROLE j ON a.job_id = j.job_id
JOIN COMPANY c ON j.drive_id = c.company_id
JOIN INTERVIEW_ROUND ir ON j.job_id = ir.job_id
LEFT JOIN INTERVIEW_RESULT res ON a.application_id = res.application_id AND ir.round_id = res.round_id
WHERE a.status NOT IN ('Rejected', 'Selected');
