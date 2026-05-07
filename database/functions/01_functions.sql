USE placement_portal_final;

DELIMITER //

-- Function 1: Check Student Eligibility for a Job
CREATE FUNCTION Check_Eligibility(p_student_id VARCHAR(20), p_job_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_cgpa DECIMAL(4,2);
    DECLARE v_backlogs INT;
    DECLARE v_tenth DECIMAL(5,2);
    DECLARE v_twelfth DECIMAL(5,2);
    DECLARE v_dept_id INT;
    
    DECLARE v_min_cgpa DECIMAL(4,2);
    DECLARE v_max_backlogs INT;
    DECLARE v_min_tenth DECIMAL(5,2);
    DECLARE v_min_twelfth DECIMAL(5,2);
    DECLARE v_allowed_depts VARCHAR(255);
    
    -- Get student details
    SELECT cgpa, active_backlogs, tenth_percentage, twelfth_percentage, dept_id 
    INTO v_cgpa, v_backlogs, v_tenth, v_twelfth, v_dept_id
    FROM STUDENT WHERE student_id = p_student_id;
    
    -- Get eligibility criteria
    SELECT min_cgpa, max_backlogs, min_tenth, min_twelfth, allowed_departments
    INTO v_min_cgpa, v_max_backlogs, v_min_tenth, v_min_twelfth, v_allowed_depts
    FROM ELIGIBILITY_CRITERIA WHERE job_id = p_job_id;
    
    -- Check criteria
    IF v_cgpa >= v_min_cgpa AND 
       v_backlogs <= v_max_backlogs AND 
       v_tenth >= v_min_tenth AND 
       v_twelfth >= v_min_twelfth AND
       (v_allowed_depts = 'ALL' OR FIND_IN_SET(CAST(v_dept_id AS CHAR), v_allowed_depts) > 0) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

-- Function 2: Calculate Department Placement Percentage
CREATE FUNCTION Calculate_Placement_Percentage(p_dept_id INT, p_year YEAR)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_total_students INT;
    DECLARE v_placed_students INT;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.00;
    
    SELECT COUNT(*) INTO v_total_students 
    FROM STUDENT 
    WHERE dept_id = p_dept_id AND enrollment_year = p_year;
    
    IF v_total_students = 0 THEN RETURN 0.00; END IF;
    
    SELECT COUNT(*) INTO v_placed_students 
    FROM STUDENT 
    WHERE dept_id = p_dept_id AND enrollment_year = p_year AND is_placed = TRUE;
    
    SET v_percentage = (v_placed_students / v_total_students) * 100;
    RETURN v_percentage;
END //

-- Function 3: Get Highest Package
CREATE FUNCTION Get_Highest_Package(p_dept_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_highest_package DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(MAX(j.package), 0) INTO v_highest_package
    FROM OFFER_LETTER o
    JOIN APPLICATION a ON o.application_id = a.application_id
    JOIN JOB_ROLE j ON a.job_id = j.job_id
    JOIN STUDENT s ON a.student_id = s.student_id
    WHERE (p_dept_id IS NULL OR s.dept_id = p_dept_id) AND o.acceptance_status = 'Accepted';
    
    RETURN v_highest_package;
END //

-- Function 4: Get Average CGPA of placed vs unplaced
CREATE FUNCTION Calculate_Average_CGPA(p_is_placed BOOLEAN)
RETURNS DECIMAL(4,2)
READS SQL DATA
BEGIN
    DECLARE v_avg_cgpa DECIMAL(4,2) DEFAULT 0;
    
    SELECT COALESCE(AVG(cgpa), 0) INTO v_avg_cgpa
    FROM STUDENT
    WHERE is_placed = p_is_placed;
    
    RETURN v_avg_cgpa;
END //

DELIMITER ;
