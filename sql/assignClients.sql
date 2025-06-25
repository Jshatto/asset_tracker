UPDATE assets 
SET client_id = CASE 
  WHEN id % 3 = 1 THEN 1  -- Every 3rd asset goes to client 1
  WHEN id % 3 = 2 THEN 2  -- Every 3rd asset goes to client 2
  ELSE 3                  -- Remaining assets go to client 3
END
WHERE client_id IS NULL;