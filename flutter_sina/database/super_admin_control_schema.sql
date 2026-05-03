create table if not exists admin_users_control (
  id text primary key,
  name text not null,
  username text not null,
  role text not null,
  unit text not null,
  email text not null default '',
  phone text not null default '',
  student_number text not null default '',
  passport_number text not null default '',
  locked boolean not null default false,
  permissions text[] not null default '{}',
  updated_at timestamptz not null default now()
);

create table if not exists admin_sections_control (
  id text primary key,
  title text not null,
  locked boolean not null default false,
  maintenance_message text not null default '',
  updated_at timestamptz not null default now()
);

create table if not exists admin_services_control (
  id text primary key,
  title text not null,
  provider text not null,
  active boolean not null default true,
  external_provider boolean not null default false,
  needs_approval boolean not null default false,
  api_enabled boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists admin_floating_messages (
  id text primary key,
  target_type text not null,
  target_keys text[] not null default '{}',
  lang text not null,
  title text not null,
  message text not null,
  start_at timestamptz not null,
  end_at timestamptz not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists admin_support_knowledge (
  id text primary key,
  question text not null,
  answer text not null,
  target_unit text not null,
  active boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists admin_activity_logs (
  id text primary key,
  actor text not null,
  action text not null,
  target text not null,
  created_at timestamptz not null default now()
);
