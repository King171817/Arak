create table if not exists app_users (
  id text primary key,
  username text unique not null,
  password_hash text,
  full_name text not null,
  role text not null,
  unit_key text not null default '',
  email text not null default '',
  phone text not null default '',
  student_number text not null default '',
  passport_number text not null default '',
  avatar_url text not null default '',
  locked boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists app_roles (
  id text primary key,
  title text not null,
  description text not null default '',
  active boolean not null default true
);

create table if not exists app_permissions (
  id text primary key,
  title text not null,
  description text not null default ''
);

create table if not exists app_user_permissions (
  id text primary key,
  user_id text not null references app_users(id) on delete cascade,
  permission_id text not null references app_permissions(id) on delete cascade,
  granted_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists app_units (
  id text primary key,
  title_fa text not null,
  title_en text not null default '',
  title_ar text not null default '',
  icon_key text not null default 'account_balance',
  active boolean not null default true,
  locked boolean not null default false,
  maintenance_message text not null default ''
);

create table if not exists education_classes (
  id text primary key,
  title text not null,
  professor_id text not null references app_users(id),
  professor_name text not null,
  semester text not null,
  week_day text not null,
  start_time text not null,
  end_time text not null,
  status text not null default 'planned',
  started_at timestamptz,
  ended_at timestamptz,
  created_by text not null default 'admin2',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists education_class_students (
  id text primary key,
  class_id text not null references education_classes(id) on delete cascade,
  student_id text not null references app_users(id),
  student_name text not null,
  created_at timestamptz not null default now()
);

create table if not exists class_attendance (
  id text primary key,
  class_id text not null references education_classes(id) on delete cascade,
  student_id text not null references app_users(id),
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  status text not null default 'present'
);

create table if not exists student_tickets (
  id text primary key,
  student_id text not null references app_users(id),
  student_name text not null,
  unit_key text not null,
  title text not null,
  description text not null,
  tracking_number text not null,
  status text not null default 'open',
  priority text not null default 'normal',
  assigned_to text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists ticket_messages (
  id text primary key,
  ticket_id text not null references student_tickets(id) on delete cascade,
  sender_id text not null references app_users(id),
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists app_messages (
  id text primary key,
  chat_type text not null,
  from_user_id text not null references app_users(id),
  to_user_id text,
  to_unit_key text,
  to_role text,
  body text not null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists app_notifications (
  id text primary key,
  target_type text not null,
  target_key text not null,
  title text not null,
  body text not null,
  unread boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists floating_messages (
  id text primary key,
  target_type text not null,
  target_keys text[] not null default '{}',
  lang text not null default 'FA',
  title text not null,
  message text not null,
  start_at timestamptz not null,
  end_at timestamptz not null,
  active boolean not null default true,
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists floating_message_dismissals (
  id text primary key,
  message_id text not null references floating_messages(id) on delete cascade,
  user_id text not null references app_users(id) on delete cascade,
  dismissed_at timestamptz not null default now()
);

create table if not exists partner_services (
  id text primary key,
  title text not null,
  icon_key text not null default 'apps',
  provider_name text not null,
  provider_type text not null default 'internal',
  contact_info text not null default '',
  api_enabled boolean not null default false,
  api_base_url text not null default '',
  active boolean not null default true,
  needs_approval boolean not null default false,
  external_provider boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists service_requests (
  id text primary key,
  service_id text not null references partner_services(id),
  user_id text not null references app_users(id),
  title text not null,
  description text not null,
  status text not null default 'open',
  provider_response text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists ui_section_settings (
  id text primary key,
  title text not null,
  target_type text not null,
  target_key text not null,
  icon_key text not null default 'widgets',
  icon_size numeric not null default 24,
  font_size numeric not null default 13,
  visible boolean not null default true,
  enabled boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists app_assets_settings (
  id text primary key,
  asset_type text not null,
  title text not null,
  asset_url text not null,
  active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists smart_support_knowledge (
  id text primary key,
  question_key text not null,
  answer text not null,
  target_unit_key text not null default 'support',
  lang text not null default 'FA',
  active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists smart_support_requests (
  id text primary key,
  user_id text not null default 'guest',
  user_name text not null default '',
  question text not null,
  answer text not null,
  target_unit_key text not null default 'support',
  answered_automatically boolean not null default false,
  sent_to_manager boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists activity_logs (
  id text primary key,
  actor_id text not null default 'system',
  actor_name text not null default '',
  action text not null,
  target_type text not null,
  target_id text not null,
  details text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists system_locks (
  id text primary key,
  lock_type text not null,
  target_key text not null,
  message text not null default '',
  active boolean not null default true,
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

insert into app_roles (id, title, description) values
('student', 'دانشجو', 'کاربر دانشجو'),
('professor', 'استاد', 'کاربر استاد'),
('educationManager', 'مدیر آموزش', 'مدیر واحد آموزش'),
('educationOfficer', 'کارشناس آموزش', 'کارشناس زیر نظر مدیر آموزش'),
('unitManager', 'مدیر واحد', 'مدیر یکی از واحدها'),
('unitOfficer', 'کارشناس واحد', 'کارشناس یکی از واحدها'),
('superAdmin', 'مدیر اصلی', 'دسترسی کامل سامانه')
on conflict (id) do nothing;

insert into app_units (id, title_fa, title_en, title_ar, icon_key) values
('education', 'آموزش', 'Education', 'التعليم', 'school'),
('international', 'امور بین‌الملل', 'International', 'الدولی', 'language'),
('studentServices', 'خدمات دانشجویی', 'Student Services', 'خدمات الطلاب', 'groups'),
('consular', 'کنسولی', 'Consular', 'القنصلية', 'badge'),
('services', 'سایر خدمات', 'Other Services', 'خدمات أخرى', 'apps'),
('support', 'پشتیبانی', 'Support', 'الدعم', 'support_agent')
on conflict (id) do nothing;

insert into partner_services (id, title, icon_key, provider_name, provider_type, active, needs_approval, external_provider) values
('translation', 'ترجمه مدارک', 'translate', 'شرکت ترجمه / واحد بین‌الملل', 'external', true, true, true),
('printing', 'پرینت و کپی', 'print', 'مرکز چاپ دانشگاه / شرکت همکار', 'hybrid', true, false, true),
('taxi', 'تاکسی', 'local_taxi', 'شرکت حمل‌ونقل همکار', 'external', true, true, true),
('insurance', 'بیمه', 'health_and_safety', 'شرکت بیمه همکار', 'external', true, true, true),
('library', 'کتابخانه', 'local_library', 'کتابخانه دانشگاه', 'internal', true, false, false),
('map', 'نقشه دانشگاه', 'map', 'مدیریت سامانه', 'internal', true, false, false)
on conflict (id) do nothing;
create or replace view super_admin_overview as
select
  (select count(*) from app_users) as users_count,
  (select count(*) from app_users where locked = true) as locked_users_count,
  (select count(*) from education_classes) as classes_count,
  (select count(*) from student_tickets) as tickets_count,
  (select count(*) from partner_services where active = true) as active_services_count,
  (select count(*) from activity_logs) as activity_logs_count;

create index if not exists idx_app_users_role on app_users(role);
create index if not exists idx_app_users_unit on app_users(unit_key);
create index if not exists idx_tickets_student on student_tickets(student_id);
create index if not exists idx_tickets_unit on student_tickets(unit_key);
create index if not exists idx_messages_from_user on app_messages(from_user_id);
create index if not exists idx_activity_actor on activity_logs(actor_id);
create index if not exists idx_floating_target on floating_messages(target_type);
-- SUPER ADMIN EXTRA DATABASE STRUCTURE

create table if not exists role_permission_templates (
  id text primary key,
  role_id text not null,
  permission_id text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists admin_reports (
  id text primary key,
  report_type text not null,
  title text not null,
  filters jsonb not null default '{}',
  result jsonb not null default '{}',
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists admin_bulk_messages (
  id text primary key,
  message_type text not null,
  target_type text not null,
  target_keys text[] not null default '{}',
  title text not null,
  body text not null,
  lang text not null default 'FA',
  sent_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists admin_asset_files (
  id text primary key,
  asset_type text not null,
  file_name text not null,
  file_url text not null,
  storage_bucket text not null default 'app-assets',
  active boolean not null default true,
  uploaded_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists admin_database_snapshots (
  id text primary key,
  title text not null,
  snapshot_type text not null,
  description text not null default '',
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists admin_service_api_configs (
  id text primary key,
  service_id text not null references partner_services(id) on delete cascade,
  api_base_url text not null default '',
  api_key_label text not null default '',
  callback_url text not null default '',
  enabled boolean not null default false,
  updated_at timestamptz not null default now()
);

insert into app_permissions (id, title, description) values
('viewDashboard', 'مشاهده داشبورد', 'اجازه مشاهده داشبورد'),
('manageUsers', 'مدیریت کاربران', 'افزودن، ویرایش و مشاهده کاربران'),
('lockUsers', 'قفل کاربران', 'قفل یا باز کردن کاربر'),
('changeRoles', 'تغییر نقش', 'تغییر نقش کاربر'),
('managePermissions', 'مدیریت دسترسی‌ها', 'دادن یا گرفتن دسترسی'),
('manageUnits', 'مدیریت واحدها', 'قفل واحد، پیام واحد و تنظیم واحد'),
('manageClasses', 'مدیریت کلاس‌ها', 'ایجاد، ویرایش، شروع و گزارش کلاس'),
('viewReports', 'مشاهده گزارش‌ها', 'گزارش لحظه‌ای و دوره‌ای'),
('manageTickets', 'مدیریت تیکت‌ها', 'پاسخ و ارجاع تیکت'),
('manageServices', 'مدیریت خدمات', 'کنترل خدمات و شرکت‌ها'),
('manageAppearance', 'مدیریت ظاهر', 'لوگو، فونت، آیکون و بک‌گراند'),
('manageFloatingMessages', 'مدیریت پیام شناور', 'ایجاد پیام شناور زمان‌دار'),
('manageSupportKnowledge', 'مدیریت دیتاست پشتیبانی', 'ویرایش دانش دستیار هوشمند'),
('manageDatabase', 'مدیریت دیتابیس', 'دسترسی به دیتابیس و گزارش داده'),
('manageGlobalSettings', 'تنظیمات سراسری', 'تعمیرات، ثبت‌نام، تنظیمات کل سامانه')
on conflict (id) do nothing;

insert into role_permission_templates (id, role_id, permission_id) values
('tpl_super_01', 'superAdmin', 'viewDashboard'),
('tpl_super_02', 'superAdmin', 'manageUsers'),
('tpl_super_03', 'superAdmin', 'lockUsers'),
('tpl_super_04', 'superAdmin', 'changeRoles'),
('tpl_super_05', 'superAdmin', 'managePermissions'),
('tpl_super_06', 'superAdmin', 'manageUnits'),
('tpl_super_07', 'superAdmin', 'manageClasses'),
('tpl_super_08', 'superAdmin', 'viewReports'),
('tpl_super_09', 'superAdmin', 'manageTickets'),
('tpl_super_10', 'superAdmin', 'manageServices'),
('tpl_super_11', 'superAdmin', 'manageAppearance'),
('tpl_super_12', 'superAdmin', 'manageFloatingMessages'),
('tpl_super_13', 'superAdmin', 'manageSupportKnowledge'),
('tpl_super_14', 'superAdmin', 'manageDatabase'),
('tpl_super_15', 'superAdmin', 'manageGlobalSettings')
on conflict (id) do nothing;

create or replace view admin_live_overview as
select
  (select count(*) from app_users) as users_count,
  (select count(*) from app_users where locked = true) as locked_users_count,
  (select count(*) from app_units where locked = true) as locked_units_count,
  (select count(*) from education_classes where status = 'active') as active_classes_count,
  (select count(*) from student_tickets where status = 'open') as open_tickets_count,
  (select count(*) from partner_services where active = true) as active_services_count,
  (select count(*) from floating_messages where active = true and now() between start_at and end_at) as active_floating_messages_count,
  (select count(*) from smart_support_requests where answered_automatically = false) as unanswered_support_count,
  (select count(*) from activity_logs where created_at > now() - interval '24 hours') as logs_last_24h;
create table if not exists push_tokens (
  id text primary key,
  user_id text not null,
  role text not null default '',
  unit_key text not null default '',
  fcm_token text not null,
  platform text not null default '',
  active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists error_reports (
  id text primary key,
  source text not null,
  message text not null,
  stack_trace text not null default '',
  app_version text not null default '',
  build_number text not null default '',
  extra text not null default '',
  resolved boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists backup_jobs (
  id text primary key,
  title text not null,
  backup_type text not null,
  description text not null default '',
  status text not null default 'created',
  file_url text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists user_sessions (
  id text primary key,
  user_id text not null,
  device_name text not null default '',
  platform text not null default '',
  token_hash text not null default '',
  active boolean not null default true,
  last_seen_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists logout_all_requests (
  id text primary key,
  user_id text not null,
  requested_by text not null default 'sina',
  reason text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists user_activity_logs (
  id text primary key,
  user_id text not null,
  user_name text not null default '',
  action text not null,
  page_key text not null default '',
  details text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists idx_push_tokens_user on push_tokens(user_id);
create index if not exists idx_error_reports_created on error_reports(created_at);
create index if not exists idx_user_sessions_user on user_sessions(user_id);
create index if not exists idx_user_activity_user on user_activity_logs(user_id);
-- ACCESS CONTROL EXTENSIONS

create table if not exists app_role_permissions (
  id text primary key,
  role_id text not null,
  permission_id text not null,
  enabled boolean not null default true,
  updated_by text not null default 'sina',
  updated_at timestamptz not null default now()
);

create table if not exists app_unit_permissions (
  id text primary key,
  unit_key text not null,
  permission_id text not null,
  enabled boolean not null default true,
  updated_by text not null default 'sina',
  updated_at timestamptz not null default now()
);

create table if not exists app_user_access_overrides (
  id text primary key,
  user_id text not null,
  permission_id text not null,
  enabled boolean not null default true,
  reason text not null default '',
  updated_by text not null default 'sina',
  updated_at timestamptz not null default now()
);

create table if not exists section_maintenance_windows (
  id text primary key,
  section_key text not null,
  title text not null,
  message_fa text not null default '',
  message_en text not null default '',
  message_ar text not null default '',
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  active boolean not null default true,
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists report_requests (
  id text primary key,
  report_key text not null,
  title text not null,
  from_date timestamptz not null,
  to_date timestamptz not null,
  filters jsonb not null default '{}',
  created_by text not null default 'sina',
  created_at timestamptz not null default now()
);

create table if not exists floating_messages_seen (
  id text primary key,
  message_id text not null,
  user_id text not null,
  seen_at timestamptz not null default now(),
  dismissed_at timestamptz
);

create index if not exists idx_access_user_override_user on app_user_access_overrides(user_id);
create index if not exists idx_section_maintenance_key on section_maintenance_windows(section_key);
create index if not exists idx_report_requests_key on report_requests(report_key);
create index if not exists idx_floating_seen_user on floating_messages_seen(user_id);
create table if not exists floating_message_user_state (
  id text primary key,
  message_id text not null,
  user_id text not null,
  seen boolean not null default false,
  dismissed boolean not null default false,
  seen_at timestamptz,
  dismissed_at timestamptz,
  updated_at timestamptz not null default now()
);

create index if not exists idx_floating_message_user_state_user
on floating_message_user_state(user_id);

create index if not exists idx_floating_message_user_state_message
on floating_message_user_state(message_id);
create table if not exists live_class_sessions (
  id text primary key,
  class_id text not null,
  title text not null,
  professor_id text not null,
  professor_name text not null,
  status text not null default 'waiting',
  started_at timestamptz,
  ended_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists live_class_participants (
  id text primary key,
  session_id text not null,
  class_id text not null,
  user_id text not null,
  user_name text not null,
  role text not null,
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  is_online boolean not null default true
);

create table if not exists live_class_messages (
  id text primary key,
  session_id text not null,
  class_id text not null,
  sender_id text not null,
  sender_name text not null,
  sender_role text not null,
  message text not null,
  created_at timestamptz not null default now()
);

create table if not exists live_class_materials (
  id text primary key,
  class_id text not null,
  session_id text,
  title text not null,
  file_url text not null default '',
  material_type text not null default 'file',
  uploaded_by text not null,
  created_at timestamptz not null default now()
);

create table if not exists live_class_events (
  id text primary key,
  session_id text not null,
  class_id text not null,
  actor_id text not null,
  actor_name text not null,
  event_type text not null,
  details text not null default '',
  created_at timestamptz not null default now()
);
