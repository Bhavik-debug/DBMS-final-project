USE placement_portal_final;

DELIMITER //

-- Trigger 1: BEFORE INSERT Application (Prevent duplicate application logic natively)
CREATE TRIGGER Before_Application_Insert
BEFORE INSERT ON APPLICATION
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM APPLICATION WHERE student_id = NEW.student_id AND job_id = NEW.job_id;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate application not allowed.';
    END IF;
END //

-- Trigger 2: AFTER UPDATE of Offer Letter (Auto-Update Student Placed Status)
CREATE TRIGGER After_Offer_Acceptance
AFTER UPDATE ON OFFER_LETTER
FOR EACH ROW
BEGIN
    DECLARE v_student_id VARCHAR(20);
    
    IF NEW.acceptance_status = 'Accepted' AND OLD.acceptance_status != 'Accepted' THEN
        SELECT student_id INTO v_student_id FROM APPLICATION WHERE application_id = NEW.application_id;
        
        UPDATE STUDENT SET is_placed = TRUE WHERE student_id = v_student_id;
        
        INSERT INTO NOTIFICATION (recipient_id, recipient_type, title, message)
        VALUES (v_student_id, 'Student', 'Congratulations!', 'Your offer has been accepted and your status is updated to Placed.');
    END IF;
END //

-- Trigger 3: AFTER DELETE on STUDENT (Audit Log)
CREATE TRIGGER After_Student_Delete
AFTER DELETE ON STUDENT
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (table_name, operation, record_id, old_value, changed_by)
    VALUES ('STUDENT', 'DELETE', OLD.student_id, CONCAT('Name: ', OLD.first_name, ' ', OLD.last_name), 'System');
END //

-- Trigger 4: BEFORE UPDATE on STUDENT (Audit Log for CGPA Changes)
CREATE TRIGGER Before_Student_CGPA_Update
BEFORE UPDATE ON STUDENT
FOR EACH ROW
BEGIN
    IF NEW.cgpa != OLD.cgpa THEN
        INSERT INTO AUDIT_LOG (table_name, operation, record_id, old_value, new_value, changed_by)
        VALUES ('STUDENT', 'UPDATE_CGPA', OLD.student_id, CAST(OLD.cgpa AS CHAR), CAST(NEW.cgpa AS CHAR), 'System');
    END IF;
END //

DELIMITER ;
