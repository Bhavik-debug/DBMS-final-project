DROP DATABASE IF EXISTS placement_portal_final;
CREATE DATABASE IF NOT EXISTS placement_portal_final;
USE placement_portal_final;

-- 1. DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    hod_name VARCHAR(100) NOT NULL
);

-- 2. STUDENT Table
CREATE TABLE STUDENT (
    student_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    cgpa DECIMAL(4,2) CHECK (cgpa >= 0 AND cgpa <= 10.0),
    tenth_percentage DECIMAL(5,2) CHECK (tenth_percentage >= 0 AND tenth_percentage <= 100),
    twelfth_percentage DECIMAL(5,2) CHECK (twelfth_percentage >= 0 AND twelfth_percentage <= 100),
    active_backlogs INT DEFAULT 0,
    dept_id INT NOT NULL,
    enrollment_year YEAR NOT NULL,
    is_placed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. COMPANY Table
CREATE TABLE COMPANY (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL UNIQUE,
    industry_type VARCHAR(50),
    website VARCHAR(255),
    hr_contact_name VARCHAR(100),
    hr_email VARCHAR(100) UNIQUE NOT NULL,
    hr_phone VARCHAR(15)
);

-- 4. PLACEMENT_DRIVE Table
CREATE TABLE PLACEMENT_DRIVE (
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    drive_date DATE NOT NULL,
    registration_deadline DATE NOT NULL,
    drive_location VARCHAR(100) DEFAULT 'On-Campus',
    status ENUM('Upcoming', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Upcoming',
    FOREIGN KEY (company_id) REFERENCES COMPANY(company_id) ON DELETE CASCADE
);

-- 5. JOB_ROLE Table
CREATE TABLE JOB_ROLE (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    drive_id INT NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    package DECIMAL(10,2) NOT NULL, -- CTC in LPA
    job_location VARCHAR(100),
    vacancies INT DEFAULT 0,
    description TEXT,
    FOREIGN KEY (drive_id) REFERENCES PLACEMENT_DRIVE(drive_id) ON DELETE CASCADE
);

-- 6. ELIGIBILITY_CRITERIA Table (1-to-1 with JOB_ROLE conceptually, but kept separate for normalization)
CREATE TABLE ELIGIBILITY_CRITERIA (
    criteria_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT UNIQUE NOT NULL,
    min_cgpa DECIMAL(4,2) DEFAULT 0,
    max_backlogs INT DEFAULT 0,
    min_tenth DECIMAL(5,2) DEFAULT 0,
    min_twelfth DECIMAL(5,2) DEFAULT 0,
    allowed_departments VARCHAR(255) DEFAULT 'ALL', -- Comma separated dept_ids or 'ALL'
    FOREIGN KEY (job_id) REFERENCES JOB_ROLE(job_id) ON DELETE CASCADE
);

-- 7. APPLICATION Table
CREATE TABLE APPLICATION (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(20) NOT NULL,
    job_id INT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Applied', 'Shortlisted', 'Interview', 'Selected', 'Waitlisted', 'Rejected') DEFAULT 'Applied',
    UNIQUE KEY(student_id, job_id), -- Prevent duplicate applications
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES JOB_ROLE(job_id) ON DELETE CASCADE
);

-- 8. INTERVIEW_ROUND Table
CREATE TABLE INTERVIEW_ROUND (
    round_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    round_number INT NOT NULL,
    round_type ENUM('Aptitude', 'Technical', 'HR', 'Group Discussion', 'Managerial') NOT NULL,
    round_date DATE,
    UNIQUE KEY(job_id, round_number),
    FOREIGN KEY (job_id) REFERENCES JOB_ROLE(job_id) ON DELETE CASCADE
);

-- 9. INTERVIEW_RESULT Table
CREATE TABLE INTERVIEW_RESULT (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    round_id INT NOT NULL,
    score DECIMAL(5,2),
    status ENUM('Pass', 'Fail', 'Pending') DEFAULT 'Pending',
    remarks TEXT,
    UNIQUE KEY(application_id, round_id),
    FOREIGN KEY (application_id) REFERENCES APPLICATION(application_id) ON DELETE CASCADE,
    FOREIGN KEY (round_id) REFERENCES INTERVIEW_ROUND(round_id) ON DELETE CASCADE
);

-- 10. OFFER_LETTER Table
CREATE TABLE OFFER_LETTER (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT UNIQUE NOT NULL,
    offer_date DATE NOT NULL,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    joining_date DATE,
    acceptance_status ENUM('Pending', 'Accepted', 'Declined') DEFAULT 'Pending',
    FOREIGN KEY (application_id) REFERENCES APPLICATION(application_id) ON DELETE CASCADE
);

-- 11. SKILL_MASTER Table
CREATE TABLE SKILL_MASTER (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(50) UNIQUE NOT NULL,
    skill_category VARCHAR(50)
);

-- 12. STUDENT_SKILL Table (Many-to-Many)
CREATE TABLE STUDENT_SKILL (
    student_id VARCHAR(20) NOT NULL,
    skill_id INT NOT NULL,
    proficiency ENUM('Beginner', 'Intermediate', 'Advanced') DEFAULT 'Beginner',
    PRIMARY KEY (student_id, skill_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES SKILL_MASTER(skill_id) ON DELETE CASCADE
);

-- 13. ADMIN Table
CREATE TABLE ADMIN (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('SuperAdmin', 'PlacementOfficer', 'Coordinator') DEFAULT 'PlacementOfficer',
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 14. AUDIT_LOG Table
CREATE TABLE AUDIT_LOG (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(20),
    record_id VARCHAR(50),
    old_value TEXT,
    new_value TEXT,
    changed_by VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. LOGIN_HISTORY Table
CREATE TABLE LOGIN_HISTORY (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(50) NOT NULL,
    user_type ENUM('Student', 'Admin') NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    status ENUM('Success', 'Failed') NOT NULL
);

-- 16. NOTIFICATION Table
CREATE TABLE NOTIFICATION (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    recipient_id VARCHAR(50) NOT NULL,
    recipient_type ENUM('Student', 'Admin', 'All') NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 17. RECRUITER Table
CREATE TABLE RECRUITER (
    recruiter_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    designation VARCHAR(50),
    FOREIGN KEY (company_id) REFERENCES COMPANY(company_id) ON DELETE CASCADE
);
