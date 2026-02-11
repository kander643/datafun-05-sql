-- sql/duckdb/kander643_shelter_bootstrap.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Creates shelter tables and loads data from CSV files (DuckDB).
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/kander643_shelter_bootstrap.sql
--   CSV:  data/shelter/store.csv
--   CSV:  data/shelter/sale.csv
--   DB:   artifacts/duckdb/shelter.duckdb
--
--
-- ============================================================
-- TOPIC DOMAINS + 1:M RELATIONSHIPS
-- ============================================================
-- OUR DOMAINS:
-- Each domain (e.g. retail) has two tables.
-- They are related in a 1-to-many relationship (1:M).
--
-- GENERAL:
-- In a 1-to-many relationship:
-- - The one table (1) is the independent/parent table.
--   It does not depend on any other table.
-- - The many table (M) is the dependent/child table.
--   It depends on the independent/parent table.
-- - They are related by a foreign key in the dependent/child table
--   that references the primary key in the independent/parent table.
--
--
-- REQ: Tables must be created in order to satisfy foreign key constraints.
-- REQ: Data must be loaded in order to satisfy foreign key constraints.
--
--
-- ============================================================
-- EXECUTION: ATOMIC BOOTSTRAP (ALL OR NOTHING)
-- ============================================================
-- Use a transaction to ensure atomicity.
-- Atomicity: either all operations succeed,
-- or none do and the database remains unchanged.
-- Start with BEGIN TRANSACTION; and end with COMMIT; if all succeed.
-- If any operation fails, the database will ROLLBACK to undo all changes.
-- This ensures the database is never left in a partial or inconsistent state.
BEGIN TRANSACTION;
--
--
-- ============================================================
-- STEP 1: CREATE TABLES (PARENT FIRST, THEN CHILD)
-- ============================================================
-- The independent table must be created first.
-- In retail, stores exist independently of sales.
-- Therefore, create the store table before the sale table.
--
-- Create the `store` table using DuckDB SQL syntax and data types.
-- In our table, all the fields are required (NOT NULL).
-- This means that every record must have a value for these fields.
-- The primary key is store_id, which uniquely identifies each store.
CREATE TABLE IF NOT EXISTS shelter (
  -- Every table must have a primary key that uniquely identifies each record.
  shelter_id TEXT PRIMARY KEY,
  shelter_name TEXT NOT NULL,
  city TEXT NOT NULL,
  region TEXT NOT NULL
);
-- Create the `adoption` table using DuckDB SQL syntax and data types.
CREATE TABLE adoption (
    adoption_id VARCHAR,
    shelter_id VARCHAR,
    animal_type VARCHAR,
    outcome VARCHAR,
    fee DOUBLE,
    adopt_date DATE
);
--
--
-- ============================================================
-- STEP 2: LOAD DATA (PARENT FIRST, THEN CHILD)
-- ============================================================
-- DUCKDB SPECIFIC:
-- DuckDB allows us to load data from CSV files using the DuckDB COPY command.
--
-- The independent table must be loaded first.
-- In shelter, shelters exist independently of adoptions.
-- Therefore, load the shelter table before the adoption table.
--
-- SQLITE ALTERNATIVE:
-- If we used SQLite, we would load data using Python and pandas.
-- Load the parent (independent) table first.
COPY shelter
FROM 'data/shelter/shelter.csv'
(HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');

-- Load the child (dependent) table second.
COPY adoption
FROM 'data/shelter/adoption.csv'
(HEADER 1, DELIMITER ',', QUOTE '"', ESCAPE '"');

--
--
-- ============================================================
-- FINISH EXECUTION: ATOMIC BOOTSTRAP (ALL OR NOTHING)
-- ============================================================
-- If we reach this point, all operations succeeded.
-- Therefore, commit the transaction to make the changes permanent.
COMMIT;
--
--
-- ============================================================
-- REFERENCE: DUCKDB COPY CSV OPTIONS
-- ============================================================
-- CUSTOM: WHEN USING DUCKDB COPY COMMAND, the last line tells how to read the CSV file.
--
-- HEADER 1:
-- The first row in the CSV file contains column headers (not data).
-- Use HEADER 0 if no header row.
--
-- DELIMITER ',':
-- Columns are separated by commas.
--
-- QUOTE '"':
-- Text fields are enclosed in double quotes.
--
-- ESCAPE '"':
-- Double quotes within text fields are escaped by doubling them.
