USE placement_portal_final;

-- 1. DEPARTMENT (10 entries)
INSERT INTO DEPARTMENT (dept_name, hod_name) VALUES 
('Computer Science', 'Dr. Alan Turing'),
('Information Technology', 'Dr. Grace Hopper'),
('Electronics and Communication', 'Dr. Claude Shannon'),
('Mechanical Engineering', 'Dr. Henry Ford'),
('Civil Engineering', 'Dr. Isambard Brunel'),
('Electrical Engineering', 'Dr. Nikola Tesla'),
('Aerospace Engineering', 'Dr. Wernher von Braun'),
('Biotechnology', 'Dr. Rosalind Franklin'),
('Chemical Engineering', 'Dr. Marie Curie'),
('Metallurgy', 'Dr. Henry Bessemer');

-- 2. STUDENT (10 entries)
INSERT INTO STUDENT (student_id, first_name, last_name, email, phone_number, dob, gender, cgpa, tenth_percentage, twelfth_percentage, active_backlogs, dept_id, enrollment_year, is_placed) VALUES 
('CS001', 'Alice', 'Smith', 'alice@college.edu', '9876543210', '2002-05-15', 'Female', 9.2, 95.0, 92.5, 0, 1, 2020, FALSE),
('CS002', 'Bob', 'Johnson', 'bob@college.edu', '9876543211', '2001-08-22', 'Male', 8.5, 88.0, 85.0, 0, 1, 2020, FALSE),
('IT001', 'Charlie', 'Brown', 'charlie@college.edu', '9876543212', '2002-01-10', 'Male', 7.8, 80.0, 78.0, 1, 2, 2020, FALSE),
('EC001', 'Diana', 'Prince', 'diana@college.edu', '9876543213', '2002-11-05', 'Female', 9.0, 92.0, 90.0, 0, 3, 2020, FALSE),
('ME001', 'Evan', 'Wright', 'evan@college.edu', '9876543214', '2001-03-12', 'Male', 8.1, 85.0, 82.0, 0, 4, 2020, FALSE),
('CE001', 'Fiona', 'Gallagher', 'fiona@college.edu', '9876543215', '2002-07-19', 'Female', 8.8, 89.0, 87.0, 0, 5, 2020, FALSE),
('EE001', 'George', 'Washington', 'george@college.edu', '9876543216', '2001-12-01', 'Male', 7.5, 75.0, 76.0, 2, 6, 2020, FALSE),
('AE001', 'Hannah', 'Abbott', 'hannah@college.edu', '9876543217', '2002-04-25', 'Female', 9.5, 96.0, 94.0, 0, 7, 2020, FALSE),
('BT001', 'Ian', 'Malcolm', 'ian@college.edu', '9876543218', '2001-09-09', 'Male', 8.2, 83.0, 81.0, 0, 8, 2020, FALSE),
('CH001', 'Jane', 'Goodall', 'jane@college.edu', '9876543219', '2002-02-14', 'Female', 8.7, 86.0, 88.0, 0, 9, 2020, FALSE);

-- 3. COMPANY (10 entries)
INSERT INTO COMPANY (company_name, industry_type, website, hr_contact_name, hr_email, hr_phone) VALUES 
('TechCorp', 'Software', 'techcorp.com', 'John Doe', 'hr@techcorp.com', '1122334455'),
('DataSys', 'Data Analytics', 'datasys.com', 'Jane Roe', 'hr@datasys.com', '2233445566'),
('ElectroTech', 'Hardware', 'electrotech.com', 'Mike Smith', 'hr@electrotech.com', '3344556677'),
('BuildIt', 'Construction', 'buildit.com', 'Sarah Connor', 'hr@buildit.com', '4455667788'),
('AeroSpaceX', 'Aerospace', 'aerospacex.com', 'Elon Musk', 'hr@aerospacex.com', '5566778899'),
('BioGen', 'Biotechnology', 'biogen.com', 'Alice Vance', 'hr@biogen.com', '6677889900'),
('ChemWorks', 'Chemical', 'chemworks.com', 'Walter White', 'hr@chemworks.com', '7788990011'),
('AutoMakers', 'Automotive', 'automakers.com', 'Henry Ford II', 'hr@automakers.com', '8899001122'),
('FinServe', 'Finance', 'finserve.com', 'Gordon Gekko', 'hr@finserve.com', '9900112233'),
('CloudNet', 'Cloud Computing', 'cloudnet.com', 'Satya Nadella', 'hr@cloudnet.com', '0011223344');

