-- sql/duckdb/kander643_shelter_query_adoption_aggregate.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Summarize overall adoption activity across ALL shelters.
--
-- This query answers:
-- - "What is our total revenue?"
-- - "What is the average adoption amount?"
--
-- WHY:
-- - Establishes system-wide performance
-- - Provides a baseline before breaking results down by shelter
-- - Helps answer:
--   "Is overall performance up or down?"

SELECT
  animal_type,
  COUNT(*) AS adoption_count,
  ROUND(SUM(fee), 2) AS fee_revenue
FROM adoption
GROUP BY animal_type;
