CREATE TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  client_name VARCHAR(255) NOT NULL,
  contact_email VARCHAR(255),
  contact_phone VARCHAR(50),
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(50),
  zip_code VARCHAR(20),
  country VARCHAR(100) DEFAULT 'United States',
  status VARCHAR(20) DEFAULT 'Active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  notes TEXT
);