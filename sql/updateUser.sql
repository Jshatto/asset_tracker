UPDATE users
SET
  email     = {{ formEditUser.data.email }},
  user_role = {{ formEditUser.data.user_role }},
  client_id = {{ formEditUser.data.client_id }}
WHERE id = {{ formEditUser.data.id }}
RETURNING *;