-- 4. PLACEMENT_DRIVE (10 entries)
INSERT INTO PLACEMENT_DRIVE (company_id, drive_date, registration_deadline, status) VALUES 
(1, DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Upcoming'),
(2, DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Upcoming'),
(3, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'Completed'),
(4, DATE_ADD(CURDATE(), INTERVAL 20 DAY), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Upcoming'),
(5, DATE_ADD(CURDATE(), INTERVAL 25 DAY), DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'Upcoming'),
(6, CURDATE(), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Ongoing'),
(7, DATE_ADD(CURDATE(), INTERVAL 30 DAY), DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'Upcoming'),
(8, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'Completed'),
(9, DATE_ADD(CURDATE(), INTERVAL 5 DAY), CURDATE(), 'Upcoming'),
(10, DATE_ADD(CURDATE(), INTERVAL 12 DAY), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Upcoming');

-- 5. JOB_ROLE (10 entries)
INSERT INTO JOB_ROLE (drive_id, job_title, package, job_location, vacancies) VALUES 
(1, 'Software Development Engineer', 12.50, 'Bangalore', 10),
(2, 'Data Analyst', 8.00, 'Hyderabad', 15),
(3, 'Hardware Engineer', 7.50, 'Pune', 5),
(4, 'Site Engineer', 6.00, 'Mumbai', 20),
(5, 'Aerodynamics Engineer', 15.00, 'Bangalore', 3),
(6, 'Research Scientist', 10.00, 'Delhi', 8),
(7, 'Process Engineer', 7.00, 'Chennai', 12),
(8, 'Automotive Design Engineer', 9.00, 'Pune', 6),
(9, 'Financial Analyst', 11.00, 'Mumbai', 10),
(10, 'Cloud Architect', 14.00, 'Hyderabad', 5);

-- 6. ELIGIBILITY_CRITERIA (10 entries)
INSERT INTO ELIGIBILITY_CRITERIA (job_id, min_cgpa, max_backlogs, min_tenth, min_twelfth, allowed_departments) VALUES 
(1, 8.0, 0, 85.0, 85.0, '1,2'),
(2, 7.5, 1, 75.0, 75.0, '1,2,3'),
(3, 7.0, 0, 70.0, 70.0, '3,6'),
(4, 6.5, 2, 60.0, 60.0, '5'),
(5, 9.0, 0, 90.0, 90.0, '7,4'),
(6, 8.5, 0, 80.0, 80.0, '8'),
(7, 7.0, 1, 70.0, 70.0, '9'),
(8, 7.5, 0, 75.0, 75.0, '4'),
(9, 8.0, 0, 80.0, 80.0, 'ALL'),
(10, 8.5, 0, 85.0, 85.0, '1,2');

-- 7. SKILL_MASTER (10 entries)
INSERT INTO SKILL_MASTER (skill_name, skill_category) VALUES 
('Java', 'Programming'),
('Python', 'Programming'),
('SQL', 'Database'),
('Verilog', 'Hardware'),
('AutoCAD', 'Design'),
('MATLAB', 'Analysis'),
('C++', 'Programming'),
('AWS', 'Cloud'),
('Excel', 'Tools'),
('Machine Learning', 'Domain');

-- 8. STUDENT_SKILL (10 entries)
INSERT INTO STUDENT_SKILL (student_id, skill_id, proficiency) VALUES 
('CS001', 1, 'Advanced'),
('CS001', 3, 'Intermediate'),
('IT001', 2, 'Intermediate'),
('EC001', 4, 'Advanced'),
('ME001', 5, 'Intermediate'),
('CE001', 5, 'Beginner'),
('EE001', 6, 'Intermediate'),
('AE001', 6, 'Advanced'),
('BT001', 2, 'Beginner'),
('CH001', 9, 'Advanced');

-- 9. ADMIN (10 entries)
INSERT INTO ADMIN (username, password_hash, role, email) VALUES 
('admin1', 'hash1', 'SuperAdmin', 'admin1@college.edu'),
('admin2', 'hash2', 'PlacementOfficer', 'admin2@college.edu'),
('admin3', 'hash3', 'Coordinator', 'admin3@college.edu'),
('admin4', 'hash4', 'PlacementOfficer', 'admin4@college.edu'),
('admin5', 'hash5', 'Coordinator', 'admin5@college.edu'),
('admin6', 'hash6', 'Coordinator', 'admin6@college.edu'),
('admin7', 'hash7', 'PlacementOfficer', 'admin7@college.edu'),
('admin8', 'hash8', 'Coordinator', 'admin8@college.edu'),
('admin9', 'hash9', 'SuperAdmin', 'admin9@college.edu'),
('admin10', 'hash10', 'Coordinator', 'admin10@college.edu');

-- 10. RECRUITER (10 entries)
INSERT INTO RECRUITER (company_id, name, email, phone, designation) VALUES 
(1, 'Alice Recruiter', 'alice.r@techcorp.com', '1112223334', 'Senior Recruiter'),
(2, 'Bob Recruiter', 'bob.r@datasys.com', '2223334445', 'HR Manager'),
(3, 'Charlie Recruiter', 'charlie.r@electrotech.com', '3334445556', 'Talent Acquisition'),
(4, 'Diana Recruiter', 'diana.r@buildit.com', '4445556667', 'Campus Recruiter'),
(5, 'Evan Recruiter', 'evan.r@aerospacex.com', '5556667778', 'HR Lead'),
(6, 'Fiona Recruiter', 'fiona.r@biogen.com', '6667778889', 'University Relations'),
(7, 'George Recruiter', 'george.r@chemworks.com', '7778889990', 'HR Associate'),
(8, 'Hannah Recruiter', 'hannah.r@automakers.com', '8889990001', 'Recruitment Specialist'),
(9, 'Ian Recruiter', 'ian.r@finserve.com', '9990001112', 'Campus Lead'),
(10, 'Jane Recruiter', 'jane.r@cloudnet.com', '0001112223', 'Technical Recruiter');

-- 11. APPLICATION (10 entries)
INSERT INTO APPLICATION (student_id, job_id, status) VALUES 
('CS001', 1, 'Selected'),
('CS002', 1, 'Applied'),
('IT001', 2, 'Applied'),
('EC001', 3, 'Rejected'),
('AE001', 5, 'Shortlisted'),
('CH001', 9, 'Applied'),
('CS001', 10, 'Applied'),
('ME001', 4, 'Applied'),
('CE001', 4, 'Applied'),
('BT001', 6, 'Applied');

-- 12. INTERVIEW_ROUND (10 entries)
INSERT INTO INTERVIEW_ROUND (job_id, round_number, round_type, round_date) VALUES 
(1, 1, 'Aptitude', CURDATE()),
(1, 2, 'Technical', CURDATE()),
(2, 1, 'Aptitude', CURDATE()),
(3, 1, 'Technical', CURDATE()),
(4, 1, 'HR', CURDATE()),
(5, 1, 'Technical', CURDATE()),
(6, 1, 'Aptitude', CURDATE()),
(7, 1, 'Technical', CURDATE()),
(8, 1, 'HR', CURDATE()),
(9, 1, 'Managerial', CURDATE()),
(10, 1, 'Technical', CURDATE());

-- 13. INTERVIEW_RESULT (10 entries)
INSERT INTO INTERVIEW_RESULT (application_id, round_id, score, status) VALUES 
(1, 1, 85.0, 'Pass'),
(1, 2, 90.0, 'Pass'),
(4, 4, 40.0, 'Fail'),
(5, 6, 88.0, 'Pass'),
(2, 1, 70.0, 'Pass'),
(3, 3, 75.0, 'Pass'),
(8, 5, 80.0, 'Pass'),
(9, 5, 82.0, 'Pass'),
(10, 7, 78.0, 'Pass'),
(6, 10, 85.0, 'Pass');

-- 14. OFFER_LETTER (1 entry intentionally, representing one acceptance to demonstrate triggers without failing)
INSERT INTO OFFER_LETTER (application_id, offer_date, base_salary, joining_date, acceptance_status) VALUES 
(1, CURDATE(), 12.50, DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'Accepted');

-- 15. AUDIT_LOG (10 dummy entries to ensure the table has data immediately)
INSERT INTO AUDIT_LOG (table_name, operation, record_id, changed_by) VALUES 
('DEPARTMENT', 'INSERT', '1', 'System'),
('STUDENT', 'INSERT', 'CS001', 'System'),
('STUDENT', 'INSERT', 'CS002', 'System'),
('COMPANY', 'INSERT', '1', 'System'),
('JOB_ROLE', 'INSERT', '1', 'System'),
('APPLICATION', 'INSERT', '1', 'System'),
('INTERVIEW_ROUND', 'INSERT', '1', 'System'),
('INTERVIEW_RESULT', 'INSERT', '1', 'System'),
('OFFER_LETTER', 'INSERT', '1', 'System'),
('STUDENT', 'UPDATE_CGPA', 'CS001', 'System');

-- 16. LOGIN_HISTORY (10 entries)
INSERT INTO LOGIN_HISTORY (user_id, user_type, status) VALUES 
('CS001', 'Student', 'Success'),
('CS002', 'Student', 'Success'),
('admin1', 'Admin', 'Success'),
('IT001', 'Student', 'Failed'),
('EC001', 'Student', 'Success'),
('admin2', 'Admin', 'Success'),
('ME001', 'Student', 'Success'),
('admin3', 'Admin', 'Success'),
('CE001', 'Student', 'Failed'),
('AE001', 'Student', 'Success');

-- 17. NOTIFICATION (10 entries)
INSERT INTO NOTIFICATION (recipient_id, recipient_type, title, message) VALUES 
('CS001', 'Student', 'Welcome', 'Welcome to placement portal'),
('CS002', 'Student', 'Welcome', 'Welcome to placement portal'),
('admin1', 'Admin', 'Alert', 'New drive added'),
('IT001', 'Student', 'Job Alert', 'TechCorp drive added'),
('EC001', 'Student', 'Job Alert', 'TechCorp drive added'),
('ME001', 'Student', 'Reminder', 'Update profile'),
('CE001', 'Student', 'Reminder', 'Update profile'),
('EE001', 'Student', 'Job Alert', 'DataSys drive added'),
('AE001', 'Student', 'Job Alert', 'DataSys drive added'),
('admin2', 'Admin', 'Status', 'System running smoothly');
