-- getAssetValueComparison
WITH
  months AS (
    SELECT
      generate_series(
        ({{ baseYear.value }} || '-01-01')::date,
        ({{ baseYear.value }} || '-01-01')::date + interval '11 month',
        interval '1 month'
      ) AS month_date
  ),
  base AS (
    SELECT
      DATE_TRUNC('month', purchase_date)::date AS month_date,
      SUM(purchase_price)                        AS total_cost
    FROM assets
    WHERE EXTRACT(YEAR FROM purchase_date) = {{ baseYear.value }}
    GROUP BY 1
  ),
  comp AS (
    SELECT
      -- take the month of each compareYear purchase but map it onto baseYear’s calendar
      make_date(
        {{ baseYear.value }},
        EXTRACT(MONTH FROM purchase_date)::INT,
        1
      )                                       AS month_date,
      SUM(purchase_price)                     AS total_cost
    FROM assets
    WHERE EXTRACT(YEAR FROM purchase_date) = {{ compareYear.value }}
    GROUP BY 1
  )
SELECT
  m.month_date,
  COALESCE(b.total_cost, 0)   AS base_total,
  COALESCE(c.total_cost, 0)   AS compare_total
FROM months m
LEFT JOIN base b   ON m.month_date = b.month_date
LEFT JOIN comp c   ON m.month_date = c.month_date
ORDER BY m.month_date;
