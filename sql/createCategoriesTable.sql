CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  category_name VARCHAR(255) NOT NULL UNIQUE,
  default_useful_life INTEGER DEFAULT 5,
  default_depreciation_method VARCHAR(50) DEFAULT 'Straight-Line',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);