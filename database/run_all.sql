-- Master script to build the entire placement_portal_final

-- 1. Schema
SOURCE c:/Users/ACER/Desktop/dbms final/database/schema/01_tables.sql;

-- 2. Functions
SOURCE c:/Users/ACER/Desktop/dbms final/database/functions/01_functions.sql;

-- 3. Views
SOURCE c:/Users/ACER/Desktop/dbms final/database/views/01_views.sql;

-- 4. Procedures
SOURCE c:/Users/ACER/Desktop/dbms final/database/procedures/01_procedures.sql;

-- 5. Triggers
SOURCE c:/Users/ACER/Desktop/dbms final/database/triggers/01_triggers.sql;

-- 6. Indexes
SOURCE c:/Users/ACER/Desktop/dbms final/database/indexes/01_indexes.sql;

-- 7. Sample Data
SOURCE c:/Users/ACER/Desktop/dbms final/database/sample_data/01_insert_data.sql;

SELECT 'Database built successfully!' AS Result;
