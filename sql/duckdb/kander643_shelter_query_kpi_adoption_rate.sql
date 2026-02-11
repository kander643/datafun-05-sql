-- sql/duckdb/kander643_shelter_query_kpi_adoption_rate.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Calculate a Key Performance Indicator (KPI) for the shelter domain using DuckDB SQL.
--
-- KPI DRIVES THE WORK:
-- In analytics, we do not start with "write a query."
-- We start with a KPI that supports an actionable decision.
--
-- ACTIONABLE OUTCOME (EXAMPLE):
-- We want to identify which shelters are generating the most adoptions so we can:
-- - allocate staffing during high-performing periods,
-- - increase inventory for top animal types,
-- - investigate why low-performing shelters are underperforming,
-- - target promotions where they will have the biggest impact.
--
-- In this example, our KPI is shelter adoption count (total number of adoptions) by shelter.
--
-- ANALYST RESPONSIBILITY:
-- Analysts are responsible for determining HOW to get the information
-- that informs the KPI and supports action.
-- That means:
-- - identifying the needed tables,
-- - joining them correctly,
-- - selecting the right measures,
-- - aggregating at the correct level (store),
-- - and presenting results in a way that supports decision-making.
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/case_shelter_kpi_adoption_rate.sql
--   DB:   artifacts/duckdb/shelter.duckdb
--
--
-- ============================================================
-- TOPIC DOMAINS + 1:M RELATIONSHIPS
-- ============================================================
-- OUR DOMAIN: SHELTER
-- Two tables in a 1-to-many relationship (1:M):
-- - shelter (1): independent/parent table
-- - adoption  (M): dependent/child table
--
-- HOW THIS RELATES TO OUR KPI:
-- - The shelter table tells us "which shelter" (shelter_id, shelter_name, location).
-- - The adoption table contains the measurable activity (adoption_id, animal_type, adoption_date).
-- - To compute adoption count by shelter, we must:
--   1) connect each adoption to its shelter (JOIN on shelter_id),
--   2) aggregate adoption counts at the shelter level (GROUP BY shelter).
--
--
-- ============================================================
-- KPI DEFINITION
-- ============================================================
-- KPI NAME: Total Adoptions by Shelter
--
-- KPI QUESTION:
-- "How many adoptions did each shelter generate?"
--
-- MEASURE:
-- - adoption count = COUNT(adoption.adoption_id)
--
-- GRAIN (LEVEL OF DETAIL):
-- - one row per shelter
--
-- OUTPUT (WHAT DECISION-MAKERS NEED):
-- - shelter identifier and name
-- - total adoption count
-- - optionally: number of adoptions and average adoption amount
--
--
-- ============================================================
-- EXECUTION: GET THE INFORMATION THAT INFORMS THE KPI
-- ============================================================
-- Strategy:
-- - JOIN shelter (1) to adoption (M)
-- - GROUP BY shelter
-- - COUNT adoptions to compute adoption count
-- - ORDER results so we can quickly see top shelters
--
SELECT
  s.shelter_id,
  s.shelter_name,
  s.city,
  s.region,
  COUNT(a.adoption_id) AS adoption_count,
  ROUND(SUM(a.fee), 2) AS total_adoption_revenue,
  ROUND(AVG(a.fee), 2) AS avg_adoption_amount
FROM shelter AS s
JOIN adoption AS a
  ON a.shelter_id = s.shelter_id
GROUP BY
  s.shelter_id,
  s.shelter_name,
  s.city,
  s.region
ORDER BY total_adoption_revenue DESC;
