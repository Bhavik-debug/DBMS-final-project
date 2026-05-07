# University Placement & Recruitment Management System

## 1. Entity-Relationship (ER) Design

The database is designed with robust normalization up to 3NF/BCNF. Here are the primary entities and their relationships:

- **STUDENT**: Core entity. 1-to-N with APPLICATION, 1-to-1 with DEPARTMENT.
- **DEPARTMENT**: 1-to-N with STUDENT.
- **COMPANY**: 1-to-N with PLACEMENT_DRIVE and RECRUITER.
- **PLACEMENT_DRIVE**: 1-to-N with JOB_ROLE.
- **JOB_ROLE**: 1-to-1 with ELIGIBILITY_CRITERIA, 1-to-N with APPLICATION and INTERVIEW_ROUND.
- **APPLICATION**: Many-to-Many resolution between STUDENT and JOB_ROLE. 1-to-N with INTERVIEW_RESULT, 1-to-1 with OFFER_LETTER.
- **SKILL_MASTER & STUDENT_SKILL**: Many-to-Many resolution between STUDENT and skills.

## 2. Normalization Steps

### First Normal Form (1NF)
- All columns have atomic values. (e.g., instead of storing multiple skills in one string, we use a separate `STUDENT_SKILL` table).

### Second Normal Form (2NF)
- All tables are in 1NF and all non-key attributes are fully functional dependent on the primary key.
- Example: In `INTERVIEW_RESULT`, the score depends entirely on the composite of `application_id` and `round_id`.

### Third Normal Form (3NF) / BCNF
- No transitive dependencies. 
- Example: We don't store `company_name` directly in the `JOB_ROLE` table. Instead, `JOB_ROLE` links to `PLACEMENT_DRIVE`, which links to `COMPANY`.

## 3. ACID Properties Implementation

- **Atomicity**: Seen in `Apply_For_Job` and `Publish_Result` procedures. If inserting an application succeeds but creating the audit log fails, the transaction is rolled back.
- **Consistency**: Enforced heavily through `FOREIGN KEY` constraints (CASCADE/RESTRICT), `CHECK` constraints (CGPA >= 0), and `UNIQUE` constraints (preventing duplicate applications).
- **Isolation**: Handled by MySQL's default InnoDB isolation level (`REPEATABLE READ`), ensuring concurrent application submissions don't read dirty data.
- **Durability**: Once a transaction COMMITs in `Publish_Result`, the change is permanent, and logs are persisted.

## 4. Triggers Flowchart

- `BEFORE INSERT on APPLICATION`: Intercepts inserts, checks for duplicate applications using `COUNT(*)`, and throws `SIGNAL SQLSTATE '45000'` if found.
- `AFTER UPDATE on OFFER_LETTER`: If `acceptance_status` changes to 'Accepted', it automatically updates the `STUDENT` table (`is_placed = TRUE`).

## 5. View Explanation
- `Placement_Analytics_View`: Simplifies the dashboard by abstracting complex Joins and aggregations (average CGPA, percentage of students placed, highest package).
