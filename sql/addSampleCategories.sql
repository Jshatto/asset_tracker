INSERT INTO categories (category_name, default_useful_life, default_depreciation_method) VALUES
('Office Equipment', 5, 'Straight-Line'),
('IT Equipment', 3, 'Straight-Line'),
('Vehicles', 8, 'Declining Balance'),
('Furniture', 7, 'Straight-Line'),
('Machinery', 10, 'Declining Balance'),
('Software', 3, 'Straight-Line'),
('Tools', 5, 'Straight-Line')
ON CONFLICT (category_name) DO NOTHING;