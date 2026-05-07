USE placement_portal_final;

-- 1. Index on Student Department (Speeds up department-wise placement queries)
CREATE INDEX idx_student_dept ON STUDENT(dept_id);

-- 2. Index on Application Status (Speeds up filtering applications)
CREATE INDEX idx_app_status ON APPLICATION(status);

-- 3. Composite Index on Job Role (Drive + Salary)
CREATE INDEX idx_job_drive_pkg ON JOB_ROLE(drive_id, package);

-- 4. Index on Student Placement Status
CREATE INDEX idx_student_placed ON STUDENT(is_placed);

-- 5. Index on Offer Letter Acceptance Status
CREATE INDEX idx_offer_status ON OFFER_LETTER(acceptance_status);
