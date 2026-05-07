# University Placement & Recruitment Management System
### Advanced DBMS Project for Viva Evaluation

This is a complete Full-Stack DBMS-Centric project designed specifically for advanced database system evaluation. The primary business logic runs directly inside MySQL using Stored Procedures, Functions, Triggers, and Views.

## Project Structure

```text
/backend               # Node.js + Express bridging server
/frontend              # React.js DBMS Demonstration Panel
/database
  ├── /schema          # Normalised 3NF/BCNF Table definitions
  ├── /functions       # Reusable PL/SQL functions
  ├── /views           # Real-time analytics views
  ├── /procedures      # Transactional stored procedures
  ├── /triggers        # Automation and audit logging triggers
  ├── /indexes         # Query optimization indexes
  ├── /sample_data     # Realistic mock data
  ├── /queries         # 30 complex SQL queries (Joins, Windows, CTEs)
  └── run_all.sql      # Master script to build the DB
/docs                  # ER Schema & ACID documentation
/docs/viva_notes       # 50+ Viva & Interview Questions
```

## How to Test and Run the Complete System

Since I am an AI and do not have your local MySQL `root` password, I have built the entire project for you, but you need to run the final execution step.

### Step 1: Initialize Database
1. Open MySQL Workbench or your terminal.
2. Run the master script to build the entire database and insert sample data:
```sql
SOURCE c:/Users/ACER/Desktop/dbms final/database/run_all.sql;
```

### Step 2: Start Backend Server
1. Go into the backend folder and open the `.env` file.
2. **IMPORTANT**: Change the `DB_PASSWORD` in the `.env` file to your actual MySQL root password.
3. Open a terminal in `/backend` and run:
```bash
npm run start # (or node server.js)
```

### Step 3: Start Frontend Demonstration Panel
1. Open a terminal in `/frontend` and run:
```bash
npm run dev
```
2. Open your browser to `http://localhost:5173`.

## DBMS Features Highlight

- **Stored Procedures**: `Apply_For_Job()` handles atomicity, checking eligibility, preventing duplicates, and inserting audit logs inside a single `START TRANSACTION; ... COMMIT;` block.
- **Functions**: `Check_Eligibility()` encapsulates complex logic to ensure a student meets CGPA, backlog, and branch criteria.
- **Triggers**: `Before_Application_Insert` natively prevents duplicates. `After_Offer_Acceptance` automatically changes `is_placed = TRUE` for students.
- **Views**: `Placement_Analytics_View` pre-aggregates placement statistics securely for the dashboard.
- **Complex SQL**: Find 30 highly complex queries demonstrating Joins, Window Functions (`RANK()`, `DENSE_RANK()`), Correlated Subqueries, and CTEs in `/database/queries/01_complex_queries.sql`.


