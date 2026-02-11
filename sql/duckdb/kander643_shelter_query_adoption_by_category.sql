-- sql/duckdb/kander643_shelter_query_adoption_by_category.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Break overall adoption performance down by animal type.
--
-- This query answers:
-- "How many adoptions and how much revenue do we have by animal type?"
--
-- WHY:
-- - Overall totals hide important differences.
-- - Grouping lets us compare parts of the system.
-- - This often reveals where action is needed:
--   * Which categories drive revenue?
--   * Which categories underperform?
--
-- IMPORTANT:
-- This query uses GROUP BY but does NOT join tables yet.
-- We are still working only with the dependent/child table (sale).

SELECT
  animal_type,
  COUNT(*) AS adoption_count,
  ROUND(SUM(fee), 2) AS fee_revenue,
  ROUND(AVG(fee), 2) AS avg_adoption_amount
FROM adoption
GROUP BY animal_type
ORDER BY fee_revenue DESC;
