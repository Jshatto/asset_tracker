SELECT 0 AS id, 'All Clients' AS name
UNION ALL
SELECT id, client_name AS name
FROM clients
ORDER BY id;
