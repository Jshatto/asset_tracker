INSERT INTO users (
  email,
  user_role,
  client_id
) VALUES (
  {{ formAddUser.data.email }},
  {{ formAddUser.data.user_role }},
  {{ formAddUser.data.client_id }}
)
RETURNING *;
