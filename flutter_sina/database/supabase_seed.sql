-- Flutter Sina Supabase Seed Data
-- Run this after supabase_schema.sql.

insert into app_users (
  id, username, password, display_name, role, unit_key, is_locked
) values
  ('student_admin', 'admin', '1234', 'دانشجو نمونه', 'student', 'student', false),
  ('p001', 'prof1', '1234', 'دکتر محمدی', 'professor', 'education', false),
  ('p002', 'prof2', '1234', 'Dr. Johnson', 'professor', 'education', false),
  ('manager_international', 'admin1', '1234', 'مدیر امور بین‌الملل', 'unitManager', 'international', false),
  ('manager_education', 'admin2', '1234', 'مدیر آموزش', 'educationManager', 'education', false),
  ('manager_student_services', 'admin3', '1234', 'مدیر خدمات دانشجویی', 'unitManager', 'student_services', false),
  ('manager_consular', 'admin4', '1234', 'مدیر کنسولی', 'unitManager', 'consular', false),
  ('super_admin_sina', 'sina', '1234', 'sina', 'superAdmin', 'admin_main', false),
  ('eo001', 'edu_officer1', '1234', 'کارشناس آموزش ۱', 'educationOfficer', 'education', false)
on conflict (id) do update set
  username = excluded.username,
  password = excluded.password,
  display_name = excluded.display_name,
  role = excluded.role,
  unit_key = excluded.unit_key,
  is_locked = excluded.is_locked;

insert into student_tickets (
  id,
  tracking_code,
  student_id,
  student_name,
  unit_key,
  title,
  description,
  status,
  created_at,
  updated_at,
  assigned_to
) values
  (
    't001',
    'EDU-1404-0001',
    's001',
    'رضا حسینی',
    'education',
    'درخواست گواهی اشتغال به تحصیل',
    'نیاز به گواهی برای تمدید اقامت دارم.',
    'reviewing',
    now() - interval '10 days',
    now() - interval '9 days',
    'کارشناس آموزش ۱'
  ),
  (
    't002',
    'INT-1404-0002',
    's002',
    'علی احمدی',
    'international',
    'تکمیل مدارک پذیرش',
    'مدارک جدید بارگذاری شده و نیاز به بررسی دارد.',
    'needDocuments',
    now() - interval '8 days',
    now() - interval '7 days',
    'مدیر امور بین‌الملل'
  ),
  (
    't003',
    'SS-1404-0003',
    's003',
    'فاطمه رضایی',
    'student_services',
    'پیگیری خوابگاه',
    'درخواست خوابگاه ثبت شده اما نتیجه اعلام نشده است.',
    'submitted',
    now() - interval '6 days',
    now() - interval '6 days',
    'در انتظار ارجاع'
  )
on conflict (id) do update set
  tracking_code = excluded.tracking_code,
  student_id = excluded.student_id,
  student_name = excluded.student_name,
  unit_key = excluded.unit_key,
  title = excluded.title,
  description = excluded.description,
  status = excluded.status,
  updated_at = excluded.updated_at,
  assigned_to = excluded.assigned_to;

insert into education_classes (
  id,
  title,
  professor_id,
  professor_name,
  student_ids,
  student_names,
  week_day,
  start_time,
  end_time,
  semester,
  created_at,
  started_at,
  finished_at,
  status
) values
  (
    'ec001',
    'برنامه‌نویسی پیشرفته',
    'p001',
    'دکتر محمدی',
    '["s001", "s002"]'::jsonb,
    '["رضا حسینی", "علی احمدی"]'::jsonb,
    'شنبه',
    '10:00',
    '11:30',
    'نیمسال اول ۱۴۰۴',
    now() - interval '20 days',
    null,
    null,
    'scheduled'
  ),
  (
    'ec002',
    'پایگاه داده',
    'p001',
    'دکتر محمدی',
    '["s001", "s003", "s004"]'::jsonb,
    '["رضا حسینی", "فاطمه رضایی", "Sara Smith"]'::jsonb,
    'دوشنبه',
    '14:00',
    '15:30',
    'نیمسال اول ۱۴۰۴',
    now() - interval '18 days',
    now() - interval '9 days',
    now() - interval '9 days' + interval '88 minutes',
    'finished'
  )
on conflict (id) do update set
  title = excluded.title,
  professor_id = excluded.professor_id,
  professor_name = excluded.professor_name,
  student_ids = excluded.student_ids,
  student_names = excluded.student_names,
  week_day = excluded.week_day,
  start_time = excluded.start_time,
  end_time = excluded.end_time,
  semester = excluded.semester,
  started_at = excluded.started_at,
  finished_at = excluded.finished_at,
  status = excluded.status;
