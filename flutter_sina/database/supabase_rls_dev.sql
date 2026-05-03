-- Flutter Sina Supabase RLS Policies
-- Run this after supabase_schema.sql and supabase_seed.sql when you are ready.
-- این نسخه اولیه برای توسعه است. برای نسخه نهایی باید با Supabase Auth کامل‌تر شود.

alter table app_users enable row level security;
alter table student_tickets enable row level security;
alter table education_classes enable row level security;
alter table system_locks enable row level security;
alter table floating_announcements enable row level security;

-- Development policies
-- هشدار: این policyها برای شروع توسعه هستند و برای production باید محدودتر شوند.

drop policy if exists "dev_read_app_users" on app_users;
create policy "dev_read_app_users"
on app_users
for select
using (true);

drop policy if exists "dev_read_student_tickets" on student_tickets;
create policy "dev_read_student_tickets"
on student_tickets
for select
using (true);

drop policy if exists "dev_insert_student_tickets" on student_tickets;
create policy "dev_insert_student_tickets"
on student_tickets
for insert
with check (true);

drop policy if exists "dev_update_student_tickets" on student_tickets;
create policy "dev_update_student_tickets"
on student_tickets
for update
using (true)
with check (true);

drop policy if exists "dev_read_education_classes" on education_classes;
create policy "dev_read_education_classes"
on education_classes
for select
using (true);

drop policy if exists "dev_insert_education_classes" on education_classes;
create policy "dev_insert_education_classes"
on education_classes
for insert
with check (true);

drop policy if exists "dev_update_education_classes" on education_classes;
create policy "dev_update_education_classes"
on education_classes
for update
using (true)
with check (true);

drop policy if exists "dev_read_system_locks" on system_locks;
create policy "dev_read_system_locks"
on system_locks
for select
using (true);

drop policy if exists "dev_write_system_locks" on system_locks;
create policy "dev_write_system_locks"
on system_locks
for all
using (true)
with check (true);

drop policy if exists "dev_read_floating_announcements" on floating_announcements;
create policy "dev_read_floating_announcements"
on floating_announcements
for select
using (true);

drop policy if exists "dev_write_floating_announcements" on floating_announcements;
create policy "dev_write_floating_announcements"
on floating_announcements
for all
using (true)
with check (true);
