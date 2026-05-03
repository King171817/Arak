insert into app_users (
  id,
  username,
  password_hash,
  full_name,
  role,
  unit_key,
  email,
  phone,
  student_number,
  passport_number,
  locked,
  active
) values
('s001', 'admin', '1234', 'دانشجو نمونه', 'student', 'education', 'student@example.com', '', 's001', 'P-000000', false, true),
('p001', 'prof1', '1234', 'استاد نمونه', 'professor', 'education', 'professor@example.com', '', '', '', false, true),
('m001', 'admin2', '1234', 'مدیر آموزش', 'educationManager', 'education', 'manager@example.com', '', '', '', false, true),
('sina', 'sina', '1234', 'مدیر اصلی', 'superAdmin', 'all', 'sina@example.com', '', '', '', false, true)
on conflict (id) do update set
  username = excluded.username,
  password_hash = excluded.password_hash,
  full_name = excluded.full_name,
  role = excluded.role,
  unit_key = excluded.unit_key,
  locked = false,
  active = true,
  updated_at = now();
