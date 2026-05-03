-- Flutter Sina Supabase Schema
-- Run this in Supabase SQL Editor when you are ready.

create table if not exists app_users (
  id text primary key,
  username text unique not null,
  password text not null,
  display_name text not null,
  role text not null,
  unit_key text not null,
  is_locked boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists student_tickets (
  id text primary key,
  tracking_code text unique not null,
  student_id text not null,
  student_name text not null,
  unit_key text not null,
  title text not null,
  description text not null,
  status text not null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  assigned_to text not null
);

create table if not exists education_classes (
  id text primary key,
  title text not null,
  professor_id text not null,
  professor_name text not null,
  student_ids jsonb not null default '[]'::jsonb,
  student_names jsonb not null default '[]'::jsonb,
  week_day text not null,
  start_time text not null,
  end_time text not null,
  semester text not null,
  created_at timestamptz not null,
  started_at timestamptz,
  finished_at timestamptz,
  status text not null
);

create table if not exists system_locks (
  id text primary key,
  target_type text not null,
  target_key text not null,
  title text not null,
  reason text not null,
  created_at timestamptz not null,
  expires_at timestamptz,
  is_active boolean not null default true
);

create table if not exists floating_announcements (
  id text primary key,
  text_fa text not null,
  text_en text not null,
  text_ar text not null,
  target text not null,
  created_at timestamptz not null,
  expires_at timestamptz,
  is_active boolean not null default true
);

create index if not exists idx_student_tickets_unit_key on student_tickets(unit_key);
create index if not exists idx_student_tickets_student_id on student_tickets(student_id);
create index if not exists idx_student_tickets_status on student_tickets(status);
create index if not exists idx_education_classes_professor_id on education_classes(professor_id);
create index if not exists idx_system_locks_target on system_locks(target_type, target_key);
