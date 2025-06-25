SELECT *
FROM clients
WHERE id = {{ url.searchParams.clientId }};
