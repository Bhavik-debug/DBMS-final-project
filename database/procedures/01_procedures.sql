USE placement_portal_final;

DELIMITER //

-- Procedure 1: Apply For Job with Transactions & Exception Handling
CREATE PROCEDURE Apply_For_Job(IN p_student_id VARCHAR(20), IN p_job_id INT, OUT p_status VARCHAR(100))
BEGIN
    DECLARE v_is_eligible BOOLEAN;
    DECLARE v_is_already_placed BOOLEAN;
    DECLARE v_already_applied INT;
    
    -- Exception Handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 'Error: Transaction Failed. Application Rolled Back.';
    END;
    
    START TRANSACTION;
    
    -- Check if student exists and is placed
    SELECT is_placed INTO v_is_already_placed FROM STUDENT WHERE student_id = p_student_id;
    
    IF v_is_already_placed = TRUE THEN
        SET p_status = 'Error: Student is already placed.';
        ROLLBACK;
    ELSE
        -- Check if already applied
        SELECT COUNT(*) INTO v_already_applied FROM APPLICATION WHERE student_id = p_student_id AND job_id = p_job_id;
        
        IF v_already_applied > 0 THEN
            SET p_status = 'Error: Student has already applied for this job.';
            ROLLBACK;
        ELSE
            -- Check eligibility
            SET v_is_eligible = Check_Eligibility(p_student_id, p_job_id);
            
            IF v_is_eligible = FALSE THEN
                SET p_status = 'Error: Student does not meet eligibility criteria.';
                ROLLBACK;
            ELSE
                -- Insert Application
                INSERT INTO APPLICATION (student_id, job_id, status) VALUES (p_student_id, p_job_id, 'Applied');
                
                -- Log Audit
                INSERT INTO AUDIT_LOG (table_name, operation, record_id, new_value, changed_by) 
                VALUES ('APPLICATION', 'INSERT', LAST_INSERT_ID(), CONCAT('Student: ', p_student_id, ' Job: ', p_job_id), p_student_id);
                
                COMMIT;
                SET p_status = 'Success: Successfully applied for the job.';
            END IF;
        END IF;
    END IF;
END //

-- Procedure 2: Publish Result and Auto-Update Status
CREATE PROCEDURE Publish_Result(IN p_application_id INT, IN p_round_id INT, IN p_score DECIMAL(5,2), IN p_result_status ENUM('Pass', 'Fail'), OUT p_msg VARCHAR(255))
BEGIN
    DECLARE v_max_round INT;
    DECLARE v_current_round INT;
    DECLARE v_job_id INT;
    DECLARE v_student_id VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_msg = 'Error: Failed to publish result.';
    END;

    START TRANSACTION;
    
    -- Insert or Update Result
    INSERT INTO INTERVIEW_RESULT (application_id, round_id, score, status)
    VALUES (p_application_id, p_round_id, p_score, p_result_status)
    ON DUPLICATE KEY UPDATE score = p_score, status = p_result_status;
    
    SELECT job_id, student_id INTO v_job_id, v_student_id FROM APPLICATION WHERE application_id = p_application_id;
    SELECT MAX(round_number) INTO v_max_round FROM INTERVIEW_ROUND WHERE job_id = v_job_id;
    SELECT round_number INTO v_current_round FROM INTERVIEW_ROUND WHERE round_id = p_round_id;
    
    IF p_result_status = 'Fail' THEN
        UPDATE APPLICATION SET status = 'Rejected' WHERE application_id = p_application_id;
        SET p_msg = 'Result published. Applicant Rejected.';
    ELSEIF v_current_round = v_max_round THEN
        UPDATE APPLICATION SET status = 'Selected' WHERE application_id = p_application_id;
        -- Generate Offer Letter placeholder
        INSERT INTO OFFER_LETTER (application_id, offer_date, base_salary)
        SELECT p_application_id, CURDATE(), package FROM JOB_ROLE WHERE job_id = v_job_id;
        
        SET p_msg = 'Result published. Applicant Selected and Offer Generated.';
    ELSE
        UPDATE APPLICATION SET status = 'Shortlisted' WHERE application_id = p_application_id;
        SET p_msg = 'Result published. Applicant Shortlisted for next round.';
    END IF;
    
    COMMIT;
END //

-- Procedure 3: Batch Auto Reject Ineligible Students Using Cursor
CREATE PROCEDURE Auto_Reject_Ineligible_Students()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_app_id INT;
    DECLARE v_student_id VARCHAR(20);
    DECLARE v_job_id INT;
    DECLARE v_eligible BOOLEAN;
    
    DECLARE app_cursor CURSOR FOR SELECT application_id, student_id, job_id FROM APPLICATION WHERE status = 'Applied';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN app_cursor;
    
    read_loop: LOOP
        FETCH app_cursor INTO v_app_id, v_student_id, v_job_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET v_eligible = Check_Eligibility(v_student_id, v_job_id);
        
        IF v_eligible = FALSE THEN
            UPDATE APPLICATION SET status = 'Rejected' WHERE application_id = v_app_id;
            
            INSERT INTO NOTIFICATION (recipient_id, recipient_type, title, message)
            VALUES (v_student_id, 'Student', 'Application Update', CONCAT('Your application for Job ID ', v_job_id, ' has been rejected due to ineligibility.'));
        END IF;
    END LOOP;
    
    CLOSE app_cursor;
END //

DELIMITER ;
