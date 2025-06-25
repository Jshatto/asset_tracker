WITH yearly_data AS (
  SELECT 
    EXTRACT(YEAR FROM purchase_date) as year,
    SUM(purchase_price::numeric) as total_asset_value,
    
    -- Book depreciation for the year
    SUM(
      CASE 
        WHEN book_depreciation_method = 'Straight-Line' OR book_depreciation_method IS NULL THEN
          purchase_price::numeric / NULLIF(useful_life_years, 0)
        ELSE 0
      END
    ) as annual_book_depreciation,
    
    -- Tax depreciation for the year (simplified - first year rates)
    SUM(
      CASE 
        WHEN section_179_election = TRUE 
        THEN COALESCE(NULLIF(section_179_amount, 0), purchase_price::numeric)
        WHEN bonus_depreciation_election = TRUE 
        THEN purchase_price::numeric
        ELSE 
          CASE COALESCE(macrs_class_life, 5)
            WHEN 5 THEN purchase_price::numeric * 0.20
            WHEN 3 THEN purchase_price::numeric * 0.3333
            WHEN 7 THEN purchase_price::numeric * 0.1429
            ELSE purchase_price::numeric * 0.20
          END
      END
    ) as annual_tax_depreciation
    
  FROM assets 
  WHERE purchase_date IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM purchase_date)
)
SELECT 
  year,
  total_asset_value,
  annual_book_depreciation,
  annual_tax_depreciation
FROM yearly_data
ORDER BY year;