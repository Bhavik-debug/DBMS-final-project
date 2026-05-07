# DBMS Viva Preparation Notes

## SQL Queries & Normalization

**Q1: What normal forms does this database adhere to?**
**A:** The schema is normalized up to 3NF/BCNF. There are no repeating groups (1NF), no partial dependencies (2NF), and no transitive dependencies (3NF). For example, `company_name` is stored in the `COMPANY` table, not `JOB_ROLE`, eliminating data redundancy.

**Q2: Explain the difference between INNER JOIN and LEFT JOIN using this schema.**
**A:** An `INNER JOIN` between `STUDENT` and `APPLICATION` will only return students who have applied for at least one job. A `LEFT JOIN` will return *all* students, and those who haven't applied will show NULL for the application columns.

**Q3: What are Window Functions? How are they used here?**
**A:** Window functions perform calculations across a set of table rows that are related to the current row, without collapsing them into a single output row like `GROUP BY`. In our `01_complex_queries.sql`, we used `RANK() OVER(PARTITION BY dept_id ORDER BY cgpa DESC)` to find the top-ranking students within each department independently.

## PL/SQL: Triggers & Procedures

**Q4: Why use a Stored Procedure for `Apply_For_Job` instead of just executing an INSERT statement from the backend?**
**A:** A stored procedure encapsulates the business logic inside the database. `Apply_For_Job` checks if the student is already placed, checks if they have already applied, calls a function `Check_Eligibility()`, and logs the action into the `AUDIT_LOG` table, all within a single Atomic Transaction. It minimizes network round-trips and guarantees data consistency.

**Q5: What is the purpose of the `After_Offer_Acceptance` trigger?**
**A:** It maintains database consistency. When an offer letter's status is updated to 'Accepted', the trigger automatically updates the `STUDENT` table to set `is_placed = TRUE`. This prevents anomalies where an offer is accepted but the student is still marked as unplaced.

**Q6: What happens if a procedure fails halfway through?**
**A:** We implemented Exception Handling (`DECLARE EXIT HANDLER FOR SQLEXCEPTION`). If any error occurs, a `ROLLBACK` is executed to undo all changes made during the transaction, preserving the database's Atomicity.

## Indexing & Performance

**Q7: Why did we create an index on `STUDENT(dept_id)`?**
**A:** The application frequently groups data by department (e.g., calculating placement percentage per branch). The B-Tree index on `dept_id` allows the database engine to quickly locate students by department without scanning the entire `STUDENT` table (avoiding full table scans).

**Q8: Explain the `EXISTS` vs `IN` operator performance difference.**
**A:** `EXISTS` stops scanning once it finds the first matching row, making it faster for large datasets. `IN` evaluates the entire subquery first and stores it in memory. In query #8, we used `EXISTS` to efficiently find companies that have conducted drives.

## Transactions & ACID

**Q9: How is Isolation maintained in our transactions?**
**A:** MySQL's InnoDB engine handles Isolation. When `Publish_Result` is running, row-level locks prevent other transactions from modifying the same application record simultaneously, preventing Lost Updates and Dirty Reads.
