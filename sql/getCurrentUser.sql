-- Query name: getCurrentUser
SELECT 
  id, 
  email, 
  user_role
FROM users
WHERE email = {{ retool.user.email }};
