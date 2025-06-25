ALTER TABLE assets ADD COLUMN IF NOT EXISTS tax_depreciation_method VARCHAR(50) DEFAULT 'MACRS';
ALTER TABLE assets ADD COLUMN IF NOT EXISTS book_depreciation_method VARCHAR(50) DEFAULT 'Straight-Line';
ALTER TABLE assets ADD COLUMN IF NOT EXISTS macrs_class_life INTEGER DEFAULT 5;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS accumulated_tax_depreciation NUMERIC DEFAULT 0;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS accumulated_book_depreciation NUMERIC DEFAULT 0;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS placed_in_service_date DATE;